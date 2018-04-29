
import RxSwift
import Foundation

struct RxExample {
    static func printHello() {
        let wordList = ["Hello", "Rx", "World"]

        _ = Observable<Int>.interval(1, scheduler: SerialDispatchQueueScheduler(qos: .default))
            .take(wordList.count)
            .map { index in wordList[index]}
            .do(onNext: { word in
                print(word)
            })

        // sleep for the duration of the above so the application doesn't exit before completion
        Thread.sleep(forTimeInterval: Double(wordList.count))
    }
}
