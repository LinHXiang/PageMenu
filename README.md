# PageMenu


# use
```
 let pageMenuView = PageMenuView(keys: ["test","test1","test2","test3","test4"], delegate: self)
```
 #### or 
```
 let pageMenuView = PageMenuView()
 pageMenuView.setUpMenus(keys: ["test","test1"], delegate: self)
```
# setUp(like color..)
```
 pageMenuView.setMenuControl(normalColor: UIColor.red, selectedColor: UIColor.black, lineColor: UIColor.green)
```
```
 pageMenuView.updateMenuControllerTitle(title: "00000", menuIndex: 1)
```
# setUpSubviews (PageMenuViewDelegate)
```
extension ViewController : PageMenuViewDelegate {
    
    func pageMenuView(_ pageMenuView: PageMenuView, pageForIndexAt index: Int) -> UIView {
        let view = UIView()
        switch index {
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
    
    
    func pageViewDidShow(_ pageMenuView: PageMenuView, _ page: UIView, _ index: Int) {
        if index == 3 {
            print("3")
        }
    }
}
```
