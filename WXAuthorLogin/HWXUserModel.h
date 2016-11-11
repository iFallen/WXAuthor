//
//  HWXUserModel.h
//  WXAuthorLogin
//
//  Created by JuanFelix on 02/11/2016.
//  Copyright © 2016 JuanFelix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWXUserModel : NSObject

@property (nonatomic,copy) NSString * city;
@property (nonatomic,copy) NSString * country;
@property (nonatomic,copy) NSString * headimgurl;
@property (nonatomic,copy) NSString * language;
@property (nonatomic,copy) NSString * nickname;
@property (nonatomic,copy) NSString * openid;
@property (nonatomic,copy) NSString * province;
@property (nonatomic,copy) NSString * sex;
@property (nonatomic,copy) NSString * unionid;

@property (nonatomic,assign,readonly) BOOL isLogin;

+(HWXUserModel *)currentUser;

-(void)loadData:(NSDictionary *)dicP;

@end
