//
//  WXZiMuTableObject.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/29.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZiMuTableObject.h"
#import "pinyin.h"

@interface WXZiMuTableObject ()

@property(nonatomic,retain)NSMutableArray *zimuAllKeys;
@property(nonatomic,retain)NSArray *listArr;
@property (nonatomic,strong) NSMutableArray *tempOtherArr;

@end

@implementation WXZiMuTableObject

// 单例
+ (WXZiMuTableObject *)parxuInit
{
    static WXZiMuTableObject *sharedManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedManagerInstance = [[self alloc] init];
    });
    return sharedManagerInstance;
}

- (NSMutableDictionary *)sortedArrayWithPinYinDic:(NSArray *)citys
{
    _tempOtherArr=[[NSMutableArray alloc] init];
    _zimuAllKeys=[[NSMutableArray alloc] init];
    // 通过ASCII遍历，取出对应字幕
    for(int i=65;i<91;i++)
    {
        [_zimuAllKeys addObject:[NSString stringWithFormat:@"%C",(unichar)i]];
    }
    
    _listArr=citys;
    
    if(!citys) return nil;
    
    NSMutableDictionary *returnDic = [NSMutableDictionary new];
    _tempOtherArr = [NSMutableArray new];
    BOOL isReturn = NO;
    
    for (NSString *key in _zimuAllKeys)
    {
        if ([_tempOtherArr count])
        {
            isReturn = YES;
        }
        
        NSMutableArray *tempArr = [NSMutableArray new];
        for (NSInteger i=0;i<_listArr.count;i++)
        {
            NSString *pyResult = [self hanZiToPinYinWithString:_listArr[i]]; //
            NSString *firstLetter = [pyResult substringToIndex:1];
            if ([firstLetter isEqualToString:key])
            {
                [tempArr addObject:_listArr[i]];
            }
            
            if(isReturn) continue;
            char c = [pyResult characterAtIndex:0];
            if (isalpha(c) == 0)
            {
                [_tempOtherArr addObject:_listArr[i]];
            }
        }
        if (tempArr.count>0)
        {
            [returnDic setObject:tempArr forKey:key];
        }
    }
    
    return returnDic;
}

/**
 *  汉子转拼音
 *
 *  @param hanZi 汉字
 *
 *  @return 拼音
 */
- (NSString *)hanZiToPinYinWithString:(NSString *)hanZi
{
    if(!hanZi) return nil;
    
    NSString *pinYinResult=[NSString string];
    for(int j=0; j<hanZi.length; j++)
    {
        NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([hanZi characterAtIndex:j])] uppercaseString];
        pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
    }
    
    return pinYinResult;
    
}

@end
