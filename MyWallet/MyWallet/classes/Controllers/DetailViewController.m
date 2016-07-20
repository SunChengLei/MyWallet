//
//  DetailViewController.m
//  MyWallet
//
//  Created by apple on 16/6/28.
//  Copyright © 2016年 MorpLCP. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()<CPAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *leiBieLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view2Height;
@property (weak, nonatomic) IBOutlet UIImageView *imgType;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.leiBieLabel.text = self.bill.bUse;
    if (self.bill.bType == 1) {
        self.imgType.image = [UIImage imageNamed:@"in"];
    } else{
        self.imgType.image = [UIImage imageNamed:@"out"];
    }
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f", self.bill.bMoney];
    self.balanceMoneyLabel.text = [NSString stringWithFormat:@"%.2f", self.bill.bBalance];
    self.contentLabel.text = self.bill.bDes;
    
    if ([self.bill.bCreatDate isEqualToString:[FinalTools currentDateWithFormat:@"yyyy-MM-dd"]]) {
        self.title = @"今天";
    } else{
        self.title = self.bill.bCreatDate;
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"delete"] style:UIBarButtonItemStylePlain target:self action:@selector(deleteClick)];
    
}

- (void)deleteClick{
    CPAlertView *alert = [[CPAlertView alloc] initWithTitle:@"提示" message:@"删除此条记录?" delegate:self style:(CPAlertViewStyleDefault) buttons:@"取消", @"删除", nil];
    alert.tag = 123456;
    [alert show];
}

- (void)alertView:(CPAlertView *)alertView buttonIndex:(NSNumber *)btnIndex{
    if (alertView.tag == 123456 && [btnIndex isEqual:@(1)]) {
        
        if ([[BillManager manager] deleteBillWithId:self.bill.bId]) {
            double money = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Money"] doubleValue];
            if (self.bill.bType == 0) {
                money += self.bill.bMoney;
            } else if (self.bill.bType == 1) {
                money -= self.bill.bMoney;
            }
            [[NSUserDefaults standardUserDefaults] setObject:@(money) forKey:@"Money"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadDrawData" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newBill" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
}

- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    self.view2Height.constant = 20 + [self tableHeight:self.bill.bDes];
    
}

- (CGFloat)tableHeight:(NSString *)string
{
    
    CGSize labelHeight = [string boundingRectWithSize:CGSizeMake(ScreenWidth- 78, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f]} context:nil].size;
    return labelHeight.height;
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

@end
