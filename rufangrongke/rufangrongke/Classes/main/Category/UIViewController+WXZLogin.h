//
//  UIViewController+WXZLogin.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/26.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^loginMessage)(id result);

@interface UIViewController (WXZLogin)
//- (void)login;
- (NSDictionary *)loginMessage;

- (void)loginRequest:(loginMessage)message;

- (NSDictionary *)localUserInfo;

@end
