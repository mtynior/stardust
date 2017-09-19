import Foundation

let fileManager = FileManager.default

// Finds first occurrence of supported path
let supportedPaths = ["Stardustfile.swift", "stardust/Stardustfile.swift", "Stardust/Stardustfile.swift"]
let resolvedPath = supportedPaths.first { fileManager.fileExists(atPath: $0) }

// Exit if a Stardustfile was not found at any supported path
guard let stardustfilePath = resolvedPath else {
    print("Could not find a Stardustfile")
    print("Please use a supported path: \(supportedPaths)")
    exit(0)
}

// Is this a dev build: e.g. running inside a cloned Stardust/Stardustfile
let libraryFolders = [".build/debug", ".build/release"]

// Check and find where we can link to libStardust from
let libStardust = "libStardust.dylib"
let libPaths = libraryFolders
guard let libPath = libPaths.first(where: { fileManager.fileExists(atPath: $0 + "/libStardust.dylib") }) else {
    print("Could not find a libStardust at any of: \(libPaths)")
    exit(1)
}

// Example commands:
//
//
// ## Run the full system:
//
// ## Run compilation and eval of the Stardustfile:
// swiftc --driver-mode=swift -L .build/debug -I .build/debug -lStardust Stardustfile.swift
//

let taskName = CommandLine.arguments[1]

var args = [String]()
args += ["--driver-mode=swift"] // Eval in swift mode, I think?
args += ["-L", libPath] // Find libs inside this folder
args += ["-I", libPath] // Find libs inside this folder
args += ["-lStardust"] // Eval the code with the Target Stardust added
args += [stardustfilePath] // The Stardustfile
args += [taskName]

// This ain't optimal, but SwiftPM have _so much code_ around this.
// So maybe there's a better way
let supportedSwiftCPaths = ["/home/travis/.swiftenv/shims/swiftc", "/usr/bin/swiftc"]
let swiftCPath = supportedSwiftCPaths.first { fileManager.fileExists(atPath: $0) }
let swiftC = swiftCPath != nil ? swiftCPath! : "swiftc"

print("Running: \(swiftC) \(args.joined(separator: " "))")

// Create a process to eval the Swift file
let proc = Process()
proc.launchPath = swiftC
proc.arguments = args

let standardOutput = FileHandle.standardOutput
proc.standardOutput = standardOutput
proc.standardError = standardOutput

proc.launch()
proc.waitUntilExit()

if (proc.terminationStatus != 0) {
    print("Stardustfile eval failed at \(stardustfilePath)")
}

// Return the same error code as the compilation
exit(proc.terminationStatus)