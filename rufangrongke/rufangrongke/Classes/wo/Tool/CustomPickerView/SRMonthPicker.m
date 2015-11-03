/*
 Copyright (C) 2012-2013 Simon Rice
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import "SRMonthPicker.h"

#define MONTH_ROW_MULTIPLIER 40 // 月行乘数,原来是340(数大内容少，则不会循环滚动)
#define DEFAULT_MINIMUM_YEAR 1 // 默认年的最小范围值
#define DEFAULT_MAXIMUM_YEAR 99999 // 默认年的最大范围值
#define DATE_COMPONENT_FLAGS NSMonthCalendarUnit | NSYearCalendarUnit // 获取日历的年月

@interface SRMonthPicker()

@property (nonatomic) int monthComponent; // 月的内容
@property (nonatomic) int yearComponent; // 年的内容
@property (nonatomic, readonly) NSArray* monthStrings; // 存储月的数据

-(int)yearFromRow:(NSUInteger)row; //
-(NSUInteger)rowFromYear:(int)year; //

@end

@implementation SRMonthPicker

@synthesize date = _date;
@synthesize monthStrings = _monthStrings;
@synthesize enableColourRow = _enableColourRow;
@synthesize monthPickerDelegate = _monthPickerDelegate;

-(id)initWithDate:(NSDate *)date
{
    self = [super init];
    
    if (self)
    {
        [self prepare];
        [self setDate:date];
        self.showsSelectionIndicator = YES; // 是否显示选择指示器
    }
    
    return self;
}

-(id)init
{
    self = [self initWithDate:[NSDate date]];
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self prepare];
        if (!_date)
            [self setDate:[NSDate date]];
    }
    
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self prepare];
        if (!_date)
            [self setDate:[NSDate date]];
    }
    
    return self;
}

-(void)prepare
{
    // 遵循UIPickerViewDataSource/Delegate
    self.dataSource = self;
    self.delegate = self;
    
    // 初始化
    _enableColourRow = YES;
    _wrapMonths = YES;
}

-(id<UIPickerViewDelegate>)delegate
{
    return self;
}

-(void)setDelegate:(id<UIPickerViewDelegate>)delegate
{
    if ([delegate isEqual:self])
        [super setDelegate:delegate];
}

-(id<UIPickerViewDataSource>)dataSource
{
    return self;
}

-(void)setDataSource:(id<UIPickerViewDataSource>)dataSource
{
    if ([dataSource isEqual:self])
        [super setDataSource:dataSource];
}

// 一年几个月
-(int)monthComponent
{
    return self.yearComponent ^ 1;
}

// 一个布尔值来决定今年是否显示在前面
-(int)yearComponent
{
    return !self.yearFirst;
}

// 获取月份
-(NSArray *)monthStrings
{
    return [[NSDateFormatter alloc] init].veryShortMonthSymbols; // 获取月份
}

-(void)setYearFirst:(BOOL)yearFirst
{
    _yearFirst = yearFirst;
    NSDate* date = self.date;
    [self reloadAllComponents]; // 刷新所有内容
    [self setNeedsLayout]; // 允许你在画周期发生之前进行布局
    [self setDate:date]; //
}

// 设置年的最小范围值
-(void)setMinimumYear:(NSNumber *)minimumYear
{
    NSDate* currentDate = self.date;
    NSDateComponents* components = [[NSCalendar currentCalendar] components:DATE_COMPONENT_FLAGS fromDate:currentDate];
    components.timeZone = [NSTimeZone defaultTimeZone];
    
    if (minimumYear && components.year < minimumYear.integerValue)
        components.year = minimumYear.integerValue;
    
    _minimumYear = minimumYear;
    [self reloadAllComponents];
    [self setDate:[[NSCalendar currentCalendar] dateFromComponents:components]];
}

// 设置年的最大范围值
-(void)setMaximumYear:(NSNumber *)maximumYear
{
    NSDate* currentDate = self.date;
    NSDateComponents* components = [[NSCalendar currentCalendar] components:DATE_COMPONENT_FLAGS fromDate:currentDate];
    components.timeZone = [NSTimeZone defaultTimeZone];
    
    if (maximumYear && components.year > maximumYear.integerValue)
        components.year = maximumYear.integerValue;
    
    _maximumYear = maximumYear;
    [self reloadAllComponents];
    [self setDate:[[NSCalendar currentCalendar] dateFromComponents:components]];
}

-(void)setWrapMonths:(BOOL)wrapMonths
{
    _wrapMonths = wrapMonths; // 一个布尔值,确定包装
    [self reloadAllComponents]; // 刷新所有组件
}

-(int)yearFromRow:(NSUInteger)row
{
    int minYear = DEFAULT_MINIMUM_YEAR;
    
    if (self.minimumYear)
        minYear = self.minimumYear.integerValue;
    
    return row + minYear;
}

-(NSUInteger)rowFromYear:(int)year
{
    int minYear = DEFAULT_MINIMUM_YEAR;
    
    if (self.minimumYear)
        minYear = self.minimumYear.integerValue;
    
    return year - minYear;
}

-(void)setDate:(NSDate *)date
{
    NSDateComponents* components = [[NSCalendar currentCalendar] components:DATE_COMPONENT_FLAGS fromDate:date];
    components.timeZone = [NSTimeZone defaultTimeZone];
    
    if (self.minimumYear && components.year < self.minimumYear.integerValue)
        components.year = self.minimumYear.integerValue;
    else if (self.maximumYear && components.year > self.maximumYear.integerValue)
        components.year = self.maximumYear.integerValue;
    
    if(self.wrapMonths){
        int monthMidpoint = self.monthStrings.count * (MONTH_ROW_MULTIPLIER / 2);
        
        [self selectRow:(components.month - 1 + monthMidpoint) inComponent:self.monthComponent animated:NO];
    }
    else {
        [self selectRow:(components.month - 1) inComponent:self.monthComponent animated:NO];
    }
    [self selectRow:[self rowFromYear:components.year] inComponent:self.yearComponent animated:NO];
    
    _date = [[NSCalendar currentCalendar] dateFromComponents:components];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSDateComponents* components = [[NSDateComponents alloc] init];
    components.month = 1 + ([self selectedRowInComponent:self.monthComponent] % self.monthStrings.count);
    components.year = [self yearFromRow:[self selectedRowInComponent:self.yearComponent]];
    
    [self willChangeValueForKey:@"date"];
    if ([self.monthPickerDelegate respondsToSelector:@selector(monthPickerWillChangeDate:)])
        [self.monthPickerDelegate monthPickerWillChangeDate:self];
    
    _date = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    if ([self.monthPickerDelegate respondsToSelector:@selector(monthPickerDidChangeDate:)])
        [self.monthPickerDelegate monthPickerDidChangeDate:self];
    [self didChangeValueForKey:@"date"];
}

// 选取器如果有多个滚轮，就返回滚轮的数量，我们这里有两个，就返回2
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// 返回给定的组件有多少行数据
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == self.monthComponent && !self.wrapMonths)
        return self.monthStrings.count;
    else if(component == self.monthComponent)
        return MONTH_ROW_MULTIPLIER * self.monthStrings.count;
    
    int maxYear = DEFAULT_MAXIMUM_YEAR;
    if (self.maximumYear)
        maxYear = self.maximumYear.integerValue;
    
    return [self rowFromYear:maxYear] + 1;
}

// 设置每列的宽度
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == self.monthComponent)
    {
        NSLog(@"monthWidth = %f",self.monthWidth);
        return self.monthWidth; // 返回月的宽度（126.0f）
    }
    else
    {
        NSLog(@"yearWidth = %f",self.yearWidth);
        return self.yearWidth; // 返回年的宽度（80.0f）
    }
}

// 替换text居中
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    CGFloat width = [self pickerView:self widthForComponent:component];
    CGRect frame = CGRectMake(0.0f, 0.0f, width, 45.0f);
    
    // 计算frame
    if (component == self.monthComponent)
    {
        const CGFloat padding = 9.0f;
        if (component)
        {
            frame.origin.x += padding;
            frame.size.width -= padding;
        }
        
        frame.size.width -= padding;
    }
    
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    // 判断内容是月，还是年
    if (component == self.monthComponent)
    {
        label.text = [self.monthStrings objectAtIndex:(row % self.monthStrings.count)];
        formatter.dateFormat = @"MM";
//        label.textAlignment = component ? NSTextAlignmentLeft : NSTextAlignmentRight;
        label.textAlignment = NSTextAlignmentCenter;
    } else
    {
        label.text = [NSString stringWithFormat:@"%d", [self yearFromRow:row]];
        label.textAlignment = NSTextAlignmentLeft;
        formatter.dateFormat = @"yyyy";
    }
    
    if (_enableColourRow && [[formatter stringFromDate:[NSDate date]] isEqualToString:label.text])
        label.textColor = [UIColor colorWithRed:0.0f green:0.35f blue:0.91f alpha:1.0f];
    
    label.font = [UIFont boldSystemFontOfSize:18.0f];
    label.backgroundColor = [UIColor clearColor];
    label.shadowOffset = CGSizeMake(0.0f, 0.1f);
    label.shadowColor = [UIColor whiteColor];
    
    return label;
}

@end
