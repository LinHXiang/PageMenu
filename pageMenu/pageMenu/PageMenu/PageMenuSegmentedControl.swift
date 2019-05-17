//
//  PageMenuSegmentedControl.swift
//  PageMenu
//
//  Created by 浩翔林 on 2019/5/10.
//  Copyright © 2019 浩翔林. All rights reserved.
//

import UIKit

class PageMenuSegmentedControl: UIView {
    
    var clickTitleHandler:((Int)->Void)? = nil
    
    public var titles = [String]()
    
    public weak var selectedBtn:UIButton? = nil
    
    public let scrollLineView = UIView()
    
    public var scrollLineConstraints:[NSLayoutConstraint] = []
    
    public let titleButtonTag = 80000
    
    func commonInit(_ titles:[String],lineColor:UIColor = UIColor.red){
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.titles = titles
        self.subviews.forEach { (each) in
            each.removeFromSuperview()
        }
        for index in 0..<self.titles.count {
            autoreleasepool {
                let titleButton = UIButton(type: .custom)
                titleButton.setTitle(titles[index], for: .normal)
                titleButton.tag = index + titleButtonTag
                titleButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 13)
                titleButton.setTitleColor(UIColor.black, for: .selected)
                titleButton.setTitleColor(UIColor.gray, for: .normal)
                titleButton.addTarget(self, action: #selector(clickTitle(_:)), for: .touchUpInside)
                titleButton.sizeToFit()
                let size = titleButton.frame.size
                titleButton.translatesAutoresizingMaskIntoConstraints = false
                if index == 0 {
                    titleButton.isSelected = true
                    self.selectedBtn = titleButton
                }
                self.addSubview(titleButton)
                
                titleButton.addConstraint(NSLayoutConstraint(item: titleButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: size.height))
                
                self.addConstraint(NSLayoutConstraint(item: titleButton, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier:1.0/CGFloat(self.titles.count) , constant: 0))
                
                if let lastButton = viewWithTag(index + titleButtonTag - 1) {
                    self.addConstraint(NSLayoutConstraint(item: titleButton, attribute: .left, relatedBy: .equal, toItem: lastButton, attribute: .right, multiplier:1.0 , constant: 0))
                }else{
                    self.addConstraint(NSLayoutConstraint(item: titleButton, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier:1.0 , constant: 0))
                }
                self.addConstraint(NSLayoutConstraint(item: titleButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier:1.0, constant: 0))
            }
        }
        
        setLineColor(lineColor)
        scrollLineView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollLineView)
        
        scrollLineView.addConstraint(NSLayoutConstraint(item: scrollLineView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier:1.0, constant: 3))
        self.addConstraint(NSLayoutConstraint(item: scrollLineView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier:1.0, constant: 0))
        
        updateSelectedLineConstraint()
        
    }
    
    func setTitleButtonType(normalColor:UIColor? = nil,selectedColor:UIColor? = nil,font:UIFont? = nil){
        self.subviews.forEach { (subview) in
            if subview.isKind(of: UIButton.classForCoder()){
                if let normalColor = normalColor {
                    (subview as? UIButton)?.setTitleColor(normalColor, for: .normal)
                }
                if let selectedColor = selectedColor {
                    (subview as? UIButton)?.setTitleColor(selectedColor, for: .selected)
                }
                if let font = font {
                    (subview as? UIButton)?.titleLabel?.font = font
                }
            }
        }
    }
    
    func setLineColor(_ lineColor : UIColor){
        scrollLineView.backgroundColor = lineColor
        scrollLineView.layer.shadowColor = lineColor.cgColor
        scrollLineView.layer.shadowOffset = CGSize(width: 0, height: 3)
        scrollLineView.layer.shadowOpacity = 0.5
        scrollLineView.layer.cornerRadius = 1.5
    }
    
    func clickMenu(index:Int){
        if (index + titleButtonTag) != selectedBtn?.tag {
            clickTitleHandler?(index)
            updateSelectedLineConstraint()
        }
    }
    
    @objc public func clickTitle(_ sender:UIButton){
        clickMenu(index: sender.tag - titleButtonTag)
    }
    
    func scrolling(offset:CGFloat){
        if self.frame.width != 0 {
            if let button = viewWithTag(Int(offset/self.frame.width + CGFloat(titleButtonTag) + 0.5)) as? UIButton , button != selectedBtn{
                selectedBtn?.isSelected = false
                button.isSelected = true
                selectedBtn = button
            }
            var tmp = offset
            while (tmp > self.frame.width){
                tmp = tmp - self.frame.width
            }
            self.addLineConstraint(leftButtonTag: Int(offset/self.frame.width + CGFloat(titleButtonTag)), scale: tmp/self.frame.width)
        }
    }
    
    public func updateSelectedLineConstraint(){
        self.removeConstraints(scrollLineConstraints)
        let lineWidthConstraint = NSLayoutConstraint(item: scrollLineView, attribute: .width, relatedBy: .equal, toItem: selectedBtn?.titleLabel, attribute: .width, multiplier:1.0, constant: 0)
        let lineCenterXConstraint = NSLayoutConstraint(item: scrollLineView, attribute: .centerX, relatedBy: .equal, toItem: selectedBtn, attribute: .centerX, multiplier:1.0, constant: 0)
        self.scrollLineConstraints = [lineWidthConstraint,lineCenterXConstraint]
        self.addConstraints(self.scrollLineConstraints)
    }
    
    public func addLineConstraint(leftButtonTag:Int,scale:CGFloat){
        if let left = viewWithTag(leftButtonTag) as? UIButton , let right = viewWithTag(leftButtonTag+1) as? UIButton{
            self.removeConstraints(scrollLineConstraints)
            let leftButtonTextRect = left.convert(left.titleLabel!.frame, to: self)
            let RightButtonTextRect = right.convert(right.titleLabel!.frame, to: self)
            let buttonSpace = RightButtonTextRect.origin.x - leftButtonTextRect.maxX
            
            let lineLeftConstraint = NSLayoutConstraint(item: scrollLineView, attribute: .left, relatedBy: .equal, toItem: ((scale == 1.0 || scale <= 0.5 ) ? left.titleLabel : right.titleLabel), attribute: .left, multiplier:1.0, constant: ((scale == 1.0 || scale <= 0.5 ) ? 0 : (-(1-scale)*2*(buttonSpace + leftButtonTextRect.size.width))))
            
            let lineRightConstraint = NSLayoutConstraint(item: scrollLineView, attribute: .right, relatedBy: .equal, toItem: ((scale == 1.0 || scale <= 0.5 ) ? left.titleLabel : right.titleLabel), attribute: .right, multiplier:1.0, constant: scale <= 0.5 ? (scale*2*(buttonSpace + RightButtonTextRect.size.width)) : 0)
            
            self.scrollLineConstraints = [lineLeftConstraint,lineRightConstraint]
            self.addConstraints(self.scrollLineConstraints)
        }
    }
    
    //分割线
    override func draw(_ rect: CGRect) {
        let context : CGContext = UIGraphicsGetCurrentContext()!;
        context.setLineWidth(1.0)
        UIGraphicsGetCurrentContext()!.setStrokeColor(UIColor.lightGray.cgColor)
        
        UIGraphicsGetCurrentContext()!.beginPath()
        context.move(to: CGPoint(x: 0, y: self.bounds.height))
        context.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height))
        UIGraphicsGetCurrentContext()!.closePath()
        context.strokePath()
    }
}
