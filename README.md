# FirecrawlScraper

A beautiful iOS app for web scraping using the Firecrawl API.

> **⚠️ IMPORTANT:** Before running the app, add your Firecrawl API key to `FirecrawlScraper/Config.swift`
> See [API_KEY_SETUP.md](API_KEY_SETUP.md) for quick instructions.

## Features

- ✨ Simple and elegant SwiftUI interface
- 🌐 Web content scraping via Firecrawl API
- 📱 Native iOS experience with modern design
- 🎨 Beautiful gradient UI with smooth animations
- 📊 Displays title, description, and full content
- 🔗 **Tappable links** - All URLs in scraped content are clickable and open in Safari
- ⌨️ **Smart keyboard** - Swipe down or tap outside to dismiss keyboard
- 🔐 Simple hardcoded API key configuration

## Screenshots

The app features:
- Clean gradient background (blue to purple)
- Large icon-based header
- Simple URL input with validation
- Loading state with progress indicator
- Beautiful card-based results display

## Project Structure

```
FirecrawlScraper/
├── FirecrawlScraperApp.swift    # App entry point
├── ContentView.swift             # Main UI view
├── TappableTextView.swift        # Custom view for clickable links
├── ScraperViewModel.swift        # View model for state management
├── MCPService.swift              # Firecrawl API integration service
├── Config.swift                  # ⚠️ API key goes here! ⚠️
├── Models.swift                  # Data models
├── Info.plist                    # App configuration
└── Assets.xcassets/              # App icons and assets
```

## Getting Started

### Requirements

- Xcode 15.0 or later
- iOS 16.0 or later
- Swift 5.9 or later
- **Firecrawl API Key** (get one at [firecrawl.dev](https://firecrawl.dev))

### Installation

1. **Clone or Download** this repository
2. **Open the project:**
   ```bash
   open FirecrawlScraper/FirecrawlScraper.xcodeproj
   ```
3. **Select your target device or simulator**
4. **Build and run** (⌘+R)

### Setting up Your Firecrawl API Key

1. **Get your API Key:**
   - Visit [firecrawl.dev](https://firecrawl.dev)
   - Sign up or log in to your account
   - Navigate to your API settings/dashboard
   - Copy your API key (starts with `fc-...`)

2. **Add API Key to Config.swift:**
   - Open `FirecrawlScraper/Config.swift` in Xcode
   - Find the line: `let apiKey = "YOUR_API_KEY_HERE"`
   - Replace `"YOUR_API_KEY_HERE"` with your actual API key
   - Example: `let apiKey = "fc-1234567890abcdef..."`
   - Save the file (⌘+S)

3. **Build and Run:**
   - Press ⌘+R to build and run the app
   - Enter any URL in the input field
   - Tap "Scrape Content"
   - View the extracted content

### How It Works

The app uses the **Firecrawl API v1** to extract clean, structured content from any website:

1. **API Endpoint:** `https://api.firecrawl.dev/v1/scrape`
2. **Request Format:**
   - Sends URL with format preferences (markdown, HTML)
   - Configures to extract main content only
3. **Response Processing:**
   - Extracts title from metadata or Open Graph tags
   - Gets description from meta tags
   - Displays markdown-formatted content
4. **Configuration:**
   - API key is hardcoded in `Config.swift`
   - Replace placeholder before building the app

## UI Design

The app features a modern, elegant design:

- **Color Scheme:** Blue and purple gradients
- **Typography:** SF Pro (system font)
- **Layout:** Card-based with smooth shadows
- **Icons:** SF Symbols for consistent design
- **Animations:** Smooth transitions and loading states
- **Interactive Links:** Automatically detects and styles URLs (markdown & plain text)
- **Smart Keyboard:** Dismisses with swipe down gesture or tap outside

## Architecture

- **MVVM Pattern:** Separation of UI and business logic
- **SwiftUI:** Declarative UI framework
- **Async/Await:** Modern concurrency for network operations
- **ObservableObject:** Reactive state management

## API Features

The app leverages Firecrawl's powerful features:
- **Clean Content Extraction:** Removes ads, navigation, and clutter
- **Markdown Formatting:** Returns content in clean markdown format
- **Metadata Extraction:** Captures title, description, and Open Graph data
- **Multi-format Support:** Can extract HTML and markdown
- **Main Content Focus:** Optionally extracts only the primary content

## Future Enhancements

- [ ] History of scraped URLs with local storage
- [ ] Export scraped content (PDF, Markdown, JSON)
- [ ] Bookmark and organize favorite scrapes
- [ ] Custom scraping parameters (tags to include/exclude)
- [ ] Share extension for Safari
- [ ] Batch URL scraping
- [ ] Dark mode optimization
- [ ] iPad split-view support

## License

This project is created for educational purposes.

## Support

For issues or questions about:
- **Firecrawl MCP:** Visit [Firecrawl Documentation](https://www.firecrawl.dev/)
- **iOS Development:** Check [Apple Developer Documentation](https://developer.apple.com/)

---

Built with ❤️ using SwiftUI
