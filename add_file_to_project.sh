#!/bin/bash

# Generate UUIDs for Xcode
UUID1=$(uuidgen | tr -d '-' | cut -c1-24)
UUID2=$(uuidgen | tr -d '-' | cut -c1-24)
UUID3=$(uuidgen | tr -d '-' | cut -c1-24)

PROJECT_FILE="FirecrawlScraper.xcodeproj/project.pbxproj"

# Backup original
cp "$PROJECT_FILE" "$PROJECT_FILE.backup"

# Add PBXBuildFile entries (after ContentView.swift)
sed -i '' "/ContentView.swift in Sources/a\\
		$UUID1 /* MarkdownView.swift in Sources */ = {isa = PBXBuildFile; fileRef = $UUID3 /* MarkdownView.swift */; };\\
		$UUID2 /* MarkdownView.swift in Sources */ = {isa = PBXBuildFile; fileRef = $UUID3 /* MarkdownView.swift */; };
" "$PROJECT_FILE"

# Add PBXFileReference (after ContentView.swift)
sed -i '' "/ContentView.swift .*fileRef/a\\
		$UUID3 /* MarkdownView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = MarkdownView.swift; sourceTree = \"<group>\"; };
" "$PROJECT_FILE"

# Add to group (after ContentView.swift in group)
sed -i '' "/A10000004 \/\* ContentView.swift \*\//a\\
				$UUID3 /* MarkdownView.swift */,
" "$PROJECT_FILE"

# Add to build phases for both targets
sed -i '' "/A10000003 \/\* ContentView.swift in Sources \*\//a\\
				$UUID1 /* MarkdownView.swift in Sources */,
" "$PROJECT_FILE"

sed -i '' "/A10000046 \/\* ContentView.swift in Sources \*\//a\\
				$UUID2 /* MarkdownView.swift in Sources */,
" "$PROJECT_FILE"

echo "✅ MarkdownView.swift added to project!"
echo "UUIDs used:"
echo "  PBXBuildFile (iOS): $UUID1"
echo "  PBXBuildFile (macOS): $UUID2"
echo "  PBXFileReference: $UUID3"
