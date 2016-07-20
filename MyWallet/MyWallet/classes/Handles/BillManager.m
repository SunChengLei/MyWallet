//
//  BillManager.m
//  MyWallet
//
//  Created by 美鑫科技 on 16/6/22.
//  Copyright © 2016年 MorpLCP. All rights reserved.
//

#import "BillManager.h"
#import "SystemManager.h"
#import "Bill.h"

#define SQL_BILL_GETLIST @"select * from t_bill"
#define SQL_BILL_GETBILLBYID @"select * from t_bill where bId=?"

#define SQL_BILL_ADDNEWBILL @"insert into t_bill (bType,bUse,bDes,bMoney,bBalance,bCreatDate) values (?,?,?,?,?,?)"

#define SQL_BILL_DELETEBILLBYID @"delete from t_bill where bId=?"

@interface BillManager ()

@property (nonatomic, strong) NSMutableDictionary *dataDict;
@property (nonatomic, strong) NSMutableArray *keyArray;

@end

@implementation BillManager

- (instancetype)init{
    
    self = [super init];
    
    if (self) [self analyticalData];
    
    return self;
    
}

+ (instancetype)manager{
    
    BillManager *manager = [BillManager new];
    
    return manager;
    
}

// 解析数据
- (void)analyticalData{
    
    if (![[SystemManager manager].db open]) return;
    
    FMResultSet *set = [[SystemManager manager].db executeQuery:SQL_BILL_GETLIST, [[NSUserDefaults standardUserDefaults] objectForKey:@"uName"]];
    
    while ([set next]) {
        
        Bill *bill = [Bill new];
        
        bill.bId = [set intForColumn:@"bId"];
        bill.bType = [set intForColumn:@"bType"];
        bill.bUse = [set stringForColumn:@"bUse"];
        bill.bDes = [set stringForColumn:@"bDes"];
        bill.bMoney = [set doubleForColumn:@"bMoney"];
        bill.bBalance = [set doubleForColumn:@"bBalance"];
        bill.bCreatDate = [set stringForColumn:@"bCreatDate"];
        
        NSString *key = bill.bCreatDate;
        
        if (self.dataDict[key] == nil) {
            
            NSMutableArray *array = [NSMutableArray arrayWithObject:bill];
            [self.dataDict setObject:array forKey:key];
            
        } else{
            
            NSMutableArray *billArray = self.dataDict[key];
            [billArray addObject:bill];
            
        }
        
        self.keyArray = [self.dataDict allKeys].mutableCopy;
        
        [self.keyArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            
            if ([obj1 compare:obj2] == 1) return NSOrderedAscending;
            else return NSOrderedDescending;
            
        }];
        
    }
    
    [[SystemManager manager].db close];
    
}

// 获取全部账单列表
- (id)getBillList{
    
    return self.dataDict;
    
}

// 获取当前账期账单列表
- (id)getBillListWithCurrentMonth{
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"BudgetDate"]) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        for (NSString *key in self.dataDict) {
            
            if ([[key substringWithRange:NSMakeRange(0, 4)] isEqualToString:[[FinalTools currentDateWithFormat:@"yyyy-MM-dd"] substringWithRange:NSMakeRange(0, 4)]]) {
                
                if ([[key substringWithRange: NSMakeRange(5, 2)] isEqualToString:[[FinalTools currentDateWithFormat:@"yyyy-MM-dd"] substringWithRange:NSMakeRange(5, 2)]]) {
                    
                    [dict setObject:self.dataDict[key] forKey:key];
                    
                }
                
            }
            
        }
        
        return dict;
        
    } else {
        
        NSString *dataStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"BudgetDate"];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        for (NSString *key in self.dataDict) {
            
            if ([[key substringWithRange:NSMakeRange(0, 4)] isEqualToString:[[FinalTools currentDateWithFormat:@"yyyy-MM-dd"] substringWithRange:NSMakeRange(0, 4)]]) {
                
                if ([[[FinalTools currentDateWithFormat:@"yyyy-MM-dd"] substringWithRange:NSMakeRange(8, 2)] integerValue] > [dataStr integerValue]) {
                    
                    if ([[key substringWithRange:NSMakeRange(5, 2)] isEqualToString:[[FinalTools currentDateWithFormat:@"yyyy-MM-dd"] substringWithRange:NSMakeRange(5, 2)]] && [[key substringWithRange:NSMakeRange(8, 2)] integerValue] > [dataStr integerValue]) {
                        
                        [dict setObject:self.dataDict[key] forKey:key];
                        
                    }
                    
                } else{
                    
                    if ([[key substringWithRange: NSMakeRange(5, 2)] isEqualToString:[[FinalTools currentDateWithFormat:@"yyyy-MM-dd"] substringWithRange:NSMakeRange(5, 2)]]) {
                        
                        if ([[key substringWithRange:NSMakeRange(8, 2)] integerValue] <= [dataStr integerValue]) {
                            
                            [dict setObject:self.dataDict[key] forKey:key];
                            
                        }
                        
                    } else if ([[key substringWithRange: NSMakeRange(5, 2)] isEqualToString:[NSString stringWithFormat:@"%ld", (long)([[[FinalTools currentDateWithFormat:@"yyyy-MM-dd"] substringWithRange:NSMakeRange(5, 2)] integerValue] - 1)]]){
                        
                        if ([[key substringWithRange:NSMakeRange(8, 2)] integerValue] >= [dataStr integerValue]) {
                            
                            [dict setObject:self.dataDict[key] forKey:key];
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        return dict;
        
    }
    
}

- (NSMutableDictionary *)dataDict{
    
    if (!_dataDict) _dataDict = [NSMutableDictionary dictionary];
    
    return _dataDict;
    
}

// 记一笔
- (BOOL)addNewBill:(Bill *)bill{
    
    if (![[SystemManager manager].db open]) return NO;
    
    if ([[SystemManager manager].db executeUpdate:SQL_BILL_ADDNEWBILL, @(bill.bType), bill.bUse, bill.bDes, @(bill.bMoney), @(bill.bBalance), bill.bCreatDate]) {
        
        [[SystemManager manager].db close];
        
        return YES;
        
    } else {
        
        [[SystemManager manager].db close];
        
        return NO;
        
    }
    
}

// 根据ID删除记录
- (BOOL)deleteBillWithId:(NSInteger)bId {
    
    if (![[SystemManager manager].db open]) return NO;
    
    if ([[SystemManager manager].db executeUpdate:SQL_BILL_DELETEBILLBYID, @(bId)]) {
        
        [[SystemManager manager].db close];
        
        return YES;
        
    } else {
        
        [[SystemManager manager].db close];
        
        return NO;
        
    }
    
}

// 获取指定某天收支总结
- (NSString *)getConclusionWithDate:(NSString *)date{
    
    double inMoney_day = 0.0;
    double outMoney_day = 0.0;
    
    NSDictionary *dict = [[BillManager manager] getBillList];
    
    NSArray *billArray = dict[date];
    
    for (Bill *bill in billArray) {
        
        if (bill.bType == 0) outMoney_day += bill.bMoney;
        else if (bill.bType == 1) inMoney_day += bill.bMoney;
        
    }
    
    return [NSString stringWithFormat:@"%.2f,%.2f", inMoney_day, outMoney_day];
    
}

// 获取今日收支总结
- (void)getConclusion_Day:(void(^)(double inMoney, double outMoney))result{
    
    double inMoney_day = 0.0;
    double outMoney_day = 0.0;
    
    NSDictionary *dict = [[BillManager manager] getBillList];
    
    NSArray *keyArray = [dict allKeys];
    
    for (Bill *bill in dict[keyArray[0]]) {
        
        if (bill.bType == 0) outMoney_day += bill.bMoney;
        else if (bill.bType == 1) inMoney_day += bill.bMoney;
        
    }
    
    result(inMoney_day, outMoney_day);
    
}

// 获取当前月份收支总结
- (void)getConclusion_Month:(void(^)(double inMoney, double outMoney))result{
    
    double inMoney_month = 0.0;
    double outMoney_month = 0.0;
    
    NSDictionary *dict = [[BillManager manager] getBillList];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"BudgetDate"]) {
        
        for (NSString *key in dict) {
            
            if ([[key substringWithRange:NSMakeRange(0, 4)] isEqualToString:[[FinalTools currentDateWithFormat:@"yyyy-MM-dd"] substringWithRange:NSMakeRange(0, 4)]]) {
                
                if ([[key substringWithRange: NSMakeRange(5, 2)] isEqualToString:[[FinalTools currentDateWithFormat:@"yyyy-MM-dd"] substringWithRange:NSMakeRange(5, 2)]]) {
                    
                    for (Bill *bill in dict[key]) {
                        
                        if (bill.bType == 0) outMoney_month += bill.bMoney;
                        else if (bill.bType == 1) inMoney_month += bill.bMoney;
                        
                    }
                    
                }
                
            }
            
        }
        
    } else {
        
        NSString *dateSta = [[NSUserDefaults standardUserDefaults] objectForKey:@"BudgetDate"];
        
        for (NSString *key in dict) {
            
            if ([[key substringWithRange:NSMakeRange(0, 4)] isEqualToString:[[FinalTools currentDateWithFormat:@"yyyy-MM-dd"] substringWithRange:NSMakeRange(0, 4)]]) {
                
                if ([[[FinalTools currentDateWithFormat:@"yyyy-MM-dd"] substringWithRange:NSMakeRange(8, 2)] integerValue] > [dateSta integerValue]) {
                    
                    if ([[key substringWithRange:NSMakeRange(5, 2)] isEqualToString:[[FinalTools currentDateWithFormat:@"yyyy-MM-dd"] substringWithRange:NSMakeRange(5, 2)]] && [[key substringWithRange:NSMakeRange(8, 2)] integerValue] > [dateSta integerValue]) {
                        
                        for (Bill * bill in dict[key]) {
                            
                            if (bill.bType == 0) outMoney_month += bill.bMoney;
                            else if (bill.bType == 1) inMoney_month += bill.bMoney;
                            
                        }
                        
                    }
                    
                } else{
                    
                    if ([[key substringWithRange: NSMakeRange(5, 2)] isEqualToString:[[FinalTools currentDateWithFormat:@"yyyy-MM-dd"] substringWithRange:NSMakeRange(5, 2)]]) {
                        
                        if ([[key substringWithRange:NSMakeRange(8, 2)] integerValue] <= [dateSta integerValue]) {
                            
                            for (Bill *bill in dict[key]) {
                                
                                if (bill.bType == 0) outMoney_month += bill.bMoney;
                                else if (bill.bType == 1) inMoney_month += bill.bMoney;
                                
                            }
                            
                        }
                        
                    } else if ([[key substringWithRange: NSMakeRange(5, 2)] isEqualToString:[NSString stringWithFormat:@"%ld", (long)([[[FinalTools currentDateWithFormat:@"yyyy-MM-dd"] substringWithRange:NSMakeRange(5, 2)] integerValue] - 1)]]){
                        
                        if ([[key substringWithRange:NSMakeRange(8, 2)] integerValue] >= [dateSta integerValue]) {
                            
                            for (Bill *bill in dict[key]) {
                                
                                if (bill.bType == 0) outMoney_month += bill.bMoney;
                                else if (bill.bType == 1) inMoney_month += bill.bMoney;
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    result(inMoney_month, outMoney_month);
    
}

- (NSString *)getConclusion_Month_NoBlock{
    
    double inMoney_month = 0.0;
    double outMoney_month = 0.0;
    
    NSDictionary *dict = [[BillManager manager] getBillList];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"BudgetDate"]) {
        
        for (NSString *key in dict) {
            
            if ([[key substringWithRange:NSMakeRange(0, 4)] isEqualToString:[[FinalTools currentDateWithFormat:@"yyyy-MM-dd"] substringWithRange:NSMakeRange(0, 4)]]) {
                
                if ([[key substringWithRange: NSMakeRange(5, 2)] isEqualToString:[[FinalTools currentDateWithFormat:@"yyyy-MM-dd"] substringWithRange:NSMakeRange(5, 2)]]) {
                    
                    for (Bill *bill in dict[key]) {
                        
                        if (bill.bType == 0) outMoney_month += bill.bMoney;
                        else if (bill.bType == 1) inMoney_month += bill.bMoney;
                        
                    }
                    
                }
                
            }
            
        }
        
    } else {
        
        NSString *dateSta = [[NSUserDefaults standardUserDefaults] objectForKey:@"BudgetDate"];
        
        for (NSString *key in dict) {
            
            if ([[key substringWithRange:NSMakeRange(0, 4)] isEqualToString:[[FinalTools currentDateWithFormat:@"yyyy-MM-dd"] substringWithRange:NSMakeRange(0, 4)]]) {
                
                if ([[[FinalTools currentDateWithFormat:@"yyyy-MM-dd"] substringWithRange:NSMakeRange(8, 2)] integerValue] > [dateSta integerValue]) {
                    
                    if ([[key substringWithRange:NSMakeRange(5, 2)] isEqualToString:[[FinalTools currentDateWithFormat:@"yyyy-MM-dd"] substringWithRange:NSMakeRange(5, 2)]] && [[key substringWithRange:NSMakeRange(8, 2)] integerValue] > [dateSta integerValue]) {
                        
                        for (Bill * bill in dict[key]) {
                            
                            if (bill.bType == 0) outMoney_month += bill.bMoney;
                            else if (bill.bType == 1) inMoney_month += bill.bMoney;
                            
                        }
                        
                    }
                    
                } else{
                    
                    if ([[key substringWithRange: NSMakeRange(5, 2)] isEqualToString:[[FinalTools currentDateWithFormat:@"yyyy-MM-dd"] substringWithRange:NSMakeRange(5, 2)]]) {
                        
                        if ([[key substringWithRange:NSMakeRange(8, 2)] integerValue] <= [dateSta integerValue]) {
                            
                            for (Bill *bill in dict[key]) {
                                
                                if (bill.bType == 0) outMoney_month += bill.bMoney;
                                else if (bill.bType == 1) inMoney_month += bill.bMoney;
                                
                            }
                            
                        }
                        
                    } else if ([[key substringWithRange: NSMakeRange(5, 2)] isEqualToString:[NSString stringWithFormat:@"%ld", (long)([[[FinalTools currentDateWithFormat:@"yyyy-MM-dd"] substringWithRange:NSMakeRange(5, 2)] integerValue] - 1)]]){
                        
                        if ([[key substringWithRange:NSMakeRange(8, 2)] integerValue] >= [dateSta integerValue]) {
                            
                            for (Bill *bill in dict[key]) {
                                
                                if (bill.bType == 0) outMoney_month += bill.bMoney;
                                else if (bill.bType == 1) inMoney_month += bill.bMoney;
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    return [NSString stringWithFormat:@"%.2f,%.2f", inMoney_month, outMoney_month];
    
}


// 获取指定月份的收支总结
- (NSString *)getMonthConclusionWithDate:(NSString *)date{
    
    double inMoney_month = 0.0;
    double outMoney_month = 0.0;
    
    NSDictionary *dict = [[BillManager manager] getBillList];
    
    NSString *month = [date substringWithRange:NSMakeRange(5, 2)];
    NSString *nextMonth = [NSString stringWithFormat:@"%ld",  (long)([[date substringWithRange:NSMakeRange(5, 2)] integerValue] + 1)];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"BudgetDate"]) {
        
        for (NSString *key in dict) {
            
            if ([[key substringWithRange:NSMakeRange(0, 4)] isEqualToString:[date substringWithRange:NSMakeRange(0, 4)]]) {
                
                if ([[key substringWithRange:NSMakeRange(5, 2)] isEqualToString:month]) {
                    
                    for (Bill *bill in dict[key]) {
                        
                        if (bill.bType == 0) outMoney_month += bill.bMoney;
                        else if (bill.bType == 1) inMoney_month += bill.bMoney;
                        
                    }
                    
                }
                
            }
            
        }
        
    } else {
        
        NSString *dateSta = [[NSUserDefaults standardUserDefaults] objectForKey:@"BudgetDate"];
        
        for (NSString *key in dict) {
            
            if ([[key substringWithRange:NSMakeRange(0, 4)] isEqualToString:[date substringWithRange:NSMakeRange(0, 4)]]) {
                
                if ([[key substringWithRange:NSMakeRange(5, 2)] isEqualToString:month]) {
                    
                    if ([[key substringWithRange:NSMakeRange(8, 2)] integerValue] >= [dateSta integerValue]) {
                        
                        for (Bill *bill in dict[key]) {
                            
                            if (bill.bType == 0) outMoney_month += bill.bMoney;
                            else if (bill.bType == 1) inMoney_month += bill.bMoney;
                            
                        }
                        
                    }
                    
                } else if ([[key substringWithRange:NSMakeRange(5, 2)] isEqualToString:nextMonth]){
                    
                    if ([[key substringWithRange:NSMakeRange(8, 2)] integerValue] <= [dateSta integerValue]) {
                        
                        for (Bill *bill in dict[key]) {
                            
                            if (bill.bType == 0) outMoney_month += bill.bMoney;
                            else if (bill.bType == 1) inMoney_month += bill.bMoney;
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    return [NSString stringWithFormat:@"%.2f,%.2f", inMoney_month, outMoney_month];
    
}

- (NSMutableArray *)keyArray{
    
    if (!_keyArray) _keyArray = [NSMutableArray array];
    
    return _keyArray;
    
}

@end
