//
//  LockView.m
//  MyWallet
//
//  Created by 美鑫科技 on 16/6/27.
//  Copyright © 2016年 MorpLCP. All rights reserved.
//

#import "LockView.h"
#import "IndexViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface LockView ()<UITextFieldDelegate, CPAlertViewDelegate>

@property (nonatomic, strong) UITextField *txtPassword;
@property (nonatomic, strong) LAContext *ctx;

@end

@implementation LockView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.txtPassword = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 250, 20)];
        _txtPassword.center = CGPointMake(ScreenWidth / 2.0, ScreenHeight / 2.0);
        _txtPassword.layer.borderWidth = 0;
        _txtPassword.delegate = self;
        _txtPassword.placeholder = @"输入您的密码";
        _txtPassword.textAlignment = NSTextAlignmentCenter;
        [_txtPassword setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
        [_txtPassword setValue:COLOR_RGB(0xcccccc) forKeyPath:@"_placeholderLabel.textColor"];
        _txtPassword.textColor = COLOR_RGB(0xeeeeee);
        _txtPassword.tintColor = COLOR_RGB(0xdddddd);
        UIImageView *bacImage3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"txt1"]];
        bacImage3.frame = CGRectMake(0, 0, _txtPassword.frame.size.width, _txtPassword.frame.size.height);
        [_txtPassword addSubview:bacImage3];
        [self addSubview:_txtPassword];
    }
    return self;
}

- (void)loginWithBiometrics{

        [_ctx evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"轻触Home键进行识别" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self dismiss];
                });
            } else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
            }
        }];
   
}

static LockView *lockView = nil;

+ (instancetype)lock{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lockView = [LockView new];
    });
    [lockView checkBiometrics];
    return lockView;
}

- (void)checkBiometrics{
    
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {} else{
        
        self.ctx = [LAContext new];
        if ([_ctx canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:NULL]) {
            UILabel *lblHuo = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth - 40) / 2.0, _txtPassword.frame.origin.y + _txtPassword.frame.size.height + 10, 40, 20)];
            lblHuo.textAlignment = NSTextAlignmentCenter;
            lblHuo.textColor = COLOR_RGB(0xeeeeee);
            lblHuo.text = @"或";
            lblHuo.font = [UIFont systemFontOfSize:13];
            [self addSubview:lblHuo];
            UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zw"]];
            image.frame = CGRectMake((ScreenWidth - 64) / 2.0, lblHuo.frame.origin.y + lblHuo.frame.size.height + 10, 64, 64);
            image.userInteractionEnabled = YES;
            [self addSubview:image];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginWithBiometrics)];
            [image addGestureRecognizer:tap];
            
        }
    }
    
}

- (void)action2Login{
    if ([[UserManager manager] loginWithPwd:_txtPassword.text]) {
        [self dismiss];
    } else{
        CPAlertView *alert = [[CPAlertView alloc] initWithTitle:@"提示" message:@"密码错误" delegate:self style:(CPAlertViewStyleDefault) buttons:@"好的", nil];
        [alert show];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_txtPassword resignFirstResponder];
    [self action2Login];
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)show{
    if (self.isShow) {
        return;
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = COLOR_RGB(0x333333);
    }];
    [window addSubview:self];
    self.isShow = YES;
}

- (void)dismiss{
    
    if (self.ctx) {
        _ctx = nil;
    }
    self.txtPassword.text = @"";
    [UIView animateWithDuration:1 animations:^{
        self.backgroundColor = [UIColor clearColor];
    }];
    [self removeFromSuperview];
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    window.userInteractionEnabled = YES;
    self.isShow = NO;
}

@end
