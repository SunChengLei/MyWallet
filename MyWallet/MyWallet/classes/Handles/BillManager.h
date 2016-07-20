//
//  BillManager.h
//  MyWallet
//
//  Created by 美鑫科技 on 16/6/22.
//  Copyright © 2016年 MorpLCP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bill.h"

@interface BillManager : NSObject

+ (instancetype)manager;

/**
 *  获取账单列表
 */
- (id)getBillList;

/**
 *  获取当前账期账单列表
 */
- (id)getBillListWithCurrentMonth;

/**
 *  记一笔
 *
 *  @param bill 账单
 *
 *  @return 布尔值
 */
- (BOOL)addNewBill:(Bill *)bill;

/**
 *  根据ID删除一条记录
 *
 *  @param bId 记录编号
 *
 *  @return 布尔值
 */
- (BOOL)deleteBillWithId:(NSInteger)bId;

/**
 *  获取指定某天收支总结
 *
 *  @return 钱
 */
- (NSString *)getConclusionWithDate:(NSString *)date;

/**
 *  获取今日收支总结
 *
 *  @return 钱
 */
- (void)getConclusion_Day:(void(^)(double inMoney, double outMoney))result;

/**
 *  获取当前月份收支总结 -block
 *
 *  @return 钱
 */
- (void)getConclusion_Month:(void(^)(double inMoney, double outMoney))result;

/**
 *  获取当前月份收支总结
 *
 *  @return 钱
 */
- (NSString *)getConclusion_Month_NoBlock;

/**
 *  获取指定月份收支总结
 *
 *  @return 钱
 */
- (NSString *)getMonthConclusionWithDate:(NSString *)date;


@end
