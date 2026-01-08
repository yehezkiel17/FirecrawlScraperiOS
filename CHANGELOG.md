# Changelog

## [Latest] - 2026-01-08

### ✨ Added

#### 🔗 Tappable Links Feature
- **New File:** `TappableTextView.swift` - Custom SwiftUI view for detecting and making links clickable
- **Feature:** All URLs in scraped content are now automatically detected and tappable
- **Support:** Both markdown links `[text](url)` and plain URLs `https://example.com`
- **Behavior:** Links open in Safari when tapped
- **Styling:** Links appear in blue with underline for clear visibility

#### ⌨️ Smart Keyboard Dismissal
- **Swipe Down:** Drag down gesture anywhere dismisses the keyboard
- **Tap Outside:** Tapping outside the text field dismisses keyboard
- **Done Button:** Keyboard shows "Done" button for easy dismissal
- **Auto-Dismiss:** Keyboard auto-dismisses when tapping "Scrape Content"
- **Implementation:** Uses `@FocusState` for smooth keyboard management

### 🔄 Changed
- Updated `ContentView.swift` to use `TappableTextView` instead of plain `Text`
- Added `@FocusState` property for keyboard management
- Added gesture recognizers for keyboard dismissal
- TextField now has `.focused()` modifier connected to state

### 📝 Documentation
- Updated `README.md` with new features
- Created `FEATURES.md` explaining tappable links and keyboard features
- Updated project structure documentation

---

## [Initial Release] - 2026-01-08

### ✨ Features
- Beautiful SwiftUI interface with gradient design
- Firecrawl API integration for web scraping
- Hardcoded API key configuration in `Config.swift`
- Clean card-based result display
- Title, description, and content extraction
- Error handling and loading states
- iOS 16+ support

### 📁 Project Structure
- `FirecrawlScraperApp.swift` - App entry point
- `ContentView.swift` - Main UI
- `Config.swift` - API key configuration
- `MCPService.swift` - Firecrawl API integration
- `Models.swift` - Data models
- `ScraperViewModel.swift` - MVVM view model

### 📖 Documentation
- `README.md` - Project overview and setup
- `SETUP_GUIDE.md` - Quick setup instructions
- `API_KEY_SETUP.md` - API key configuration guide
- `.gitignore` - Git ignore configuration
