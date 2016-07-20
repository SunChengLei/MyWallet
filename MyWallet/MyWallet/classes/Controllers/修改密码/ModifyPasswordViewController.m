//
//  ModifyPasswordViewController.m
//  MyWallet
//
//  Created by apple on 16/6/27.
//  Copyright © 2016年 MorpLCP. All rights reserved.
//

#import "ModifyPasswordViewController.h"
#import "LockView.h"

@interface ModifyPasswordViewController ()<UITextFieldDelegate, CPAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *wrteView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondPasswordTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewToText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textTop;

@property (weak, nonatomic) IBOutlet UIButton *queDingButton;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_RGB(0x333333);
    self.wrteView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    [self add];
    
}
- (void)add{
    
    self.queDingButton.layer.cornerRadius = 5;
    self.queDingButton.layer.borderWidth = 1;
    self.queDingButton.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8f].CGColor;
    [self.queDingButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.8f] forState:UIControlStateNormal];
    self.queDingButton.backgroundColor = [UIColor clearColor];
    
    self.btnCancel.layer.cornerRadius = 5;
    self.btnCancel.layer.borderWidth = 1;
    self.btnCancel.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8f].CGColor;
    [self.btnCancel setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.8f] forState:UIControlStateNormal];
    self.btnCancel.backgroundColor = [UIColor clearColor];
    
    self.passwordTextField.delegate = self;
    self.firstPasswordTextField.delegate = self;
    self.secondPasswordTextField.delegate = self;
    [self addtextField:self.passwordTextField];
    [self addtextField:self.firstPasswordTextField];
    [self addtextField:self.secondPasswordTextField];
    
}

- (void)viewWillLayoutSubviews{
    if (IsiPhone4) {
        self.viewHeight.constant = 30;
        self.viewToText.constant = 50;
        self.textTop.constant = 154;
    } else if(IsiPhone5) {
        self.viewHeight.constant = 35;
        self.viewToText.constant = 60;
        self.textTop.constant = 154;
    } else{
        self.viewHeight.constant = 40;
        self.viewToText.constant = 70;
        self.textTop.constant = 204;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)addtextField:(UITextField *)textField{
    [textField setValue:COLOR_RGB(0xcccccc) forKeyPath:@"_placeholderLabel.textColor"];
    textField.textColor = COLOR_RGB(0xeeeeee);
    textField.tintColor = COLOR_RGB(0xdddddd);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.passwordTextField resignFirstResponder];
    [self.firstPasswordTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    return YES;
}

#pragma mark =====保存按钮点击事件
- (IBAction)queDingButtonAction:(id)sender {
    if (![StringUtils validateNumber:_passwordTextField.text] || ![StringUtils validateNumber:_firstPasswordTextField.text] || ![StringUtils validateNumber:_secondPasswordTextField.text]) {
        CPAlertView *alert = [[CPAlertView alloc] initWithTitle:@"提示" message:@"请输入数字" delegate:self style:(CPAlertViewStyleDefault) buttons:@"好的", nil];
        [alert show];
        return;
    }
    
    if (_passwordTextField.text == nil || [_passwordTextField.text isEqualToString:@""]) {
        CPAlertView *alert = [[CPAlertView alloc] initWithTitle:@"提示" message:@"请输入原密码" delegate:self style:(CPAlertViewStyleDefault) buttons:@"好的", nil];
        [alert show];
        return;
    }
    
    if (_firstPasswordTextField.text == nil || [_firstPasswordTextField.text isEqualToString:@""] || _secondPasswordTextField.text == nil || [_secondPasswordTextField.text isEqualToString:@""] ) {
        CPAlertView *alert = [[CPAlertView alloc] initWithTitle:@"提示" message:@"请输入一个新密码" delegate:self style:(CPAlertViewStyleDefault) buttons:@"好的", nil];
        [alert show];
        return;
    }
    
    if (![_firstPasswordTextField.text isEqualToString:_secondPasswordTextField.text]) {
        CPAlertView *alert = [[CPAlertView alloc] initWithTitle:@"提示" message:@"两次密码输入不一致" delegate:self style:(CPAlertViewStyleDefault) buttons:@"好的", nil];
        [alert show];
        return;
    }
    
    int result = [[UserManager manager] editPasswordWithOldPwd:self.passwordTextField.text newPwd:_firstPasswordTextField.text];
    if (result == 1) {
        CPAlertView *alert = [[CPAlertView alloc] initWithTitle:@"提示" message:@"原密码输入错误" delegate:self style:(CPAlertViewStyleDefault) buttons:@"好的", nil];
        [alert show];
        return;
    } else if (result == 2){
        CPAlertView *alert = [[CPAlertView alloc] initWithTitle:@"提示" message:@"密码修改成功" delegate:self style:(CPAlertViewStyleDefault) buttons:@"好的", nil];
        alert.tag = 10526;
        [alert show];
        return;
    }
}

- (void)alertView:(CPAlertView *)alertView buttonIndex:(NSNumber *)btnIndex{
    if (alertView.tag == 10526) {
        [self dismissViewControllerAnimated:YES completion:nil];
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Init"] isEqualToString:@"Y"]) {
            [[LockView lock] show];
        }
    }
}

- (IBAction)action2Cancel:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
