//
//  PageTitleView.swift
//  DouyuDemo
//
//  Created by GreatSKL on 2017/8/6.
//  Copyright © 2017年 GreatSKL. All rights reserved.
//

import UIKit

fileprivate let kScrollLineH: CGFloat = 2

class PageTitleView: UIView {
    //MARK:- 定义属性
    fileprivate var titles: [String]
    
    //MARK:- 懒加载属性
    fileprivate lazy var titleLabels: [UILabel] = [UILabel]()
    
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        
        return scrollView
    }()
    
    fileprivate lazy var scrollLine: UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        
        return scrollLine
    }()
    
    //MARK:- 自定义构造函数
    init(frame: CGRect, titles: [String]) {
        self.titles = titles
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension PageTitleView {
    fileprivate func setupUI() {
        // 1. 添加UIScrollView
        addSubview(scrollView)
        scrollView.frame = bounds
        
        // 2. 添加title对应的label
        setupTitleLabels()
        
        // 3. 设置底线和滚动滑块儿
        setupBottomLineANdScrollLine()
    }
    
    fileprivate func setupTitleLabels() {
        
        let labelW: CGFloat = frame.width / CGFloat(titles.count)
        let labelH: CGFloat = frame.height - kScrollLineH
        let labelY: CGFloat = 0
        
        for (index, title) in titles.enumerated() {
            let label = UILabel()
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: CGFloat(16.0))
            label.textColor = UIColor.darkGray
            label.textAlignment = .center

            let labelX: CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            titleLabels.append(label)
            
            scrollView.addSubview(label)
        }
    }
    
    fileprivate func setupBottomLineANdScrollLine() {
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        let lineH: CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        
        addSubview(bottomLine)
        
        guard let firstLabel = titleLabels.first else {
            return
        }
        firstLabel.textColor = UIColor.orange
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kScrollLineH, width: firstLabel.frame.width, height: kScrollLineH)
        scrollView.addSubview(scrollLine)
        
    }
}
