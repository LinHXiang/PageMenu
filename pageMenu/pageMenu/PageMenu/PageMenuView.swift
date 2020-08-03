//
//  PageMenuView.swift
//  PageMenuView
//
//  Created by 浩翔林 on 2019/5/10.
//  Copyright © 2019 浩翔林. All rights reserved.
//

import UIKit

protocol PageMenuViewDelegate : class {
    
    func pageMenuView(_ pageMenuView:PageMenuView ,pageForIndexAt index:Int)->UIView
    
    func pageViewDidShow(_ pageMenuView:PageMenuView , _ page:UIView , _ index:Int)
}

extension PageMenuViewDelegate{
    func pageViewDidShow(_ pageMenuView:PageMenuView , _ page:UIView , _ index:Int){
        
    }
}

class PageMenuView: UIView {
    
    weak var delegate:PageMenuViewDelegate?
    
    public let segmentedControl = PageMenuSegmentedControl()
    
    public let infoScrollView = UIScrollView()
    
    public var keys:[String] = ["测试"]
    
    public let infoScrollSubviewTag = 10
    
    override var backgroundColor: UIColor?{
        didSet{
            segmentedControl.backgroundColor = self.backgroundColor
            infoScrollView.backgroundColor = self.backgroundColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(keys: [String],delegate:PageMenuViewDelegate){
        self.init(frame: CGRect.zero)
        self.setUpMenus(keys: keys, delegate: delegate)
    }
    
    func setUpMenus(keys: [String],delegate:PageMenuViewDelegate) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.white
        self.delegate = delegate
        self.keys = keys
        
        segmentedControl.commonInit(keys)
        segmentedControl.clickTitleHandler = { [weak self] (index) in
            self?.clickIndex(index)
        }
        self.addSubview(segmentedControl)
        
        segmentedControl.addConstraint(NSLayoutConstraint(item: segmentedControl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 35))
        self.addConstraint(NSLayoutConstraint(item: segmentedControl, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: segmentedControl, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: segmentedControl, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0))
        
        infoScrollView.isPagingEnabled = true
        infoScrollView.translatesAutoresizingMaskIntoConstraints = false
        infoScrollView.showsVerticalScrollIndicator = false
        infoScrollView.showsHorizontalScrollIndicator = false
        infoScrollView.delegate = self
        self.addSubview(infoScrollView)
        
        self.addConstraint(NSLayoutConstraint(item: infoScrollView, attribute: .top, relatedBy: .equal, toItem: segmentedControl, attribute: .bottom, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: infoScrollView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: infoScrollView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: infoScrollView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0))
        
        infoScrollView.subviews.forEach { (each) in
            each.removeFromSuperview()
        }
        for index in 0..<keys.count {
            let view = self.delegate?.pageMenuView(self, pageForIndexAt: index)
            let page = view == nil ? UIView() : view!
            page.tag = infoScrollSubviewTag + index
            infoScrollView.addSubview(page)
        }
        self.bringSubviewToFront(segmentedControl)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for page in self.infoScrollView.subviews {
            page.frame = CGRect(x: 0, y: 0, width: infoScrollView.frame.width, height: infoScrollView.frame.height)
            page.frame = CGRect(x: infoScrollView.frame.width * CGFloat(page.tag - infoScrollSubviewTag), y: 0, width: infoScrollView.frame.width, height: infoScrollView.frame.height)
        }
        infoScrollView.contentSize = CGSize(width: CGFloat(keys.count) * self.frame.width , height: 0)
    }
    
    public func clickIndex(_ index:Int){
        infoScrollView.setContentOffset(CGPoint(x: infoScrollView.frame.width * CGFloat(index), y: 0), animated: true)
    }
    
    func clickMenu(index:Int){
        segmentedControl.clickMenu(index: index)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//SetUp Method
extension PageMenuView {
    
    func setMenuControl(normalColor:UIColor? = nil,selectedColor:UIColor? = nil,font:UIFont? = nil,lineColor:UIColor = UIColor.red){
        segmentedControl.setTitleButtonType(normalColor: normalColor, selectedColor: selectedColor, font: font)
        segmentedControl.setLineColor(lineColor)
    }
    
    func updateMenuControllerTitle(title:String,menuIndex:Int){
        self.segmentedControl.updateButtonTitle(title: title, menuIndex: menuIndex)
    }
    
}

extension PageMenuView :UIScrollViewDelegate{
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        segmentedControl.scrolling(offset: scrollView.contentOffset.x)
        
        if self.frame.width > 0 && scrollView.contentOffset.x >= 0{
            let index = scrollView.contentOffset.x / self.frame.width
            if ((index*10).truncatingRemainder(dividingBy: 10.0)) == 0 , let page = self.infoScrollView.viewWithTag(Int(index) + infoScrollSubviewTag){
                self.delegate?.pageViewDidShow(self, page, page.tag - infoScrollSubviewTag)
            }
        }
    }
    
}
