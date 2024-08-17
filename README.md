# Simple, Self-Hosted Go links

Includes a Chrome and Firefox extension and self hosted server for [Go links](https://golinks.github.io/golinks/).

> [!NOTE]  
> Maintence is primarily for Chromium-based browsers (e.g. Chrome, Arc). Firefox may or may not work

## Installation

1. Run the server ([see instructions here](./server/README.md))

2. Install the custom extension. See documentation for the following browsers:

   - [Chrome](https://support.google.com/chrome/a/answer/2714278?hl=en#:~:text=Go%20to%20chrome%3A%2F%2Fextensions,the%20app%20or%20extension%20folder.)
   - Arc: Same as Chrome but instead of `chrome://extensions`, go to `arc://extensions`.
   - Firefox:
     - [Initial install](https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/Your_first_WebExtension#installing)
     - [Persisting the extension](https://stackoverflow.com/questions/47363481/install-a-personal-firefox-web-extension-permanently)

3. Find the extension options for your newly installed extension and add your respective server/API key.
