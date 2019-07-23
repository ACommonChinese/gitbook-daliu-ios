# UIView

####生命周期

```Swift
@IBAction func add(_ sender: Any) {
    print(self.redView)
    self.view.addSubview(self.redView)
}

@IBAction func remove(_ sender: Any) {
    self.redView.removeFromSuperview()
}

class RedView: UIView {
    override func willRemoveSubview(_ subview: UIView) {
        print("will remove sub view")
    }
    override func didAddSubview(_ subview: UIView) {
        print("did add subview")
    }
    override func willMove(toSuperview newSuperview: UIView?) {
        if nil == newSuperview {
            print("dismiss_____1. remove from super view")
        }
        else {
            print("show_____2. will move to super view");
        }
    }
    override func willMove(toWindow newWindow: UIWindow?) {
        if nil == newWindow {
            print("dismiss_____2. remove from super window")
        }
        else {
            print("show_____1. will move to super window")
        }
    }
    override func didMoveToSuperview() {
        if nil != self.superview?.description {
            print("show_____3. did move to super view")
        }
        else {
            print("dismiss_____3. did remove from super view")
        }
    }
}
```

打印结果：
```
show_____1. will move to super window
show_____2. will move to super view
show_____3. did move to super view
dismiss_____1. remove from super view
dismiss_____2. remove from super window
dismiss_____3. did remove from super view
```

**影响view是否可接收到事件的因素(摘自Programming iOS 11)**
A hidden view does not (normally) receive touch events.
A view whose background color is nil (the default) has a transparent background, it will be invisible, can receive touch events.
A view’s alpha affects it’s subviews, A view whose alpha is 0 or very close to it is like a view whose isHidden is true, it is completely transparent, invisible, along with subviews, and cannot (normally) be touched.

**bounds, frame和坐标转换(摘自Programming iOS 11)**
If you change a view’s bounds size, you change its frame. The change in the view’s frame takes place around its center, which remains unchanged.
If you change a view’s bounds origin, you move the origin of its internal coordinate system. A change in the bounds origin of the superview will change the apparent position of a subview. 
Changing a view’s bounds does not change its center; changing a view’s center does not change its bounds. Thus, a view’s bounds and center can completely describe the view’s size and its position within its superview. The view’s frame is therefore superfluous! In face, the frame property is merely a convenient expression of the center and bounds values.

It is possible to convert between the coordinates of any two views in the same window. 
Convenience methods are supplied to perform this conversion both for a CGPoint and for a CGRect:
convert(_:to:)
convert(_:from:)
The first parameter is either a CGPoint or a CGRect. The second parameter is a UIView; if the second parameter is nil, it is taken to be the window. 
The recipient[rɪˈsɪpɪənt] is another UIView; the CGPoint or CGRect is being converted between its coordinates and the second view’s coordinates.

比如：v1.convert(aPoint, to:v2) 表示把在v1坐标系中的点aPoint转换成v2坐标系中的点

v1.convert(aPoint, from:v2) 表示把在v2坐标系中的点aPoint转换成v1坐标系中的点

For example, if v1 is the superview of v2, then to center v2 within v1 you could say:
v2.center = v1.convert(v1.center, from:v1.superview)

**Window Coordinates and Screen Coordinates**
The device screen has no frame, but it has bounds: UIScreen.main.bounds
The main window has no superview, but its frame is set with respect to the screen's bounds:
let w = UIWindow(frame: UIScreen.main.bounds) UIApplication.shared.keyWindow?.frame

```
UICoordinateSpace
UIScreen.main.coordinateSpace: 
This coordinate space rotates. Its bounds height and width are transposed when the app rotates to compensate for a change in the orientation of the device; its origin is at the top left of the app.

UIScreen.main.fixedCoordinateSpace
This coordinate space is invariant. Its bounds origin is at the top left of the physical device, regardless of how the device itself is held.

print(UIScreen.main.coordinateSpace.bounds) // portait: (0.0, 0.0, 375.0, 667.0)  横屏：(0.0, 0.0, 667.0, 375.0)
print(UIScreen.main.fixedCoordinateSpace.bounds) // portait: (0.0, 0.0, 375.0, 667.0)  横屏：(0.0, 0.0, 375.0, 667.0)
```

UICoordinateSpace provides methods parallel to the coordinate-conversion methods I listed in the previous section:
convert(_:from:)
convert(_:to:)

参数1： CGPoint | CGRect
参数2： UICoordinateSpace, which might be a UIView or the UIScreen; so is the recipient.

Suppose we have a UIView v in our interface, and we wish to learn its position in fixed device coordinates. We could do it like this:

`let r: CGRect = v.superview!.convert(v.frame, to: UIScreen.main.fixedCoordinateSpace)`

**Transform**
v1 = UIView(frame: CGRect(113, 111, 132, 194))
v1.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
self.view.addSubview(v1)
v1.transform = CGAffineTransform(rotationAngle: 45 * .pi/180)

The view’s bounds property is unaffected; the internal coordinate system is unchanged, so the subview is drawn in the same place relative to its superview.
The view’s frame, however, is now useless, as no mere rectangle can describe the region of the superview apparently occupied by the view;
The rule is that if a view’s transform is not the identify transform, you should not set its frame;  also, automatic resizing of a subview, requires that the superview’s transform be the identity transform.

scale transform:
v1.transform = CGAffineTransform(scaleX: 1.8, y: 1)
The bounds of v1 is still unaffected, so the subview is still drawn in the same place relative to its superview; this means that the two views seem to have stretched horizontally together. No bounds or centers were harmed by the application of this transform.

successive transforms: 连续旋转：
v2.transform = CGAffineTransform(translationX: 100, y: 0).rotated(by: 45 * .pi/180)
v2.transform = CGAffineTransform(rotationAngle: 45 * .pi/180).translatedBy(x: 100, y: 0)

```Swift
v2.transform = CGAffineTransform(rotationAngle: 45 * .pi/180)
v2.transform = CGAffineTransform(rotationAngle: 45 * .pi/180)
v2.transform = CGAffineTransform(rotationAngle: 45 * .pi/180)
v2.transform = CGAffineTransform(rotationAngle: 45 * .pi/180)
v2.transform = CGAffineTransform(rotationAngle: 45 * .pi/180)
```
上面这5句只相当于一句：
`v2.transform = CGAffineTransform(rotationAngle: 45 * .pi/180)`
因为“Methods are provided for transforming an existing transform. This operation is not commutative”
只向右旋转了45度。
```Swift
v2.transform = CGAffineTransform(rotationAngle: 45 * .pi/180)
v2.transform = v2.transform.translatedBy(x: 100, y: 0)
```
上面这句意思是向右旋转45度并向右移动100点，相当于下面一句：
`v2.transform = CGAffineTransform(rotationAngle: 45 * .pi/180).translatedBy(x: 100, y: 0)`
相当于下面三句：
```Swift
let r: CGAffineTransform = CGAffineTransform(rotationAngle: 45 * .pi/180)
let t: CGAffineTransform = CGAffineTransform(translationX: 100, y: 0)
v2.transform = t.concatenating(r) // not r.concatenating(t)
```


