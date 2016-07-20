//
//  CPSimpleDrawerView.m
//  MyWallet
//
//  Created by 美鑫科技 on 16/6/27.
//  Copyright © 2016年 MorpLCP. All rights reserved.
//

#import "CPSimpleDrawerView.h"

@interface CPSimpleDrawerView ()

@property (nonatomic, strong) UIViewController *leftVC;
@property (nonatomic, strong) UIView *bacView;

@end
@implementation CPSimpleDrawerView

- (instancetype)initWithLeftViewController:(UIViewController *)viewController{
    self = [super initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeight - 20.0f)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.leftVC = viewController;
        _leftVC.view.frame = CGRectMake(-(ScreenWidth / 3.0) * 2.0, 0, (ScreenWidth / 3.0) * 2.0, ScreenHeight - 20.0f);
        [self addSubview:_leftVC.view];
        
        UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipClick)];
        swip.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:swip];
    }
    return self;
}

- (void)swipClick{
    [self dismiss];
}

- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        CGRect newFrame = self.leftVC.view.frame;
        newFrame.origin = CGPointMake(0, 0);
        self.leftVC.view.frame = newFrame;
    }];
}

- (void)dismiss{
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor clearColor];
        _leftVC.view.frame = CGRectMake(-(ScreenWidth / 3.0) * 2.0, 0, (ScreenWidth / 3.0) * 2.0, ScreenHeight - 20.0f);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
