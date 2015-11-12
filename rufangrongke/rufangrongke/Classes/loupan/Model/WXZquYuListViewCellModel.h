//
//  WXZquYuListViewCellModel.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/11.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Qus;
@interface WXZquYuListViewCellModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSArray<Qus *> *qus;

@property (nonatomic, assign) BOOL ok;

@end
@interface Qus : NSObject

@property (nonatomic, copy) NSString *q;

@property (nonatomic, assign) NSInteger c;

@end

