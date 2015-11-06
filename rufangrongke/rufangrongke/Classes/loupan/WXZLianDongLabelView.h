//
//  WXZLianDongLabelView.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/5.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXZLianDongLabelView : UIView
@property (weak, nonatomic) IBOutlet UILabel *labelView;

@property (weak, nonatomic) IBOutlet UIButton *hongseBtn;

+ (instancetype)lianDongLabelView;
@end
