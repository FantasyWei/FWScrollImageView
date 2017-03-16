//
//  FWScrollModel.swift
//  kangaroo  street
//
//  Created by FantasyWei on 2016/10/20.
//  Copyright © 2016年 FantasyWei. All rights reserved.
//

import UIKit

/**
 "article_id": "24075",
 "content_id": "24075",
 "newstype": "",
 "newstypeid": "ordinary",
 "channel_desc": "",
 "channel_id": "<2>:<12>,<2>:<23>",
 "insert_date": "2016-10-18 12:56:58",
 "title": "全球总决赛表情创作活动",
 "article_url": "http://lol.qq.com/m/act/a20161010mkemo/mkpage.html",
 "summary": "打开脑洞创作表情 皮肤、外设等你拿",
 "score": "3",
 "publication_date": "2016-10-18 18:15:30",
 "targetid": "1582072203",
 "intent": "",
 "is_act": "0",
 "is_hot": "0",
 "is_subject": "0",
 "is_new": "0",
 "is_top": "False",
 "image_with_btn": "False",
 "image_spec": "1",
 "is_report": "True",
 "is_direct": "False",
 "image_url_small": "http://ossweb-img.qq.com/upload/qqtalk/news/201610/181256583876978_282.jpg",
 "image_url_big": "http://ossweb-img.qq.com/upload/qqtalk/news/201610/181256583876978_480.jpg",
 "pv": "2731545",
 "bmatchid": "0",
 "v_len": "",
 "pics_id": "0"
 
 */
class FWScrollModel: NSObject {
    
    var article_id : NSInteger? = 0
    var type : NSInteger = 0
    var type_id:NSInteger? = 0
    var  title :String?
    var  image_url_big : String?
    var article_url:String?
    
    init(dict:[String:AnyObject]) {
     super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
    
    

}
