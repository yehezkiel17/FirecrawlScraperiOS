# 🔑 API Key Setup

## Quick Instructions

Your Firecrawl API key needs to be added to the code **before** building the app.

### Location
```
FirecrawlScraper/Config.swift
```

### What to Change

Open `Config.swift` and find this line (around line 8):

```swift
let apiKey = "YOUR_API_KEY_HERE"
```

Replace it with your actual API key:

```swift
let apiKey = "fc-1234567890abcdef..."
```

### Where to Get Your API Key

1. Go to **[https://firecrawl.dev](https://firecrawl.dev)**
2. Sign up or log in
3. Navigate to your **Dashboard** or **API Settings**
4. Copy your API key (starts with `fc-`)

### Example

**Before:**
```swift
class FirecrawlConfig {
    static let shared = FirecrawlConfig()

    // MARK: - ⚠️ PASTE YOUR FIRECRAWL API KEY HERE ⚠️
    // Get your API key from: https://firecrawl.dev
    let apiKey = "YOUR_API_KEY_HERE"
    // Example: let apiKey = "fc-1234567890abcdef..."

    private init() {}

    var hasValidAPIKey: Bool {
        !apiKey.isEmpty && apiKey != "YOUR_API_KEY_HERE"
    }
}
```

**After:**
```swift
class FirecrawlConfig {
    static let shared = FirecrawlConfig()

    // MARK: - ⚠️ PASTE YOUR FIRECRAWL API KEY HERE ⚠️
    // Get your API key from: https://firecrawl.dev
    let apiKey = "fc-abc123xyz456def789..."
    // Example: let apiKey = "fc-1234567890abcdef..."

    private init() {}

    var hasValidAPIKey: Bool {
        !apiKey.isEmpty && apiKey != "YOUR_API_KEY_HERE"
    }
}
```

### After Adding Your Key

1. **Save the file** (⌘+S in Xcode)
2. **Build and run** (⌘+R in Xcode)
3. **Start scraping!**

---

**Note:** Keep your API key private. Don't commit it to version control!
