//
//  WXZPurchaseIntentionCell.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/4.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXZKeHuDetailModel.h"

@interface WXZPurchaseIntentionCell : UITableViewCell

+ (instancetype)initPurchaseIntentionCell;

- (void)showTypeName:(NSInteger)row;
- (void)showTypeData:(NSArray *)typeArr Target:(id)target action:(SEL)action row:(NSInteger)row withQuYuArr:(NSMutableArray *)quyuAr1 withHxArr:(NSMutableArray *)hxAr2 withFwArr:(NSMutableArray *)fwAr3  isModify:(BOOL)ismodify yuanData:(WXZKeHuDetailModel *)model;

@end
