//
//  StringUtils.h
//  MyWallet
//
//  Created by 美鑫科技 on 16/6/24.
//  Copyright © 2016年 MorpLCP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringUtils : NSObject

/**
 *  判断字符串是否是数字
 *
 *  @param number <#number description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)validateNumber:(NSString*)number;

@end
