//
//  LLDatePickerViewController.h
//  LLDatePicker
//
//  Created by LL on 2018/12/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LLDatePickerMode) {
    LLDatePickerModeYearAndMonth,      // yyyy-MM
    LLDatePickerModeYearAndDate        // yyyy-MM-dd
};

//MARK:PickerView
@interface LLDatePickerViewController : UIViewController

@property (assign, nonatomic) LLDatePickerMode datePickerMode;
// 当前选中的时间
@property (strong, nonatomic) NSDate *date;
// 最小可选择时间
@property (strong, nonatomic) NSDate *minimumDate;
// 最大可选择时间
@property (strong, nonatomic) NSDate *maximumDate;
// 开始年份，默认1901
@property (assign, nonatomic) NSInteger startYear;
// 结束年份，默认2099
@property (assign, nonatomic) NSInteger endYear;
// 点击蒙版是否关闭
@property (assign, nonatomic) BOOL clickDismiss;
// ToolBar取消文字颜色
@property (strong, nonatomic) UIColor *cancelTextColor;
// ToolBar确认字体颜色
@property (strong, nonatomic) UIColor *sureTextColor;
// 超出最大或最小区间后文字颜色
@property (strong, nonatomic) UIColor *disableColor;
// 安全区内文字颜色
@property (strong, nonatomic) UIColor *ableColor;
// ToolBar 取消文案
@property (copy, nonatomic) NSString *cancelText;
// ToolBar 确认文案
@property (copy, nonatomic) NSString *sureText;
// ToolBar 文案字号
@property (strong, nonatomic) UIFont *toolBarFont;
// 选中时间回调  yyyyMM/yyyyMMdd
@property (copy, nonatomic) void(^selectedDate)(NSDateComponents *components);
@end

NS_ASSUME_NONNULL_END
