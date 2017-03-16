//
//  FWScrollView.swift
//  kangaroo  street
//
//  Created by FantasyWei on 2016/10/20.
//  Copyright © 2016年 FantasyWei. All rights reserved.
//

import UIKit
import SDWebImage

let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height


// 使用时必须传入 URLString 和参数 parameters
// 注意: 使用时必须把 model 模型改为自己的,请求网络数据自己检验
typealias scrollViewCallBack = (_ index : Int,_ model : FWScrollModel)->()
class FWScrollImageView: UIView,UIScrollViewDelegate{
    
    var callBack : scrollViewCallBack?
    //MARK: - 获取图片并加载
    
    /// 获取图片并加载
    ///
    /// - parameter urlString:  请求网络地址获取 image 的 数组
    /// - parameter parameters: 网络请求所需要的参数
    /// - parameter interval: 轮播器自动滑动时间
    
    func sendHttpRequest(method:FWRequestMethod? = .GET,urlString :String,parameters :[String:AnyObject]?,interval:CGFloat){
        
        self.interval = interval
        
        FWNetWorkTools.sharedTools.request(method: method, urlString: urlString, parameters: parameters as AnyObject?) { (responced, error) in
            if responced != nil {

                let dataDict : [String:AnyObject] = responced as! [String : AnyObject]
//                let coder = dataDict["errorCode"]! as! NSInteger
//                if coder != 1000 {
//                    SVProgressHUD.showError(withStatus: "网络请求错误")
//                    return
//                }
                let dataArr : [AnyObject] = dataDict["list"]! as! [AnyObject]
                
                for dataList in dataArr {
                    let listDict = dataList as! [String:AnyObject]
                    let scrollModel = FWScrollModel(dict: listDict)
                    self.dataArray.append(scrollModel)
                    }
                self.currentIndex = 0
                self.previousIndex = self.dataArray.count - 1
                self.nextIndex = self.currentIndex + 1
                   DispatchQueue.main.async {[weak self] in
                    self?.setupScrollView()
                    self?.setupImageView()
                    self?.initTimer()
                    self?.setupPageContol()
                }
            }
            if error != nil{
                print("网络请求错误")
                return
            }
        }
    }
    
    // MARK: - 点击回调
    @objc private func didSelectImageView(){
        if callBack != nil {
            let model  = dataArray[current]
            callBack!(current,model)
        }
    }
    // 设置 pageControll
    @objc private func changePageControl(){
        // 获取正确的 图片位置
        if currentIndex == -1 {
            current = dataArray.count-1
        }else if currentIndex == dataArray.count{
            current = 0
        }else{
            current = currentIndex
        }
        
        if ScrollView.contentOffset.x <= kScreenWidth * 0.5{    // 向左拉
            pageControll.currentPage = 3
            if current == 0 {
                self.pageControll.currentPage = dataArray.count - 1
            }else{
                self.pageControll.currentPage = current - 1
            }
        }else if ScrollView.contentOffset.x >= kScreenWidth * 1.5{ // 向右拉
            if current == dataArray.count - 1{
                pageControll.currentPage = 0
            }else{
            pageControll.currentPage = current + 1
            }
        }else{
            pageControll.currentPage = current
        }
        
    }
    // 计时器回调
    @objc private func carousel(){
        
        ScrollView.setContentOffset(CGPoint(x:frame.size.width * 2,y: 0), animated: true)
        changePageControl()
    }
    
    // MARK: - ScrollViewDelegate 控制滚动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if ScrollView.contentOffset.x == frame.size.width * 2{
            currentIndex = currentIndex + 1
            previousView.image = currentImageView.image
            currentImageView.image = nextImageView.image
            ScrollView.setContentOffset(CGPoint(x:frame.size.width,y: 0), animated: false)
            nextIndex = 0
        if currentIndex == dataArray.count-1{
            nextIndex = 0
        }else if currentIndex == dataArray.count{
            currentIndex = 0
            nextIndex = dataArray.count > 1 ?1:0
        }else{
            nextIndex = currentIndex + 1
            }
           let urlString2 = NSURL(string: dataArray[nextIndex].image_url_big!)!
            nextImageView.sd_setImage(with: urlString2 as URL!, placeholderImage: nil, options: SDWebImageOptions.continueInBackground, completed: nil)
        }
        
        if ScrollView.contentOffset.x == 0 {
            currentIndex = currentIndex - 1
            nextImageView.image = currentImageView.image
            currentImageView.image = previousView.image
            ScrollView.setContentOffset(CGPoint(x:frame.size.width,y: 0), animated: false)
            previousIndex = 0
            if currentIndex == 0 {
                previousIndex = dataArray.count-1
            }else if currentIndex<0{
                currentIndex = dataArray.count-1
                previousIndex = dataArray.count > 1 ? (currentIndex-1):0
            }else{
                previousIndex = currentIndex - 1
            }
            let urlString0 = NSURL(string: dataArray[previousIndex].image_url_big!)!
            previousView.sd_setImage(with: urlString0 as URL!, placeholderImage: nil, options: SDWebImageOptions.continueInBackground, completed: nil)

        }
        changePageControl()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if timer.isValid == false {
            initTimer()
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        timer.invalidate()
    }
    
    //MARK: - 初始化视图
    private func setupScrollView(){
        ScrollView.contentSize = CGSize(width: 3 * kScreenWidth, height: 0)
        
        ScrollView.contentOffset = CGPoint(x: kScreenWidth, y: 0)
        
        ScrollView.showsHorizontalScrollIndicator = false
        
        ScrollView.isPagingEnabled = true
        
        ScrollView.delegate = self
        
        ScrollView.isScrollEnabled = true
        
        ScrollView.bounces = false
        
        ScrollView.isUserInteractionEnabled = true
        
        addSubview(ScrollView)
        
        ScrollView.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalTo(self)
        }
        
    }

    private func setupImageView(){
        /// 初始化当前视图
        let urlString1 = NSURL(string: dataArray[currentIndex].image_url_big!)!
        currentImageView.sd_setImage(with: urlString1 as URL!, placeholderImage: nil, options: SDWebImageOptions.continueInBackground, completed: nil)
        currentImageView.frame = CGRect(x: frame.size.width, y: 0, width: frame.size.width, height:frame.size.height)
        currentImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didSelectImageView))
        currentImageView.addGestureRecognizer(tapGesture)
        currentImageView.contentMode = UIViewContentMode.scaleToFill
        ScrollView.addSubview(currentImageView)
        /// 初始化下一个视图
        let urlString2 = NSURL(string: dataArray[nextIndex].image_url_big!)!
        nextImageView.sd_setImage(with: urlString2 as URL!, placeholderImage: nil, options: SDWebImageOptions.continueInBackground, completed: nil)
        nextImageView.frame = CGRect(x: frame.size.width * 2, y: 0, width: frame.size.width, height: frame.size.height)
        nextImageView.contentMode = UIViewContentMode.scaleToFill
        ScrollView.addSubview(nextImageView)
        /// 初始化上一个视图
        let urlString0 = NSURL(string: dataArray[previousIndex].image_url_big!)!
        previousView.sd_setImage(with: urlString0 as URL!, placeholderImage: nil, options: SDWebImageOptions.continueInBackground, completed: nil)
        previousView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        previousView.contentMode = UIViewContentMode.scaleToFill
        ScrollView.addSubview(previousView)
        
    }
    private func setupPageContol(){
        
        pageControll.numberOfPages = dataArray.count
        pageControll.currentPage = 0
        // 设置 page 颜色
        pageControll.currentPageIndicatorTintColor = UIColor.yellow
        pageControll.pageIndicatorTintColor = UIColor.gray
        addSubview(pageControll)
        
        pageControll.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self.snp.bottom).offset(-20)
            make.width.equalTo(100)
        }
        
    }
    private func initTimer(){
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(interval), target: self, selector: #selector(carousel), userInfo: nil, repeats: true)
        let mainLoop = RunLoop.main
        mainLoop.add(timer, forMode: RunLoopMode.commonModes)
    }
    

    
    //MARK: -  懒加载数据
    static let scrollIMages : FWScrollImageView = {
        return FWScrollImageView()
    }()
    private var currentImageView = UIImageView()
    private var nextImageView = UIImageView()
    private var previousView = UIImageView()
    private var currentIndex:Int = 0
    private var nextIndex:Int = 0
    private var previousIndex:Int = 0
    private var current : Int = 0
    private var interval : CGFloat = 0.0
    
    private var dataArray = [FWScrollModel]()
    
    private var timer = Timer()
    
    private lazy var pageControll : UIPageControl={
        let page = UIPageControl()
        return page
    }()
    private lazy var ScrollView : UIScrollView = {
        return UIScrollView()
    }()
    

}
