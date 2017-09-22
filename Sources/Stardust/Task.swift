import Foundation

public struct Task {
    
    public var name: String

    public var description: String?

    public var handler: ( () throws -> Void  )

    public init(name: String, handler: @escaping ( () throws -> Void  ) ) {
        self.name = name
        self.handler = handler
    }

}
