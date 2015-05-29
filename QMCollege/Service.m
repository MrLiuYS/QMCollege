//
//  Service.m
//  QMCollege
//
//  Created by QiMENG on 15/5/29.
//  Copyright (c) 2015年 QiMENG. All rights reserved.
//

#import "Service.h"

@implementation Service

+ (instancetype)sharedClient {
    static Service *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[Service alloc] initWithBaseURL:[NSURL URLWithString:kBaseURLString]];

        _sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [_sharedClient.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    
                    break;
                    
                case AFNetworkReachabilityStatusReachableViaWiFi:
                {
                    [SVProgressHUD showErrorWithStatus:@"已链接wifi"];
                    
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"已链接wifi" message:nil delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil, nil];
                    [alert show];
                }
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                {
                    [SVProgressHUD showErrorWithStatus:@"网络中断.请检查网络设置."];
                }
                    break;
                default:
                    break;
            }
        }];
        
    });
    
    return _sharedClient;
}
#pragma mark - 数据转换成中文
+ (NSString *)encodingGBKFromData:(id)aData {
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *string = [[NSString alloc] initWithData:aData encoding:gbkEncoding];
    return string;
}
#pragma mark - 中文转换成GBK码
+ (NSString *)encodingBKStr:(NSString *)aStr {
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    aStr = [aStr stringByAddingPercentEscapesUsingEncoding:enc];
    return aStr;
}

#pragma mark - 获取省市列表
+ (NSURLSessionDataTask *) cityList:(void (^)(NSArray *array, NSError *error))block{
    
    return [[Service sharedClient] GET:@""
                            parameters:nil
                               success:^(NSURLSessionDataTask *task, id responseObject) {
                                   block([self parseCityListFromData:responseObject],nil);
                               } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                   [SVProgressHUD showErrorWithStatus:@"数据错误,请稍后再试"];
                               }];
}
+ (NSArray *)parseCityListFromData:(id)response {
    
    NSMutableArray * mainArray = [NSMutableArray array];
    @autoreleasepool {
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithHTMLData:response
                                                                  encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)
                                                                     error:NULL];
        if (doc) {
            NSArray *list = [doc nodesForXPath:@"//div[@id='main']" error:NULL];
            
            for (GDataXMLElement * elements in list) {
                
                NSArray *groups = [elements elementsForName:@"p"];
                
                if (groups.count >0) {
                    
                    GDataXMLElement *element = groups[0];
                    
                    NSArray *agroups = [element elementsForName:@"a"];
                    
                    for (GDataXMLElement * item in agroups) {
                        
                        Model * m = [[Model alloc]initWithCity:item.stringValue
                                                 infoUrlString:[[element attributeForName:@"href"] stringValue]];
                        
                        [mainArray addObject:m];
                        
                    }
                    
                }
            }
        }
    }
    
    return mainArray;
}

#pragma mark - 获取省市下学校列表列表
+ (NSURLSessionDataTask *) collegeListFromCity:(NSString *)aCity withBlock:(void (^)(NSArray *array, NSError *error))block
{
    
    return [[Service sharedClient] GET:aCity
                            parameters:nil
                               success:^(NSURLSessionDataTask *task, id responseObject) {
                                   block([self parseCollegeListFromCity:responseObject],nil);
                               } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                   [SVProgressHUD showErrorWithStatus:@"数据错误,请稍后再试"];
                               }];
}
+ (NSArray *)parseCollegeListFromCity:(id)response {
    
    NSMutableArray * mainArray = [NSMutableArray array];
    
    @autoreleasepool {
     
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithHTMLData:response
                                                                  encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)
                                                                     error:NULL];
        if (doc) {
            NSArray *list = [doc nodesForXPath:@"//ul[@id='daxue']" error:NULL];

            NSLog(@"%@",list);
            
        }
        
        
        
    }
    
    return mainArray;
}


@end






