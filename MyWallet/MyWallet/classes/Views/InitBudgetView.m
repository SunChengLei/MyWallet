//
//  InitBudgetView.m
//  MyWallet
//
//  Created by 美鑫科技 on 16/7/7.
//  Copyright © 2016年 MorpLCP. All rights reserved.
//

#import "InitBudgetView.h"

@interface InitBudgetView () <CPAlertViewDelegate>

@property (nonatomic, strong) UITextField *txtDate;

@end

@implementation InitBudgetView

- (instancetype)init{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 80, 120)];
        centerView.center = CGPointMake(ScreenWidth / 2.0, ScreenHeight / 2.0);
        centerView.layer.masksToBounds = YES;
        centerView.layer.cornerRadius = 3;
        centerView.backgroundColor = [UIColor whiteColor];
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, centerView.frame.size.width, 40)];
        lblTitle.textAlignment = NSTextAlignmentCenter;
        lblTitle.font = [UIFont systemFontOfSize:20];
        lblTitle.text = @"设置起始日期";
        [centerView addSubview:lblTitle];
        
        self.txtDate = [[UITextField alloc] initWithFrame:CGRectMake(10, lblTitle.frame.size.height, centerView.frame.size.width - 20, 40)];
        _txtDate.placeholder = @"请输入起始日期，请务必设置到28号之前";
        _txtDate.textAlignment = NSTextAlignmentCenter;
        [_txtDate becomeFirstResponder];
        [centerView addSubview:_txtDate];
        
        UIButton *btnSubmit = [UIButton buttonWithType:(UIButtonTypeSystem)];
        btnSubmit.frame = CGRectMake((centerView.frame.size.width - centerView.frame.size.width / 2.0) / 2.0, _txtDate.frame.origin.y + _txtDate.frame.size.height + 5, centerView.frame.size.width / 2.0, 30);
        [btnSubmit setBackgroundColor:[UIColor darkGrayColor]];
        [btnSubmit setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [btnSubmit addTarget:self action:@selector(btnClick) forControlEvents:(UIControlEventTouchUpInside)];
        [btnSubmit  setTitle:@"提交" forState:(UIControlStateNormal)];
        [centerView addSubview:btnSubmit];
        
        [self addSubview:centerView];
        
    }
    return self;
}

- (void)btnClick{
    
    if (_txtDate.text == nil || [_txtDate.text isEqualToString:@""]) {
        CPAlertView *alert = [[CPAlertView alloc] initWithTitle:@"提示" message:@"放弃设置起始日期？" delegate:self style:(CPAlertViewStyleDefault) buttons:@"以后再说", @"继续设置", nil];
        alert.tag = 10050;
        [alert show];
        return;
    }
    
    if (![StringUtils validateNumber:_txtDate.text]) {
        CPAlertView *alert = [[CPAlertView alloc] initWithTitle:@"提示" message:@"请输入数字" buttons:@"好的", nil];
        [alert show];
        return;
    }
    if ([_txtDate.text integerValue] >= 29 || [_txtDate.text integerValue] <= 0) {
        CPAlertView *alert = [[CPAlertView alloc] initWithTitle:@"提示" message:@"请输入0 - 29之间的数字" buttons:@"好的", nil];
        [alert show];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@([_txtDate.text integerValue]) forKey:@"BudgetDate"];
    
    [self dismiss];
    
}

- (void)alertView:(CPAlertView *)alertView buttonIndex:(NSNumber *)btnIndex{
    if (alertView.tag == 10050) {
        if ([btnIndex isEqual:@(0)]) {
            [self dismiss];
        } else {
            [_txtDate becomeFirstResponder];
        }
    }
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)dismiss {
    [self removeFromSuperview];
}

@end
