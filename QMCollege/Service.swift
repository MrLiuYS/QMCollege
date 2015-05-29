//
//  Service.swift
//  QMCollege
//
//  Created by QiMENG on 15/5/27.
//  Copyright (c) 2015年 QiMENG. All rights reserved.
//

import UIKit


class Service:AFHTTPSessionManager
{
    class func shareInstance()->Service
    {
        struct singleton
        {
            static var predicate:dispatch_once_t = 0
            static var instance:Service? = nil
        }
        dispatch_once(&singleton.predicate,
            {
                singleton.instance=Service(baseURL: NSURL(string: kBaseURLString))
                singleton.instance?.responseSerializer = AFHTTPResponseSerializer()
            }
        )
        return singleton.instance!
        //    }
        
        
    }
    
    func citylist(block:((array:NSArray!, error:NSError!)->Void!) ){
        
        Service.shareInstance().GET("", parameters: nil, success: { (task:NSURLSessionDataTask!, responseObject:AnyObject!) -> Void in
            
            println(responseObject)
            
//            var doc:GDataXMLDocument = GDataXMLDocument(data: responseObject
//                , encoding: CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingInvalidId), error: nil)

            
            var doc:GDataXMLDocument = GDataXMLDocument(HTMLData: responseObject, encoding: CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000), error: nil)
            
            
                block(array: [], error: nil)
            
            }) { (task:NSURLSessionDataTask!, error:NSError!) -> Void in
                
                block(array: nil, error: error)
                
        }
    }
    

        
}


