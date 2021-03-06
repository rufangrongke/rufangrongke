//
//  WXZWorkingTimeView.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/29.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

/**
 * 从业时间view
 **/

#import <UIKit/UIKit.h>
#import "SRMonthPicker.h" // pickerView

@interface WXZWorkingTimeView : UIView<SRMonthPickerDelegate> // 遵循协议

@property (weak, nonatomic) IBOutlet UIView *bgView; // 背景view

@property (weak, nonatomic) IBOutlet UIImageView *bgImgView; // 背景图片

@property (weak, nonatomic) IBOutlet SRMonthPicker *timePickerView; // 时间选择

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn; // 取消按钮
@property (weak, nonatomic) IBOutlet UIButton *determineBtn; // 确定按钮

@end
