# Overview
This Dart package contains APIs for building browser extensions for:
  * Chrome
  * Edge
  * Firefox

Currently the package supports only a small set of APIs. If you want to access all APIs, there is
[package:chrome](https://pub.dev/packages/chrome).

# Getting started
## 1.Create a project
First, install/update `webextdev`:
```
pub global activate webextdev
```

Now you can:
```
webextdev create hello_world
```

## 3.Build the project
```
pub run webextdev build
```