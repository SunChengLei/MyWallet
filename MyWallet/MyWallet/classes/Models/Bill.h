//
//  Bill.h
//  MyWallet
//
//  Created by 美鑫科技 on 16/6/22.
//  Copyright © 2016年 MorpLCP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bill : NSObject

@property (nonatomic, assign) NSInteger bId; // 账单ID
@property (nonatomic, assign) NSInteger bType; // 账单类型，1:收入, 0:支出
@property (nonatomic, copy) NSString *bUse; // 账单用途
@property (nonatomic, copy) NSString *bDes; // 详细描述
@property (nonatomic, assign) double bMoney; // 金额
@property (nonatomic, assign) double bBalance; // 余额
@property (nonatomic, copy) NSString *bCreatDate; // 记录时间

@end
