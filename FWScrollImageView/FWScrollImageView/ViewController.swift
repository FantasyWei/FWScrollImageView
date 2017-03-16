//
//  ViewController.swift
//  FWScrollImageView
//
//  Created by FantasyWei on 2017/3/16.
//  Copyright © 2017年 FantasyWei. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scrollView = FWScrollImageView()
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(64)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(200)
        }
        
        let  urlString = "http://qt.qq.com/static/pages/news/phone/c13_list_1.shtml?plat=android&version=9709"
        scrollView.sendHttpRequest(method: .GET,urlString: urlString, parameters: nil,interval: 2)
        
        
        // 点击图片的回调
        scrollView.callBack = { (index:Int,model:FWScrollModel)-> Void in
            print("当前点击的是第\(index+1)张图片,模型是\(model)")
        }
        
    }

}
