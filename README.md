# LocalStorage
A Swift Property Wrapper that allows users to automatically save and load objects in UserDefaults.

## How to use?

Simple: Use it just like AppStorage.
The Item must conform to the Codable Protocol.
You can use it with Objects and Arrays.

## Demo

```swift

import SwiftUI
import LocalStorage

struct Item: Codable, Identifiable, Equatable {
    var id = UUID()
    var i: Int
}

struct ContentView: View {
    
    @LocalStorage("Test") var storage = [Item]()
    
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
