// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "KVStore",
    targets: [Target(name:"KVStoreTests", dependencies: []), Target(name:"KVStore", dependencies:[])],
    dependencies: []
)
