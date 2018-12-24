//
//  LLDatePickerToolBar.h
//  DateTools
//
//  Created by LL on 2018/12/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLDatePickerToolBar : UIView
@property (strong, nonatomic) UIButton * cancelBtn;
@property (strong, nonatomic) UIButton * sureBtn;
@property (copy, nonatomic) void(^cancelBlock)(void);
@property (copy, nonatomic) void(^sureBlock)(void);
@end

NS_ASSUME_NONNULL_END
