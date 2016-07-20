//
//  DrawHeaderView.m
//  MyWallet
//
//  Created by 美鑫科技 on 16/6/27.
//  Copyright © 2016年 MorpLCP. All rights reserved.
//

#import "DrawHeaderView.h"

@interface DrawHeaderView ()

@property (nonatomic, strong) UIImageView *backImage;
@property (nonatomic, strong) UIImageView *headerImage;
@property (nonatomic, strong) UILabel *lblNickName;
@property (nonatomic, strong) UILabel *lblMoney;

@end

@implementation DrawHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backImage = [[UIImageView alloc] init];
        NSData *imgData = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUserHeader"];
        UIImage *image = [UIImage imageWithData:imgData];
        _backImage.image = image;
        [self addSubview:_backImage];
        
        self.headerImage = [[UIImageView alloc] init];
        _headerImage.layer.masksToBounds = YES;
        _headerImage.image = image;
        [self addSubview:_headerImage];
        
        self.lblNickName = [[UILabel alloc] init];
        _lblNickName.textAlignment = NSTextAlignmentCenter;
        _lblNickName.textColor = [UIColor whiteColor];
        _lblNickName.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"uName"];
        [self addSubview:_lblNickName];
        
        self.lblMoney = [[UILabel alloc] init];
        _lblMoney.textAlignment = NSTextAlignmentCenter;
        _lblMoney.font = [UIFont systemFontOfSize:20.0f];
        _lblMoney.textColor = [UIColor whiteColor];
        
        NSString *moneyStr = @"";
        
        NSMutableAttributedString *attrStr;
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Money"] doubleValue] > 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"Money"] doubleValue] < 10000) {
            moneyStr = [NSString stringWithFormat:@"买房钱:￥%.2f", [[[NSUserDefaults standardUserDefaults] objectForKey:@"Money"] doubleValue]];
            attrStr =  [[NSMutableAttributedString alloc] initWithString:moneyStr];
            [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:[moneyStr rangeOfString:[NSString stringWithFormat:@"￥%.2f", [[[NSUserDefaults standardUserDefaults] objectForKey:@"Money"] doubleValue]]]];
            [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:[moneyStr rangeOfString:[NSString stringWithFormat:@"￥%.2f", [[[NSUserDefaults standardUserDefaults] objectForKey:@"Money"] doubleValue]]]];
        } else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Money"] doubleValue] >= 10000) {
            moneyStr = [NSString stringWithFormat:@"买房钱:￥%.2f万", [[[NSUserDefaults standardUserDefaults] objectForKey:@"Money"] doubleValue] / 10000.0f];
            attrStr =  [[NSMutableAttributedString alloc] initWithString:moneyStr];
            [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:[moneyStr rangeOfString:[NSString stringWithFormat:@"￥%.2f万", [[[NSUserDefaults standardUserDefaults] objectForKey:@"Money"] doubleValue] / 10000.0f]]];
            [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:[moneyStr rangeOfString:[NSString stringWithFormat:@"￥%.2f万", [[[NSUserDefaults standardUserDefaults] objectForKey:@"Money"] doubleValue] / 10000.0f]]];
        } else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Money"] doubleValue] < 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"Money"] doubleValue] > -10000) {
            moneyStr = [NSString stringWithFormat:@"买房钱:￥%.2f", [[[NSUserDefaults standardUserDefaults] objectForKey:@"Money"] doubleValue]];
            attrStr =  [[NSMutableAttributedString alloc] initWithString:moneyStr];
            [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[moneyStr rangeOfString:[NSString stringWithFormat:@"￥%.2f", [[[NSUserDefaults standardUserDefaults] objectForKey:@"Money"] doubleValue]]]];
            [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:[moneyStr rangeOfString:[NSString stringWithFormat:@"￥%.2f", [[[NSUserDefaults standardUserDefaults] objectForKey:@"Money"] doubleValue]]]];
        } else {
            moneyStr = [NSString stringWithFormat:@"买房钱:￥%.2f万", [[[NSUserDefaults standardUserDefaults] objectForKey:@"Money"] doubleValue] / 10000.0f];
            attrStr =  [[NSMutableAttributedString alloc] initWithString:moneyStr];
            [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[moneyStr rangeOfString:[NSString stringWithFormat:@"￥%.2f万", [[[NSUserDefaults standardUserDefaults] objectForKey:@"Money"] doubleValue] / 10000.0f]]];
            [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:[moneyStr rangeOfString:[NSString stringWithFormat:@"￥%.2f万", [[[NSUserDefaults standardUserDefaults] objectForKey:@"Money"] doubleValue] / 10000.0f]]];
        }
        
        _lblMoney.attributedText = attrStr;
        [self addSubview:_lblMoney];
        
        [self setNeedsLayout];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"reloadDrawData" object:nil];
        
    }
    return self;
}

- (void)layoutSubviews{
    
    _backImage.frame = CGRectMake(
                                  0,
                                  0,
                                  self.frame.size.width,
                                  180);
    
    _headerImage.frame = CGRectMake(
                                    (self.frame.size.width - 80) / 2.0,
                                    10,
                                    80,
                                    80);
    _headerImage.layer.cornerRadius = 40.0;
    
    _lblNickName.frame = CGRectMake(
                                    0,
                                    _headerImage.frame.origin.y + _headerImage.frame.size.height + 10.0,
                                    self.frame.size.width,
                                    30);
    
    _lblMoney.frame = CGRectMake(
                                 0,
                                 _lblNickName.frame.origin.y + _lblNickName.frame.size.height + 5.0,
                                 self.frame.size.width,
                                 40);
    
}

- (void)reloadData{
    
    NSData *imgData = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUserHeader"];
    UIImage *image = [UIImage imageWithData:imgData];
    _headerImage.image = image;
    _lblNickName.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"uName"];

    NSString *moneyStr = @"";
    
    NSMutableAttributedString *attrStr;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Money"] doubleValue] > 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"Money"] doubleValue] < 10000) {
        moneyStr = [NSString stringWithFormat:@"买房钱:￥%.2f", [[[NSUserDefaults standardUserDefaults] objectForKey:@"Money"] doubleValue]];
        attrStr =  [[NSMutableAttributedString alloc] initWithString:moneyStr];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:[moneyStr rangeOfString:[NSString stringWithFormat:@"￥%.2f", [[[NSUserDefaults standardUserDefaults] objectForKey:@"Money"] doubleValue]]]];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:[moneyStr rangeOfString:[NSString stringWithFormat:@"￥%.2f", [[[NSUserDefaults standardUserDefaults] objectForKey:@"Money"] doubleValue]]]];
    } else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Money"] doubleValue] >= 10000) {
        moneyStr = [NSString stringWithFormat:@"买房钱:￥%.2f万", [[[NSUserDefaults standardUserDefaults] objectForKey:@"Money"] doubleValue] / 10000.0f];
        attrStr =  [[NSMutableAttributedString alloc] initWithString:moneyStr];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:[moneyStr rangeOfString:[NSString stringWithFormat:@"￥%.2f万", [[[NSUserDefaults standardUserDefaults] objectForKey:@"Money"] doubleValue] / 10000.0f]]];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:[moneyStr rangeOfString:[NSString stringWithFormat:@"￥%.2f万", [[[NSUserDefaults standardUserDefaults] objectForKey:@"Money"] doubleValue] / 10000.0f]]];
    } else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Money"] doubleValue] < 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"Money"] doubleValue] > -10000) {
        
        moneyStr = [NSString stringWithFormat:@"买房钱:￥%.2f", [[[NSUserDefaults standardUserDefaults] objectForKey:@"Money"] doubleValue]];
        attrStr =  [[NSMutableAttributedString alloc] initWithString:moneyStr];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[moneyStr rangeOfString:[NSString stringWithFormat:@"￥%.2f", [[[NSUserDefaults standardUserDefaults] objectForKey:@"Money"] doubleValue]]]];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:[moneyStr rangeOfString:[NSString stringWithFormat:@"￥%.2f", [[[NSUserDefaults standardUserDefaults] objectForKey:@"Money"] doubleValue]]]];
    
    } else {
        moneyStr = [NSString stringWithFormat:@"买房钱:￥%.2f万", [[[NSUserDefaults standardUserDefaults] objectForKey:@"Money"] doubleValue] / 10000.0f];
        attrStr =  [[NSMutableAttributedString alloc] initWithString:moneyStr];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[moneyStr rangeOfString:[NSString stringWithFormat:@"￥%.2f万", [[[NSUserDefaults standardUserDefaults] objectForKey:@"Money"] doubleValue] / 10000.0f]]];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:[moneyStr rangeOfString:[NSString stringWithFormat:@"￥%.2f万", [[[NSUserDefaults standardUserDefaults] objectForKey:@"Money"] doubleValue] / 10000.0f]]];
    }
    
    _lblMoney.attributedText = attrStr;
    
}

- (void)effect{
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:(UIBlurEffectStyleDark)];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(
                                  0,
                                  0,
                                  self.frame.size.width,
                                  180);
//    effectView.alpha = 0.9f;
    [_backImage addSubview:effectView];
}

@end
