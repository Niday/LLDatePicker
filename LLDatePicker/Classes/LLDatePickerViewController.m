//
//  LLDatePickerViewController.m
//  LLDatePicker
//
//  Created by LL on 2018/12/24.
//

#import "LLDatePickerViewController.h"
#import "LLDatePickerToolBar.h"
#import "LLDatePickerModel.h"
#import "NSDate+DateTools.h"


#define LLScreenWidth   ([UIScreen mainScreen].bounds).size.width
#define LLScreenHeight  ([UIScreen mainScreen].bounds).size.height

@interface LLDatePickerViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) LLDatePickerModel *currentDate;
@property (strong, nonatomic) LLDatePickerToolBar *datePickerToolBar;
// 当前月份天数
@property (assign, nonatomic) NSInteger monthDays;
@property (strong, nonatomic) UIView *backView;

@end

@implementation LLDatePickerViewController
    
- (instancetype)init{
    self = [super init];
    if (self) {
        
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.currentDate = [[LLDatePickerModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 默认开始/结束年份
    self.startYear   = 1900;
    self.endYear     = 2099;
    
    [self.view addSubview:self.backView];
    
    if (self.clickDismiss) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissView)];
        [self.backView addGestureRecognizer:tap];
    }
    
    // ToolBar
    __weak typeof(self) weakSelf = self;
    self.datePickerToolBar = [[LLDatePickerToolBar alloc]initWithFrame:CGRectMake(0, LLScreenHeight - 260, LLScreenWidth, 44)];
    self.datePickerToolBar.cancelBlock = ^{
        [weakSelf dismissView];
    };
    self.datePickerToolBar.sureBlock = ^{
        if (weakSelf.selectedDate) {
           NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate dateWithYear:weakSelf.currentDate.year month:weakSelf.currentDate.month day:weakSelf.currentDate.day]];
            weakSelf.selectedDate(components);
            [weakSelf dismissView];
        }
    };
    [self.backView addSubview:self.datePickerToolBar];
    
    // UIPickerView
    self.pickerView  = [[UIPickerView alloc]init];
    self.pickerView.frame = CGRectMake(0,  LLScreenHeight - 216, LLScreenWidth, 216);
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self.backView addSubview:self.pickerView];
    
    self.currentDate = [self pickerModelWithDate:self.date];
    [self selectDate:self.currentDate];
    
    
    
    if (self.cancelTextColor) {
        [self.datePickerToolBar.cancelBtn setTitleColor:self.cancelTextColor forState:UIControlStateNormal];
    }
    if (self.sureTextColor) {
        [self.datePickerToolBar.sureBtn setTitleColor:self.sureTextColor forState:UIControlStateNormal];
    }
    if (self.cancelText && self.cancelText.length > 0) {
        [self.datePickerToolBar.cancelBtn setTitle:self.cancelText forState:UIControlStateNormal];
        
    }
    if (self.sureText && self.sureText.length > 0) {
        [self.datePickerToolBar.sureBtn setTitle:self.sureText forState:UIControlStateNormal];
    }
    if (self.toolBarFont) {
        [self.datePickerToolBar.cancelBtn.titleLabel setFont:self.toolBarFont];
        [self.datePickerToolBar.sureBtn.titleLabel setFont:self.toolBarFont];
    }
}
    
- (void)dismissView{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
    
- (void)selectDate:(LLDatePickerModel *)model{
    
    NSInteger yearIndex    = model.year-self.startYear-1;
    NSInteger monthIndex   = model.month-1;
    NSInteger dayIndex     = model.day-1;
    
    if (self.datePickerMode == LLDatePickerModeYearAndMonth) {
        [self.pickerView selectRow:yearIndex inComponent:0 animated:YES];
        [self.pickerView selectRow:monthIndex inComponent:1 animated:YES];
    }
    
    if (self.datePickerMode == LLDatePickerModeYearAndDate) {
        [self monthRefresh:2];
        [self.pickerView selectRow:yearIndex inComponent:0 animated:YES];
        [self.pickerView selectRow:monthIndex inComponent:1 animated:YES];
        [self.pickerView selectRow:dayIndex inComponent:2 animated:YES];
    }
}
    
// 刷新当前月份天数
- (void)monthRefresh:(NSInteger)index{
    
    [self calculateMonthDays:self.currentDate];
    [self.pickerView reloadComponent:index];
}
    
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    if (self.datePickerMode == LLDatePickerModeYearAndMonth) {
        return 2;
    }
    if (self.datePickerMode == LLDatePickerModeYearAndDate) {
        return 3;
    }
    return 0;
}
    
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {
        return self.endYear - self.startYear;
    }
    if (component == 1) {
        return 12;
    }
    if (component == 2) {
        return self.monthDays;
    }
    return 0;
}
    
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *label = nil;
    if ([view isKindOfClass:[UILabel class]]) {
        label = (UILabel *)view;
    }
    if (!label) {
        label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
    }
    
    UIColor *textColor = self.ableColor ? self.ableColor : [UIColor blackColor];
    if (component == 0) {
        if (self.minimumDate && row + 1 < self.minimumDate.year - self.startYear) {
            textColor = self.disableColor ? self.disableColor : [UIColor grayColor];
        }
        if (self.maximumDate && row + 1 > self.maximumDate.year - self.startYear) {
            textColor = self.disableColor ? self.disableColor : [UIColor grayColor];
        }
        if (self.minimumDate && self.maximumDate && self.minimumDate.year == self.maximumDate.year) {
            if (row + 1 == self.minimumDate.year - self.startYear) {
                textColor = self.ableColor ? self.ableColor : [UIColor blackColor];
            }
        }
    }
    
    if (component == 1) {
        NSInteger yearRow = [pickerView selectedRowInComponent:0];
        if (self.minimumDate &&
            yearRow + 1 == self.minimumDate.year - self.startYear &&
            row + 1 < self.minimumDate.month) {
            textColor = self.disableColor ? self.disableColor : [UIColor grayColor];
        }
        if (self.maximumDate &&
            yearRow + 1 == self.maximumDate.year - self.startYear &&
            row + 1 > self.maximumDate.month) {
            textColor = self.disableColor ? self.disableColor : [UIColor grayColor];
        }
        if (self.minimumDate &&
            self.maximumDate &&
            self.minimumDate.year == self.maximumDate.year &&
            self.minimumDate.month == self.maximumDate.month) {
            if (row + 1 == self.minimumDate.month) {
                textColor = self.ableColor ? self.ableColor : [UIColor blackColor];
            }
        }
    }
    
    if (component == 2) {
        NSInteger yearRow  = [pickerView selectedRowInComponent:0];
        NSInteger monthRow = [pickerView selectedRowInComponent:1];
        if (self.minimumDate &&
            yearRow + 1 == self.minimumDate.year - self.startYear &&
            monthRow + 1 == self.minimumDate.month &&
            row + 1 < self.minimumDate.day) {
            textColor = self.disableColor ? self.disableColor : [UIColor grayColor];
        }
        if (self.maximumDate &&
            yearRow + 1 == self.maximumDate.year - self.startYear &&
            monthRow + 1 == self.maximumDate.month &&
            row + 1 >  self.maximumDate.day) {
            textColor = self.disableColor ? self.disableColor : [UIColor grayColor];
        }
        if (self.minimumDate &&
            self.maximumDate &&
            self.minimumDate.year == self.maximumDate.year &&
            self.minimumDate.month == self.maximumDate.month &&
            self.minimumDate.day == self.maximumDate.day) {
            if (row + 1 == self.minimumDate.day) {
                textColor = self.ableColor ? self.ableColor : [UIColor blackColor];
            }
        }
    }
    
    label.textColor = textColor;
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return label;
}
    
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (component == 0) {
        return [NSString stringWithFormat:@"%ld年",(long)self.startYear + row + 1];
    }
    if (component == 1) {
        return [NSString stringWithFormat:@"%ld月",row + 1];
    }
    if (component == 2) {
        return [NSString stringWithFormat:@"%ld日",row + 1];
    }
    return @"";
}
    
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0) {
        self.currentDate.year = self.startYear + row + 1;
        // 刷新月份
        [pickerView reloadComponent:1];
    }
    if (component == 1) {
        self.currentDate.month = row + 1;
    }
    if (component == 2) {
        self.currentDate.day = row + 1;
    }
    
    // 刷新月份天数
    if (self.datePickerMode == LLDatePickerModeYearAndDate && (component == 0 || component == 1)) {
        [self monthRefresh:2];
    }
    
    NSDate *date = [NSDate dateWithYear:self.currentDate.year month:self.currentDate.month day:self.currentDate.day];
    if (self.minimumDate) {
        NSComparisonResult result = [[NSCalendar currentCalendar] compareDate:self.minimumDate toDate:date toUnitGranularity:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay];
        if (result == NSOrderedDescending) {
            self.currentDate = [self pickerModelWithDate:self.minimumDate];
            [self selectDate:self.currentDate];
        }
    }
    
    if (self.maximumDate) {
        NSComparisonResult result = [[NSCalendar currentCalendar] compareDate:self.maximumDate toDate:date toUnitGranularity:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay];
        if (result == NSOrderedAscending) {
            self.currentDate = [self pickerModelWithDate:self.maximumDate];
            [self selectDate:self.currentDate];
        }
    }
}
    
//MARK:NSDate 转 LLDatePickerModel
- (LLDatePickerModel *)pickerModelWithDate:(NSDate *)date{
    
    LLDatePickerModel *model = [[LLDatePickerModel alloc]init];
    model.year  = date.year;
    model.month = date.month;
    model.day   = date.day;
    return model;
}

//MARK:判断是否是闰年
- (BOOL)isLeapYear:(NSInteger)year{
    
    if (year % 100 == 0) {
        if (year % 400 == 0) {return YES;} else {return NO;}
    } else {
        if (year % 4 == 0) {return YES;} else {return NO;}
    }
}

//MARK:计算月份天数
- (void)calculateMonthDays:(LLDatePickerModel *)model{
    
    if([@[@1,@3,@5,@7,@8,@10,@12] containsObject:@(model.month)]){
        self.monthDays = 32;
        return;
    }else if ([@[@4,@6,@9,@11] containsObject:@(model.month)]){
        self.monthDays = 30;
        return;
    }
    if([self isLeapYear:model.year]){
        self.monthDays = 29;
        return;
    }
    self.monthDays = 28;
}
    
//MARK:LAZY
- (UIView *)backView{
    
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:self.view.bounds];
    }
    return _backView;
}

@end
