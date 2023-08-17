//  Created by Florian Hubl on 18.01.2023

import SwiftUI

@available(iOS 13.0, *)
class LocalStorageItem<Item: Codable>: ObservableObject {
    @Published var item: Item
    init(item: Codable) {
        self.item = item as! Item
    }
}

@available(iOS 14.0, *)
@propertyWrapper
public struct LocalStorage<Item: Codable>: DynamicProperty {
    @StateObject private var encoded: LocalStorageItem<Item>
    let key: String
    
    public var wrappedValue: Item {
        get {
            encoded.item
        }
        nonmutating set {
            encoded.item = newValue
            let json = try! JSONEncoder().encode(newValue)
            UserDefaults().set(json, forKey: key)
        }
    }
    
    public var projectedValue: Binding<Item> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }
    
    public init(wrappedValue: Item, _ a: String) {
        let data = UserDefaults().data(forKey: a)
        self.key = a
        if let data = data {
            do {
                let item = try JSONDecoder().decode(Item.self, from: data)
                UserDefaults().set(item, forKey: a)
                self._encoded = StateObject(wrappedValue: LocalStorageItem(item: wrappedValue))
            }catch {
                self._encoded = StateObject(wrappedValue: LocalStorageItem(item: wrappedValue))
                let json = try! JSONEncoder().encode(wrappedValue)
                UserDefaults().set(json, forKey: a)
                print("LocalStorage: Input has not the correct type")
                print("Input key: \(a)")
                print("Input item: \(wrappedValue)")
                print("Input type: \(type(of: wrappedValue))")
                print("Data in UserDefaults: \(String(data: data, encoding: .utf8) ?? "Data Error")")
                print("The data has been overwritten with: \(wrappedValue)")
            }
        }else {
            self._encoded = StateObject(wrappedValue: LocalStorageItem(item: wrappedValue))
            let json = try! JSONEncoder().encode(wrappedValue)
            UserDefaults().set(json, forKey: a)
        }
    }
}

