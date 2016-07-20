//
//  FinalTools.m
//  MyWallet
//
//  Created by 李成鹏 on 16/6/27.
//  Copyright © 2016年 MorpLCP. All rights reserved.
//

#import "FinalTools.h"

@implementation FinalTools

// 按照格式，获取当前时间
+ (NSString *)currentDateWithFormat:(NSString *)format{
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:format];
    return [formater stringFromDate:[NSDate date]];
}

// 获取当期正在显示的VC
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

@end
