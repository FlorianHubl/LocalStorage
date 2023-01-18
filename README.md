# LocalStorage
A Swift Property Wrapper that allows users to automatically save and load objects in UserDefaults.

## How to use?

Simple: Use it just like AppStorage.
The Item must conform to the Codable Protocol.
You can use it with Objects and Arrays.

## Demo

```swift

struct DemoObject: Codable, Identifiable, Equatable {
    var id = UUID()
    var i: Int
}

struct LocalStorageDemo: View {
    
    @LocalStorage("Demo") var storage = [DemoObject(i: 1)]
    
    var body: some View {
        VStack {
            Text("LocalStorageDemo")
            ForEach(storage) { storage in
                Text("\(storage.i)")
            }
        }
        .onTapGesture {
            storage.append(Test(i: Int.random(in: 1...100)))
        }
        .animation(.easeInOut, value: storage)
    }
}

```
The data is saved permanently on the device.
