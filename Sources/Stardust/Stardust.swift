import Foundation

#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif

private final class StardustRunner {
    
    let version = "0.0.1"

    static let shared = StardustRunner()

    let dsl: StardustDSL = StardustDSL()

    private init() { }

    fileprivate func run() {
          do {
            let taskName = CommandLine.arguments[1]
            try executeTask(name: taskName) 
        } catch let error {
            print(error)
            exit(1)
        }
    }


    func executeTask(name: String) throws {
        
        guard let task = dsl.tasks.filter({ $0.name == name }).first else {
            let availableTasks = dsl.tasks.map({ $0.name })
            print("Could not find task named: '\(name)'")
            print("Abailable tasks:\n\(availableTasks)")
            return 
        }

        try task.handler()
    }

}

public func Stardust() -> StardustDSL {
    return StardustRunner.shared.dsl
}

public func run() {
    StardustRunner.shared.run()
}