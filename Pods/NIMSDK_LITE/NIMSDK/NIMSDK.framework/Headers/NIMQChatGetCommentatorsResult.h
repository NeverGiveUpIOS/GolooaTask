//
// Created by 陈吉力 on 2024/1/25.
// Copyright (c) 2024 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIMQChatCommentator.h"

@interface NIMQChatGetCommentatorsResult: NSObject
/// 评论者列表
@property (nonatomic, strong, readonly) NSArray<NIMQChatCommentator *> *commentators;
/// 是否还有下一页
@property (nonatomic, assign, readonly) BOOL hasMore;
/// 分页标识，用于下一页请求
@property (nonatomic, copy, readonly) NSString *pageToken;
/// 评论者总数
@property (nonatomic, assign, readonly) NSUInteger total;
@end