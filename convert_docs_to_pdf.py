#!/usr/bin/env python3
"""
Convert ARCHITECTURE.md to PDF with proper formatting
"""

import markdown
import os

# Read the markdown file
with open('ARCHITECTURE.md', 'r', encoding='utf-8') as f:
    md_content = f.read()

# Convert markdown to HTML
md = markdown.Markdown(extensions=['tables', 'fenced_code', 'codehilite'])
html_content = md.convert(md_content)

# Create HTML template with CSS styling
html_template = f"""
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>FirecrawlScraper Architecture Documentation</title>
    <style>
        @page {{
            size: A4;
            margin: 2cm;
        }}

        body {{
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif;
            line-height: 1.6;
            color: #333;
            max-width: 900px;
            margin: 0 auto;
            padding: 20px;
        }}

        h1 {{
            color: #2c3e50;
            border-bottom: 3px solid #3498db;
            padding-bottom: 10px;
            margin-top: 30px;
        }}

        h2 {{
            color: #34495e;
            border-bottom: 2px solid #95a5a6;
            padding-bottom: 8px;
            margin-top: 25px;
        }}

        h3 {{
            color: #5a6c7d;
            margin-top: 20px;
        }}

        code {{
            background-color: #f4f4f4;
            padding: 2px 6px;
            border-radius: 3px;
            font-family: 'Monaco', 'Menlo', 'Courier New', monospace;
            font-size: 0.9em;
        }}

        pre {{
            background-color: #2d2d2d;
            color: #f8f8f2;
            padding: 15px;
            border-radius: 5px;
            overflow-x: auto;
            page-break-inside: avoid;
        }}

        pre code {{
            background-color: transparent;
            padding: 0;
            color: #f8f8f2;
        }}

        table {{
            border-collapse: collapse;
            width: 100%;
            margin: 20px 0;
            page-break-inside: avoid;
        }}

        th, td {{
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }}

        th {{
            background-color: #3498db;
            color: white;
        }}

        tr:nth-child(even) {{
            background-color: #f9f9f9;
        }}

        blockquote {{
            border-left: 4px solid #3498db;
            padding-left: 15px;
            color: #666;
            font-style: italic;
            margin: 15px 0;
        }}

        ul, ol {{
            margin: 10px 0;
            padding-left: 30px;
        }}

        li {{
            margin: 5px 0;
        }}

        a {{
            color: #3498db;
            text-decoration: none;
        }}

        a:hover {{
            text-decoration: underline;
        }}

        .mermaid {{
            background-color: #f9f9f9;
            border: 1px solid #ddd;
            padding: 15px;
            border-radius: 5px;
            margin: 20px 0;
            page-break-inside: avoid;
        }}

        .diagram-placeholder {{
            background-color: #e8f4f8;
            border: 2px dashed #3498db;
            padding: 30px;
            text-align: center;
            margin: 20px 0;
            border-radius: 5px;
            font-style: italic;
            color: #555;
        }}

        .note {{
            background-color: #fff3cd;
            border-left: 4px solid #ffc107;
            padding: 15px;
            margin: 15px 0;
            border-radius: 3px;
        }}

        .architecture-ascii {{
            font-family: 'Courier New', monospace;
            background-color: #f4f4f4;
            padding: 15px;
            border-radius: 5px;
            white-space: pre;
            overflow-x: auto;
            page-break-inside: avoid;
        }}
    </style>
</head>
<body>
    {html_content}

    <div style="margin-top: 50px; padding-top: 20px; border-top: 2px solid #ddd; text-align: center; color: #888;">
        <p>Generated from ARCHITECTURE.md</p>
        <p>FirecrawlScraper Documentation</p>
    </div>
</body>
</html>
"""

# Write HTML file
with open('ARCHITECTURE.html', 'w', encoding='utf-8') as f:
    f.write(html_template)

print("✅ HTML file created: ARCHITECTURE.html")
print("\nTo convert to PDF, you can:")
print("1. Open ARCHITECTURE.html in your browser and print to PDF (⌘P)")
print("2. Or install wkhtmltopdf and run:")
print("   brew install wkhtmltopdf")
print("   wkhtmltopdf ARCHITECTURE.html ARCHITECTURE.pdf")
print("3. Or use Python library (requires weasyprint):")
print("   pip3 install weasyprint")
print("   python3 -c 'from weasyprint import HTML; HTML(\"ARCHITECTURE.html\").write_pdf(\"ARCHITECTURE.pdf\")'")
