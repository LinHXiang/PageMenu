# PageMenu


# use
```
 let pageMenuView = PageMenuView(keys: key, delegate: self)
```
# setUp(like color..)
```
 pageMenuView.setTagControl(normalColor: UIColor.red, selectedColor: UIColor.black, lineColor: UIColor.green)
 ```
# setUpSubviews
```
 func commonInitTagView(tag: Int) -> UIView {
        let view = UIView()
        switch tag {
        case 0:
            view.backgroundColor = UIColor.red
        case 1:
            view.backgroundColor = UIColor.blue
        case 2:
            view.backgroundColor = UIColor.gray
        case 3:
            view.backgroundColor = UIColor.black
        case 4:
            view.backgroundColor = UIColor.green.withAlphaComponent(0.3)
        default:
            break
        }
        return view
  }
```
