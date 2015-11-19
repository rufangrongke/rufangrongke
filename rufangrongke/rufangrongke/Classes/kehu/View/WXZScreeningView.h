//
//  WXZScreeningView.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/10.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

/**
 * 筛选类型view
 **/

#import <UIKit/UIKit.h>
#import "WXZKeHuController.h" // 引入客户首页.h文件

@interface WXZScreeningView : UIView //<BackFilterTypeDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTable; // 筛选类型tableView

@property (nonatomic,strong) NSArray *dataArr; // 筛选类型内容数组

@property (nonatomic,assign) id<BackFilterTypeDelegate> backScreeningTypeDelegate; // 声明返回筛选类型内容的代理

@end
