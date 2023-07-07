# Simple, Self-Hosted Go links

Includes a Chrome extension and self hosted server for [Go links](https://golinks.github.io/golinks/).

Only tested on Google Chrome but should be easily modifiable to Firefox (try changing `chrome` to `browser` in `extension/worker.js``)

## Installation

1. Must have Docker and Python3.10.
2. Turn on Dev mode (top right) and unpack the extension into chrome://extensions
3. Run the docker container:

```bash
cd server
docker compose up -d
```
