//
//  LockView.h
//  MyWallet
//
//  Created by 美鑫科技 on 16/6/27.
//  Copyright © 2016年 MorpLCP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LockView : UIView

@property (nonatomic, assign) BOOL isShow;

+ (instancetype)lock;

- (void)show;

@end
