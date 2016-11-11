//
//  HWeChatAuthorUtils.m
//  qcrm
//
//  Created by JuanFelix on 8/22/15.
//  Copyright (c) 2015 SKKJ-JuanFelix. All rights reserved.
//

#import "HWeChatAuthorUtils.h"
#import "HDefine.h"

@implementation HWeChatAuthorUtils

+(void)getAccessTokenByCode:(NSString *)code
                   finished:(HFinished)afinished{
    NSString * getAccTokenReqURL = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",HWX_AppID,HWX_Secret,code];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:getAccTokenReqURL];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",dic);
                NSString * str = dic[@"errmsg"];
                if ([str isKindOfClass:[NSString class]] && str.length) {
                    if (afinished) {
                        afinished(@"获取Access_Token失败",NO);
                    }
                }else{
                    if (afinished) {
                        afinished(dic,YES);
                    }
                }
            }else{
                if (afinished) {
                    afinished(@"获取用户微信信息失败",NO);
                }
            }
        });
    });
}

+(void)getUserInfoByAccessToken:(NSString *)accToken
                      andOpenID:(NSString *)openID
                       finished:(HFinished)finished{
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accToken,openID];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSString * str = dic[@"errmsg"];
                if ([str isKindOfClass:[NSString class]] && str.length) {
                    if (finished) {
                        finished(@"获取用户微信信息失败",NO);
                    }
                }else{
                    if (finished) {
                        finished(dic,YES);
                    }
                }
            }else{
                if (finished) {
                    finished(@"获取用户微信信息失败",NO);
                }
            }
        });
    });
}

@end
