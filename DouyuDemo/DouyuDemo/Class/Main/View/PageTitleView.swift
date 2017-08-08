//
//  PageTitleView.swift
//  DouyuDemo
//
//  Created by GreatSKL on 2017/8/6.
//  Copyright © 2017年 GreatSKL. All rights reserved.
//

import UIKit

protocol PageTitleViewDelegate: class {
    func pageTitleView(titleView: PageTitleView, selectIndex index: Int)
}

fileprivate let kScrollLineH: CGFloat = 2
fileprivate let kNormalLabelColor: (r: CGFloat, g: CGFloat, b: CGFloat) = (r: 85, g: 85, b: 85)
fileprivate let kSelectedLabelColor: (r: CGFloat, g: CGFloat, b: CGFloat) = (r: 255, g: 128, b: 0)
fileprivate let normalLabelColor = UIColor(r: kNormalLabelColor.r,
                                           g: kNormalLabelColor.g,
                                           b: kNormalLabelColor.b)
fileprivate let selectedLabelColor = UIColor(r: kSelectedLabelColor.r,
                                            g: kSelectedLabelColor.g,
                                            b: kSelectedLabelColor.b)

class PageTitleView: UIView {
    //MARK:- 定义属性
    fileprivate var currentLabelIndex: Int = 0
    fileprivate var titles: [String]
    weak var delegate: PageTitleViewDelegate?
    
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
            // 1. 创建UILabel并设置属性
            let label = UILabel()
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: CGFloat(16.0))
            label.textColor = normalLabelColor
            label.textAlignment = .center

            // 2. 设置label的frame
            let labelX: CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            // 3. 将label添加到scrollView中
            titleLabels.append(label)
            scrollView.addSubview(label)
            
            // 4. 给label添加手势
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick(tapGes:)))
            label.addGestureRecognizer(tapGes)
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
        firstLabel.textColor = selectedLabelColor
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x,
                                  y: frame.height - kScrollLineH,
                                  width: firstLabel.frame.width,
                                  height: kScrollLineH)
        scrollView.addSubview(scrollLine)
        
    }
}

extension PageTitleView {
    @objc fileprivate func titleLabelClick(tapGes: UITapGestureRecognizer) {
        // 1. 获取当前label的下标值
        guard let currentLabel = tapGes.view as? UILabel else { return }
        
        // 2. 获取之前label
        let oldLabel = titleLabels[currentLabelIndex]
        
        // 3. 切换文字的颜色
        currentLabel.textColor = selectedLabelColor
        oldLabel.textColor = normalLabelColor
        
        // 4. 保存新的label的下标值
        currentLabelIndex = currentLabel.tag
        
        // 5. 滚动条位置发生改变
        let scrollLinePositionX = CGFloat(currentLabelIndex) * scrollLine.frame.width
        UIView.animate(withDuration: 0.15, animations: {[weak self] in
            self?.scrollLine.frame.origin.x = scrollLinePositionX
        })
        
        // 6. 通知代理
        delegate?.pageTitleView(titleView: self, selectIndex: currentLabelIndex)
    }
}

//MARK:- 对外接口
extension PageTitleView {
    func setTitleWithProgess(progress: CGFloat, sourceIndex: Int, targetIndex: Int){
        // 1. 取出sourceLabel和targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        // 2. 处理滑块逻辑
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let movedX = moveTotalX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + movedX
        
        // 3. 处理颜色渐变
        // 3.1 取出变化的范围
        let colorDelta = (deltaR: kSelectedLabelColor.r - kNormalLabelColor.r,
                          deltaG: kSelectedLabelColor.g - kNormalLabelColor.g,
                          deltaB: kSelectedLabelColor.b - kNormalLabelColor.b)
        // 3.2 变sourceLabel
        sourceLabel.textColor = UIColor(r: kSelectedLabelColor.r - colorDelta.deltaR * progress,
                                        g: kSelectedLabelColor.g - colorDelta.deltaG * progress,
                                        b: kSelectedLabelColor.b - colorDelta.deltaB * progress)
        
        // 3.3 设置targetLabel
        targetLabel.textColor = UIColor(r: kNormalLabelColor.r + colorDelta.deltaR * progress,
                                       g: kNormalLabelColor.g + colorDelta.deltaG * progress,
                                       b: kNormalLabelColor.b + colorDelta.deltaB * progress)
        
        // 4. 记录最新的index
        currentLabelIndex = targetIndex
    }
}

