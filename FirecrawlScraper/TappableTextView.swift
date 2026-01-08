import SwiftUI

struct TappableTextView: View {
    let text: String
    let font: Font
    let color: Color
    let lineLimit: Int?

    init(text: String, font: Font = .body, color: Color = .secondary, lineLimit: Int? = nil) {
        self.text = text
        self.font = font
        self.color = color
        self.lineLimit = lineLimit
    }

    var body: some View {
        Text(makeAttributedString())
            .font(font)
            .foregroundColor(color)
            .lineLimit(lineLimit)
            .tint(.blue)
    }

    private func makeAttributedString() -> AttributedString {
        // First, try to parse as markdown
        if let attributedString = try? AttributedString(markdown: text, options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)) {
            return attributedString
        }

        // If markdown parsing fails, detect plain URLs
        var attributedString = AttributedString(text)

        // Detect URLs using data detector
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector?.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))

        matches?.reversed().forEach { match in
            if let range = Range(match.range, in: text) {
                let urlString = String(text[range])
                if let url = URL(string: urlString),
                   let attributedRange = Range(match.range, in: attributedString) {
                    attributedString[attributedRange].link = url
                    attributedString[attributedRange].foregroundColor = .blue
                    attributedString[attributedRange].underlineStyle = .single
                }
            }
        }

        return attributedString
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 20) {
        TappableTextView(
            text: "Check out https://apple.com for more info!",
            font: .body,
            color: .primary
        )

        TappableTextView(
            text: "[Apple](https://apple.com) is a great website",
            font: .body,
            color: .primary
        )

        TappableTextView(
            text: "Visit https://google.com or https://github.com for more",
            font: .caption,
            color: .secondary
        )
    }
    .padding()
}
