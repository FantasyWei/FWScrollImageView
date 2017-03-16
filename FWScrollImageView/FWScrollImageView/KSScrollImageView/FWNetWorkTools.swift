//
//  FWNetWorkTools.swift
//  kangaroo  street
//
//  Created by FantasyWei on 2016/10/20.
//  Copyright © 2016年 FantasyWei. All rights reserved.
//

import UIKit
import AFNetworking

enum FWRequestMethod :String{
    case GET = "GET"
    case POST = "POST"
}

class FWNetWorkTools: AFHTTPSessionManager {
    
    // 单例
    static let sharedTools : FWNetWorkTools = {
        let instence = FWNetWorkTools()
        instence.responseSerializer.acceptableContentTypes?.insert("text/html")
        instence.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return instence
    }()
    
    typealias FWRequestCallBack = (_ response : AnyObject?,_ error:NSError?)->()
    
    func request(method:FWRequestMethod? = .GET,urlString:String,parameters: AnyObject?, finished:@escaping FWRequestCallBack){
        
        let success = { (dataTask: URLSessionDataTask?, responseObject: Any?) -> Void in
            finished(responseObject as AnyObject?, nil)
        }
        let failure = { (dataTask: URLSessionDataTask?, error: Error)->() in
            finished(nil, error as NSError?)
        }
        if  method == .GET {
            get(urlString, parameters: parameters, progress: nil, success: success, failure: failure)
        }else{
            post(urlString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
        
    }

}
