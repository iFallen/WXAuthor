//
//  ViewController.m
//  WXAuthorLogin
//
//  Created by JuanFelix on 02/11/2016.
//  Copyright © 2016 JuanFelix. All rights reserved.
//

#import "ViewController.h"
#import "WXApi.h"
#import "HDefine.h"
#import "HWXUserModel.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgHeader;
@property (weak, nonatomic) IBOutlet UILabel *lbNickName;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loggedinAction) name:HAuthor_Success object:nil];
}

-(void)loggedinAction{
    HWXUserModel * wxUserInfo = [HWXUserModel currentUser];
    if ([wxUserInfo isLogin]) {

        dispatch_async(dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData * imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:wxUserInfo.headimgurl]];
            UIImage * image = [UIImage imageWithData:imgData];
            [self.imgHeader performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:false];
        });
        self.lbNickName.text = wxUserInfo.nickname;
    }
}

- (IBAction)authorAction:(id)sender {
    if ([WXApi isWXAppInstalled]) {
        //构造SendAuthReq结构体
        SendAuthReq* req =[[SendAuthReq alloc ] init];
        //    req.scope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact,post_timeline,sns";
        req.scope = @"snsapi_userinfo";
        req.state = @"123" ;//区分请求，同tag
        //第三方向微信终端发送一个SendAuthReq消息结构
        /** 由用户微信号和AppID组成的唯一标识，发送请求时第三方程序必须填写，用于校验微信用户是否换号登录*/
        //    req.openID = @"op0n5vlD9ribrZ2jeZ4S7_cw1qjs";
        //    op0n5voRT_lZbNRlPZ9Li0znAce8
        [WXApi sendReq:req];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
