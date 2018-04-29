<p align="center">
  <img src="docs/assets/logo.png">
  <br />
  <br />
  An opinionated Swift for TensorFlow starter project.
</p>


## Overview

STS is a a [Docker](http://docker.com/)ized, [Swift Package Manager](https://swift.org/package-manager/) enabled starter repository for [Swift for TensorFlow](https://github.com/tensorflow/swift) projects.

### Architecture

Projects built with this template will have a resultant architecture with the following traits:

1. Build output is a deployable Docker image with an entrypoint to a release-built executable
2. Provides quick and easy REPL access against the project's Swift for Tensorflow code and third-party libraries
3. Easily unit testable
4. Runs anywhere Docker is available with no additional setup necessary - zero conflicts with existing Swift or TensorFlow installations.

This will enable both ease of use during the research phase and a rapid transition to a scalable training solution and beyond (production deployment).

### Swift for TensorFlow

<p align="center">
  <img src="docs/assets/swift-tf-logo.png">
</p>

From the [official docs](https://github.com/tensorflow/swift):

>Swift for TensorFlow is a new way to develop machine learning models. It gives you the power of [TensorFlow](https://www.tensorflow.org) directly integrated into the [Swift programming language](https://swift.org/about).

### Docker

The project is fully Dockerized via the [swift-tensorflow](https://github.com/zachgrayio/swift-tensorflow#7-start-the-repl-in-a-container) image, meaning you don't need to worry about setting up local dependencies or conflicts with existing Xcode/Swift installations when developing Swift+TF applications unless you really want to - all build/run tasks can be accomplished from within the container.

### Swift Package Manager

This project template is a [Swift Package Manager](https://swift.org/package-manager/) project - `Package.swift` defines the runnable application, the core library, and third-party dependencies.

## Quickstart

### Prerequisites

#### Install Docker CE

Installation guides for macOS/Windows/Linux can be found [here](https://docs.docker.com/install/).

#### Clone the `swift-tensorflow-starter` Repository

```bash
git clone --depth 1 https://github.com/zachgrayio/swift-tensorflow-starter.git
cd swift-tensorflow-starter
```

Optionally, you may reset `git` so you can commit and push to your own repository:

```bash
rm -rf .git
git init && git commit -am "initial"
```

### 1) Add your Swift TensorFlow code

* Add your Swift source files to the to `Sources/STSLibary` directory
* If you'd like them to be part of the runnable application, add the appropriate calls to the `run()` method of `Application.swift`. If you only want to access this code from the REPL, that's it!

### 2) Build

Debug: 

```bash
docker build -t sts-app .
```

Release: 

```bash
docker build --build-arg CONFIG=release -t sts-app .
```

*Note: you may tag your built container as anything you'd like; if you use a different tag, be sure to use it instead of `sts-app` in the following bash commands.*

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

Now you can import anything defined in the `STSLibrary` module and interact with it. In this case, we're running the application.

```
Welcome to Swift version 4.2-dev (LLVM 04bdb56f3d, Clang b44dbbdf44). Type :help for assistance.
  1> import STSLibrary
  2> let app = Application()
app: STSLibrary.Application = {}
  3> app.run()
STS: Hello, world!
  4> :exit
```

### Scripts

There are optional scripts provided for common actions defined in steps 1-4 above:

* `run_tests.sh`
* `run_app.sh`
* `run_repl.sh`
* `gen_proj.sh`

## Usage

### SwitfPM Project Settings

By default the following names are used:

* Executable: `STSApplication`
* Library: `STSLibrary`
* SwiftPM project: `STSProject`

If desired, you can easily override these values with a simple find/replace in the root directory. The files which need changes are `Package.swift` and the `Dockerfile`, the example test classes, and a few directory names in `Sources` and `Tests`.

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

### Writing Unit Tests

See `STSLibraryTests.testApplicationPrefix()` in `Tests/STSLibraryTests/STSLibraryTests.swift` for an example test.

*Note: TensorFlow is not yet supported in Unit Tests.*

### Generate .xcodeproj

If desired, users on macOS can generate a `.xcodeproj` that you can open with an IDE (Xcode, AppCode, CLion). This is optional, and the xcodeproj is ignored in `.gitignore` by default. Also note that you'll want to swap out your xctoolchain as described [here](https://github.com/tensorflow/swift/blob/master/Installation.md) if you go this route.

The following command mounts a volume in the current directory and generates the project, resulting in the file being written to your host's disk.

```bash
docker run --rm -v ${PWD}:/usr/src \
    --entrypoint /usr/bin/swift \
    sts-app \
    package generate-xcodeproj
open STSProject.xcodeproj
```

## Disclaimer

A note from the official docs:

> Note: Swift for TensorFlow is an early stage research project. It has been released to enable open source development and is not yet ready for general use by machine learning developers.

## License

This project is [MIT Licensed](https://github.com/zachgrayio/swift-tensorflow-starter/blob/master/LICENSE).
