//
//  WXZLouPanYiBaoBeiKeHuModel.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/16.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Ls;
@interface WXZLouPanYiBaoBeiKeHuModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSArray<Ls *> *ls;

@property (nonatomic, assign) BOOL ok;

@end
@interface Ls : NSObject

@property (nonatomic, copy) NSString *Mobile;

@property (nonatomic, copy) NSString *typeBig;

@property (nonatomic, copy) NSString *Sex;

@property (nonatomic, copy) NSString *typeSmall;

@property (nonatomic, copy) NSString *XingMing;

@end

