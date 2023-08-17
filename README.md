# LocalStorage

<img src="https://github.com/FlorianHubl/LocalStorage/blob/main/LocalStorage.png" width="173" height="173">

A Swift Property Wrapper that allows users to automatically save and load objects in UserDefaults.
Its an extention of AppStorage.

## Install via Swift Package Manager

- Add it using XCode menu **File > Swift Package > Add Package Dependency**
- Add **https://github.com/FlorianHubl/LocalStorage.git** as Swift Package URL
- Click on the package
- Click Add Package and you are done :)

## Requirements

- iOS 13 or higher
- iPadOS 13 or higher
- macOS 10.15 or higher
- Mac Catalyst 13 or higher
- tvOS 6 or higher
- watchOS 6 or higher

## The Problem 

```swift

import SwiftUI

struct Item {
    var i: Int
}

@AppStorage("item") var item = Item(i: Int) // <-- This doesn't work, because AppStorage/UserDefaults doesn't support objects and arrays


```

## The Solution

Simple: Use LocalStorage just like AppStorage.
The item must conform to the Codable protocol.
You can use it with objects and arrays.

```swift

import LocalStorage

struct Item {
    var i: Int
}

@LocalStorage("item") var item = Item(i: Int)


```


## Demo in SwiftUI

```swift

import SwiftUI
import LocalStorage

struct Item: Codable, Identifiable, Equatable {
    var id = UUID()
    var int: Int
}

struct ContentView: View {
    
    @LocalStorage("items") var items = [Item]()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    Text("\(item.int)")
                }
                .onDelete { indexSet in
                    items.remove(atOffsets: indexSet)
                }
            }
            Button("Add Object") {
                items.append(Item(i: Int.random(in: 1...100)))
            }
            .navigationTitle("LocalStorage Demo")
        }
        .animation(.easeInOut, value: items)
    }
}

```
The data is saved permanently on the device.

## Ok, but how does it actually work?

Simple: When the user writes something to this value the property wrapper will convert that data into JSON and save it as binary data into the UserDefault under the specified key. If the user reads from the value the Data will be fetched from the UserDefaults and convert the JSON into a Swift object or array. Note that this package is pretty new and probably got some bugs. If you find one please report them to further improove the package. So now it is time to play around with it. :D


