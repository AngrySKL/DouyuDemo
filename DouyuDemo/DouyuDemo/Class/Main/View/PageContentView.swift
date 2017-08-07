//
//  PageContentView.swift
//  DouyuDemo
//
//  Created by GreatSKL on 2017/8/7.
//  Copyright © 2017年 GreatSKL. All rights reserved.
//

import UIKit

fileprivate let ContentId = "ContentId"

class PageContentView: UIView {
    
    //MARK:- 属性
    fileprivate var childrenViewControllers: [UIViewController]
    fileprivate var parentViewController: UIViewController
    
    //MARK:- 懒加载属性
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentId)
        
        return collectionView
    }()
    
    //MARK:- 自定义构造函数
    init(frame: CGRect, childrenViewControllers: [UIViewController], parentViewController: UIViewController) {
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
            parentViewController.addChildViewController(childViewController)
        }
        
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}

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
