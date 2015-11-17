//
//  WXZLiandong.h
//  1102-footView
//
//  Created by 儒房融科 on 15/11/2.
//  Copyright (c) 2015年 儒房融科. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXZLiandong : UIView
/* 控制器数组 */
@property (nonatomic , strong) NSMutableArray *VC_array;

+ (instancetype)makeLiandongView:(NSMutableArray *)VCArray;
@end
