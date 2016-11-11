//
//  AppDelegate.m
//  WXAuthorLogin
//
//  Created by JuanFelix on 02/11/2016.
//  Copyright © 2016 JuanFelix. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"
#import "HDefine.h"
#import "HWeChatAuthorUtils.h"
#import "HWXUserModel.h"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    data = nil;
    
    NSAssert(HWX_AppID.length, @"请填写微信AppKey");
    [WXApi registerApp:HWX_AppID withDescription:@"HDemo"];
    
    return YES;
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [WXApi handleOpenURL:url delegate:self];
}


#pragma mark we chat
- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[SendMessageToWXResp class]]){
        int code = resp.errCode;
        if (code == 0) {//分享成功
        }
    }else if([resp isKindOfClass:[SendAuthResp class]]){//获取授权
        
        //第一步 调起微信 获取 code
        //第二步 通过 code获取 accessToken 和 refreshToken(用来刷新accessToken有效期)
        //第三步 通过accessToken 获取用户基本信息
        SendAuthResp * temp = (SendAuthResp *)resp;
        NSString *strTitle = [NSString stringWithFormat:@"微信返回消息结果"];
        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d myCode:%@ code:%@ lang:%@ country:%@", temp.errCode,temp.state,temp.code,temp.lang,temp.country];
        NSLog(@"%@,%@",strTitle,strMsg);
        if (temp.errCode != 0) {
            if (temp.errCode == -4) {
                NSLog(@"用户拒绝授权");
            }else if (temp.errCode == -2){
                NSLog(@"用户取消授权");
            }
        }else{//获取Access
            [MBProgressHUD showHUDAddedTo:self.window animated:YES];
            [HWeChatAuthorUtils getAccessTokenByCode:temp.code finished:^(id content, BOOL success) {
                
                if (success) {
                    [HWeChatAuthorUtils getUserInfoByAccessToken:content[@"access_token"] andOpenID:content[@"openid"] finished:^(id content, BOOL success) {
                        [MBProgressHUD hideHUDForView:self.window animated:YES];
                        if (success) {
                            NSLog(@"===授权成功===");
                            NSLog(@"%@",content);
                            NSLog(@"======");
                            [[HWXUserModel currentUser] loadData:content];
                            [[NSNotificationCenter defaultCenter] postNotificationName:HAuthor_Success object:nil];
                        }else{
                            NSLog(@"===授权失败===");
                            NSLog(@"%@",content);
                            NSLog(@"======");
                        }
                    }];
                }else{
                    [MBProgressHUD hideHUDForView:self.window animated:YES];
                    NSLog(@"===授权失败===");
                    NSLog(@"%@",content);
                    NSLog(@"======");
                }
            }];
        }
    }
//    else if ([resp isKindOfClass:[PayResp class]]) {
//    }
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
