//
//  PassWordVC.m
//  MyApp1.1
//
//  Created by qingyun on 16/8/28.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "VertifyVC.h"
#import "RegisterVC.h"
#import "AVOSCloud/AVOSCloud.h"
#import "AppDelegate.h"

@interface VertifyVC ()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txfConfirmCode;
@property (nonatomic, strong) NSString *phoneNum;

@end

@implementation VertifyVC

#if 0
- (IBAction)ReReciveConfirmCode:(id)sender {
   
    
    [AVUser requestMobilePhoneVerify:self.phoneNum withBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded){
            //发送成功
            NSLog(@"发送成功");
        }else{
            NSLog(@"发送失败%@",error);
        }
    }];
    
}

#endif
- (IBAction)finishBtn:(id)sender {
    
    [AVUser verifyMobilePhone:self.txfConfirmCode.text withBlock:^(BOOL succeeded, NSError *error) {
        //验证结果
        if (error) {
            NSLog(@"verify error %@",error);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证失败，请重新输入" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil ,nil];
            [alert show];
            
        }else{
            NSLog(@"verify success");
            AppDelegate *app = [[UIApplication sharedApplication]delegate];
            [app changeToTrainVC];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"跳转到首页", @"去完善信息" ,nil];
            [alert show];
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
        [delegate changeToUpdateInfo];
    }else if (buttonIndex == 0){
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        [delegate changeToTrainVC];
    }
    
}


@end
