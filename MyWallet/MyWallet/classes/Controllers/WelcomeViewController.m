//
//  WelcomeViewController.m
//  MyWallet
//
//  Created by 美鑫科技 on 16/6/23.
//  Copyright © 2016年 MorpLCP. All rights reserved.
//

#import "WelcomeViewController.h"
#import "SystemManager.h"
#import "CPAlertView.h"
#import "InitViewController.h"

@interface WelcomeViewController ()<CPAlertViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initSubViews];
    
}

- (void)initSubViews{
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((ScreenWidth - 200) / 2.0, ScreenHeight - 70.0, 200.0, 20)];
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.pageIndicatorTintColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.7f];
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = 3;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 3.0, self.view.frame.size.height);
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    
    UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    firstView.backgroundColor = [UIColor colorWithRed:25.0 / 255.0 green:162.0 / 255.0 blue:212.0 / 255.0 alpha:1];
    
    UIImageView *img1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1"]];
    img1.frame = CGRectMake((self.view.frame.size.width - 250) / 2.0, 100, 250, 250);
    [firstView addSubview:img1];
    
    UILabel *lblTitle1 = [[UILabel alloc] initWithFrame:CGRectMake(0, img1.frame.origin.y + img1.frame.size.height -20, self.view.frame.size.width, 80.0)];
    lblTitle1.textAlignment = NSTextAlignmentCenter;
    lblTitle1.textColor = [UIColor whiteColor];
    lblTitle1.font = [UIFont systemFontOfSize:25];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor blackColor];
    shadow.shadowOffset = CGSizeMake(1, 1);
    NSDictionary *attributes = @{NSShadowAttributeName:shadow};
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"发工资了，我要存钱！" attributes:attributes];
    lblTitle1.attributedText = str;
    [firstView addSubview:lblTitle1];
    
    UIView *secondView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
    secondView.backgroundColor = [UIColor colorWithRed:146.0 / 255.0 green:238.0 / 255.0 blue:102.0 / 255.0 alpha:1];
    
    UIImageView *img2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2"]];
    img2.frame = CGRectMake((self.view.frame.size.width - 250) / 2.0, 100, 250, 250);
    [secondView addSubview:img2];
    
    UILabel *lblTitle2 = [[UILabel alloc] initWithFrame:CGRectMake(0, img2.frame.origin.y + img2.frame.size.height -20, self.view.frame.size.width, 80.0)];
    lblTitle2.textAlignment = NSTextAlignmentCenter;
    lblTitle2.textColor = [UIColor whiteColor];
    lblTitle2.font = [UIFont systemFontOfSize:25];
    NSShadow *shadow2 = [[NSShadow alloc] init];
    shadow2.shadowColor = [UIColor blackColor];
    shadow2.shadowOffset = CGSizeMake(1, 1);
    NSDictionary *attributes2 = @{NSShadowAttributeName:shadow2};
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"钱花光了，我要存钱！" attributes:attributes2];
    lblTitle2.attributedText = str2;
    [secondView addSubview:lblTitle2];
    
    UIView *thirdView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 2.0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    thirdView.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:107.0 / 255.0 blue:47.0 / 255.0 alpha:1];
    
    UIImageView *img3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"3"]];
    img3.frame = CGRectMake((self.view.frame.size.width - 250) / 2.0, 100, 250, 250);
    [thirdView addSubview:img3];
    
    UILabel *lblTitle3 = [[UILabel alloc] initWithFrame:CGRectMake(0, img3.frame.origin.y + img3.frame.size.height -20, self.view.frame.size.width, 80.0)];
    lblTitle3.textAlignment = NSTextAlignmentCenter;
    lblTitle3.textColor = [UIColor whiteColor];
    lblTitle3.font = [UIFont systemFontOfSize:25];
    NSShadow *shadow3 = [[NSShadow alloc] init];
    shadow3.shadowColor = [UIColor blackColor];
    shadow3.shadowOffset = CGSizeMake(1, 1);
    NSDictionary *attributes3 = @{NSShadowAttributeName:shadow3};
    NSAttributedString *str3 = [[NSAttributedString alloc] initWithString:@"无论如何，我要存钱！" attributes:attributes3];
    lblTitle3.attributedText = str3;
    [thirdView addSubview:lblTitle3];
    
    UIButton *btnStart = [UIButton buttonWithType:UIButtonTypeSystem];
    btnStart.frame = CGRectMake((self.view.frame.size.width - 200) / 2.0, self.view.frame.size.height - 70.0, 200.0, 40);
    btnStart.layer.masksToBounds = YES;
    btnStart.layer.cornerRadius = 5.0;
    btnStart.layer.borderWidth = 1.0f;
    btnStart.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8f].CGColor;
    [btnStart addTarget:self action:@selector(action2Start) forControlEvents:UIControlEventTouchUpInside];
    [btnStart setTitle:@"立即体验" forState:UIControlStateNormal];
    [btnStart setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.8f] forState:UIControlStateNormal];
    [thirdView addSubview:btnStart];
    
    [_scrollView addSubview:firstView];
    [_scrollView addSubview:secondView];
    [_scrollView addSubview:thirdView];
    
    [self.view addSubview:_scrollView];
    [self.view addSubview:_pageControl];
    
}

- (void)action2Start{
    
    if ([[SystemManager manager] initDataBase]) {
        InitViewController *initVC = [[InitViewController alloc] init];
        WelcomeViewController *welcomVC = (WelcomeViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        [welcomVC removeFromParentViewController];
        welcomVC = nil;
        [UIApplication sharedApplication].keyWindow.rootViewController = initVC;
        
    } else{
        CPAlertView *alert = [[CPAlertView alloc] initWithTitle:@"提示" message:@"初始化失败, 请重试！" delegate:self style:(CPAlertViewStyleDefault) buttons:@"取消", @"重试", nil];
        [alert show];
    }
    
}

#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger currentPage = scrollView.contentOffset.x / self.view.frame.size.width;
    _pageControl.currentPage = currentPage;
    if (currentPage == 2) {
        [_pageControl removeFromSuperview];
    } else{
        [self.view addSubview:_pageControl];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)alertView:(CPAlertView *)alertView buttonIndex:(NSNumber *)btnIndex{
    if ([btnIndex  isEqual: @(1)]) {
        [self action2Start];
    } else{
        return;
    }
}


@end
