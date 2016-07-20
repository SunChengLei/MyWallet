//
//  UserManager.h
//  MyWallet
//
//  Created by 美鑫科技 on 16/6/22.
//  Copyright © 2016年 MorpLCP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import <UIKit/UIKit.h>

@interface UserManager : NSObject

+ (instancetype)manager;

// 增加用户
- (BOOL)addUserWithNickName:(NSString *)nickName UPwd:(NSString *)uPwd Money:(double)money HeaderPicture:(UIImage *)image;

// 修改用户
- (BOOL)editUserWithPic:(UIImage *)image UnickName:(NSString *)uNickName;

// 登录
- (BOOL)loginWithPwd:(NSString *)pwd;

// 修改密码
- (int)editPasswordWithOldPwd:(NSString *)oldPwd newPwd:(NSString *)newPwd;

// 获取当前用户ID
- (NSInteger)currentUserId;

@end
