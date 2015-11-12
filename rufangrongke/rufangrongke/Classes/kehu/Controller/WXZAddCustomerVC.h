//
//  WXZAddCustomerVC.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/4.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXZKeHuDetailModel.h"

@protocol UpdateKeHuDetailInfoDelegate <NSObject>

- (void)updateKeHuDetailInfo:(NSString *)customerId;

@end

@interface WXZAddCustomerVC : UIViewController 

@property (nonatomic,strong) NSString *titleStr;

@property (nonatomic,strong) WXZKeHuDetailModel *detailModel;

@property (nonatomic,assign) BOOL isModifyCustomerInfo;

@property (nonatomic,assign) BOOL isKeHuDetail;

@property (nonatomic,assign) id<UpdateKeHuDetailInfoDelegate> updateDelegate;

@end
