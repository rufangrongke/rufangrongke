//
//  UIViewController+WXZLogin.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/26.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^loginSuccessMsg)(id successResult);
typedef void(^loginFailedMsg)(id failedResult);

@interface UIViewController (WXZLogin)
//- (void)login;
- (NSDictionary *)loginMessage;

- (void)loginRequest:(loginSuccessMsg)message; // 登录请求

- (NSDictionary *)localUserInfo;

- (void)reloadCityRegionList;
/*回到登陆页*/
- (void)goBackLoginPage;
/* 请求结果 */
typedef void (^WXZNetworkBlock)();
- (void)networkResponse:(id)responseObject block:(WXZNetworkBlock)block;
/* 网络无法访问 */
- (void)netWorkError;
@end
