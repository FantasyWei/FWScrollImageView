<div align='center'><img src = 'http://ofermdgmf.bkt.clouddn.com/yaojing.jpg' width = 80 ></div>

# KSScrollImageView

* 快速实现无线轮播- Swift3.0
* **注意：**下载之后请使用 pod update 将三方框架加入,项目上传时,并没有加入第三方框架,会报错，请先 cd 到文件目录，然后请 pod update， 代码为
    
         pod update --no-repo-update

***

##效果图如下:
![image](http://ofermdgmf.bkt.clouddn.com/KSScreollImageView.gif)

-
<font size=5>注意:</font>

* 需要导入 AFNetWorking Snapkit SDWebImage 三个框架
* 需要自己在框架中处理 AFN 获取到的数据,保证数据数组 dataArray 中存放的是正确的模型
* 需要自己将 model 中的参数类型进行设定为自己的网络字段
* 上传时忽略了上述的三个第三方框架,请您自己导入,谢谢!!!
* 如果项目运行的时候控制台报错,请在Xcode->Product->Scheme->Eidt Scheme...-> run ->Environment Variables 下添加 OS_ACTIVITY_MODE值为 disable


## 如何使用
使用时调用下面的方法即可:

    scrollView.sendHttpRequest(method: .GET,urlString: urlString, parameters: nil,interval: 1)

参数:

* method : 请求方式 .GET 或 .POST,如果不写则默认为 GET 方式
* urlString :  访问的网络地址
* parameters:  网络访问的参数

闭包回调:

    scrollView.callBack = { (index:Int,model:KSScrollModel)-> Void in
     		print("当前点击的是第\(index+1)张图片,模型是\(model)")
    }
 
输出: 只需要将 model 的属性拿出来即可,例: model. name 

    当前点击的是第2张图片,模型是<KSScrollImageView.KSScrollModel: 0x600000326040>

## 示例代码
	import UIKit
	import SnapKit

    class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scrollView = KSScrollImageView()
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(64)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(200)
        }
        
        let  urlString = "http://qt.qq.com/static/pages/news/phone/c13_list_1.shtml?plat=android&version=9709"
        scrollView.sendHttpRequest(method: .GET,urlString: urlString, parameters: nil,interval: 2)
        
        
        // 点击图片的回调
        scrollView.callBack = { (index:Int,model:KSScrollModel)-> Void in
            print("当前点击的是第\(index+1)张图片,模型是\(model)")
        }
        
    }
}

