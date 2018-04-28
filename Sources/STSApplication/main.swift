import STSLibrary

let app = Application()
do {
    try app.run()
} catch {
    print("Failed to run the STS Application: \(error)")
}
