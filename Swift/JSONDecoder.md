# JSONDecoder

参考：

[http://www.cocoachina.com/articles/23771](http://www.cocoachina.com/articles/23771)
[https://www.jianshu.com/p/f4b3dce8bd6f](https://www.jianshu.com/p/f4b3dce8bd6f)

JSONDecoder是Swift 4.0出现用来反序列化(JSON->对象)的类。

```swift
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Swift 4.0
        // An object that decodes instances of a data type from JSON objects.
        let button: UIButton = UIButton(frame: CGRect(origin: CGPoint(x: 100, y: 100), size: CGSize(width: 200, height: 200)));
        button.addTarget(self, action: #selector(click), for: UIControl.Event.touchUpInside)
        button.backgroundColor = UIColor.red
        button.setTitle("Click me", for: UIControl.State.normal)
        self.view.addSubview(button)
    }
    
    // typealias Codable = Decodable & Encodable
    // 需要被反序列化的对象需要实现Decodable接口
    struct Product: Codable {
        var name: String
        var points: Int
        var description: String?
    }

    @objc
    func click() {
        let json = """
            {
                "name": "Durian",
                "points": 600,
                "description": "A fruit with a distinctive scent."
            }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        var product: Product!
        do {
            product = try decoder.decode(Product.self, from: json)
        } catch {
            print("error decode json")
        }
        print(product.name) // Durian
    }
}
```

### 字段不一致

假如务端下发的key跟端上不一致， 比如，服务端下发key="order_id"，端上定义key="orderId" 针对这个情况，使用JSONDecoder也可以解决，可以使用JSONDecoder的CodingKeys像在OC编程时的JSONModel类似做名称转换：

简单修改一下上面示例：

```swift
// typealias Codable = Decodable & Encodable
struct Person: Codable {
    var userId: String?
    var name: String?
    var height: CGFloat?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case name = "user_name"
        case height // 这是需要把所有的枚举都列出来，虽然height相同，也需要显式写上
    }
}

@objc
func click() {
    let json = """
        {
            "user_id": "1001",
            "user_name": "刘大",
            "height": 180.0
        }
    """.data(using: .utf8)!
    let decoder = JSONDecoder()
    var p: Person!
    do {
        p = try decoder.decode(Person.self, from: json)
    } catch {
        print("error decode json")
    }
    print(p.name!) // 刘大
}
```

在Swift 4.1, Apple给JSONDecoder添加了一个keySecodingStrategy属性:

```swift
let decoder = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromSnakeCase // 这会把snake case转为CamelCase
```

### 嵌套结构

```swift
// typealias Codable = Decodable & Encodable
struct Person: Codable {
    var name: String
    var points: Int
    var ability: Ability
    var description: String?
    
    struct Ability: Codable {
        var mathematics: String
        var physics: String
        var chemistry: String
    }
}

@objc
func click() {
    let json = """
    {
        "name": "大刘",
        "points": 600,
        "ability": {
            "mathematics": "优秀",
            "physics": "差",
            "chemistry": "及格"
        },
        "description": "大刘是一个好学生"
    }
    """.data(using: .utf8)!
    let decoder = JSONDecoder()
    var p: Person!
    do {
        p = try decoder.decode(Person.self, from: json)
    } catch {
        print("error decode json")
    }
    print(p.ability.chemistry) // 及格
}
```

由于数理化评价一般是优秀、良好、差这三种之一，因此可以做枚举：

```swift
struct Person: Codable {
    var name: String
    var points: Int
    var ability: Ability
    var description: String?
    
    struct Ability: Codable {
        var mathematics: Appraise
        var physics: Appraise
        var chemistry: Appraise
    }
    
    enum Appraise: String, Codable {
        case excellent, fine, bad
    }
}

@objc
func click() {
    let json = """
    {
        "name": "大刘",
        "points": 600,
        "ability": {
            "mathematics": "excellent",
            "physics": "bad",
            "chemistry": "fine"
        },
        "description": "大刘是一个好学生"
    }
    """.data(using: .utf8)!
    let decoder = JSONDecoder()
    var p: Person!
    do {
        p = try decoder.decode(Person.self, from: json)
    } catch {
        print("error decode json")
    }
    print(p.ability.chemistry) // fine
}
```
**注：**汉字不可做枚举值，比如上面把 `case excellent, fine, bad` 写成 `case 优秀 良好 差`, 即使json返回的是：

```
"ability": {
    "mathematics": "优秀",
    "physics": "差",
    chemistry": "良好"
}
```

经测试，程序也会crash, 因此可改为如下形式：

```swift
struct Person: Codable {
    var name: String
    var points: Int
    var ability: Ability
    var description: String?
    
    struct Ability: Codable {
        var mathematics: Appraise
        var physics: Appraise
        var chemistry: Appraise
    }
    
    enum Appraise: String, Codable {
        case excellent = "优秀", fine = "良好", bad = "差"
    }
}

@objc
func click() {
    let json = """
    {
        "name": "大刘",
        "points": 600,
        "ability": {
            "mathematics": "优秀",
            "physics": "差",
            "chemistry": "良好"
        },
        "description": "大刘是一个好学生"
    }
    """.data(using: .utf8)!
    let decoder = JSONDecoder()
    var p: Person!
    do {
        p = try decoder.decode(Person.self, from: json)
    } catch {
        print("error decode json")
    }
    print(p.ability.chemistry) // fine
}
```

### 平台可能不返回

针对平台可能不返回的情况，Swift天生支持optional， 因此只需在属性后加上?即可， 比如：`var name: String?`


### 类型不匹配

比如平台返回的是字符串"1"，而端上使用Int接收，这会直接Crash, JSONDecoder抛出typeMismatch异常而终结数据解析。目前JSONDecoder原生无法解决这类问题，


### 示例：

[代码示例JSONDecoderDemo](https://github.com/ACommonChinese/gitbook-daliu-ios/tree/master/%E4%BB%A3%E7%A0%81%E7%A4%BA%E4%BE%8B/JSONDecoderDemo)

通过一个复杂一些的示例展示，写一个从本地加载JSON数据为生成模型对象的类

```swift
class JSONLoader {
    public static func load<T: Decodable>(_ filename: String, as type: T.Type = T.self) -> T {
        let data: Data
        
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
}
```

调用如下：

```swift
let landmarks: [Landmark] = JSONLoader.load("landmarkData.json")
for landmark in landmarks {
    print(landmark.coordinates.latitude)
}
```


