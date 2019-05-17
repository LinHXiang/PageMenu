//
//  ViewController.swift
//  pageMenu
//
//  Created by 浩翔林 on 2019/5/14.
//  Copyright © 2019 浩翔林. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let key = ["test","test1","test2","test3","test4"]
        let pageMenuView = PageMenuView(keys: key, delegate: self)
        pageMenuView.setMenuControl(normalColor: UIColor.red, selectedColor: UIColor.black, lineColor: UIColor.green)
        pageMenuView.setUpMenus(keys: ["test","12345"], delegate: self)
        self.view.addSubview(pageMenuView)
        
        let constraintArrayH = NSLayoutConstraint.constraints(withVisualFormat: "H:|[pageMenuView]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["pageMenuView":pageMenuView])
        let constraintArrayV = NSLayoutConstraint.constraints(withVisualFormat: "V:|-51-[pageMenuView]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["pageMenuView":pageMenuView])
        
        self.view.addConstraints(constraintArrayH)
        self.view.addConstraints(constraintArrayV)
    }
}


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
