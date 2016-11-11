//
//  HWXUserModel.m
//  WXAuthorLogin
//
//  Created by JuanFelix on 02/11/2016.
//  Copyright © 2016 JuanFelix. All rights reserved.
//

#import "HWXUserModel.h"

static HWXUserModel * wxUser = nil;

@interface HWXUserModel()

@property (nonatomic,assign) BOOL loggedin;

@end

@implementation HWXUserModel

+(HWXUserModel *)currentUser{
    if (wxUser == nil) {
        wxUser = [[HWXUserModel alloc] init];
    }
    return wxUser;
}

-(instancetype)init{
    if (self = [super init]) {
        self.loggedin = false;
    }
    return self;
}


-(void)loadData:(NSDictionary *)dicP{
    if ([dicP isKindOfClass:[NSDictionary class]] && [dicP count]) {
        self.loggedin = true;
        [self setValuesForKeysWithDictionary:dicP];
    }else{
        wxUser = nil;
    }
}


-(BOOL)isLogin{
    return self.loggedin;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
