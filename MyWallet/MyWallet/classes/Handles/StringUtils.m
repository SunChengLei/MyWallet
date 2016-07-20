//
//  StringUtils.m
//  MyWallet
//
//  Created by 美鑫科技 on 16/6/24.
//  Copyright © 2016年 MorpLCP. All rights reserved.
//

#import "StringUtils.h"

@implementation StringUtils

// 判断输入的是否为数字
+ (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

@end
