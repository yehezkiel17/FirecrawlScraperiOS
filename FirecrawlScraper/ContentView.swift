import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ScraperViewModel()
    @State private var urlInput = ""
    @FocusState private var isInputFocused: Bool
    private let config = FirecrawlConfig.shared

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 24) {
                    headerView

                    if !config.hasValidAPIKey {
                        apiKeyWarning
                    }

                    inputSection

                    if viewModel.isLoading {
                        loadingView
                    } else if let error = viewModel.errorMessage {
                        errorView(message: error)
                    } else if let result = viewModel.scrapedContent {
                        resultView(result: result)
                    }

                    Spacer()
                }
                .padding()
            }
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .gesture(
                DragGesture(minimumDistance: 10)
                    .onEnded { value in
                        // Detect swipe down gesture
                        if value.translation.height > 50 {
                            dismissKeyboard()
                        }
                    }
            )
            .onTapGesture {
                // Dismiss keyboard when tapping outside
                dismissKeyboard()
            }
        }
    }

    private func dismissKeyboard() {
        isInputFocused = false
    }

    private var headerView: some View {
        VStack(spacing: 12) {
            Image(systemName: "globe.americas.fill")
                .font(.system(size: 60))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Text("Web Scraper")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Extract content from any website")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.top, 40)
    }

    private var apiKeyWarning: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(.orange)

            Text("API Key Not Configured")
                .font(.headline)

            Text("Please add your Firecrawl API key in Config.swift")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Text("FirecrawlScraper/Config.swift")
                .font(.caption)
                .fontWeight(.semibold)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.orange.opacity(0.2))
                .foregroundColor(.orange)
                .cornerRadius(8)
        }
        .padding()
        #if os(iOS)
        .background(Color(.systemBackground))
        #else
        .background(Color(NSColor.windowBackgroundColor))
        #endif
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.circle.fill")
                .font(.system(size: 50))
                .foregroundColor(.red)

            Text("Error")
                .font(.title2)
                .fontWeight(.bold)

            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
        #if os(iOS)
        .background(Color(.systemBackground))
        #else
        .background(Color(NSColor.windowBackgroundColor))
        #endif
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }

    private var inputSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "link")
                    .foregroundColor(.gray)

                TextField("Enter URL", text: $urlInput)
                    .textFieldStyle(.plain)
                    #if os(iOS)
                    .autocapitalization(.none)
                    .keyboardType(.URL)
                    #endif
                    .focused($isInputFocused)
                    .submitLabel(.done)
                    .onSubmit {
                        dismissKeyboard()
                    }

                if !urlInput.isEmpty {
                    Button(action: { urlInput = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            #if os(iOS)
            .background(Color(.systemBackground))
            #else
            .background(Color(NSColor.windowBackgroundColor))
            #endif
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
            .simultaneousGesture(TapGesture().onEnded { })

            Button(action: scrapeWebsite) {
                HStack {
                    Image(systemName: "arrow.down.circle.fill")
                    Text("Scrape Content")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .disabled(urlInput.isEmpty || viewModel.isLoading)
            .opacity(urlInput.isEmpty ? 0.6 : 1.0)
        }
        .padding(.horizontal)
    }

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Scraping content...")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .padding()
    }

    private func resultView(result: ScrapedContent) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Results")
                    .font(.title2)
                    .fontWeight(.bold)

                if let title = result.title {
                    resultCard(title: "Title", content: title, icon: "doc.text")
                }

                if let description = result.description {
                    resultCard(title: "Description", content: description, icon: "text.alignleft")
                }

                resultCard(title: "Content", content: result.content, icon: "doc.richtext")

                if let url = result.url {
                    resultCard(title: "URL", content: url, icon: "link")
                }
            }
            .padding()
        }
        #if os(iOS)
        .background(Color(.systemBackground))
        #else
        .background(Color(NSColor.windowBackgroundColor))
        #endif
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }

    private func resultCard(title: String, content: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
            }

            TappableTextView(
                text: content,
                font: .body,
                color: .secondary,
                lineLimit: title == "Content" ? nil : 3
            )
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        #if os(iOS)
        .background(Color(.secondarySystemBackground))
        #else
        .background(Color(NSColor.controlBackgroundColor))
        #endif
        .cornerRadius(12)
    }

    private func scrapeWebsite() {
        dismissKeyboard()
        viewModel.scrapeURL(urlInput)
    }
}

#Preview {
    ContentView()
}
