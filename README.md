# KVStore ![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat) ![Pod Support](https://img.shields.io/cocoapods/v/KVStore.svg?maxAge=2592000)

KVStore is a wrapper over sqlite to store and persist key value pairs.

## Demo
Have a look at the [demo app](https://appetize.io/app/773rqj6a096emec0gn92dd3bn0?device=iphone7&scale=75&orientation=portrait&osVersion=10.3)
# Installation
### CocoaPods

[CocoaPods](https://cocoapods.org/) is a dependency manager for Cocoa projects. You can install it with the following command:

```
$ gem install cocoapods

```
To integrate CardsStack into your Xcode project using CocoaPods, specify it in your Podfile:

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'KVStore', '1.3'
end

```
Then, run the following command:

```
$ pod install
```

### Carthage
[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```
$ brew update
$ brew install carthage

```
To integrate CardsStack into your Xcode project using Carthage, specify it in your Cartfile:

```
github "priteshrnandgaonkar/KVStore" == 1.5

```
Run `carthage update` to build the framework and drag the built CardsStack.framework into your Xcode project.

# How to use?

Create an instance of type `KVStoreManager`. As the name suggest, its a store manager which manages data of the KVStore. It can be initialised as follows


``` swift
do {
	let storeManager = try KVStoreManager(with: "TestKVPersistence")
}
catch (let error) {
	showAlert(withTitle: "Error", buttonTitle: "OK", message: error.localizedDescription, okAction: nil)
}
```

From the above code snippet, you can see that the `init` method for `KVStoreManager` is failable. The above initialisation may either fail in the execution of sqlite statements(which is highly unlikely) or the creation of database file.

This `KVStoreManager` has the following API's which eases the storage and fetching of data from sqlite database

``` swift

func insert<T: Hashable>(value: Data, for key: T) throws
func deleteValue<T: Hashable>(for key: T) throws
func update<T: Hashable>(value: Data, for key: T) throws
func getValue<T: Hashable>(for key: T) -> Data?
 
```

You can also access the value through subscript syntax, like as follows

``` swift
let data = storeManager[key]
```

The method definitions are self explanatory as to what they perform. The important point is that the `key` which is passed as argument should be of type `Hashable` and the value would be stored as `Data`

You can checkout the example in the framework and play around with it. To get used to this library.