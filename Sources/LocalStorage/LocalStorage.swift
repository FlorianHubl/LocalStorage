//  Created by Florian Hubl on 18.01.2023

import SwiftUI

@available(iOS 13.0, *)
@propertyWrapper
public class LocalStorage<Item: Codable>: DynamicProperty {
    @Published private var encoded: Item
    let key: String
    
    
    public var wrappedValue: Item {
        get {
            encoded
        }
        set {
            encoded = newValue
            let json = try! JSONEncoder().encode(newValue)
            UserDefaults().set(json, forKey: key)
        }
    }
    
    public init(wrappedValue: Item, _ a: String) {
        let data = UserDefaults().data(forKey: a)
        self.key = a
        if let data = data {
            do {
                let item = try JSONDecoder().decode(Item.self, from: data)
                self._encoded = Published(wrappedValue: item)
            }catch {
                self._encoded = Published(wrappedValue: wrappedValue)
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
            self._encoded = Published(wrappedValue: wrappedValue)
            let json = try! JSONEncoder().encode(wrappedValue)
            UserDefaults().set(json, forKey: a)
        }
    }
}

