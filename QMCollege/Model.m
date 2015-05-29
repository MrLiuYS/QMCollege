//
//  Model.m
//  QMCollege
//
//  Created by QiMENG on 15/5/29.
//  Copyright (c) 2015年 QiMENG. All rights reserved.
//

#import "Model.h"

@implementation Model


- (instancetype)initWithCity:(NSString *)aCity infoUrlString:(NSString *)aInfoUrlString
{
    self = [super init];
    if (self) {
        
        _city = aCity;
        _infoUrlString = aInfoUrlString;
        
    }
    return self;
}


@end
