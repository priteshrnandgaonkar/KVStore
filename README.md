#KVStore ![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)

KVStore is a wrapper over sqlite to store and persist key value pairs.

#Installation
### Carthage
[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```
$ brew update
$ brew install carthage

```
To integrate CardsStack into your Xcode project using Carthage, specify it in your Cartfile:

```
github "priteshrnandgaonkar/KVStore" == 1.0

```
Run `carthage update` to build the framework and drag the built CardsStack.framework into your Xcode project.

#How to use?

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
func getValue<T: Hashable>(for key: T) throws -> Data
 
```

The method definitions are self explanatory as to what they perform. The important point is that the `key` which is passed as argument should be of type `Hashable` and the value would be stored as `Data`

You can checkout the example in the framework and play around with it. To get used to this library.