//
//  WXZScreeningView.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/10.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//  筛选view

#import <UIKit/UIKit.h>
#import "WXZKeHuController.h"

@interface WXZScreeningView : UIView //<BackFilterTypeDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTable;

@property (nonatomic,strong) NSArray *dataArr;

@property (nonatomic,assign) id<BackFilterTypeDelegate> backScreeningTypeDelegate;

@end
