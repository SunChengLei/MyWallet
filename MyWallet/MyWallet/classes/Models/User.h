//
//  User.h
//  MyWallet
//
//  Created by 美鑫科技 on 16/6/22.
//  Copyright © 2016年 MorpLCP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, assign) NSInteger uId; // 编号
@property (nonatomic, copy) NSString *uPwd; // 密码
@property (nonatomic, copy) NSString *uNickName; // 昵称
@property (nonatomic, strong) NSData *uHeaderPicture; // 头像

@end
