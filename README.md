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

## How to use?

Simple: Use it just like AppStorage.
The item must conform to the Codable protocol.
You can use it with objects and arrays.

## Demo

```swift

import SwiftUI
import LocalStorage

struct Item: Codable, Identifiable, Equatable {
    var id = UUID()
    var i: Int
}

struct ContentView: View {
    
    @LocalStorage("Demo") var storage = [Item]()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(storage) { storage in
                    Text("\(storage.i)")
                }
                .onDelete { indexSet in
                    storage.remove(atOffsets: indexSet)
                }
            }
            Button("Add Object") {
                storage.append(Item(i: Int.random(in: 1...100)))
            }
            .navigationTitle("LocalStorage Demo")
        }
        .animation(.easeInOut, value: storage)
    }
}

```
The data is saved permanently on the device.
