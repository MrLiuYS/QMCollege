//
//  CollegeModel.m
//  QMCollege
//
//  Created by Lin on 15/5/30.
//  Copyright (c) 2015年 QiMENG. All rights reserved.
//

#import "CollegeModel.h"
#import "QMCollege-Bridging-Header.h"
@implementation CollegeModel


- (void)setLogo:(NSString *)logo {
    
    _logo = [NSString stringWithFormat:@"%@%@",kBaseURLString,logo];
    
}


- (void)setIntro:(NSString *)intro {
    
    _intro = intro;
    
    NSArray * array = [intro componentsSeparatedByString:@"\n"];

    NSLog(@"%@",array);
    
    
    
    
}


- (void)setInfo211And985:(NSString *)info211And985 {
    
    _info211And985 = info211And985;
    
    
    
}


@end
