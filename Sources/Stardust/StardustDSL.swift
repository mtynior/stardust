import Foundation

public struct Task {
    
    public var name: String

    public var handler: ( () throws -> Void  )

    public init(name: String, handler: @escaping ( () throws -> Void  ) ) {
        self.name = name
        self.handler = handler
    }

}

public class StardustDSL {

    var tasks: [Task] = []

    public init() { }

    public func task(_ name: String, handler: @escaping ( () throws -> Void)) {
        let task = Task(name: name, handler: handler)

        tasks.append(task)
    }

}