//
//  CPAlertView.m
//  CPAlertView
//
//  Created by 美鑫科技 on 16/5/28.
//  Copyright © 2016年 MorpLCP. All rights reserved.
//

#import "CPAlertView.h"

#define kWindowWidth [UIScreen mainScreen].bounds.size.width
#define kWindowHeight   [UIScreen mainScreen].bounds.size.height
#define RgbColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

@interface CPAlertView () {
    UIColor *_BackgroundColor;
    UIColor *_TintColor;
    UIColor *_LineColor;
    UIColor *_BtnTitleColor;
}

@property (nonatomic, strong) UIView *bacView;
@property (nonatomic, strong) UIView *view4Btns;
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UILabel *lblMessage;
@property (nonatomic, assign) CGRect viewFrame;
@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation CPAlertView

- (instancetype)init{
    
    self = [super init];
    if (self) {
        
        _BackgroundColor = [UIColor whiteColor];
        _TintColor = [UIColor blackColor];
        _LineColor = [UIColor blackColor];
        _BtnTitleColor = RgbColor(20, 143, 70);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 3;
        self.backgroundColor = _BackgroundColor;
        
        self.frame = CGRectMake(0, 0, 0, 0);
        self.center = CGPointMake(kWindowWidth / 2.0, kWindowHeight / 2.0);
        
        self.bacView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight)];
        self.bacView.backgroundColor = [_TintColor colorWithAlphaComponent:0];
        [self.bacView addSubview:self];
    }
    return self;
    
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message buttons:(NSString *)btn1, ...{
    
    va_list ap;
    va_start(ap, btn1);
    if (btn1) {
        [self.array addObject:btn1];
    }
    while (YES) {
        id obj  = va_arg(ap, id);
        if (obj == nil) break;
        [self.array addObject:(NSString *)obj];
    }
    va_end(ap);
    
    self = [self init];
    if (self) {
        
        CGFloat height = [message boundingRectWithSize:CGSizeMake(kWindowWidth - 50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil].size.height + 10;
        _viewFrame = CGRectMake(20, (kWindowHeight - 80 - height) / 2.0, kWindowWidth - 40, height + 100);
        
        if (title) {
            self.lblTitle = [[UILabel alloc] init];
            _lblTitle.text = title;
            _lblTitle.font = [UIFont systemFontOfSize:18];
            _lblTitle.textAlignment = NSTextAlignmentCenter;
            [self addSubview:_lblTitle];
        }
        
        if (message) {
            self.lblMessage = [[UILabel alloc] init];
            _lblMessage.font = [UIFont systemFontOfSize:14.0];
            _lblMessage.text = message;
            _lblMessage.textAlignment = NSTextAlignmentCenter;
            _lblMessage.numberOfLines = 0;
            [self addSubview:_lblMessage];
        }
        
        if (btn1) {
            self.view4Btns = [[UIView alloc] init];
            [self addSubview:_view4Btns];
        }
    }
    return self;
    
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id<CPAlertViewDelegate>)delegate style:(CPAlertViewStyle)style buttons:(NSString *)btn1, ...{
    
    if (_delegate) {
        _delegate = nil;
    }
    _delegate = delegate;
    
    va_list ap;
    va_start(ap, btn1);
    if (btn1) {
        [self.array addObject:btn1];
    }
    while (YES) {
        id obj  = va_arg(ap, id);
        if (obj == nil) break;
        [self.array addObject:(NSString *)obj];
    }
    va_end(ap);
    
    self = [self init];
    if (self) {
        
        switch (style) {
            case CPAlertViewStyleDefault:
                _BackgroundColor = [UIColor whiteColor];
                _TintColor = [UIColor blackColor];
                _LineColor = [UIColor blackColor];
                _BtnTitleColor = RgbColor(20, 143, 70);
                break;
            case CPAlertViewStyleWhite:
                _BackgroundColor = [UIColor whiteColor];
                _TintColor = [UIColor blackColor];
                _LineColor = [UIColor blackColor];
                _BtnTitleColor = RgbColor(20, 143, 70);
                break;
            case CPAlertViewStyleDark:
                _BackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
                _TintColor = [UIColor whiteColor];
                _LineColor = [UIColor whiteColor];
                _BtnTitleColor = [UIColor whiteColor];
                break;
            default:
                break;
        }
        
        self.backgroundColor = _BackgroundColor;
        CGFloat height = [message boundingRectWithSize:CGSizeMake(kWindowWidth - 50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil].size.height + 10;
        _viewFrame = CGRectMake(20, (kWindowHeight - 80 - height) / 2.0, kWindowWidth - 40, height + 100);
        
        if (title) {
            self.lblTitle = [[UILabel alloc] init];
            _lblTitle.text = title;
            _lblTitle.textColor = _TintColor;
            _lblTitle.font = [UIFont systemFontOfSize:18];
            _lblTitle.textAlignment = NSTextAlignmentCenter;
            [self addSubview:_lblTitle];
        }
        
        if (message) {
            self.lblMessage = [[UILabel alloc] init];
            _lblMessage.font = [UIFont systemFontOfSize:14.0];
            _lblMessage.text = message;
            _lblMessage.textColor = _TintColor;
            _lblMessage.textAlignment = NSTextAlignmentCenter;
            _lblMessage.numberOfLines = 0;
            [self addSubview:_lblMessage];
        }
        
        if (btn1) {
            self.view4Btns = [[UIView alloc] init];
            [self addSubview:_view4Btns];
        }
    }
    
    return self;
    
}

- (void)addLineWithView:(UIView *)view{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 0.5)];
    line.backgroundColor = [_LineColor colorWithAlphaComponent:0.7f];
    [view addSubview:line];
}

- (void)addVerticalLine{
    
    if (self.array.count <= 1) {
        return;
    }
    for (int i = 0; i < self.array.count - 1; i++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake((self.view4Btns.frame.size.width / self.array.count - 0.25f) * (i + 1), 0, 0.5, self.view4Btns.frame.size.height)];
        line.backgroundColor = [_LineColor colorWithAlphaComponent:0.4f];
        [self.view4Btns addSubview:line];
    }
}

- (void)btnClick:(UIButton *)sender{
    
    if (_delegate && [_delegate respondsToSelector:@selector(alertView:buttonIndex:)]) {
        [_delegate performSelector:@selector(alertView:buttonIndex:) withObject:self withObject:@(sender.tag - 10000)];
    }
    [self dismiss];
    
}

- (void)show{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [UIView animateWithDuration:0.3 animations:^{
        self.bacView.backgroundColor = [_TintColor colorWithAlphaComponent:0.5];
    }];
    [UIView animateWithDuration:0.1 animations:^{
        self.frame = _viewFrame;
    } completion:^(BOOL finished) {
        if (_lblTitle) {
            self.lblTitle.frame = CGRectMake(0, 0, self.frame.size.width, 40);
        }
        if (_lblMessage) {
            self.lblMessage.frame = CGRectMake(5, 40, self.frame.size.width - 10, _viewFrame.size.height - 100);
        }
        if (_view4Btns) {
            self.view4Btns.frame = CGRectMake(0, 60 + _lblMessage.frame.size.height, self.frame.size.width, 40);
            for (int i = 0; i < self.array.count; i++) {
                UIButton *btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
                if (i == 0) {
                    [btn setTitle:self.array[0] forState:(UIControlStateNormal)];
                } else{
                    [btn setTitle:self.array[i] forState:(UIControlStateNormal)];
                }
                [btn setTitleColor:_BtnTitleColor forState:(UIControlStateNormal)];
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
                btn.frame = CGRectMake((_view4Btns.frame.size.width / (self.array.count)) * i, 0, (_view4Btns.frame.size.width / (self.array.count)), 40);
                btn.tag = 10000 + i;
                [self.view4Btns addSubview:btn];
            }
            
            [self addLineWithView:_view4Btns];
            [self addVerticalLine];
        }
    }];
    [window addSubview:self.bacView];
}

- (void)dismiss{
   
    self.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.bacView.backgroundColor = [_TintColor colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        [self.bacView removeFromSuperview];
        [self removeFromSuperview];
    }];
    
}

- (NSMutableArray *)array{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

@end
