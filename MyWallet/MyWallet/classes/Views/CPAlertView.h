//
//  CPAlertView.h
//  CPAlertView
//
//  Created by 美鑫科技 on 16/5/28.
//  Copyright © 2016年 MorpLCP. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CPAlertView;
@protocol CPAlertViewDelegate <NSObject>

@optional
- (void)alertView:(CPAlertView *)alertView buttonIndex:(NSNumber *)btnIndex;

@end

typedef NS_ENUM(NSUInteger, CPAlertViewStyle) {
    CPAlertViewStyleDefault = 0,
    CPAlertViewStyleWhite,
    CPAlertViewStyleDark,
};

@interface CPAlertView : UIView

@property (nonatomic, assign) id<CPAlertViewDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message buttons:(NSString *)btn1, ...;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id<CPAlertViewDelegate>)delegate style:(CPAlertViewStyle)style buttons:(NSString *)btn1, ...;

- (void)show;

- (void)dismiss;
@end
