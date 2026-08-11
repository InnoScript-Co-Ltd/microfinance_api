## Database ERD

The Microfinance Core System database is designed using PostgreSQL
with Prisma ORM and Snowflake BIGINT identifiers.

See the complete ERD:

- [Database ERD](./docs/erd.md)
- [Prisma Schema](./prisma/schema.prisma)

## Generate ERD Diagram 

- cd /Users/aunghtetpaing/Documents/mfs
- rm -rf ~/.cache/puppeteer
- export PUPPETEER_SKIP_DOWNLOAD=true
- export PUPPETEER_EXECUTABLE_PATH="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
- ls -l "$PUPPETEER_EXECUTABLE_PATH"
- "$PUPPETEER_EXECUTABLE_PATH" --version
- npx prisma generate