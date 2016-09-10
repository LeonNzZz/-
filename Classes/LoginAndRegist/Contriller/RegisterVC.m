//
//  RegisterVC.m
//  MyApp1.1
//
//  Created by qingyun on 16/8/27.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RegisterVC.h"
#import <AVOSCloud/AVOSCloud.h>

@interface RegisterVC ()
//@property (strong, nonatomic) IBOutlet UITextField *txfPhoneNum;
@property (weak, nonatomic) IBOutlet UILabel *lblTip;
@property (weak, nonatomic) IBOutlet UITextField *txfPassword;
//15617646898
//15137838603
@end

@implementation RegisterVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.txfPhoneNum.placeholder = @"请输入手机号";
    self.txfPassword.placeholder = @"请输入密码";
    //安全输入
    self.txfPassword.secureTextEntry = YES;
}
- (IBAction)getCode:(id)sender
{

    //正则手机号
    NSPredicate *prePhone = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[1][358][0-9]{9}$"];
    if (![prePhone evaluateWithObject:self.txfPhoneNum.text]) {
        //输入不不正确的时候（不在正则之内的数字）
        self.lblTip.text = @"请输入正确的手机号";
    }else{
        //输入手机号之后
        AVUser *user = [AVUser user];
        user.username = self.txfPhoneNum.text;
        user.password =  self.txfPassword.text;
        user.email = nil;
        user.mobilePhoneNumber = self.txfPhoneNum.text;
        NSError *error = nil;
        [user signUp:&error];
        NSLog(@"%@",error);
    }
    
#if 0
    [AVUser requestMobilePhoneVerify:self.txfPhoneNum.text withBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded){
            //发送成功
        }
    }];
    
        [AVOSCloud requestSmsCodeWithPhoneNumber:self.txfPhoneNum.text callback:^(BOOL succeeded, NSError *error) {
            if (error) {
                NSLog(@"短信验证失败%@",error);
            }else{
                NSLog(@"验证成功");
            }
        }];
    NSPredicate *prePhone = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[1][358][0-9]{9}$"];
    if ([prePhone evaluateWithObject:self.txfPhoneNum.text]) {
        //AVUser存储手机号
        AVUser *user = [[AVUser alloc] init];
        user.username = self.txfPhoneNum.text;
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                NSLog(@"保存失败：%@",error);
            }else{
                NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                [def setObject:user.username forKey:self.txfPhoneNum.text];
                //异步存储
                [def synchronize];
            }
        }];

    }else{
        self.lblTip.text = @"请输入正确的手机号";
    }
#endif
}
@end
