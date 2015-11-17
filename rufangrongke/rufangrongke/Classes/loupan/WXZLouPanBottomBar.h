//
//  WXZLouPanBottomBar.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/6.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WXZLouPanBottomBarProtocol <NSObject>
- (void)louPanBottomBar_click_yaojifeng;
- (void)louPanBottomBar_click_zhushou;
- (void)louPanBottomBar_click_wodekehu;
- (void)louPanBottomBar_click_baobeikehu;
@end
@interface WXZLouPanBottomBar : UIView
/* delegate */
@property (nonatomic , weak) id delegate;
@end
