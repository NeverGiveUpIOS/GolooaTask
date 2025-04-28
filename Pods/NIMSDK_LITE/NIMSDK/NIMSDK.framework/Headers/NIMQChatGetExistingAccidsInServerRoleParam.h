
//
//  NIMQChatGetExistingAccidsInServerRoleParam.h
//  NIMSDK
//
//  Created by Evang on 2022/2/15.
//  Copyright © 2022 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,NIMQChatServerRoleSortType)
{
    NIMQChatServerRoleSortByCreateTime = 1,
    NIMQChatServerRoleSortByPrecedence = 2
};

typedef NS_ENUM(NSInteger,NIMQChatServerRoleSortOrder)
{
    NIMQChatServerRoleSortAsc = 1,
    NIMQChatServerRoleSortDesc = 2
};

/**
 *  查询一批accids的自定义身份组列表
 */
@interface NIMQChatGetExistingAccidsInServerRoleParam : NSObject

/**
 * 服务器id
 */
@property (nonatomic, assign) unsigned long long  serverId;
/**
 * 用户accid数组
 */
@property (nonatomic, copy) NSArray <NSString *> *accids;
/**
 * 排序方式，默认值 NIMQChatServerRoleSortByCreateTime
 */
@property (nonatomic, assign)  NIMQChatServerRoleSortType sortType;
/**
 * 排序类型，默认值 NIMQChatServerRoleSortDesc
 */
@property (nonatomic, assign)  NIMQChatServerRoleSortOrder order;


@end

NS_ASSUME_NONNULL_END

