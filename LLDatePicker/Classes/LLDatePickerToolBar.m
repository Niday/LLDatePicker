//
//  LLDatePickerToolBar.m
//  DateTools
//
//  Created by LL on 2018/12/24.
//

#import "LLDatePickerToolBar.h"

@implementation LLDatePickerToolBar

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:239.0/255.0
                                               green:239.0/255.0
                                                blue:244.0/255.0
                                               alpha:1.0];
        [self addSubview:self.cancelBtn];
        [self addSubview:self.sureBtn];
    }
    return self;
}
    
- (void)cancelAction{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}
    
- (void)sureAction{
    if (self.sureBlock) {
        self.sureBlock();
    }
}
    
- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(10, 0, 50, self.frame.size.height);
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
    
- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.frame = CGRectMake(self.frame.size.width - 60, 0, 50, self.frame.size.height);
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}


@end
