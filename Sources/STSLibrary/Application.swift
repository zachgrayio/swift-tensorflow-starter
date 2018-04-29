import Foundation

public final class Application {
    let prefix = "STS"

    public init() {}

    public func run() throws {
        print("\(prefix): \(TensorFlowExample.multiplyTensor())")
    }
}