//
//  CollegeModel.h
//  QMCollege
//
//  Created by Lin on 15/5/30.
//  Copyright (c) 2015年 QiMENG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollegeModel : NSObject

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * website;
@property (nonatomic, copy) NSString * logo;
@property (nonatomic, copy) NSString * city;
@property (nonatomic, retain) NSArray * tels;
@property (nonatomic, assign) BOOL is211;
@property (nonatomic, assign) BOOL is985;
@property (nonatomic, copy) NSString * info211And985;//211院校：是 985院校：是

@property (nonatomic, copy) NSString * intro;   //简介

@property (nonatomic, copy) NSString * info;    //详情


@end
