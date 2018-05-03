<p align="center">
  <img src="docs/assets/logo.png">
  <br />
  <br />
  An opinionated Swift for TensorFlow starter project.
  <br />
  <br />
</p>


# Overview

STS is a [Docker](http://docker.com/)ized, [Swift Package Manager](https://swift.org/package-manager/) enabled starter repository for [Swift for TensorFlow](https://github.com/tensorflow/swift) projects. Now with hot-reload of Swift code and third-party packages!

### Swift for TensorFlow

<p align="center">
  <img src="docs/assets/swift-tf-logo.png">
</p>

From the [official docs](https://github.com/tensorflow/swift):

>Swift for TensorFlow is a new way to develop machine learning models. It gives you the power of [TensorFlow](https://www.tensorflow.org) directly integrated into the [Swift programming language](https://swift.org/about).

#### Disclaimer

> Note: Swift for TensorFlow is an early stage research project. It has been released to enable open source development and is not yet ready for general use by machine learning developers.

### Architecture

Projects built with this template will have the following traits:

1. Build output is a deployable Docker image with an entrypoint to a release-built executable
2. Quick and easy [REPL](https://github.com/tensorflow/swift/blob/master/Usage.md#repl-read-eval-print-loop) access against the project's Swift for Tensorflow code and third-party libraries
3. Easily unit testable
4. Runs anywhere Docker is available with no additional setup necessary - zero conflicts with existing Swift or TensorFlow installations.
5. *Swift code is hot-reloaded on change; third-party libraries are downloaded automatically as well. See the `--live` flag.*

This will enable both ease of use during the research phase and a rapid transition to a scalable training solution and beyond (production deployment).

### Docker

The project is fully Dockerized via the [swift-tensorflow](https://github.com/zachgrayio/swift-tensorflow) image, meaning you don't need to worry about setting up local dependencies or conflicts with existing Xcode/Swift installations when developing Swift+TF applications unless you really want to - all build/run tasks can be accomplished from within the container.

More information on the base docker image and avanced usage examples can be found in its [README](https://github.com/zachgrayio/swift-tensorflow/blob/master/README.md).

* Note: The initial Docker build may take some time; Docker needs to download intermediate layers for the Ubuntu16 image if you haven't used it previously. However, subsequent builds should complete in under 10 seconds on a reasonable machine.*

### Swift Package Manager

This project template is a [Swift Package Manager](https://swift.org/package-manager/) project - `Package.swift` defines the runnable application, the core library, and third-party dependencies.

# Quickstart

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

## The Easy Way

Users on macOS and Linux can take advantage of the supplied run script for easy usage - no Docker required!

### 1) Build and Run with Hot Reload enabled

After cloning, you can start the project in a single command using the `sts` executable that's included:

```bash
./sts run app --build --live
```

After this, any changes you make to the project will result in the Swift code being rebuilt in the container and the executable started. You can exit with `CTRL+C`.

### 2) Add your Swift TensorFlow code

* Add your Swift source files to the to `Sources/STSLibary` directory
* If you'd like them to be part of the runnable application, add the appropriate calls to the `run()` method of `Application.swift`. Assuming you wire up valid code, you'll see your output.
* If you'd rather just run the REPL, `CTRL-C` out of this session and run `./sts run repl --build`

That's it! However, it's recommended to continue reading and learn more about the underlying Docker container.

## The Hard Way

The following 4 steps describe how to add your code, build, and run the project with nothing other than the Docker binary; this should be relatively accurate cross-platform.

### 1) Add your Swift TensorFlow code

* Add your Swift source files to the to `Sources/STSLibary` directory
* If you'd like them to be part of the runnable application, add the appropriate calls to the `run()` method of `Application.swift`. If you only want to access this code from the REPL, no further work is required now.

### 2) Build

Debug: 

```bash
docker build -t sts-application .
```

Release: 

```bash
docker build --build-arg CONFIG=release -t sts-application .
```

*Note: you may tag your built container as anything you'd like; if you use a different tag, be sure to use it instead of `sts-application` in the following bash commands.*

### 3) Run Unit Tests

```bash
docker run --rm --entrypoint "/usr/bin/swift" sts-application test
```

### 4) Run

Now you can either run the executable, or a REPL.

#### Run the executable

```bash
docker run --rm sts-application
...
STS: [1.44, 0.64]
```

#### Run a REPL with access to the library

```bash
docker run --rm --security-opt seccomp:unconfined -it \
    --entrypoint /usr/bin/swift \
    sts-application \
    -I/usr/lib/swift/clang/include \
    -I/usr/lib \
    -L/usr/lib \
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
STS: [1.44, 0.64]
  4> :exit
```

### Control Script

A control script is included for extra convenience for users on macOS/Linux, but the Docker commands shown in steps 1-4 above also work on Windows.

Some example commands:

* `./sts run app --live` - automatically rebuild and run the application on code change; packages are updated automatically as well!
* `./sts build --release`,  `./sts build -r`,   `./sts build -p`,   `./sts build --prod` - build the image with a release executable
* `./sts run repl --build --name myrepl -v` - run a REPL in a container named myrepl, mounting the current directory as a volume, building the project first
* `./sts run test`,  `./sts run tests --name testcontainer` - run unit tests
* `./sts run xcode` - generate and opens a new xcode project
* `./sts run app -b` - run the application, building the container first
* `./sts run app -v` - runs an app tagged `myapp` with the current directory mounted as a volume to `/usr/src`.
* `./sts run app -n mycontainer -b` - build and tag the current image `mycontainer` and then run it.

NOTE: if you don't include the `-b|--build` flag to `app run` then the previously built image with that tag/name will be started. If an image with this tag is not found, one will be built.

# Usage

### Writing TensorFlow Code

Something to keep in mind when writing your TensorFlow code, as to avoid issues with send/receive (from the [official FAQ](https://github.com/tensorflow/swift/blob/master/FAQ.md#why-do-i-get-error-internal-error-generating-tensorflow-graph-graphgen-cannot-lower-a-sendreceive-to-the-host-yet)):

>We recommend separating functions that do tensor computation from host code in your programs. Those functions should be marked as `@inline(never)` (and have `public` access, to be safe). Within those functions, tensor computation should not be interrupted by host code. This ensures that the arguments and results of the extracted tensor program will be values on the host, as expected.

### SwiftPM Project Settings

By default the following names are used:

* Executable: `STSApplication`
* Library: `STSLibrary`
* SwiftPM project: `STSProject`

If desired, you can easily override these values with a simple find/replace in the root directory. The files which need changes are `Package.swift` and the `Dockerfile`, the example test classes and run scripts, and a few directory names in `Sources` and `Tests`.

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
    sts-application \
    package generate-xcodeproj
open STSProject.xcodeproj
```

*Note: You can also run the `run_xcode.sh` script to generate and open the project.*

### Examples

* Using RxSwift: [[View Diff](https://github.com/zachgrayio/swift-tensorflow-starter/commit/cde51c28c608d9e08f460944eae836881fef47d9)]
* Serving TensorFlow models with HTTP: coming soon.
* Training TensorFlow models over HTTP: coming soon.

### Leaving the Container

If you wish to run `swift build` and `swift run` on your project outside of the docker conainer, this is possible.

* On Linux: you've got this.
* On macOS: ensure you've [installed](https://github.com/tensorflow/swift/blob/master/Installation.md) the Swift for TensorFlow toolchain, and then use the following commands from within the project directory:

```bash
export PATH=/Library/Developer/Toolchains/swift-latest/usr/bin:"${PATH}"
swift run -Xswiftc -O
```

# License

This project is [MIT Licensed](https://github.com/zachgrayio/swift-tensorflow-starter/blob/master/LICENSE).
