/*
xcrun swiftc keygenCL.swift -o keygen -F ~/Library/Frameworks -sdk $(xcrun --show-sdk-path --sdk macosx)
*/

import Foundation
import Encryptor

let a = Process.arguments

func printHelp() {
    print("Usage:\nkeygen pw")
    print("For help, see the README file)")
}

if a.count < 2 {
    printHelp()
    exit(1)
}

let passphrase = a[1]
print(passphrase)
let key = Key(passphrase)
key.stretch()

let output = "\(key)"
let fn = "key.txt"

do {
    try output.writeToFile(
        fn,
        atomically: true,
        encoding: NSUTF8StringEncoding)
}
catch {
    printHelp()
    exit(1)
}
