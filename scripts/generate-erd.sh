```bash
#!/bin/bash

set -e

echo "======================================"
echo " Microfinance Core - Generate ERD"
echo "======================================"

# Project directory
cd /Users/aunghtetpaing/Documents/mfs

echo ""
echo "📁 Project directory:"
pwd

echo ""
echo "🧹 Removing Puppeteer cache..."
rm -rf ~/.cache/puppeteer

echo ""
echo "⚙️ Setting Puppeteer environment..."

export PUPPETEER_SKIP_DOWNLOAD=true

export PUPPETEER_EXECUTABLE_PATH="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

echo ""
echo "🌐 Chrome executable:"
echo "$PUPPETEER_EXECUTABLE_PATH"

echo ""
echo "🔍 Checking Chrome executable..."
ls -l "$PUPPETEER_EXECUTABLE_PATH"

echo ""
echo "🔍 Checking Chrome version..."
"$PUPPETEER_EXECUTABLE_PATH" --version

echo ""
echo "📊 Generating Prisma ERD..."
npx prisma generate

echo ""
echo "======================================"
echo " ✅ Prisma ERD generation completed"
echo "======================================"
```
