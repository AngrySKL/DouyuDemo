//
//  PageContentView.swift
//  DouyuDemo
//
//  Created by GreatSKL on 2017/8/7.
//  Copyright © 2017年 GreatSKL. All rights reserved.
//

import UIKit

protocol PageContentViewDelegate: class {
    func pageContentView(contentView: PageContentView,
                         progress: CGFloat,
                         sourceIndex: Int,
                         targetIndex: Int)
}

fileprivate let ContentId = "ContentId"

class PageContentView: UIView {
    
    //MARK:- 属性
    fileprivate var childrenViewControllers: [UIViewController]
    fileprivate weak var parentViewController: UIViewController?
    fileprivate var startScrollOffsetX:CGFloat = 0
    fileprivate var isForbidScrollDelegate: Bool = false
    weak var delegate: PageContentViewDelegate?
    
    //MARK:- 懒加载属性
    fileprivate lazy var collectionView: UICollectionView = { [weak self] in
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentId)
        collectionView.delegate = self
        
        return collectionView
    }()
    
    //MARK:- 自定义构造函数
    init(frame: CGRect, childrenViewControllers: [UIViewController], parentViewController: UIViewController?) {
        self.childrenViewControllers = childrenViewControllers
        self.parentViewController = parentViewController
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension PageContentView {
    fileprivate func setupUI() {
        for childViewController in childrenViewControllers {
            parentViewController?.addChildViewController(childViewController)
        }
        
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}

//MARK:- 实现协议
extension PageContentView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childrenViewControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentId, for: indexPath)
        
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        let childViewController = childrenViewControllers[indexPath.item]
        childViewController.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childViewController.view)
        
        return cell
    }
}

extension PageContentView: UICollectionViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isForbidScrollDelegate = false
        
        startScrollOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 对titleview上的标签进行点击会造成collectionview的滚动，因此，会进入这个方法，
        // 但是此时，不应该再执行下面的逻辑了，否则会造成对滑动逻辑的重复执行
        if isForbidScrollDelegate { return }
        
        // 1. 获取数据
        var progress: CGFloat = 0
        var sourceIndex: Int = 0
        var targetIndex: Int = 0
        
        // 2. 根据左滑还是右滑计算值
        let currentScrollOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        let ratio = currentScrollOffsetX / scrollViewW
        if currentScrollOffsetX > startScrollOffsetX {
            // 左滑
            progress = ratio - floor(ratio)
            sourceIndex = Int(ratio)
            targetIndex = sourceIndex + 1 >= childrenViewControllers.count ?
                childrenViewControllers.count - 1 : sourceIndex + 1
            
            // 如果完全划过去
            if currentScrollOffsetX - startScrollOffsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
            
        } else {
            // 右滑
            progress = 1 - (ratio - floor(ratio))
            targetIndex = Int(ratio)
            sourceIndex = targetIndex + 1 >= childrenViewControllers.count ?
                childrenViewControllers.count - 1 : targetIndex + 1
            
            // 如果完全划过去
        }
        
        // 3. 将计算得到的数据传给titleview
        delegate?.pageContentView(contentView: self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}

//MARK:- 对外接口
extension PageContentView {
    // 当点击titleview上的label时执行
    public func setCurrentIndex(currentIndex: Int) {
        // 1. 需要禁止执行代理方法
        isForbidScrollDelegate = true
        
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}
