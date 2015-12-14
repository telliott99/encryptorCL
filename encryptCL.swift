/*
xcrun swiftc encryptCL.swift -o encrypt -F ~/Library/Frameworks -sdk $(xcrun --show-sdk-path --sdk macosx)
*/

import Foundation
import Encryptor

let a = Process.arguments

func printHelp() {
    print("Usage:\nkeygen pw")
    print("For help, see the README file)")
}

if a.count < 3 {
    printHelp()
    exit(1)
}

let ifn = a[1]
let kfn = a[2]

var msgText: String
var keyText: String

do {
    msgText = try String(
        contentsOfFile:ifn,
        encoding: NSUTF8StringEncoding)
} catch {
    printHelp()
    exit(1)
}

do {
    keyText = try String(
        contentsOfFile:kfn,
        encoding: NSUTF8StringEncoding)
} catch {
    printHelp()
    exit(1)
}

let lines = keyText.characters.split{ $0 == "\n" }.map { String($0) }
var line0 = lines[0].characters.split{ $0 == " " }.map { String($0) }
let line1 = lines[1].characters.split{ $0 == " " }.map { String($0) }
let line2 = lines[2].characters.split{ $0 == " " }.map { String($0) }

// allow spaces in passwords on the command line...
let pw = line0[1..<line0.count].joinWithSeparator(" ")

let keyData = BinaryData(line1[1].hexByteStringToIntArray())
// print("keyData:\n\(keyData)")

let saltData = BinaryData(line2[1].hexByteStringToIntArray())
// print("saltData:\n\(saltData)")

let key = Key(pw)
key.stretch(saltIn: saltData)
// print("key:\n\(key)")

assert (keyData.data == key.data, "something wrong with the key")

let d = BinaryData(msgText.utf8.map { UInt8($0) } )
// print("input:\n\(d)")

let e = Encryptor(key)
let c = e.encrypt(d)
// print("encrypted:\n\(c)")
let output = "\(c)"

do {
    try output.writeToFile(
        "cipher.txt",
        atomically: true,
        encoding: NSUTF8StringEncoding)
}
catch {
    printHelp()
    exit(1)
}

do {
    try ("\(e.iv)").writeToFile(
        "iv.txt",
        atomically: true,
        encoding: NSUTF8StringEncoding)
}
catch {
    printHelp()
    exit(1)
}
