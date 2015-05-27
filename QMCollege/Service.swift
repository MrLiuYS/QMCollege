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
            }
        )
        return singleton.instance!
    }
    
    func citylist(block:((array:NSArray!, error:NSError!)->Void!) ){
        
        Service.shareInstance().GET("index.asp", parameters: nil, success: { (task:NSURLSessionDataTask!, responseObject:AnyObject!) -> Void in

            block(array: [], error: nil)
            
            }) { (task:NSURLSessionDataTask!, error:NSError!) -> Void in
                
                block(array: nil, error: error)
                
        }
    }
    
        
        
//    func  DefaultTextAndAuthor（ block: { [weak self](array:NSMutableArray!,error:NSError) -> _ in
//    return
//    }）
    
    
//    + (NSURLSessionDataTask *) DefaultTextAndAuthor:(void (^)(NSMutableArray *array, NSError *error))block{
//    
//    return [[Service sharedClient] GET:@"index.asp"
//    parameters:nil
//    success:^(NSURLSessionDataTask *task, id responseObject) {
//    
//    block([self parseFromDefault:responseObject], nil);
//    
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//    //                                   block(nil, error);
//    [SVProgressHUD showErrorWithStatus:@"数据错误,请稍后再试"];
//    }];
//    }
    
}


