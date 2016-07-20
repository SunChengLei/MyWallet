//
//  IndexViewController.m
//  MyWallet
//
//  Created by 美鑫科技 on 16/6/22.
//  Copyright © 2016年 MorpLCP. All rights reserved.
//

#import "IndexViewController.h"
#import "LockView.h"
#import "BillManager.h"
#import "Bill.h"
#import "BalanceOfPaymentsViewController.h"
#import "CPSimpleDrawerView.h"
#import "LeftViewController.h"
#import "DetailViewController.h"
#import "BudgetViewController.h"
#import "InitBudgetView.h"



static NSString *cellIdent = @"cellIdent";

@interface IndexViewController ()<UITableViewDataSource, UITableViewDelegate, CPAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CPSimpleDrawerView *drawView;
@property (nonatomic, strong) UIView *topHeaderView;
@property (nonatomic, strong) UILabel *lblInMoney;
@property (nonatomic, strong) UILabel *lblOutMoney;
@property (nonatomic, strong) UIView *noMoreDataView;

@end

@implementation IndexViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setNavStyle];
    [self initSubViews];
    [self setHeaderView];
    [self seeBudget];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newBill) name:@"newBill" object:nil];
    
}

- (void)setHeaderView{
    
    self.noMoreDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 40)];
    UILabel *lblMsg = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    lblMsg.textAlignment = NSTextAlignmentCenter;
    lblMsg.font = [UIFont systemFontOfSize:13];
    lblMsg.textColor = [UIColor lightGrayColor];
    lblMsg.text = @"暂无收支记录,快去记一笔吧";
    [_noMoreDataView addSubview:lblMsg];
    
    self.topHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 0)];
    self.lblInMoney = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    _lblInMoney.textAlignment = NSTextAlignmentCenter;
    _lblInMoney.font = [UIFont systemFontOfSize:13];
    _lblInMoney.textColor = [UIColor whiteColor];
    [_topHeaderView addSubview:_lblInMoney];
    [self.view addSubview:_topHeaderView];
    
}

// 检查当前收支情况
- (void)checkMoney{
    
    typeof(self)me = self;
    
    NSDictionary *dict = [[BillManager manager] getBillListWithCurrentMonth];
    NSArray *keyArray = dict.allKeys;
    if (keyArray.count > 0) {
        // 当月收支
        [[BillManager manager] getConclusion_Month:^(double inMoney, double outMoney) {
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Budget_month"]) {
                if (outMoney > [[[NSUserDefaults standardUserDefaults] objectForKey:@"Budget_month"] doubleValue]) {
                    me.topHeaderView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.7];
                    me.topHeaderView.frame = CGRectMake(0, 64, ScreenWidth, 30);
                    me.lblInMoney.frame = CGRectMake(0, 0, ScreenWidth, 30);
                    me.lblInMoney.text = [NSString stringWithFormat:@"您当月花费已超出预算￥%.2f", outMoney - [[[NSUserDefaults standardUserDefaults] objectForKey:@"Budget_month"] doubleValue]];
                    me.tableView.frame = CGRectMake(0, 94, ScreenWidth, ScreenHeight - 94);
                } else{
                    // 今日收支
                    [[BillManager manager] getConclusion_Day:^(double inMoney, double outMoney) {
                        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Budget_day"]) {
                            if (outMoney > [[[NSUserDefaults standardUserDefaults] objectForKey:@"Budget_day"] doubleValue]) {
                                me.topHeaderView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.7];
                                me.topHeaderView.frame = CGRectMake(0, 64, ScreenWidth, 30);
                                me.lblInMoney.frame = CGRectMake(0, 0, ScreenWidth, 30);
                                me.lblInMoney.text = [NSString stringWithFormat:@"您今日花费已超出预算￥%.2f", outMoney - [[[NSUserDefaults standardUserDefaults] objectForKey:@"Budget_day"] doubleValue]];
                                me.tableView.frame = CGRectMake(0, 94, ScreenWidth, ScreenHeight - 94);
                            } else{
                                me.topHeaderView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.7];
                                me.topHeaderView.frame = CGRectMake(0, 64, ScreenWidth, 0);
                                me.lblInMoney.frame = CGRectMake(0, 0, ScreenWidth, 0);
                                me.tableView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64);
                            }
                        } else{
                            me.topHeaderView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.7];
                            me.topHeaderView.frame = CGRectMake(0, 64, ScreenWidth, 0);
                            me.lblInMoney.frame = CGRectMake(0, 0, ScreenWidth, 0);
                            me.tableView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64);
                        }
                    }];
                }
            } else{
                me.topHeaderView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.7];
                me.topHeaderView.frame = CGRectMake(0, 64, ScreenWidth, 0);
                me.lblInMoney.frame = CGRectMake(0, 0, ScreenWidth, 0);
                me.tableView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64);
            }
        }];
        
    } else {
        me.topHeaderView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.7];
        me.topHeaderView.frame = CGRectMake(0, 64, ScreenWidth, 0);
        me.lblInMoney.frame = CGRectMake(0, 0, ScreenWidth, 0);
        me.tableView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64);
    }
    
}

// 检查是否已设置预算
- (void)seeBudget{
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"BudgetDate"]) {
        
        CPAlertView *alert = [[CPAlertView alloc] initWithTitle:@"提示" message:@"建议您设置每月的起始日期！快去设置吧！" delegate:self style:(CPAlertViewStyleDefault) buttons:@"暂不设置", @"立即设置", nil];
        alert.tag = 1001;
        [alert show];
        
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"Budget_month"]) {
        
        CPAlertView *alert = [[CPAlertView alloc] initWithTitle:@"提示" message:@"设置预算可以有效控制你的花费哦！快去设置吧！" delegate:self style:(CPAlertViewStyleDefault) buttons:@"暂不设置", @"立即设置", nil];
        alert.tag = 1002;
        [alert show];
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    NSDictionary *dict = [[BillManager manager] getBillListWithCurrentMonth];
    NSArray *keyArray = dict.allKeys;
    if (keyArray.count > 0) {
        [_noMoreDataView removeFromSuperview];
    } else {
        [self.view addSubview:_noMoreDataView];
    }
    [self checkMoney];
    if (self.shouldLock) {
        self.shouldLock = NO;
        [[LockView lock] show];
    }

}

- (void)initSubViews {
    
    
    UIView *topMView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    topMView.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) style:(UITableViewStyleGrouped)];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdent];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:topMView];
    [self.view addSubview:_tableView];
    
    LeftViewController *leftVC = [[LeftViewController alloc] initWithStyle:UITableViewStyleGrouped];
    self.drawView = [[CPSimpleDrawerView alloc] initWithLeftViewController:leftVC];
    UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(openDraw)];
    swip.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swip];
    
}

// 收到新账单通知
- (void)newBill {
    [self.tableView reloadData];
}

- (void)openDraw {
    [_drawView show];
}

// 设置导航条样式
- (void)setNavStyle {
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"xie"] style:(UIBarButtonItemStylePlain) target:self action:@selector(doNewBill)];
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting"] style:(UIBarButtonItemStylePlain) target:self action:@selector(setting)];
    UIBarButtonItem *left2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"lock"] style:(UIBarButtonItemStylePlain) target:self action:@selector(lockScreen)];
    self.navigationItem.leftBarButtonItems = @[left1, left2];
    self.title = @"首页";
    
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSDictionary *dict = [[BillManager manager] getBillListWithCurrentMonth];
    return dict.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dict = [[BillManager manager] getBillListWithCurrentMonth];
    NSArray *keyArray = dict.allKeys;
    NSArray *billArray = dict[keyArray[section]];
    return billArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent forIndexPath:indexPath];
    NSDictionary *dict = [[BillManager manager] getBillListWithCurrentMonth];
    NSArray *keyArray = dict.allKeys;
    NSArray *billArray = dict[keyArray[indexPath.section]];
    Bill *bill = billArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSInteger type = bill.bType;
    
    // 区分今日和其他日期
    if (type == 0) {
        cell.imageView.image = [UIImage imageNamed:@"out"];
        NSString *txt = [NSString stringWithFormat:@"【%@】花费：￥%.2f", bill.bUse, bill.bMoney];
        cell.textLabel.text = txt;
    } else{
        cell.imageView.image = [UIImage imageNamed:@"in"];
        NSString *txt = [NSString stringWithFormat:@"【%@】收入：￥%.2f", bill.bUse, bill.bMoney];
        cell.textLabel.text = txt;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

// 分区头部显示收入、支出总结
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSDictionary *dict = [[BillManager manager] getBillListWithCurrentMonth];
    NSArray *keyArray = dict.allKeys;
    NSString *dateStr = @"";
    if ([keyArray[section] isEqualToString:[FinalTools currentDateWithFormat:@"yyyy-MM-dd"]]) {
        dateStr = @"今天";
    } else {
        dateStr = keyArray[section];
    }
    NSString *tempStr = [[BillManager manager] getConclusionWithDate:keyArray[section]];
    return [NSString stringWithFormat:@"%@ (累计收入：￥%@, 支出：￥%@)", dateStr,  [tempStr componentsSeparatedByString:@","].firstObject, [tempStr componentsSeparatedByString:@","].lastObject];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    UILabel *lblMoney = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    
    // 设置底部视图阴影
    UIImageView *shadowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jianbian"]];
    shadowView.frame = CGRectMake(0, 0, ScreenWidth, 3);
    [footerView addSubview:shadowView];
    
    footerView.backgroundColor = COLOR_RGB(0xdddddd);
    lblMoney.textAlignment = NSTextAlignmentCenter;
    lblMoney.font = [UIFont systemFontOfSize:13];
    lblMoney.textColor = [UIColor darkGrayColor];
    
    NSDictionary *dict = [[BillManager manager] getBillListWithCurrentMonth];
    NSArray *keyArray = dict.allKeys;
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"Budget_day"]) {
        
        NSArray *billArray = dict[keyArray[section]];
        Bill *bill = [billArray lastObject];
        double money = bill.bBalance;
        NSString *moneyStr = @"";
        if ([keyArray[section] isEqualToString:[FinalTools currentDateWithFormat:@"yyyy-MM-dd"]]) {
            moneyStr = [NSString stringWithFormat:@"今日剩余:￥%.2f", money];
        } else {
            moneyStr = [NSString stringWithFormat:@"当日剩余:￥%.2f", money];
        }
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
        if (money >= 0) {
            [attrStr addAttribute:NSForegroundColorAttributeName value:RgbColor(20, 143, 70) range:[moneyStr rangeOfString:[NSString stringWithFormat:@"￥%.2f", money]]];
            [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:[moneyStr rangeOfString:[NSString stringWithFormat:@"￥%.2f", money]]];
            lblMoney.attributedText = attrStr;
        } else {
            [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[moneyStr rangeOfString:[NSString stringWithFormat:@"￥%.2f", money]]];
            [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:[moneyStr rangeOfString:[NSString stringWithFormat:@"￥%.2f", money]]];
            lblMoney.attributedText = attrStr;
        }
        
    } else {
        
        double outMoney_day = [[[[BillManager manager] getConclusionWithDate:keyArray[section]] componentsSeparatedByString:@","].lastObject doubleValue];
        double budgetMoney_day = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Budget_day"] doubleValue];
        double remaining_day = budgetMoney_day - outMoney_day;
        
        double outMoney_month = [[[[BillManager manager] getConclusion_Month_NoBlock] componentsSeparatedByString:@","].lastObject doubleValue];
        double budgetMoney_month = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Budget_month"] doubleValue];
        double remaining_month = budgetMoney_month - outMoney_month;
        
        NSString *moneyStr = @"";
        if ([keyArray[section] isEqualToString:[FinalTools currentDateWithFormat:@"yyyy-MM-dd"]]) {
            moneyStr =  [NSString stringWithFormat:@"今日剩余:￥%.2f 本月剩余:￥%.2f", remaining_day, remaining_month];
        } else {
            moneyStr =  [NSString stringWithFormat:@"当日剩余:￥%.2f 本月剩余:￥%.2f", remaining_day, remaining_month];
        }
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
        
        if (remaining_month > 0 && remaining_day > 0) {
            
            NSString *day_rangeStr = [NSString stringWithFormat:@"￥%.2f", remaining_day];
            NSString *month_rangeStr = [NSString stringWithFormat:@"￥%.2f", remaining_month];
            if ([day_rangeStr isEqualToString:month_rangeStr]) {
                NSRange tempRange = [moneyStr rangeOfString:day_rangeStr];
                NSRange range = NSMakeRange(tempRange.location + tempRange.length + 6, tempRange.length);
                [attrStr addAttribute:NSForegroundColorAttributeName value:RgbColor(20, 143, 70) range:[moneyStr rangeOfString:day_rangeStr]];
                [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:[moneyStr rangeOfString:day_rangeStr]];
                [attrStr addAttribute:NSForegroundColorAttributeName value:RgbColor(20, 143, 70) range:range];
                [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:range];
            } else {
                [attrStr addAttribute:NSForegroundColorAttributeName value:RgbColor(20, 143, 70)  range:[moneyStr rangeOfString:[NSString stringWithFormat:@"￥%.2f", remaining_day]]];
                [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:[moneyStr rangeOfString:[NSString stringWithFormat:@"￥%.2f", remaining_day]]];
                [attrStr addAttribute:NSForegroundColorAttributeName value:RgbColor(20, 143, 70)  range:[moneyStr rangeOfString:[NSString stringWithFormat:@"￥%.2f", remaining_month]]];
                [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:[moneyStr rangeOfString:[NSString stringWithFormat:@"￥%.2f", remaining_month]]];
            }
            lblMoney.attributedText = attrStr;
        } else if (remaining_day > 0 && remaining_month <= 0){
            [attrStr addAttribute:NSForegroundColorAttributeName value:RgbColor(20, 143, 70)  range:[moneyStr rangeOfString:[NSString stringWithFormat:@"￥%.2f", remaining_day]]];
            [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:[moneyStr rangeOfString:[NSString stringWithFormat:@"￥%.2f", remaining_day]]];
            [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[moneyStr rangeOfString:[NSString stringWithFormat:@"￥%.2f", remaining_month]]];
            [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:[moneyStr rangeOfString:[NSString stringWithFormat:@"￥%.2f", remaining_month]]];
            lblMoney.attributedText = attrStr;
        } else if (remaining_day <= 0 && remaining_month > 0){
            [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[moneyStr rangeOfString:[NSString stringWithFormat:@"￥%.2f", remaining_day]]];
            [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:[moneyStr rangeOfString:[NSString stringWithFormat:@"￥%.2f", remaining_day]]];
            [attrStr addAttribute:NSForegroundColorAttributeName value:RgbColor(20, 143, 70)  range:[moneyStr rangeOfString:[NSString stringWithFormat:@"￥%.2f", remaining_month]]];
            [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:[moneyStr rangeOfString:[NSString stringWithFormat:@"￥%.2f", remaining_month]]];
            lblMoney.attributedText = attrStr;
        } else {
            
            NSString *day_rangeStr = [NSString stringWithFormat:@"￥%.2f", remaining_day];
            NSString *month_rangeStr = [NSString stringWithFormat:@"￥%.2f", remaining_month];
            if ([day_rangeStr isEqualToString:month_rangeStr]) {
                NSRange tempRange = [moneyStr rangeOfString:day_rangeStr];
                NSRange range = NSMakeRange(tempRange.location + tempRange.length + 6, tempRange.length);
                [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[moneyStr rangeOfString:day_rangeStr]];
                [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:[moneyStr rangeOfString:day_rangeStr]];
                [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
                [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:range];
                
            } else {
                [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[moneyStr rangeOfString:day_rangeStr]];
                [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:[moneyStr rangeOfString:day_rangeStr]];
                [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[moneyStr rangeOfString:month_rangeStr]];
                [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:[moneyStr rangeOfString:month_rangeStr]];
            }
            
            lblMoney.attributedText = attrStr;
        }
    }
    
    [footerView addSubview:lblMoney];
    return footerView;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = [[BillManager manager] getBillListWithCurrentMonth];
    NSArray *keyArray = dict.allKeys;
    NSArray *billArray = dict[keyArray[indexPath.section]];
    Bill *bill = billArray[indexPath.row];
    DetailViewController *detailVC = [DetailViewController new];
    detailVC.bill = bill;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

#pragma mark -CPAlertViewDelegate

- (void)alertView:(CPAlertView *)alertView buttonIndex:(NSNumber *)btnIndex{
    if (alertView.tag == 1001 && [btnIndex isEqual:@(1)]) {
        InitBudgetView *budgetView = [[InitBudgetView alloc] init];
        [budgetView show];
    } else if (alertView.tag == 1002 && [btnIndex isEqual:@(1)]) {
        BudgetViewController *budget = [[BudgetViewController alloc] init];
        [self.navigationController pushViewController:budget animated:YES];
    }
}

- (void)doNewBill {
    BalanceOfPaymentsViewController *billVC = [BalanceOfPaymentsViewController new];
    [self.navigationController pushViewController:billVC animated:YES];
    
}

- (void)lockScreen {
    [[LockView lock] show];
}

- (void)setting {
    [_drawView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
