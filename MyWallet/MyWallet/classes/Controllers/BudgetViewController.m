//
//  BudgetViewController.m
//  MyWallet
//
//  Created by apple on 16/7/6.
//  Copyright © 2016年 MorpLCP. All rights reserved.
//

#import "BudgetViewController.h"

@interface BudgetViewController ()<UITextFieldDelegate,CPAlertViewDelegate>


@property (weak, nonatomic) IBOutlet UITextField *dayBudgetTextfield;
@property (weak, nonatomic) IBOutlet UITextField *monthBudgetTextField;

@property (weak, nonatomic) IBOutlet UIButton *baocunBUtton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progress_day;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progress_month;

@property (weak, nonatomic) IBOutlet UIView *view_day;
@property (weak, nonatomic) IBOutlet UIView *view_month;

@end

@implementation BudgetViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"我的预算";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"yszj"] style:UIBarButtonItemStylePlain target:self action:@selector(addBedgetClick)];
    
    self.dayBudgetTextfield.delegate = self;
    self.monthBudgetTextField.delegate = self;
    [self addtextField:self.dayBudgetTextfield];
    [self addtextField:self.monthBudgetTextField];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
    
    self.baocunBUtton.layer.cornerRadius = 5;
    self.baocunBUtton.layer.borderWidth = 1;
    self.baocunBUtton.layer.borderColor = COLOR_RGB(0x454545).CGColor;
    [self.baocunBUtton setTitleColor:COLOR_RGB(0x454545) forState:UIControlStateNormal];
    self.baocunBUtton.backgroundColor = [UIColor clearColor];
    [self.baocunBUtton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Budget_day"]) {
        self.dayBudgetTextfield.text = [NSString stringWithFormat:@"￥%.2f / ￥%.2f",[[[[BillManager manager] getConclusionWithDate:[FinalTools currentDateWithFormat:@"yyyy-MM-dd"]] componentsSeparatedByString:@","].lastObject doubleValue], [[[NSUserDefaults standardUserDefaults] objectForKey:@"Budget_day"] doubleValue]];
        self.monthBudgetTextField.text = [NSString stringWithFormat:@"￥%.2f / ￥%.2f", [[[[BillManager manager] getConclusion_Month_NoBlock] componentsSeparatedByString:@","].lastObject doubleValue] ,[[[NSUserDefaults standardUserDefaults] objectForKey:@"Budget_month"] doubleValue]];
        self.dayBudgetTextfield.enabled = NO;
        self.monthBudgetTextField.enabled = NO;
        self.baocunBUtton.hidden = YES;
    } else {
        self.dayBudgetTextfield.enabled = YES;
        self.monthBudgetTextField.enabled = YES;
        self.baocunBUtton.hidden = NO;
    }
    
}

- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"Budget_day"]) {
        self.progress_day.constant = 0;
        self.progress_month.constant = 0;
        return;
    }
    double outMoney_day = [[[[BillManager manager] getConclusionWithDate:[FinalTools currentDateWithFormat:@"yyyy-MM-dd"]] componentsSeparatedByString:@","].lastObject doubleValue];
    double budgetDay = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Budget_day"] doubleValue];
    if (outMoney_day > budgetDay) {
        self.progress_day.constant = 0;
    } else {
        self.progress_day.constant = self.view_day.frame.size.width * ((budgetDay - outMoney_day) / budgetDay);
    }
    
    double outMoney_month = [[[[BillManager manager] getConclusion_Month_NoBlock] componentsSeparatedByString:@","].lastObject doubleValue];
    double budgetMonth = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Budget_month"] doubleValue];
    if (outMoney_month > budgetMonth) {
        self.progress_month.constant = 0;
    } else {
        self.progress_month.constant = self.view_month.frame.size.width * ((budgetMonth - outMoney_month) / budgetMonth);
    }
    
}

- (void)btnClick:(UIButton *)sender {
    
    if ([self.dayBudgetTextfield.text isEqualToString:@""] || self.dayBudgetTextfield.text == nil) {
        CPAlertView *alert = [[CPAlertView alloc] initWithTitle:@"提示" message:@"请输入日预算" buttons:@"好的", nil];
        [alert show];
        return;
    }
    
    if ([self.monthBudgetTextField.text isEqualToString:@""] || self.monthBudgetTextField.text == nil) {
        CPAlertView *alert = [[CPAlertView alloc] initWithTitle:@"提示" message:@"请输入月预算" buttons:@"好的", nil];
        [alert show];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:self.dayBudgetTextfield.text forKey:@"Budget_day"];
    [[NSUserDefaults standardUserDefaults] setObject:self.monthBudgetTextField.text forKey:@"Budget_month"];
    
    CPAlertView *alert = [[CPAlertView alloc] initWithTitle:@"提示" message:@"恭喜您已经成功设置了预算，距离买房更近了一步！别忘了，不要轻易修改预算哦，管住自己！" buttons:@"好的", nil];
    [alert show];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newBill" object:nil];
    
    self.dayBudgetTextfield.text = [NSString stringWithFormat:@"￥%.2f / ￥%.2f",[[[[BillManager manager] getConclusionWithDate:[FinalTools currentDateWithFormat:@"yyyy-MM-dd"]] componentsSeparatedByString:@","].lastObject doubleValue], [[[NSUserDefaults standardUserDefaults] objectForKey:@"Budget_day"] doubleValue]];
    self.monthBudgetTextField.text = [NSString stringWithFormat:@"￥%.2f / ￥%.2f", [[[[BillManager manager] getConclusion_Month_NoBlock] componentsSeparatedByString:@","].lastObject doubleValue] ,[[[NSUserDefaults standardUserDefaults] objectForKey:@"Budget_month"] doubleValue]];
    
    self.dayBudgetTextfield.enabled = NO;
    self.monthBudgetTextField.enabled = NO;
    self.baocunBUtton.hidden = YES;
    
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (void)addBedgetClick{
    
    CPAlertView *alert = [[CPAlertView alloc] initWithTitle:@"温馨提示" message:@"你确定要放弃曾经的诺言，修改预算吗，本小斯提醒你如果收入没有增加，不要轻易修改预算，还要攒钱买房呢!" buttons:@"我要改", @"手贱了",nil];
    alert.delegate = self;
    [alert show];
    
}

- (void)alertView:(CPAlertView *)alertView buttonIndex:(NSNumber *)btnIndex{
    if ([btnIndex isEqual:@(0)]) {
        
        self.dayBudgetTextfield.text = [NSString stringWithFormat:@"%.2f", [[[NSUserDefaults standardUserDefaults] objectForKey:@"Budget_day"] doubleValue]];
        self.monthBudgetTextField.text = [NSString stringWithFormat:@"%.2f", [[[NSUserDefaults standardUserDefaults] objectForKey:@"Budget_month"] doubleValue]];
        self.dayBudgetTextfield.enabled = YES;
        [self.dayBudgetTextfield becomeFirstResponder];
        self.monthBudgetTextField.enabled = YES;
        self.baocunBUtton.hidden = NO;
    }
}

- (void)addtextField:(UITextField *)textField{
    textField.returnKeyType = UIReturnKeyDone;
    [textField setValue:COLOR_RGB(0xcccccc) forKeyPath:@"_placeholderLabel.textColor"];
    textField.textColor = COLOR_RGB(0x333333);
    textField.tintColor = COLOR_RGB(0xdddddd);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.dayBudgetTextfield resignFirstResponder];
    [self.monthBudgetTextField resignFirstResponder];
    return YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
