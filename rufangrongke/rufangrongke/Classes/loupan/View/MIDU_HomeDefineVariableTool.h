//
//  MIDU_HomeDefineVariableTool.h
//  MiDu
//
//  Created by 胡双飞 on 15/9/7.
//  Copyright (c) 2015年 HSF. All rights reserved.
//

#ifndef MiDu_MIDU_HomeDefineVariableTool_h
#define MiDu_MIDU_HomeDefineVariableTool_h

/**
 *  tableView常用宏
 */
#define estimatedTableViewRowHeight 44
/***********************************主页基本属性****************************************/
/**
 *  颜色类型
 */
typedef enum : NSUInteger {
    //招聘信息文字颜色
    ColorValueTypeTitile,
    //公司名称文字颜色
    ColorValueTypeSub1Titile,
    //日期、地点、学历、工作年限、公司情况、公司类型等文字颜色
    ColorValueTypeSub2Titile,
    //招聘薪资文字颜色
    ColorValueTypeMoney
} ColorValueType;

//*********主页头部视图**************
#define kLogoWidth (136 / 3)
#define kLogoHeight (62 / 3)
#define kStatusHeight 20

//************主页字体大小*************
/**
 * 日期
 */
#define kHome_TopRightTitleSize 10
/**
 *  招聘信息文字大小
 */
#define kHome_TopLeftTitleSize 14
/**
 *  公司名称文字大小 、 招聘薪资
 */
#define kHome_MidTitileSize 13
/**
 *  时间、地点、学历、工作年限、公司情况、公司类型等文字大小
 */
#define kHome_BottomTitleSize 12
/***********************************主页各个控件Frame属性****************************************/
/**
 *  图片宽高
 */
#define kHome_ImgWH 60
/**
 *  边距
 */
#define kHome_Margin 10
/**
 *  招聘信息textMaxSize
 */
#define kHome_TextMaxSize
#endif
