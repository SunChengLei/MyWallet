//
//  SystemManager.m
//  MyWallet
//
//  Created by 美鑫科技 on 16/6/22.
//  Copyright © 2016年 MorpLCP. All rights reserved.
//

#import "SystemManager.h"
#import <UIKit/UIKit.h>

#define SQL_CREATTABLE @"create table t_user (uId integer primary key autoincrement, uPwd text, uNickName text, uHeaderPicture data);create table t_bill (bId integer primary key autoincrement, bType integer, bUse text, bDes text, bMoney double, bBalance double, bCreatDate text);"
#define SQL_CHECKCOUNT @"select count(*) as 'count' from sqlite_master where type ='table' and name =?"

#define SQL_EMPTYDATA @"delete from t_user;update sqlite_sequence SET seq = 0 where name = 't_user';delete from t_bill;update sqlite_sequence SET seq = 0 where name = 't_bill';"

@implementation SystemManager

static SystemManager *manager = nil;
+ (instancetype)manager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [SystemManager new];
    });
    return manager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *dbPath = [documentPath stringByAppendingString:@"/db.database"];
        _db = [FMDatabase databaseWithPath:dbPath];
    }
    return self;
}

- (BOOL)initDataBase{
    
    if (![_db open]) {
        [_db close];
        return NO;
    }
    BOOL result = [_db executeStatements:SQL_CREATTABLE];
    if (result) {
        [_db close];
        return YES;
    } else{
        [_db close];
        return NO;
    }
    
}

// 检测是否需要初始化
- (BOOL)checkDataBase{
    if (![_db open]) {
        return YES;
    }
    FMResultSet *set = [_db executeQuery:SQL_CHECKCOUNT, @"t_user"];
    while ([set next]) {
        NSInteger count = [set intForColumn:@"count"];
        if (0 == count) {
            [_db close];
            return YES;
        }
        else {
            [_db close];
            return NO;
        }
    }
    [_db close];
    return YES;
}

// 清空表数据
- (BOOL)emptyData{
    if (![_db open]) {
        return NO;
    }
    BOOL result = [_db executeStatements:SQL_EMPTYDATA];
    [_db close];
    return result;
}

@end
