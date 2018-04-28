# swift-tensorflow-starter (STS)

A Dockerized, Swift Package Manager enabled starter repository for Swift for TensorFlow projects.

## Overview

### Dual Architecture

The project is aims to enable the creations of projects that strike a balance between two primary goals:

1. Can be easily packaged into deployable Docker image with an entrypoint to a release-built executable
2. Provides quick and easy REPL access against Swift for Tensorflow code stored in the `STSLibrary` module 

This will enable both ease of use during the research phase and a rapid transition to a scalable training solution and beyond (production deployment).

### Docker

This repository is Dockerized via the [swift-tensorflow](https://github.com/zachgrayio/swift-tensorflow#7-start-the-repl-in-a-container) image, meaning you don't need to worry about setting up local dependencies or conflicts with existing Xcode/Swift installations when developing Swift+TF applications unless you really want to - all build/run tasks can be accomplished from within the container.

### Swift Package Manager

This project template is a Swift Package Manager project - `Package.swift` defines the runnable application, the core library, and third-party dependencies.

## Quickstart

### 1) Add your model code

* Add your Swift source files to the to `STSLibary` directory 
* If you'd like them to be part of the runnable application, add the appropriate calls to the `run()` method of `Application.swift`. Otherwise, that's it!

### 2) Build

Debug: 

```bash
docker build -t sts-app .
```

Release: 

```bash
docker build --build-arg CONFIG=release -t sts-app .
```

### 3) Run Unit Tests

```bash
docker run --rm --entrypoint "/usr/bin/swift" sts-app test
```

### 4) Run

Now you can either run the executable, or a REPL.

#### Run the executable

```bash
docker run --rm sts-app
```

#### Run a REPL with access to the library

```bash
docker run --rm --security-opt seccomp:unconfined -it \
    --entrypoint /usr/bin/swift \
    sts-app \
    -I/usr/lib/swift/clang/include \
    -I/usr/src/STSLibrary \
    -L/usr/src/STSLibrary \
    -lSTSLibrary \
    -lswiftPython \
    -lswiftTensorFlow
```

Now you can import anything defined in the STSLibrary module and interact with it. In this case, we're running the application.

```
Welcome to Swift version 4.2-dev (LLVM 04bdb56f3d, Clang b44dbbdf44). Type :help for assistance.
  1> import STSLibrary
  2> let app = Application()
app: STSLibrary.Application = {}
  3> app.run()
STS: Hello, world!
  4> :exit
```

## Usage

### Generate .xcodeproj

If desired, you can generate a `.xcodeproj` that you can open with an IDE (Xcode, AppCode, CLion). This is optional, and the xcodeproj is ignored in `.gitignore` by default.

The following command mounts a volume in the current directory and generates the project, resulting in the file being written to your host's disk. 

```bash
docker run --rm -v ${PWD}:/usr/src \
    --entrypoint /usr/bin/swift \
    sts-app \
    package generate-xcodeproj
open STSProject.xcodeproj
```

### Third-party Libraries

Third-party Swift libraries can be added to the `dependencies` collection in `Package.swift` and then imported for use. 

Example: 

```swift
...
dependencies: [
    .package(url: "https://github.com/ReactiveX/RxSwift.git", "4.0.0" ..< "5.0.0")
],
...
```

### System Dependencies

The project's `Dockerfile` is based on Ubuntu 16, so you can simply add `RUN apt-get install -y ...` entries to fetch additional dependencies.

## License

This project is [MIT Licensed](https://github.com/zachgrayio/swift-tensorflow-starter/blob/master/LICENSE).
