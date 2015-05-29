//
//  Model.h
//  QMCollege
//
//  Created by QiMENG on 15/5/29.
//  Copyright (c) 2015年 QiMENG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

@property (nonatomic, copy) NSString * title;

@property (nonatomic, copy) NSString * infoUrlString;

- (instancetype)initWithTitle:(NSString *)aTitle
               infoUrlString:(NSString *)aInfoUrlString;


@end
