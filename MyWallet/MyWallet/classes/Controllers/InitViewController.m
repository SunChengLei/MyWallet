//
//  InitViewController.m
//  MyWallet
//
//  Created by 美鑫科技 on 16/6/22.
//  Copyright © 2016年 MorpLCP. All rights reserved.
//

#import "InitViewController.h"
#import "CPImageSelectView.h"
#import "IndexViewController.h"

@interface InitViewController ()<UITextFieldDelegate, CPAlertViewDelegate>

@property (nonatomic, strong) CPImageSelectView*selectImage;
@property (nonatomic, strong) UITextField *txtMoney;
@property (nonatomic, strong) UITextField *txtNickName;
@property (nonatomic, strong) UITextField *txtPassword;
@property (nonatomic, strong) YSKeyboardMoving *ys;
@end

@implementation InitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_RGB(0x333333);
    [self initSubViews];
}

// 返回状态栏样式
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)initSubViews{
    
    self.selectImage = [[CPImageSelectView alloc] initWithFrame:CGRectMake((ScreenWidth - 100.0f) / 2.0f, 100.0f, 100.0f, 100.0f)];
    [self.view addSubview:_selectImage];
    
    self.txtMoney = [[UITextField alloc] initWithFrame:CGRectMake((ScreenWidth - 250.0f) / 2.0, _selectImage.frame.origin.y + _selectImage.frame.size.height + 50, 250, 20)];
    _txtMoney.layer.borderWidth = 0;
    _txtMoney.placeholder = @"你有多少钱";
    _txtMoney.textAlignment = NSTextAlignmentCenter;
    [_txtMoney setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    [_txtMoney setValue:COLOR_RGB(0xcccccc) forKeyPath:@"_placeholderLabel.textColor"];
    _txtMoney.textColor = COLOR_RGB(0xeeeeee);
    _txtMoney.tintColor = COLOR_RGB(0xdddddd);
    _txtMoney.delegate = self;
    UIImageView *bacImage1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"txt1"]];
    bacImage1.frame = CGRectMake(0, 0, _txtMoney.frame.size.width, _txtMoney.frame.size.height);
    [_txtMoney addSubview:bacImage1];
    [self.view addSubview:_txtMoney];
    
    self.txtNickName = [[UITextField alloc] initWithFrame:CGRectMake((ScreenWidth - 250.0f) / 2.0, _txtMoney.frame.origin.y + _txtMoney.frame.size.height + 40, 250, 20)];
    _txtNickName.layer.borderWidth = 0;
    _txtNickName.delegate = self;
    _txtNickName.placeholder = @"取个霸气的昵称";
    _txtNickName.textAlignment = NSTextAlignmentCenter;
    [_txtNickName setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    [_txtNickName setValue:COLOR_RGB(0xcccccc) forKeyPath:@"_placeholderLabel.textColor"];
    _txtNickName.textColor = COLOR_RGB(0xeeeeee);
    _txtNickName.tintColor = COLOR_RGB(0xdddddd);
    UIImageView *bacImage2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"txt1"]];
    bacImage2.frame = CGRectMake(0, 0, _txtNickName.frame.size.width, _txtNickName.frame.size.height);
    [_txtNickName addSubview:bacImage2];
    [self.view addSubview:_txtNickName];
    
    self.txtPassword = [[UITextField alloc] initWithFrame:CGRectMake((ScreenWidth - 250.0f) / 2.0, _txtNickName.frame.origin.y + _txtNickName.frame.size.height + 40, 250, 20)];
    _txtPassword.layer.borderWidth = 0;
    _txtPassword.delegate = self;
    _txtPassword.placeholder = @"设置你的密码";
    _txtPassword.textAlignment = NSTextAlignmentCenter;
    [_txtPassword setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    [_txtPassword setValue:COLOR_RGB(0xcccccc) forKeyPath:@"_placeholderLabel.textColor"];
    _txtPassword.textColor = COLOR_RGB(0xeeeeee);
    _txtPassword.tintColor = COLOR_RGB(0xdddddd);
    UIImageView *bacImage3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"txt1"]];
    bacImage3.frame = CGRectMake(0, 0, _txtPassword.frame.size.width, _txtPassword.frame.size.height);
    [_txtPassword addSubview:bacImage3];
    [self.view addSubview:_txtPassword];
    
    UIButton *btnStart = [UIButton buttonWithType:UIButtonTypeSystem];
    btnStart.frame = CGRectMake((ScreenWidth - 200) / 2.0, ScreenHeight - 80.0, 200.0, 40);
    btnStart.layer.masksToBounds = YES;
    btnStart.layer.cornerRadius = 5.0f;
    btnStart.layer.borderWidth = 1.0f;
    btnStart.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8f].CGColor;
    [btnStart addTarget:self action:@selector(action2Start) forControlEvents:UIControlEventTouchUpInside];
    [btnStart setTitle:@"提交" forState:UIControlStateNormal];
    [btnStart setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.8f] forState:UIControlStateNormal];
    [self.view addSubview:btnStart];
    
}

- (void)action2Start{
    
    if (![StringUtils validateNumber:_txtMoney.text]) {
        CPAlertView *alert = [[CPAlertView alloc] initWithTitle:@"提示" message:@"请输入数字" delegate:self style:(CPAlertViewStyleDefault) buttons:@"好的", nil];
        [alert show];
        return;
    }
    if (_txtMoney.text == nil || [_txtMoney.text isEqualToString:@""]) {
        CPAlertView *alert = [[CPAlertView alloc] initWithTitle:@"提示" message:@"请输入金额" delegate:self style:(CPAlertViewStyleDefault) buttons:@"好的", nil];
        [alert show];
        return;
    }
    if (_txtNickName.text == nil || [_txtNickName.text isEqualToString:@""]) {
        CPAlertView *alert = [[CPAlertView alloc] initWithTitle:@"提示" message:@"请输入昵称" delegate:self style:(CPAlertViewStyleDefault) buttons:@"好的", nil];
        [alert show];
        return;
    }
    if (_txtPassword.text == nil || [_txtPassword.text isEqualToString:@""]){
        CPAlertView *alert = [[CPAlertView alloc] initWithTitle:@"提示" message:@"请输入密码" delegate:self style:(CPAlertViewStyleDefault) buttons:@"好的", nil];
        [alert show];
        return;
    }
    if ([[UserManager manager] addUserWithNickName:_txtNickName.text UPwd:_txtPassword.text Money:[_txtMoney.text doubleValue] HeaderPicture:self.selectImage.image]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"Y" forKey:@"Init"];
        [[NSUserDefaults standardUserDefaults] setObject:_txtMoney.text forKey:@"Money"];
        [[NSUserDefaults standardUserDefaults] setObject:_txtNickName.text forKey:@"uName"];
        CPAlertView *alert = [[CPAlertView alloc] initWithTitle:@"提示" message:@"初始化成功!" delegate:self style:(CPAlertViewStyleDefault) buttons:@"好的", nil];
        alert.tag = 10086;
        [alert show];
    }
}

#pragma mark -CPAlertViewDelegate

- (void)alertView:(CPAlertView *)alertView buttonIndex:(NSNumber *)btnIndex{
    if (alertView.tag == 10086 && [btnIndex isEqual:@(0)]) {
        IndexViewController *indexVC = [IndexViewController new];
        indexVC.shouldLock = NO;
        InitViewController *initVC = (InitViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        [initVC removeFromParentViewController];
        initVC = nil;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:indexVC];
        [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
     self.ys = [[YSKeyboardMoving alloc] init];
    [self.ys addObserverAndGesture];
}
#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _txtMoney) {
        [_txtNickName becomeFirstResponder];
    } else if (textField == _txtNickName){
        [_txtPassword becomeFirstResponder];
    } else if (textField == _txtPassword){
        [_txtPassword resignFirstResponder];
    }
    [self.ys removeObserverAndGesture];
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
