# Array

Returns the first index where the specified value appears in the collection.

func firstIndex(where predicate: (Int) throws -> Bool) rethrows -> Int?

You can use the predicate to find an element of a type that doesn’t conform to the Equatable protocol or to find an element that matches particular criteria. Here’s an example that finds a student name that begins with the letter “A”:

```swift
let students = ["Kofi", "Abena", "Peter", "Kweku", "Akosua"]
if let i = students.firstIndex(where: { $0.hasPrefix("A") }) {
    print("\(students[i]) starts with 'A'!")
}
// Prints "Abena starts with 'A'!"
```

```swift

let num = [11,22,33,44,55,33]

let i: Int? = num.firstIndex(of: 22) // 找到22所在的索引位置是1
print(i!) // 1

let index: Int? = num.firstIndex { (e) -> Bool in
    return e == 55 || e == 44 // 找到数组中
}
print(index!) // 3
```