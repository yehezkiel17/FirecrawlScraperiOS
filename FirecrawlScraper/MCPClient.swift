import Foundation

#if os(macOS)

// MARK: - MCP Protocol Models
struct JSONRPCRequest: Codable {
    var jsonrpc: String = "2.0"
    let id: Int
    let method: String
    let params: [String: AnyCodable]?

    init(id: Int, method: String, params: [String: AnyCodable]? = nil) {
        self.id = id
        self.method = method
        self.params = params
    }
}

struct JSONRPCResponse: Codable {
    let jsonrpc: String
    let id: Int?
    let result: AnyCodable?
    let error: JSONRPCError?
}

struct JSONRPCError: Codable {
    let code: Int
    let message: String
    let data: AnyCodable?
}

// Helper to encode/decode Any values
struct AnyCodable: Codable {
    let value: Any

    init(_ value: Any) {
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let bool = try? container.decode(Bool.self) {
            value = bool
        } else if let int = try? container.decode(Int.self) {
            value = int
        } else if let double = try? container.decode(Double.self) {
            value = double
        } else if let string = try? container.decode(String.self) {
            value = string
        } else if let array = try? container.decode([AnyCodable].self) {
            value = array.map { $0.value }
        } else if let dict = try? container.decode([String: AnyCodable].self) {
            value = dict.mapValues { $0.value }
        } else {
            value = NSNull()
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch value {
        case let bool as Bool:
            try container.encode(bool)
        case let int as Int:
            try container.encode(int)
        case let double as Double:
            try container.encode(double)
        case let string as String:
            try container.encode(string)
        case let array as [Any]:
            try container.encode(array.map { AnyCodable($0) })
        case let dict as [String: Any]:
            try container.encode(dict.mapValues { AnyCodable($0) })
        case is NSNull:
            try container.encodeNil()
        default:
            try container.encodeNil()
        }
    }
}

// MARK: - MCP Client
class MCPClient {
    private var process: Process?
    private var inputPipe: Pipe?
    private var outputPipe: Pipe?
    private var errorPipe: Pipe?
    private var requestID: Int = 0
    private var isInitialized = false

    private let command: [String]
    private let transport: String

    enum MCPError: LocalizedError {
        case processNotRunning
        case invalidResponse
        case serverError(String)
        case notInitialized
        case processStartFailed

        var errorDescription: String? {
            switch self {
            case .processNotRunning:
                return "MCP server process is not running"
            case .invalidResponse:
                return "Invalid response from MCP server"
            case .serverError(let message):
                return "MCP Server Error: \(message)"
            case .notInitialized:
                return "MCP client not initialized. Call initialize() first."
            case .processStartFailed:
                return "Failed to start MCP server process"
            }
        }
    }

    init(transport: String = "stdio", command: [String]) {
        self.transport = transport
        self.command = command
    }

    // MARK: - Process Management
    func start() throws {
        guard process == nil else {
            print("Process already started")
            return
        }

        process = Process()
        inputPipe = Pipe()
        outputPipe = Pipe()
        errorPipe = Pipe()

        guard let process = process,
              let inputPipe = inputPipe,
              let outputPipe = outputPipe,
              let errorPipe = errorPipe else {
            throw MCPError.processStartFailed
        }

        // Configure process
        if command.count > 0 {
            // Check if command exists first
            let checkProcess = Process()
            checkProcess.executableURL = URL(fileURLWithPath: "/usr/bin/which")
            checkProcess.arguments = [command[0]]
            checkProcess.standardOutput = Pipe()
            checkProcess.standardError = Pipe()

            do {
                try checkProcess.run()
                checkProcess.waitUntilExit()

                if checkProcess.terminationStatus != 0 {
                    print("Command '\(command[0])' not found in PATH")
                    print("Try installing: npm install -g @mendable/firecrawl-mcp-server")
                    throw MCPError.processStartFailed
                } else {
                    if let output = try? (checkProcess.standardOutput as! Pipe).fileHandleForReading.readToEnd(),
                       let path = String(data: output, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) {
                        print("Found command at: \(path)")
                    }
                }
            } catch {
                print("Failed to check if command exists: \(error)")
            }

            process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
            process.arguments = command
            print("Starting process: /usr/bin/env \(command.joined(separator: " "))")
        } else {
            throw MCPError.processStartFailed
        }

        process.standardInput = inputPipe
        process.standardOutput = outputPipe
        process.standardError = errorPipe

        // Monitor stderr for debugging
        errorPipe.fileHandleForReading.readabilityHandler = { handle in
            let data = handle.availableData
            if !data.isEmpty, let errorString = String(data: data, encoding: .utf8) {
                print("MCP Server stderr: \(errorString)")
            }
        }

        // Start process
        do {
            try process.run()
            print("Process started successfully, PID: \(process.processIdentifier)")

            // Give the process a moment to initialize
            usleep(100000) // 100ms

            if !process.isRunning {
                print("Process exited immediately")
                throw MCPError.processStartFailed
            }
        } catch {
            print("Failed to start process: \(error)")
            throw MCPError.processStartFailed
        }
    }

    func stop() {
        print("Stopping MCP client")
        process?.terminate()
        process = nil
        inputPipe = nil
        outputPipe = nil
        errorPipe = nil
        isInitialized = false
    }

    // MARK: - MCP Protocol Methods
    func initialize(clientInfo: [String: Any] = [:]) async throws {
        guard !isInitialized else { return }

        var params: [String: AnyCodable] = [
            "protocolVersion": AnyCodable("2024-11-05"),
            "capabilities": AnyCodable([:])
        ]

        if !clientInfo.isEmpty {
            params["clientInfo"] = AnyCodable(clientInfo)
        }

        let response = try await sendRequest(method: "initialize", params: params)

        if response.error != nil {
            throw MCPError.serverError(response.error?.message ?? "Initialization failed")
        }

        // Don't send initialized notification - the firecrawl MCP server doesn't expect it
        // and returns an error if we send it

        isInitialized = true
    }

    func callTool(name: String, arguments: [String: Any] = [:]) async throws -> [String: Any] {
        guard isInitialized else {
            throw MCPError.notInitialized
        }

        print("Calling tool '\(name)' with arguments: \(arguments)")

        let params: [String: AnyCodable] = [
            "name": AnyCodable(name),
            "arguments": AnyCodable(arguments)
        ]

        let response = try await sendRequest(method: "tools/call", params: params)

        if let error = response.error {
            throw MCPError.serverError(error.message)
        }

        guard let result = response.result?.value as? [String: Any] else {
            throw MCPError.invalidResponse
        }

        return result
    }

    func listTools() async throws -> [[String: Any]] {
        guard isInitialized else {
            throw MCPError.notInitialized
        }

        let response = try await sendRequest(method: "tools/list", params: nil)

        if let error = response.error {
            throw MCPError.serverError(error.message)
        }

        guard let result = response.result?.value as? [String: Any],
              let tools = result["tools"] as? [[String: Any]] else {
            throw MCPError.invalidResponse
        }

        return tools
    }

    // MARK: - JSON-RPC Communication
    private func sendRequest(method: String, params: [String: AnyCodable]?) async throws -> JSONRPCResponse {
        guard let process = process, process.isRunning else {
            print("Process not running")
            throw MCPError.processNotRunning
        }

        requestID += 1
        let currentRequestID = requestID
        let request = JSONRPCRequest(id: currentRequestID, method: method, params: params)

        // Encode and send request
        let encoder = JSONEncoder()
        // DO NOT use .prettyPrinted - it adds newlines which break the line-based JSON-RPC protocol
        let requestData = try encoder.encode(request)

        if let requestString = String(data: requestData, encoding: .utf8) {
            print("Sending request: \(requestString)")
        }

        guard let inputPipe = inputPipe else {
            throw MCPError.processNotRunning
        }

        // Write request with newline delimiter
        var dataToSend = requestData
        dataToSend.append(contentsOf: "\n".utf8)
        inputPipe.fileHandleForWriting.write(dataToSend)
        print("Request written to pipe")

        // Read response
        guard let outputPipe = outputPipe else {
            throw MCPError.processNotRunning
        }

        // Keep reading until we get a response with the matching request ID
        let decoder = JSONDecoder()
        var attempts = 0
        let maxAttempts = 200 // Increase for longer-running operations like web scraping

        while attempts < maxAttempts {
            let responseData = try await readLine(from: outputPipe)

            if let responseString = String(data: responseData, encoding: .utf8) {
                print("Received message: \(responseString.prefix(200))...")

                // Try to parse as JSON to check if it's a notification or response
                if let json = try? JSONSerialization.jsonObject(with: responseData) as? [String: Any] {
                    // Check if it's a notification (has "method" field, no "id" field or id is null)
                    if json["method"] != nil && json["id"] == nil {
                        print("Skipping notification")
                        attempts += 1
                        continue
                    }
                }
            }

            // Try to decode as response
            do {
                let response = try decoder.decode(JSONRPCResponse.self, from: responseData)

                // Check if this response matches our request ID
                if response.id == currentRequestID {
                    if let error = response.error {
                        print("MCP Error: \(error.message)")
                    }
                    return response
                } else {
                    print("Received response for different request ID: \(response.id ?? -1), expecting \(currentRequestID)")
                    attempts += 1
                    continue
                }
            } catch {
                print("Failed to decode response: \(error)")
                attempts += 1
                continue
            }
        }

        throw MCPError.invalidResponse
    }

    private func sendNotification(method: String, params: [String: AnyCodable]? = nil) async throws {
        guard let process = process, process.isRunning else {
            throw MCPError.processNotRunning
        }

        // Notifications don't have an ID
        let notification: [String: Any] = [
            "jsonrpc": "2.0",
            "method": method,
            "params": params?.mapValues { $0.value } ?? [:]
        ]

        let notificationData = try JSONSerialization.data(withJSONObject: notification)

        guard let inputPipe = inputPipe else {
            throw MCPError.processNotRunning
        }

        // Write notification with newline delimiter
        var dataToSend = notificationData
        dataToSend.append(contentsOf: "\n".utf8)
        inputPipe.fileHandleForWriting.write(dataToSend)
    }

    private func readLine(from pipe: Pipe) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            let handle = pipe.fileHandleForReading

            DispatchQueue.global(qos: .userInitiated).async {
                var buffer = Data()
                let readSize = 1024

                // Set up a timeout
                let startTime = Date()
                let timeout: TimeInterval = 60.0 // 60 seconds

                while Date().timeIntervalSince(startTime) < timeout {
                    // Try to read available data
                    let fileDescriptor = handle.fileDescriptor
                    var readBuffer = [UInt8](repeating: 0, count: readSize)

                    // Use non-blocking read
                    var flags = fcntl(fileDescriptor, F_GETFL, 0)
                    fcntl(fileDescriptor, F_SETFL, flags | O_NONBLOCK)

                    let bytesRead = read(fileDescriptor, &readBuffer, readSize)

                    if bytesRead > 0 {
                        buffer.append(Data(readBuffer[0..<bytesRead]))

                        // Check for newline
                        if let newlineIndex = buffer.firstIndex(of: UInt8(ascii: "\n")) {
                            let line = buffer.prefix(upTo: newlineIndex)
                            print("Read line (\(line.count) bytes)")
                            continuation.resume(returning: line)
                            return
                        }
                    } else if bytesRead == 0 {
                        // EOF
                        if !buffer.isEmpty {
                            print("Read incomplete line at EOF (\(buffer.count) bytes)")
                            continuation.resume(returning: buffer)
                            return
                        }
                    }

                    // Wait a bit before trying again
                    usleep(10000) // 10ms
                }

                // Timeout
                if !buffer.isEmpty {
                    print("Timeout - returning partial data (\(buffer.count) bytes)")
                    continuation.resume(returning: buffer)
                } else {
                    print("Timeout - no data received")
                    continuation.resume(throwing: MCPError.invalidResponse)
                }
            }
        }
    }
}

#endif
