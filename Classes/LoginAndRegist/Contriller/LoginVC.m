//
//  ViewController.m
//  MyApp1.1
//
//  Created by qingyun on 16/8/27.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "LoginVC.h"
#import <AVOSCloud/AVOSCloud.h>
#import "AppDelegate.h"

@interface LoginVC ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgBack;
@property (weak, nonatomic) IBOutlet UITextField *txfUserName;
@property (weak, nonatomic) IBOutlet UITextField *txfPassWord;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.txfUserName becomeFirstResponder];
    self.navigationController.navigationBarHidden = YES;
    //不扩展边
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.txfPassWord.secureTextEntry = YES;
}
- (IBAction)loginBtn:(id)sender {
    //手机号和密码登录，但是不应该是需要传值的吗？应该需要将服务其中的数据读取出来，而后进行验证
    [AVUser logInWithMobilePhoneNumberInBackground:self.txfUserName.text password:self.txfPassWord.text block:^(AVUser *user, NSError *error) {
        if (!error) {
            NSLog(@"登陆成功！");
            AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
            [delegate changeToTrainVC];
        }else{
//            NSLog(@"登录失败");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"用户名或密码错误" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
            [alert show];
        }
            
    }];
}

- (IBAction)ForgetPassword:(id)sender {
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}

@end
