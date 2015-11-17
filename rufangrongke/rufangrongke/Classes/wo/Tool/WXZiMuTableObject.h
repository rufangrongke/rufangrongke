//
//  WXZiMuTableObject.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/29.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXZiMuTableObject : NSObject

+ (WXZiMuTableObject *)parxuInit;
- (NSMutableDictionary *)sortedArrayWithPinYinDic:(NSArray *)citys;
- (NSString *)hanZiToPinYinWithString:(NSString *)hanZi;

@end
