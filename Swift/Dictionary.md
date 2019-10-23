# Dictionary

### index(forKey:)

Instance method, Returns the index for the given key.

```swift
func index(forKey key: Key) -> Dictionary<Key, Value>.Index?
```

**Return Value**
The index for key and its associated value if key is in the dictionary; otherwise, nil.


```swift
let countryCodes = ["BR": "Brazil", "GH": "Ghana", "CN": "China", "JP": "Japan"]
let index = countryCodes.index(forKey: "CN")

print(countryCodes[index!].key) // CN
print(countryCodes[index!].value) // China
print(countryCodes.keys[index!]) // CN
print(countryCodes.values[index!]) // China
```




