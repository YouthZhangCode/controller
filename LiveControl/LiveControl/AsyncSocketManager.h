//
//  AsyncSocketManager.h
//  LiveControl
//
//  Created by fy on 2017/4/26.
//  Copyright © 2017年 LY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"

typedef enum : NSUInteger {
    SocketOfflineByUser,
    SocketOffLineByServer,
} SocketOfflineType;

typedef void(^Success)(NSData *data);

@protocol SocketReceiveMessageDelegate <NSObject>
@optional
- (void)onSocketReceiveDictionary:(NSDictionary *)dict;

@end

@interface AsyncSocketManager : NSObject

@property (nonatomic, assign) SocketOfflineType offlineType;
@property (nonatomic, weak) id<SocketReceiveMessageDelegate>receiveMessageDelegate;

//单例
+ (AsyncSocketManager *)sharedManager;

//连接
- (void)socketConnectHost:(NSString *)hostIPAddress port:(UInt16)port timeout:(CGFloat)timeout;

//断开
- (void)disconnect;

//发送消息
- (void)sendMessage:(NSData *)data;



@end
