# Overview
This Dart package contains APIs for building browser extensions for Chrome, Edge, and Firefox.

Currently the package supports only a small set of APIs. If you want more APIs, you could use
[package:chrome](https://pub.dev/packages/chrome).

Licensed under the [MIT License](LICENSE).

## Contributing
  * Create issues/pull requests [in Github](https://github.com/terrier989/webext).

## Documentation
  * [Chrome APIs](https://developer.chrome.com/extensions/api_index)
  * [Mozilla APIs](https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions)

# Getting started
Pub package [webextdev](https://pub.dev/packages/webextdev) provides a convenient command-line tool.

Install _webextdev_:
```
pub global activate webextdev
```

Create a project:
```
webextdev create hello_world
```

Get dependencies:
```
cd hello_world

pub get
```

Run the browser extension:
```
pub run webextdev run --build
```