//
// Created by 陈吉力 on 2024/1/25.
// Copyright (c) 2024 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIMQChatCommentator: NSObject
/// 账号
@property(nonatomic, copy, readonly)NSString *accountId;
/// 昵称
@property(nonatomic, copy, readonly)NSString *nick;
/// 头像
@property(nonatomic, copy, readonly)NSString *avatar;
/// 操作时间
@property(nonatomic, assign, readonly) NSTimeInterval createTime;
@end