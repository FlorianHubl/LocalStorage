# LocalStorage
A Swift Property Wrapper that allows users to automatically save and load objects in UserDefaults.

## Install via Swift Package Manager

- Add it using XCode menu **File > Swift Package > Add Package Dependency**
- Add **https://github.com/FlorianHubl/LocalStorage.git** as Swift Package URL
- Click on the package
- Click Add Package and you are done :D

## Requirements

- iOS 13 or higher
- iPadOS 13 or higher
- macOS 10.15 or higher
- Mac Catalyst 13 or higher
- tvOS 6 or higher
- watchOS 6 or higher

## The Problem 

```swift

struct Item {
    var i: Int
}

@AppStorage("item") var item = Item(i: Int) // <-- This doesn't work, because AppStorage/UserDefaults doesn't support objects and arrays

```

## The Soluction

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
