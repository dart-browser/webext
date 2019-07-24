# Overview
This [Dart](https://dartlang.org) package provides a tool like
[webdev](https://pub.dev/packages/webdev), but for building and running browser extensions.

Licensed under the [MIT License](LICENSE).

## Contributing
  * Create issues/pull requests [in Github](https://github.com/terrier989/webext).

# Getting started
## 1.Create a project
First, install/update `webextdev`:
```
pub global activate webextdev
```

Now you can:
```
webextdev create hello_world

cd hello_world

pub get
```

It generates a starter project that uses [package:webext](https://pub.dev/packages/webext).

Alternatively, you can create a project yourself and just include "webextdev" in _dev_dependencies_.

## 2.Build it
```
pub run webextdev build
```

## 3.Run it
```
pub run webextdev run
```

## 3.Pack it
```
pub run webextdev pack hello.crx
```