# NSHashMap


```swift
@available(iOS 6.0, *)
open class NSMapTable<KeyType, ObjectType> : NSObject, NSCopying, NSSecureCoding, NSFastEnumeration where KeyType : AnyObject, ObjectType : AnyObject {
    public init(keyOptions: NSPointerFunctions.Options = [], valueOptions: NSPointerFunctions.Options = [], capacity initialCapacity: Int)

    public init(keyPointerFunctions keyFunctions: NSPointerFunctions, valuePointerFunctions valueFunctions: NSPointerFunctions, capacity initialCapacity: Int)

    public /*not inherited*/ init(keyOptions: NSPointerFunctions.Options = [], valueOptions: NSPointerFunctions.Options = [])

    
    @available(iOS 6.0, *)
    open class func strongToStrongObjects() -> NSMapTable<KeyType, ObjectType>

    @available(iOS 6.0, *)
    open class func weakToStrongObjects() -> NSMapTable<KeyType, ObjectType> // entries are not necessarily purged right away when the weak key is reclaimed

    @available(iOS 6.0, *)
    open class func strongToWeakObjects() -> NSMapTable<KeyType, ObjectType>

    @available(iOS 6.0, *)
    open class func weakToWeakObjects() -> NSMapTable<KeyType, ObjectType> // entries are not necessarily purged right away when the weak key or object is reclaimed

    
    /* return an NSPointerFunctions object reflecting the functions in use.  This is a new autoreleased object that can be subsequently modified and/or used directly in the creation of other pointer "collections". */
    @NSCopying open var keyPointerFunctions: NSPointerFunctions { get }

    @NSCopying open var valuePointerFunctions: NSPointerFunctions { get }
    open func object(forKey aKey: KeyType?) -> ObjectType?
    open func removeObject(forKey aKey: KeyType?)
    open func setObject(_ anObject: ObjectType?, forKey aKey: KeyType?) // add/replace value (CFDictionarySetValue, NSMapInsert)
    open var count: Int { get }
    open func keyEnumerator() -> NSEnumerator
    open func objectEnumerator() -> NSEnumerator?
    open func removeAllObjects()
    open func dictionaryRepresentation() -> [AnyHashable : ObjectType] // create a dictionary of contents
}
```

常使用的比如对key进行weak引用:  

```swift
var mapTable: NSMapTable = NSMapTable.init(keyOptions: .weakMemory, valueOptions: .strongMemory)
```

