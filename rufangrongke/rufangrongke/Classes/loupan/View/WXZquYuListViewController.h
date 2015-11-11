//
//  WXZquYuListViewController.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/11.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  WXZquYuListViewControllerDelegate <NSObject>

- (void)quYuListViewControllerDelegate:(NSString *)parameter;

@end
@interface WXZquYuListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 代理 */
@property (nonatomic , weak) id<WXZquYuListViewControllerDelegate> delegate;

@end
