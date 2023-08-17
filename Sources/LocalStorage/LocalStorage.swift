//  Created by Florian Hubl on 18.01.2023

import SwiftUI

@available(iOS 13.0, *)
@frozen @propertyWrapper public struct LocalStorage<Value> : DynamicProperty {

    @ObservedObject private var _value: Storage<Value>
    private let saveValue: (Value) -> Void

    private init(value: Value, store: UserDefaults, key: String, transform: @escaping (Any?) -> Value?, saveValue: @escaping (Value) -> Void) {
        _value = Storage(value: value, store: store, key: key, transform: transform)
        self.saveValue = saveValue
    }

    public var wrappedValue: Value {
        get {
            _value.value
        }
        nonmutating set {
            saveValue(newValue)
            _value.value = newValue
        }
    }

    public var projectedValue: Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { self.wrappedValue = $0 }
        )
    }
}

@available(iOS 13.0, *)
@usableFromInline
final class Storage<Value>: NSObject, ObservableObject {
    @Published var value: Value
    private let defaultValue: Value
    private let store: UserDefaults
    private let keyPath: String
    private let transform: (Any?) -> Value?

    init(value: Value, store: UserDefaults, key: String, transform: @escaping (Any?) -> Value?) {
        self.value = value
        self.defaultValue = value
        self.store = store
        self.keyPath = key
        self.transform = transform
        super.init()

        store.addObserver(self, forKeyPath: key, options: [.new], context: nil)
    }

    deinit {
        store.removeObserver(self, forKeyPath: keyPath)
    }

    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {

        value = change?[.newKey].flatMap(transform) ?? defaultValue
    }
}

@available(iOS 13.0, *)
extension LocalStorage where Value == Bool {
    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) {
        let store = (store ?? .standard)
        let initialValue = store.value(forKey: key) as? Value ?? wrappedValue
        self.init(value: initialValue, store: store, key: key, transform: {
            $0 as? Value
        }, saveValue: { newValue in
            store.setValue(newValue, forKey: key)
        })
    }
}

@available(iOS 13.0, *)
extension LocalStorage where Value == Int {
    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) {
        let store = (store ?? .standard)
        let initialValue = store.value(forKey: key) as? Value ?? wrappedValue
        self.init(value: initialValue, store: store, key: key, transform: {
            $0 as? Value
        }, saveValue: { newValue in
            store.setValue(newValue, forKey: key)
        })
    }
}

@available(iOS 13.0, *)
extension LocalStorage where Value == Double {
    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) {
        let store = (store ?? .standard)
        let initialValue = store.value(forKey: key) as? Value ?? wrappedValue
        self.init(value: initialValue, store: store, key: key, transform: {
            $0 as? Value
        }, saveValue: { newValue in
            store.setValue(newValue, forKey: key)
        })
    }
}

@available(iOS 13.0, *)
extension LocalStorage where Value == String {
    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) {
        let store = (store ?? .standard)
        let initialValue = store.value(forKey: key) as? Value ?? wrappedValue
        self.init(value: initialValue, store: store, key: key, transform: {
            $0 as? Value
        }, saveValue: { newValue in
            store.setValue(newValue, forKey: key)
        })
    }
}

@available(iOS 13.0, *)
extension LocalStorage where Value == URL {
    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) {
        let store = (store ?? .standard)
        let initialValue = store.url(forKey: key) ?? wrappedValue
        self.init(value: initialValue, store: store, key: key, transform: {
            ($0 as? String).flatMap(URL.init)
        }, saveValue: { newValue in
            store.set(newValue, forKey: key)
        })
    }
}

@available(iOS 13.0, *)
extension LocalStorage where Value == Data {
    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) {
        let store = (store ?? .standard)
        let initialValue = store.value(forKey: key) as? Value ?? wrappedValue
        self.init(value: initialValue, store: store, key: key, transform: {
            $0 as? Value
        }, saveValue: { newValue in
            store.setValue(newValue, forKey: key)
        })
    }
}

@available(iOS 13.0, *)
extension LocalStorage where Value: Codable {
    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) {
        let store = (store ?? .standard)
        let initialValue = store.data(forKey: key)
        var d = wrappedValue
        if let v = initialValue {
            let a = try? JSONDecoder().decode(Value.self, from: v)
            d = a ?? wrappedValue
        }
        self.init(value: d, store: store, key: key, transform: {
            $0 as? Value
        }, saveValue: { newValue in
            let json = try! JSONEncoder().encode(newValue)
            store.setValue(json, forKey: key)
        })
    }
}

@available(iOS 13.0, *)
extension LocalStorage where Value : RawRepresentable, Value.RawValue == Int {
    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) {
        let store = (store ?? .standard)
        let rawValue = store.value(forKey: key) as? Int
        let initialValue = rawValue.flatMap(Value.init) ?? wrappedValue
        self.init(value: initialValue, store: store, key: key, transform: {
            ($0 as? Int).flatMap(Value.init)
        }, saveValue: { newValue in
            store.setValue(newValue.rawValue, forKey: key)
        })
    }
}

@available(iOS 13.0, *)
extension LocalStorage where Value : RawRepresentable, Value.RawValue == String {
    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) {
        let store = (store ?? .standard)
        let rawValue = store.value(forKey: key) as? String
        let initialValue = rawValue.flatMap(Value.init) ?? wrappedValue
        self.init(value: initialValue, store: store, key: key, transform: {
            ($0 as? String).flatMap(Value.init)
        }, saveValue: { newValue in
            store.setValue(newValue.rawValue, forKey: key)
        })
    }
}
