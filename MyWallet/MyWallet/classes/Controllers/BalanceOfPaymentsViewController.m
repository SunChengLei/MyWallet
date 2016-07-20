//
//  jizhangViewController.m
//  MyWallet
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 MorpLCP. All rights reserved.
//

#import "BalanceOfPaymentsViewController.h"

@interface BalanceOfPaymentsViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,CPAlertViewDelegate,UITextFieldDelegate>
{
    
    NSInteger buttonInteger;
}


@property (weak, nonatomic) IBOutlet UIButton *categoryButton;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *pick;
@property (weak, nonatomic) IBOutlet UIButton *baocunBUtton;
@property (weak, nonatomic) IBOutlet UIView *beijingView;

@property (weak, nonatomic) IBOutlet UIButton *btnIncom;

@property (weak, nonatomic) IBOutlet UIButton *btnOut;

//备注
@property (weak, nonatomic) IBOutlet UITextField *remarksTextfield;

@property(nonatomic, strong)NSArray *shouruArray;
@property(nonatomic, strong)NSArray *zhifuArray;

@end

@implementation BalanceOfPaymentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baocunBUtton.layer.cornerRadius = 5;
    self.baocunBUtton.layer.borderWidth = 1;
    self.baocunBUtton.layer.borderColor = COLOR_RGB(0x454545).CGColor;
    [self.baocunBUtton setTitleColor:COLOR_RGB(0x454545) forState:UIControlStateNormal];
    self.baocunBUtton.backgroundColor = [UIColor clearColor];
    self.beijingView.hidden = YES;
    self.beijingView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    self.shouruArray = @[@"发工资啦",@"ta还钱啦",@"收红包",@"其他"];
    self.zhifuArray = @[@"早饭", @"午饭", @"晚饭", @"房租",@"交通",@"通讯",@"娱乐",@"购物",@"发红包",@"外借", @"还钱", @"随份子",@"其他"];
    [self addtextField:self.moneyTextField];
    [self addtextField:self.remarksTextfield];
    [self incomeButtonAction:self.btnIncom];
    self.title = @"随手记";

}
- (void)addtextField:(UITextField *)textField{
    
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyDone;
    [textField setValue:COLOR_RGB(0xcccccc) forKeyPath:@"_placeholderLabel.textColor"];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.moneyTextField) {
        if (![StringUtils validateNumber:_moneyTextField.text]) {
            CPAlertView *alert = [[CPAlertView alloc] initWithTitle:@"提示" message:@"请输入数字" delegate:self style:(CPAlertViewStyleDefault) buttons:@"好的", nil];
            [alert show];
        } else {
            return YES;
        }
    } else {
        return YES;
    }
    return YES;
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == self.moneyTextField && SCREEN_WIDTH == 320 ) {
        self.view.frame = CGRectMake(0, -20, SCREEN_WIDTH, ScreenHeight);
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.moneyTextField resignFirstResponder];
    [self.remarksTextfield resignFirstResponder];
    if (textField == self.moneyTextField && SCREEN_WIDTH == 320) {
        self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, ScreenHeight);
    }
    return YES;
    
}


#pragma mark =========收入按钮点击事件
- (IBAction)incomeButtonAction:(id)sender {
    [_categoryButton setTitle:@"请选择" forState:UIControlStateNormal];
    self.btnIncom.backgroundColor = [UIColor darkGrayColor];
    [self.btnIncom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btnOut.backgroundColor = [UIColor whiteColor];
    [self.btnOut setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    buttonInteger = 1;
}

#pragma mark =========支出按钮点击事件
- (IBAction)expenditureButtonAction:(id)sender {
    [_categoryButton setTitle:@"请选择" forState:UIControlStateNormal];
    self.btnIncom.backgroundColor = [UIColor whiteColor];
    [self.btnIncom setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.btnOut.backgroundColor = [UIColor darkGrayColor];
    [self.btnOut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttonInteger = 0;
}

#pragma mark =========分类按钮点击事件
- (IBAction)categoryButtonAction:(id)sender {
    if (buttonInteger == 1) {
        [_categoryButton setTitle:self.shouruArray[0] forState:UIControlStateNormal];
    } else{
        [_categoryButton setTitle:self.zhifuArray[0] forState:UIControlStateNormal];
    }
    self.beijingView.hidden = NO;
    [self.pick reloadAllComponents];
    
}

#pragma mark =========pick取消按钮
- (IBAction)pickQuxiaoButtonAction:(id)sender {
    self.beijingView.hidden = YES;
    [_categoryButton setTitle:@"请选择" forState:UIControlStateNormal];
}

#pragma mark =========pick确定按钮
- (IBAction)pickQueDingButtonAction:(id)sender {
    self.beijingView.hidden = YES;
}

#pragma mark =========保存按钮
- (IBAction)baoCunButton:(id)sender {
    
    if ([self.categoryButton.titleLabel.text isEqualToString:@"请选择"]) {
        CPAlertView *alert = [[CPAlertView alloc] initWithTitle:@"提示" message:@"请选择一个类别" delegate:self style:(CPAlertViewStyleDefault) buttons:@"好的", nil];
        [alert show];
        return;
    }
    
    if ([self.moneyTextField.text isEqualToString:@""]) {
        
        CPAlertView *alert = [[CPAlertView alloc] initWithTitle:@"提示" message:@"请输入金额" delegate:self style:(CPAlertViewStyleDefault) buttons:@"好的", nil];
        [alert show];
        
        return;
    }
    
    Bill *bill = [Bill new];
    bill.bType = buttonInteger;
    bill.bUse = self.categoryButton.titleLabel.text;
    bill.bMoney = [self.moneyTextField.text doubleValue];
    if (bill.bType == 0) {
        bill.bBalance = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Money"] doubleValue] - bill.bMoney;
    } else{
        bill.bBalance = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Money"] doubleValue] + bill.bMoney;
    }
    bill.bCreatDate = [FinalTools currentDateWithFormat:@"yyyy-MM-dd"];
    if ([self.remarksTextfield.text isEqualToString:@""] || self.remarksTextfield.text == nil) {
        bill.bDes = @"无";
    } else{
        bill.bDes = self.remarksTextfield.text;
    }
    if ([[BillManager manager] addNewBill:bill]) {
        [[NSUserDefaults standardUserDefaults] setObject:@(bill.bBalance) forKey:@"Money"];
        CPAlertView *alert = [[CPAlertView alloc] initWithTitle:@"提示" message:@"记录成功！" delegate:self style:(CPAlertViewStyleDefault) buttons:@"好的", nil];
        alert.tag = 15926;
        [alert show];
    } else{
        CPAlertView *alert = [[CPAlertView alloc] initWithTitle:@"提示" message:@"未知错误" delegate:self style:(CPAlertViewStyleDefault) buttons:@"好的", nil];
        [alert show];
    }
    
}

#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (buttonInteger == 1) {
        return self.shouruArray.count;
    }else{
        
        return self.zhifuArray.count;
    }
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (buttonInteger == 1) {
        return self.shouruArray[row];
    }else{
        
        return self.zhifuArray[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (buttonInteger == 1) {
        [_categoryButton setTitle:self.shouruArray[row] forState:UIControlStateNormal];
    }else{
        [_categoryButton setTitle:self.zhifuArray[row] forState:UIControlStateNormal];
    }
    
}

- (void)alertView:(CPAlertView *)alertView buttonIndex:(NSNumber *)btnIndex{
    if (alertView.tag == 15926 && [btnIndex isEqual:@(0)]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadDrawData" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newBill" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
