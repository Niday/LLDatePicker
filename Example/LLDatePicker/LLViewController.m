//
//  LLViewController.m
//  LLDatePicker
//
//  Created by 1833900456@qq.com on 12/23/2018.
//  Copyright (c) 2018 1833900456@qq.com. All rights reserved.
//

#import "LLViewController.h"
#import "LLDatePickerViewController.h"
#import "NSDate+DateTools.h"

@interface LLViewController ()

@end

@implementation LLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)yyyyMM:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    
    LLDatePickerViewController *picker = [[LLDatePickerViewController alloc]init];
    picker.datePickerMode = LLDatePickerModeYearAndMonth;
    picker.clickDismiss = YES;
    picker.date = [NSDate dateWithYear:2018 month:12 day:0];
    picker.maximumDate = [NSDate dateWithYear:2019 month:2 day:1];
    picker.selectedDate = ^(NSDateComponents *components) {
        NSString *str = [NSString stringWithFormat:@"%04ld%02ld",components.year,components.month];
        [btn setTitle:str forState:UIControlStateNormal];
    };
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)yyyyMMdd:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    LLDatePickerViewController *picker = [[LLDatePickerViewController alloc]init];
    picker.datePickerMode = LLDatePickerModeYearAndDate;
    picker.clickDismiss = YES;
    picker.date = [NSDate dateWithYear:2018 month:12 day:22];
    picker.maximumDate = [NSDate dateWithYear:2019 month:12 day:22];
    picker.minimumDate = [NSDate dateWithYear:2017 month:12 day:22];
    picker.selectedDate = ^(NSDateComponents *components) {
        NSString *str = [NSString stringWithFormat:@"%04ld%02ld%02ld",components.year,components.month,components.day];
        [btn setTitle:str forState:UIControlStateNormal];
    };
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
