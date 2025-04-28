//
// Created by 陈吉力 on 2024/1/25.
// Copyright (c) 2024 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface NIMQChatGetCommentatorsParam: NSObject
/// 服务器id
@property(nonatomic, assign)unsigned long long serverId;

/// 频道id
@property(nonatomic, assign)unsigned long long channelId;

/// 评论类型
@property(nonatomic, assign)NSInteger type;

/// 服务端消息id
@property(nonatomic, copy)NSString *messageServerId;

/// 返回数量，默认100，最大100(可配置)
@property(nonatomic, assign)NSInteger limit;

/// 分页token
@property(nonatomic, copy)NSString * pageToken;

@end
NS_ASSUME_NONNULL_END