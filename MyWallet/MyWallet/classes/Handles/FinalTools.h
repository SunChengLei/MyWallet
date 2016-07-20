//
//  FinalTools.h
//  MyWallet
//
//  Created by 李成鹏 on 16/6/27.
//  Copyright © 2016年 MorpLCP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FinalTools : NSObject

/**
 *  按格式获取当前时间
 *
 *  @param format 时间格式
 *
 *  @return 时间字符串
 */
+ (NSString *)currentDateWithFormat:(NSString *)format;

/**
 *  获取当前在显示的VC
 *
 *  @return VC
 */
+ (UIViewController *)getCurrentVC;

@end
