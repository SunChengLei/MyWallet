//
//  UserManager.m
//  MyWallet
//
//  Created by 美鑫科技 on 16/6/22.
//  Copyright © 2016年 MorpLCP. All rights reserved.
//

#import "UserManager.h"

#define SQL_USER_INSERT @"insert into t_user (uPwd,uNickName,uHeaderPicture) values (?,?,?);"
#define SQL_USER_LOGIN @"select * from t_user where uNickName=?"
#define SQL_USER_EDITPWD @"update t_user set uPwd=? where uNickName=?"
#define SQL_USER_EDITUSER @"update t_user set uNickName=?, uHeaderPicture=? where uId=?"

@implementation UserManager

+ (instancetype)manager{
    UserManager *manager = [UserManager new];
    return manager;
}

// 增加用户
- (BOOL)addUserWithNickName:(NSString *)nickName UPwd:(NSString *)uPwd Money:(double)money HeaderPicture:(UIImage *)image{
    
    NSData *data = UIImagePNGRepresentation(image);
    if (![[SystemManager manager].db open]) {
        return NO;
    }
    if ([[SystemManager manager].db executeUpdate:SQL_USER_INSERT, uPwd, nickName, data]) {
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"currentUserHeader"];
        [[SystemManager manager].db close];
        return YES;
    } else {
        [[SystemManager manager].db close];
        return NO;
    }
}

// 获取当前用户ID
- (NSInteger)currentUserId{
    if (![[SystemManager manager].db open]) {
        return -1;
    }
    FMResultSet *set = [[SystemManager manager].db executeQuery:SQL_USER_LOGIN, [[NSUserDefaults standardUserDefaults] objectForKey:@"uName"]];
    while ([set next]) {
        NSInteger uId = [set intForColumn:@"uId"];
        [[SystemManager manager].db close];
        return uId;
    }
    [[SystemManager manager].db close];
    return -1;
}

// 修改用户
- (BOOL)editUserWithPic:(UIImage *)image UnickName:(NSString *)uNickName{
    
    NSInteger userId = [self currentUserId];
    if (![[SystemManager manager].db open]) {
        return NO;
    }
    NSData *data = UIImagePNGRepresentation(image);
    if ([[SystemManager manager].db executeUpdate:SQL_USER_EDITUSER, uNickName ,data, @(userId)]) {
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"currentUserHeader"];
        [[SystemManager manager].db close];
        return YES;
    } else{
        [[SystemManager manager].db close];
        return NO;
    }
    
}

// 登录
- (BOOL)loginWithPwd:(NSString *)pwd{
    
    if (![[SystemManager manager].db open]) {
        return NO;
    }
    FMResultSet *set = [[SystemManager manager].db executeQuery:SQL_USER_LOGIN, [[NSUserDefaults standardUserDefaults] objectForKey:@"uName"]];
    while ([set next]) {
        NSString *uPwd = [set stringForColumn:@"uPwd"];
        if ([uPwd isEqualToString:pwd]) {
            [[SystemManager manager].db close];
            return YES;
        } else{
            [[SystemManager manager].db close];
            return NO;
        }
    }
    [[SystemManager manager].db close];
    return NO;
}

// 修改密码
- (int)editPasswordWithOldPwd:(NSString *)oldPwd newPwd:(NSString *)newPwd{
    
    if (![self loginWithPwd:oldPwd]) {
        [[SystemManager manager].db close];
        return 1;
    }
    if (![[SystemManager manager].db open]) {
        return 0;
    }
    if ([[SystemManager manager].db executeUpdate:SQL_USER_EDITPWD, newPwd, [[NSUserDefaults standardUserDefaults] objectForKey:@"uName"]]) {
        [[SystemManager manager].db close];
        return 2;
    } else{
        [[SystemManager manager].db close];
        return 0;
    }
}

@end
