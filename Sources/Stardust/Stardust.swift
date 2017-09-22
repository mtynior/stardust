import Foundation

public final class Stardust {

    public var tasks: [Task] = []

    public init() { }

    public func task(_ name: String, handler: @escaping ( () throws -> Void)) {
        let task = Task(name: name, handler: handler)

        tasks.append(task)
    }

    public func run() {
        do {
            let taskName = CommandLine.arguments[1] 
            try executeTask(name: taskName) 
        } catch let error {
            print(error)
            exit(1)
        }
    }

    func executeTask(name: String) throws {
        
        guard let task = tasks.filter({ $0.name == name }).first else {
            let availableTasks = tasks.map({ $0.name })
            print("Could not find task named: '\(name)'")
            print("Available tasks:\n\(availableTasks)")
            return 
        }

        try task.handler()
    }

}