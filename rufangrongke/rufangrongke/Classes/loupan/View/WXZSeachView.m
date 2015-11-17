//
//  WXZSeachView.m
//  rufangrongke
//
//  Created by dymost on 15/10/19.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZSeachView.h"

@implementation WXZSeachView

+ (instancetype)seachBar
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}
//- (void)awakeFromNib
//{
//    
//}
//- (instancetype)init
//{
//    if (self = [super init]) {
//        
//    }
//    return self;
//}
//
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame]) {
//        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
//    }
//    return self;
//}
@end
