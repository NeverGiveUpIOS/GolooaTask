
//
//  NIMQChatGetExistingChannelBlackWhiteRolesParam.h
//  NIMSDK
//
//  Created by Evang on 2022/2/15.
//  Copyright © 2022 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIMQChatDefs.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  
 */
@interface NIMQChatGetExistingChannelBlackWhiteRolesParam : NSObject

/**
 * 服务器id
 */
@property (nonatomic, assign) unsigned long long  serverId;

/**
 * 频道id
 */
@property (nonatomic, assign) unsigned long long  channelId;

/**
 * 成员身份组类型
 */
@property (nonatomic, assign) NIMQChatChannelMemberRoleType type;

/**
 * 身份组roleid数组
 */
@property (nonatomic, copy) NSArray <NSNumber *> *roleIds;

@end

NS_ASSUME_NONNULL_END

