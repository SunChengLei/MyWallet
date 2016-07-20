//
//  LeftViewController.m
//  MyWallet
//
//  Created by 美鑫科技 on 16/6/27.
//  Copyright © 2016年 MorpLCP. All rights reserved.
//

#import "LeftViewController.h"
#import "ModifyPasswordViewController.h"
#import "CPSimpleDrawerView.h"
#import "InitViewController.h"
#import "UserInfoViewController.h"
#import "BudgetViewController.h"

static NSString *leftCell = @"leftCell";
@interface LeftViewController ()<CPAlertViewDelegate>

@property (nonatomic, strong) NSArray *menuArray;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:leftCell];
    self.tableView.bounces = NO;
    [self setHeaderView];
}

- (void)setHeaderView{
    
    DrawHeaderView *header = [[DrawHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180)];
    [header effect];
    self.tableView.tableHeaderView = header;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.menuArray.count;
    } else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:leftCell forIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"xgmm"];
        } else if (indexPath.row == 1) {
            cell.imageView.image = [UIImage imageNamed:@"bjzl"];
        } else if (indexPath.row == 2){
            cell.imageView.image = [UIImage imageNamed:@"ys"];
        }
        cell.textLabel.text = self.menuArray[indexPath.row];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else{
        cell.imageView.image = [UIImage imageNamed:@""];
        cell.textLabel.text = @"注销登录";
        cell.textLabel.textColor = [UIColor redColor];
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    } else{
        return 20;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        if ([[FinalTools getCurrentVC] isKindOfClass:[UINavigationController class]]) {
            [(CPSimpleDrawerView *)[self.view superview] dismiss];
            ModifyPasswordViewController *password = [[ModifyPasswordViewController alloc] init];
            [(UINavigationController *) [FinalTools getCurrentVC] presentViewController:password animated:YES completion:nil];
        }
    } else if (indexPath.section == 0 && indexPath.row == 1){
        if ([[FinalTools getCurrentVC] isKindOfClass:[UINavigationController class]]) {
            [(CPSimpleDrawerView *)[self.view superview] dismiss];
            UserInfoViewController *userInfo = [[UserInfoViewController alloc] init];
            [(UINavigationController *) [FinalTools getCurrentVC] pushViewController:userInfo animated:YES];
        }
    } else if (indexPath.section == 0 && indexPath.row == 2){
        if ([[FinalTools getCurrentVC] isKindOfClass:[UINavigationController class]]) {
            [(CPSimpleDrawerView *)[self.view superview] dismiss];
            BudgetViewController *budget = [[BudgetViewController alloc] init];
            [(UINavigationController *) [FinalTools getCurrentVC] pushViewController:budget animated:YES];
        }
    } else if (indexPath.section == 1 && indexPath.row == 0){
        CPAlertView *alert = [[CPAlertView alloc] initWithTitle:@"警告" message:@"注销登录将会删除您的所有数据，确定注销？" delegate:self style:(CPAlertViewStyleDefault) buttons:@"确定", @"不要", nil];
        alert.tag = 10056;
        [alert show];
    }
}

- (void)alertView:(CPAlertView *)alertView buttonIndex:(NSNumber *)btnIndex{
    
    if (alertView.tag == 10056 && [btnIndex isEqual:@(0)]) {
    
        if ([[SystemManager manager] emptyData]) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Init"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Money"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uName"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentUserHeader"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Budget_day"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Budget_month"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"BudgetDate"];
            InitViewController *initVC = [InitViewController new];
            [UIApplication sharedApplication].keyWindow.rootViewController = initVC;
        } else {
            CPAlertView *alert = [[CPAlertView alloc] initWithTitle:@"提示" message:@"未知错误" delegate:self style:(CPAlertViewStyleDefault) buttons:@"确定", @"不要", nil];
            [alert show];
        }

    }
    
}

- (NSArray *)menuArray{
    if (!_menuArray) {
        _menuArray = @[@"修改密码", @"编辑资料", @"我的预算"];
    }
    return _menuArray;
}

@end
