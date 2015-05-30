//
//  Service.m
//  QMCollege
//
//  Created by QiMENG on 15/5/29.
//  Copyright (c) 2015年 QiMENG. All rights reserved.
//

#import "Service.h"


@implementation Service


+ (void)createYoumiIAD {
    
    NSString *appid = @"51f0f224c37459c6";
    NSString *secretId = @"014cb0f05770af7d";
    [YouMiNewSpot initYouMiDeveloperParams:appid YM_SecretId:secretId];
    
    //使用前先初始化一下插屏
    [YouMiNewSpot initYouMiDeveLoperSpot:kSPOTSpotTypeBoth];//填上你对应的横竖屏模式
}

+ (void)showYoumiIAD {
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kIAPClear]) {
        [YouMiNewSpot showYouMiSpotAction:^(BOOL flag){
        }];
    }
}

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
                                   block([self parseCityList:responseObject],nil);
                               } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                   [SVProgressHUD showErrorWithStatus:@"数据错误,请稍后再试"];
                               }];
}
+ (NSArray *)parseCityList:(id)response {
    
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
                        
                        Model * m = [[Model alloc]initWithTitle:item.stringValue
                                                 infoUrlString:[[item attributeForName:@"href"] stringValue]];
                        
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
                                   block([self parseCollegeList:responseObject],nil);
                               } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                   [SVProgressHUD showErrorWithStatus:@"数据错误,请稍后再试"];
                               }];
}
+ (NSArray *)parseCollegeList:(id)response {
    
    NSMutableArray * mainArray = [NSMutableArray array];
    
    @autoreleasepool {
     
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithHTMLData:response
                                                                  encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)
                                                                     error:NULL];
        if (doc) {
            NSArray *list = [doc nodesForXPath:@"//ul[@id='daxue']" error:NULL];
            
            for (GDataXMLElement * item in list) {
                
                NSArray * liItem = [item elementsForName:@"li"];
                
                for (GDataXMLElement * item2 in liItem) {
                    
                    NSArray * aitem = [item2 elementsForName:@"a"];
                    
                    for (GDataXMLElement * element in aitem) {
                        
                        Model * m = [[Model alloc]initWithTitle:element.stringValue
                                                  infoUrlString:[[element attributeForName:@"href"] stringValue]];
                        [mainArray addObject:m];

                    }   
                }
            }
        }
    }
    
    return mainArray;
}



#pragma mark - 获取学校的详细信息
+ (NSURLSessionDataTask *) infoCollege:(NSString *)aCollege withBlock:(void (^)(CollegeModel * collegeModel, NSError *error))block
{
    return [[Service sharedClient] GET:aCollege
                            parameters:nil
                               success:^(NSURLSessionDataTask *task, id responseObject) {
                                   block([self pareseCollege:responseObject],nil);
                               } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                   [SVProgressHUD showErrorWithStatus:@"数据错误,请稍后再试"];
                               }];
}

+ (CollegeModel *)pareseCollege:(id)response {
    
    CollegeModel * m = [CollegeModel new];
    
    @autoreleasepool {
     
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithHTMLData:response
                                                                  encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)
                                                                     error:NULL];
        
        if (doc) {
            NSArray *list = [doc nodesForXPath:@"//table" error:NULL];

            for (GDataXMLElement * item in list) {
                
                NSArray * trList = [item elementsForName:@"tr"];
                
                for (int i=0;i<trList.count;i++)
                {
                    
                    GDataXMLElement * item = trList[i];
                    
                    NSArray * tdList = [item elementsForName:@"td"];
                    for (GDataXMLElement * tdItem in tdList)
                    {
                        //获取图片logo
                        NSArray * imgList = [tdItem elementsForName:@"img"];
                        if (imgList) {
                            GDataXMLElement * imgElement = imgList[0];
                            m.logo = [[imgElement attributeForName:@"src"] stringValue];
                            continue;
                        }
                        
                        //获取学校名称
                        NSArray * names = [tdItem elementsForName:@"b"];
                        if (names)
                        {
                            GDataXMLElement * el = names[0];
                            NSArray * name = [el elementsForName:@"h1"];
                            if (name)
                            {
                                GDataXMLElement * el1 = name[0];
                                m.name = el1.stringValue;
                            }
                        }
                        //简介
                        NSArray * p = [tdItem elementsForName:@"p"];
                        if (p) {
                            
                            if (i == 0) {
                                GDataXMLElement * el = p[0];
                                m.intro = el.stringValue;
                            }else {
                                m.info = @"";
                                for (GDataXMLElement *el in p) {
                                    m.info = [m.info stringByAppendingFormat:@"%@\n",el.stringValue];
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return m;
}



@end






