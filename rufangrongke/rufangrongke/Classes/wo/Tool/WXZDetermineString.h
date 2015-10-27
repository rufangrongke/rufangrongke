//
//  WXZDetermineString.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/27.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXZDetermineString : NSObject

+ (BOOL)determineString:(NSString *)str;

+ (BOOL)isBeyondTheScopeOf:(NSInteger)length string:(NSString *)str;

@end
