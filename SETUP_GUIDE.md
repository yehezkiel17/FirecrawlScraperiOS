# Quick Setup Guide

Get started with FirecrawlScraper in 3 simple steps!

## Step 1: Get Your Firecrawl API Key

1. Visit **[firecrawl.dev](https://firecrawl.dev)**
2. Click **"Sign Up"** or **"Log In"**
3. Navigate to your **Dashboard** or **API Settings**
4. Find and **copy your API key** (it should start with `fc-...`)

> **Note:** Firecrawl offers a free tier to get started. Check their pricing page for details.

## Step 2: Add Your API Key to the Code

```bash
# Navigate to the project directory
cd FirecrawlScraper

# Open in Xcode
open FirecrawlScraper.xcodeproj
```

In Xcode:
1. **Open Config.swift** (in the left sidebar: FirecrawlScraper/Config.swift)
2. **Find this line:**
   ```swift
   let apiKey = "YOUR_API_KEY_HERE"
   ```
3. **Replace with your actual key:**
   ```swift
   let apiKey = "fc-1234567890abcdef..."
   ```
4. **Save the file** (⌘+S)

## Step 3: Build and Run

1. Select your target device (iPhone simulator or physical device)
2. Press **⌘+R** to build and run
3. Wait for the app to launch
4. You're ready to scrape! 🎉

## Using the App

### Scraping a Website

1. **Enter a URL** in the text field (e.g., `https://example.com`)
2. **Tap "Scrape Content"**
3. **Wait** for the content to load (usually 2-5 seconds)
4. **View the results:**
   - Title
   - Description
   - Full content in markdown format

### Tips

- ✅ **URLs must include the protocol** (`https://` or `http://`)
- ✅ Works with most websites (news, blogs, documentation)
- ❌ Some sites may block scraping (e.g., social media)
- 💡 The API extracts clean content and removes ads/navigation

## Troubleshooting

### "API Key Not Configured" Warning

- You haven't replaced the placeholder API key in Config.swift
- Open `FirecrawlScraper/Config.swift` in Xcode
- Replace `"YOUR_API_KEY_HERE"` with your actual API key
- Rebuild the app (⌘+R)

### "Firecrawl API Error: Status 401"

- Your API key is invalid or expired
- Check that you copied the full key from firecrawl.dev
- Try generating a new API key

### "Firecrawl API Error: Status 429"

- You've exceeded your API rate limit
- Wait a few minutes before trying again
- Consider upgrading your Firecrawl plan

### Connection/Network Errors

- Check your internet connection
- Try a different URL
- Ensure the target website is accessible

## Example URLs to Try

```
https://en.wikipedia.org/wiki/Web_scraping
https://news.ycombinator.com/
https://techcrunch.com/
https://www.bbc.com/news
```

## Getting Help

- **Firecrawl API Docs:** [docs.firecrawl.dev](https://docs.firecrawl.dev)
- **Firecrawl Support:** Check their support/contact page
- **iOS Issues:** Check Xcode console logs for detailed errors

---

**Enjoy scraping! 🕷️📱**
