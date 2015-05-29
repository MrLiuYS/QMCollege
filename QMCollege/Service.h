//
//  Service.h
//  QMCollege
//
//  Created by QiMENG on 15/5/29.
//  Copyright (c) 2015年 QiMENG. All rights reserved.
//

//#import "AFHTTPSessionManager.h"

#import "QMCollege-Bridging-Header.h"
#import "Model.h"

@interface Service : AFHTTPSessionManager

+ (instancetype)sharedClient;

/**
 *  数据转换成中文
 */
+ (NSString *)encodingGBKFromData:(id)aData;
/**
 *  中文转换成GBK码
 */
+ (NSString *)encodingBKStr:(NSString *)aStr;


/**
 *  获取省市列表
 */
+ (NSURLSessionDataTask *) cityList:(void (^)(NSArray *array, NSError *error))block;

/**
 *  获取省市下的学校列表
 */
+ (NSURLSessionDataTask *) collegeListFromCity:(NSString *)aCity
                                     withBlock:(void (^)(NSArray *array, NSError *error))block;


@end
