//
//  HWeChatAuthorUtils.h
//  qcrm
//
//  Created by JuanFelix on 8/22/15.
//  Copyright (c) 2015 SKKJ-JuanFelix. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^HFinished)(id content,BOOL success) ;

@interface HWeChatAuthorUtils : NSObject

//通过Code 获取 AccessToken
+(void)getAccessTokenByCode:(NSString *)code
                   finished:(HFinished)finished;

//通过AccessToken 获取 用户信息
+(void)getUserInfoByAccessToken:(NSString *)accToken
                      andOpenID:(NSString *)openID
                       finished:(HFinished)finished;
@end
