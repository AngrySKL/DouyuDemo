//
//  HomeViewController.swift
//  DouyuDemo
//
//  Created by GreatSKL on 2017/8/6.
//  Copyright © 2017年 GreatSKL. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


//MARK:- 设置UI界面
extension HomeViewController {
    fileprivate func setupUI() {
        setupNavigationBar()
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
