//
//  PageMenuView.swift
//  TagTableView
//
//  Created by 浩翔林 on 2019/5/10.
//  Copyright © 2019 浩翔林. All rights reserved.
//

import UIKit

protocol PageMenuViewDelegate : class{
    func commonInitTagView(tag:Int)->UIView
}

class PageMenuView: UIView {
    
    weak var delegate:PageMenuViewDelegate?

    public let segmentedControl = PageMenuSegmentedControl()
    
    public let infoScrollView = UIScrollView()
    
    public var keys:[String] = ["测试"]
    
    public var subInfoViews:[UIView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(keys: [String],delegate:PageMenuViewDelegate) {
        self.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.green
        self.translatesAutoresizingMaskIntoConstraints = false
        self.delegate = delegate
        self.keys = keys
        
        segmentedControl.commonInit(keys)
        segmentedControl.clickTitleHandler = { [weak self] (tag) in
            self?.clickTag(tag: tag)
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
        
        for index in 0..<keys.count {
            let view = self.delegate?.commonInitTagView(tag: index)
            let tagView = view == nil ? UIView() : view!
            tagView.translatesAutoresizingMaskIntoConstraints = false
            self.subInfoViews.append(tagView)
            infoScrollView.addSubview(tagView)
        }
        self.bringSubviewToFront(segmentedControl)
        
//        NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: OperationQueue.main) { (_) in
//            if self.infoScrollView.frame.width != 0 {
//                let tag = Int(self.infoScrollView.contentOffset.x / self.infoScrollView.frame.width)
//                self.infoScrollView.setContentOffset(CGPoint(x: self.infoScrollView.frame.width * CGFloat(tag), y: 0), animated: true)
//            }
//        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for index in 0..<self.subInfoViews.count {
            self.subInfoViews[index].frame = CGRect(x: 0, y: 0, width: infoScrollView.frame.width, height: infoScrollView.frame.height)
            self.subInfoViews[index].frame = CGRect(x: infoScrollView.frame.width * CGFloat(index), y: 0, width: infoScrollView.frame.width, height: infoScrollView.frame.height)
        }
        infoScrollView.contentSize = CGSize(width: CGFloat(keys.count) * self.frame.width , height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func clickTag(tag:Int){
        infoScrollView.setContentOffset(CGPoint(x: infoScrollView.frame.width * CGFloat(tag), y: 0), animated: true)
    }
}

//SetUp Method
extension PageMenuView {
    
    func setTagControl(normalColor:UIColor? = nil,selectedColor:UIColor? = nil,font:UIFont? = nil,lineColor:UIColor = UIColor.red){
        segmentedControl.setTitleButtonType(normalColor: normalColor, selectedColor: selectedColor, font: font)
        segmentedControl.setLineColor(lineColor)
    }
    
}

extension PageMenuView :UIScrollViewDelegate{
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        segmentedControl.scrolling(offset: scrollView.contentOffset.x)
    }
    
}
