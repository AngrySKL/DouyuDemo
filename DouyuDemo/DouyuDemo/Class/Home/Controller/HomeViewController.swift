//
//  HomeViewController.swift
//  DouyuDemo
//
//  Created by GreatSKL on 2017/8/6.
//  Copyright © 2017年 GreatSKL. All rights reserved.
//

import UIKit

fileprivate let kTitleViewH: CGFloat = 40

class HomeViewController: UIViewController {
    
    //MARK:- 懒加载属性
    fileprivate lazy var pageTitleView: PageTitleView = {[weak self] in
        let titleFrame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH, width: kScreenW, height: kTitleViewH)
        let titles = ["推荐", "游戏", "娱乐", "趣玩"]
        let titleView = PageTitleView(frame: titleFrame, titles: titles)
        titleView.delegate = self
        
        return titleView
    }()
    
    fileprivate lazy var pageContentVIew: PageContentView = {[weak self] in
        // 1. 确定内容frame
        let contentH = kScreenH - kStatusBarH - kNavigationBarH - kTitleViewH
        let contentFrame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH + kTitleViewH, width: kScreenW, height: contentH)
        
        // 2. 确定自控制器
        var childrenViewControls = [UIViewController]()
        for _ in 0..<4 {
            let viewcontroller = UIViewController()
            viewcontroller.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)),
                                                          g: CGFloat(arc4random_uniform(255)),
                                                          b: CGFloat(arc4random_uniform(255)))
            
            childrenViewControls.append(viewcontroller)
        }
        
        let contentView = PageContentView(frame: contentFrame,
                                          childrenViewControllers: childrenViewControls,
                                          parentViewController: self)
        contentView.delegate = self
        return contentView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


//MARK:- 设置UI界面
extension HomeViewController {
    fileprivate func setupUI() {
        // 不需要调整UIScrollView的内边距
        automaticallyAdjustsScrollViewInsets = false
        
        setupNavigationBar()
        
        view.addSubview(pageTitleView)
        
        pageContentVIew.backgroundColor = UIColor.green
        view.addSubview(pageContentVIew)

    }
    
    fileprivate func setupNavigationBar() {
        //1. 添加左侧Logo图片的Button
        let logoItem = UIBarButtonItem(imageName: "logo", highlightedImageName: nil, size: nil)
        
        //2. 设置右侧3个按钮
        let size = CGSize(width: 40, height: 40)
        let hisrotyItem = UIBarButtonItem(imageName: "image_my_history", highlightedImageName: "image_my_history_click", size: size)
        let searchItem = UIBarButtonItem(imageName: "image_search", highlightedImageName: "image_search_click", size: size)
        let qrcodeItem = UIBarButtonItem(imageName: "image_scan", highlightedImageName: "image_scan_click", size: size)
        
        navigationItem.leftBarButtonItem = logoItem
        navigationItem.rightBarButtonItems = [hisrotyItem, searchItem, qrcodeItem]
    }
}

//MARK:- 实现协议
extension HomeViewController: PageTitleViewDelegate {
    func pageTitleView(titleView: PageTitleView, selectIndex index: Int) {
        pageContentVIew.setCurrentIndex(currentIndex: index)
    }
}

extension HomeViewController: PageContentViewDelegate{
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgess(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}
