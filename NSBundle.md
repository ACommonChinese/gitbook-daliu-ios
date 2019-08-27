# NSBundle

[Apple: Accessing a Bundle's Contents](https://developer.apple.com/library/archive/documentation/CoreFoundation/Conceptual/CFBundles/AccessingaBundlesContents/AccessingaBundlesContents.html#//apple_ref/doc/uid/10000123i-CH104-SW14)
[Apple: NSBundle class reference](https://developer.apple.com/documentation/foundation/nsbundle?language=objc)

> A representation of the code and resources stored in a bundle directory on disk.

注：并不是所有的资源都一定要通过Bundle来获取:

> Some types of frequently used resources can be located and opened without a bundle. For example, when loading images, you store images in asset catalogs and load them using the imageNamed: methods of UIImage or NSImage. Similarly, for string resources, you use NSLocalizedString to load individual strings instead of loading the entire .strings file yourself.
> 放在Assets中的图片文件和国际化文本并不是通过Bundle来获取的

## main bundle

> **The main bundle is the bundle that contains the code and resources for the running application. **

在定位一个资源之前，首先要做的就是指定这个资源所属的bundle, NSBundle有很多构造方法，最常用的就是`mainBundle`,  `Bundle.main`返回的是包含当前可执行代码的bundle: `Returns the bundle object that contains the current executable.`, 对于app来说，就是主工程。使用mainBundle获取资源通常使用两个方法：

- `+ bundleForClass: Returns the NSBundle object with which the specified class is associated.`
- `+ bundleWithPath: Returns an NSBundle object that corresponds to the specified directory.`

在Swift中：

```
open class Bundle : NSObject {
    /* Methods for creating or retrieving bundle instances. */
    open class var main: Bundle { get }    
    public init?(path: String) // 对应OC [NSBundle bundleWithPath]

    @available(iOS 4.0, *)
    public convenience init?(url: URL)
    public /*not inherited*/ init(for aClass: AnyClass) // 对应OC [NSBundle bundleForClass]
    public /*not inherited*/ init?(identifier: String)
```

在子framework中是无法获取主bundle的资源的，因此使用main bundle必须是在App中，而不是在其他App所包含的framework中。对于一个动态库来说，它本身就是一个单独的bundle，App可以调用这个framework, 但framework无法使用工程App的功能。

获取Bundle中资源是有讲究的，下面直接通过一个代码示例演示在main bundle和在动态库中获取资源的不同方式, 完整代码可参见 [HERE](./Demos/)

在主工程中：
```swift
class MainBundleViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "main bundle"
    }

    // 普通图片
    @IBAction func getImage(_ sender: Any) {
        // OK -- Bundle.main
        // self.imageView.image = UIImage(named: "1.png", in: Bundle.main, compatibleWith: nil)
        
        // OK -- Bundle(for: AnyClass)
        // self.imageView.image = UIImage(named: "1.png", in: Bundle(for: MainBundleViewController.self), compatibleWith: nil)
        
        // OK -- Bundle.main.path
        if let path = Bundle.main.path(forResource: "1", ofType: "png") {
            self.imageView.image = UIImage(contentsOfFile: path)
        }
    }
    
    // 在文件夹images中图片
    @IBAction func getImageInDir(_ sender: Any) {
        // OK -- Bundle.main
        // self.imageView.image = UIImage(named: "2.png", in: Bundle.main, compatibleWith: nil) // 不可写为images/2.png
        
        // OK -- Bundle.main.path
        // self.imageView.image = UIImage(named: "2.png", in: Bundle(for: MainBundleViewController.self), compatibleWith: nil) // 不可写为images/2.png
        
        // OK
        if let path = Bundle.main.path(forResource: "2", ofType: "png") { // 不可写为images/2
            self.imageView.image = UIImage(contentsOfFile: path)
        }
    }
    
    // 在bundle中的图片
    @IBAction func getImageInBundle(_ sender: Any) {
        // 新建文件夹，改后缀名，托入XCode
        // https://stackoverflow.com/questions/4888208/how-to-make-an-ios-asset-bundle
        /**OK
        let imagePath: String = Bundle.main.path(forResource: "MyBundle.bundle/1", ofType: "png")!
        self.imageView.image = UIImage(contentsOfFile: imagePath)
        */
        
        let bundlePath: String = Bundle.main.path(forResource: "MyBundle", ofType: "bundle")!
        if let bundle = Bundle(path: bundlePath) {
            // OK
            // self.imageView.image = UIImage(named: "1.png", in: bundle, compatibleWith: nil)
            
            let imagePath: String = bundle.path(forResource: "1", ofType: "png")!
            self.imageView.image = UIImage(contentsOfFile: imagePath)
        }
    }
}
```

在动态库Framework中：

```swift
public class LoginViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    convenience init() {
        self.init(nibName: "LoginViewController", bundle: Bundle(for: LoginViewController.self))
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    }
    
    // 普通图片
    @IBAction func getImage(_ sender: Any) {
        // OK
        // self.imageView.image = UIImage(named: "1.jpeg", in: self.currentBundle(), compatibleWith: nil)
        
        // OK
        let path: String = self.currentBundle().path(forResource: "1", ofType: "jpeg")!
        self.imageView.image = UIImage(contentsOfFile: path)
    }
    
    // 在文件夹images中图片
    @IBAction func getImageInDir(_ sender: Any) {
        // OK
        // self.imageView.image = UIImage(named: "2.png", in: self.currentBundle(), compatibleWith: nil) // 不可写为images/2.png
        
        // OK
        if let path = self.currentBundle().path(forResource: "2", ofType: "png") { // 不可写为images/2
            self.imageView.image = UIImage(contentsOfFile: path)
        }
    }
    
    // 在bundle中的图片
    @IBAction func getImageInBundle(_ sender: Any) {
        /** // OK
        let imagePath:String! = self.currentBundle()?.path(forResource: "AccountBundle.bundle/1", ofType: "png")!
        self.imageView.image = UIImage(contentsOfFile: imagePath)
         */
        
        let bundlePath: String = self.currentBundle().path(forResource: "AccountBundle", ofType: "bundle")!
        if let bundle = Bundle(path: bundlePath) {
            // OK
            // self.imageView.image = UIImage(named: "1.png", in: bundle, compatibleWith: nil)
            
            // OK
            let imagePath: String = bundle.path(forResource: "1", ofType: "png")!
            self.imageView.image = UIImage(contentsOfFile: imagePath)
        }
    }
    
    // 在Account.xcassets中
    @IBAction func getImageInXcassets(_ sender: Any) {
        self.imageView.image = UIImage(named: "1.png", in: self.currentBundle(), compatibleWith: nil)
    }
    
    func currentBundle() -> Bundle! {
        return Bundle(for: LoginViewController.self)
    }
}
```



