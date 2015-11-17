//
//  WXZLouPanBaoBeiKeHuModel.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/16.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import <Foundation/Foundation.h>

@class List;
@interface WXZLouPanBaoBeiKeHuModel : NSObject

@property (nonatomic, assign) NSInteger rowcount;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, assign) BOOL ok;

@property (nonatomic, strong) NSArray<List *> *list;

@end
@interface List : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *Mobile;

@property (nonatomic, copy) NSString *XingMing;

@property (nonatomic, copy) NSString *QuYu;

@property (nonatomic, copy) NSString *YiXiang;

@property (nonatomic, copy) NSString *loupan;

@property (nonatomic, copy) NSString *hdTime;

@property (nonatomic, copy) NSString *Hx;

@property (nonatomic, copy) NSString *typebig;

@property (nonatomic, assign) NSInteger Row;

@property (nonatomic, copy) NSString *Sex;

@property (nonatomic, copy) NSString *typeSmall;

@end

