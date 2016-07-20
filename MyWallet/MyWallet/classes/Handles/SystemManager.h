//
//  SystemManager.h
//  MyWallet
//
//  Created by 美鑫科技 on 16/6/22.
//  Copyright © 2016年 MorpLCP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface SystemManager : NSObject

@property (nonatomic, strong) FMDatabase *db;

+ (instancetype)manager;

// 检测数据是否需要初始化
- (BOOL)checkDataBase;

// 初始化数据库
- (BOOL)initDataBase;

// 清空数据
- (BOOL)emptyData;

@end
