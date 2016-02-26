//
//  LYRegisterViewController.m
//  MSGLogin
//
//  Created by paomoliu on 15/11/15.
//  Copyright (c) 2015年 Sunshine Girls. All rights reserved.
//

#import "LYRegisterViewController.h"
#import "LYVerifyViewController.h"
#import "LYContentSegmentFormatTextFiled.h"
#import "MTAPI.h"
#import "Utils.h"

@interface LYRegisterViewController ()

@property (weak, nonatomic) IBOutlet LYContentSegmentFormatTextFiled    *phoneNumberTextFiled;
@property (weak, nonatomic) IBOutlet UITextField                        *passwordTextFiled;
@property (weak, nonatomic) IBOutlet UIButton                           *visualButton;
@property (weak, nonatomic) IBOutlet UIButton                           *nextStepButton;

- (IBAction)visualPassword:(id)sender;
- (IBAction)nextStep:(id)sender;

@end

@implementation LYRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _nextStepButton.enabled = NO;
    _nextStepButton.alpha = 0.6;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeButtonState) name:UITextFieldTextDidChangeNotification object:_phoneNumberTextFiled];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeButtonState) name:UITextFieldTextDidChangeNotification object:_passwordTextFiled];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  可视化密码
 */
- (IBAction)visualPassword:(id)sender {
    if (_visualButton.selected) {
        _passwordTextFiled.secureTextEntry = NO;
        [_visualButton setImage:[UIImage imageNamed:@"pass_visual"] forState:UIControlStateNormal];
        _visualButton.selected = NO;
    } else {
        _passwordTextFiled.secureTextEntry = YES;
        [_visualButton setImage:[UIImage imageNamed:@"pass_unvisual"] forState:UIControlStateNormal];
        _visualButton.selected = YES;
    }
}

/**
 *  跳入验证码视图
 */
- (IBAction)nextStep:(id)sender
{
    [self closeKeyboard];   //解决在进入验证码视图时，会出现键盘的闪现效果
    
    BOOL isValidTel = [Utils checkPhoneNumberValid:_phoneNumberTextFiled.phoneNumberString];
    BOOL isValidPass = [Utils checkPaswordValid:_passwordTextFiled.text];
    
    if (isValidTel && isValidPass) {  //还要做网络检测
        NSString *phoneStr = _phoneNumberTextFiled.phoneNumberString;
        NSString *message = [NSString stringWithFormat:@"我们将发送验证码短信到这个号码：\n%@", phoneStr];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认手机号"
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"好", nil];
        
        [alertView show];
    } else {
        if (!isValidTel) {
            [Utils createAlertViewWithTitle:@"手机号码错误"
                                    message:@"你输入的是一个无效的手机号码"
                          cancelButtonTitle:@"确定"];
        } else if (!isValidPass){
            [Utils createAlertViewWithTitle:@"登录密码错误，请重新填写"
                                    message:@"密码应为8～16位，支持英文数字"
                          cancelButtonTitle:@"我知道了"];
        } else {
            [Utils createAlertViewWithTitle:@"注册失败"
                                    message:@"网络无反应，请稍候重新注册"
                          cancelButtonTitle:@"确定"];
        }
    }
}

#pragma mark - Close Keyboard Method

/**
 *  关闭键盘
 */
- (IBAction)backgroundTap:(id)sender
{
    [_phoneNumberTextFiled resignFirstResponder];
    [_passwordTextFiled resignFirstResponder];
}

- (void)closeKeyboard
{
    [self.view endEditing:YES];
    [_passwordTextFiled becomeFirstResponder];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma mark - Check TextField Method

- (BOOL)checkTextfieldIsNull
{
    if (_phoneNumberTextFiled.text.length > 0 && _passwordTextFiled.text.length > 0)
        return NO;
    
    return YES;
}

#pragma mark - Change Button State

/** 改变登陆按钮的状态 **/
- (void)changeButtonState
{
    if (![self checkTextfieldIsNull]) {
        _nextStepButton.enabled = YES;
        _nextStepButton.alpha = 1.0;
    } else {
        _nextStepButton.enabled = NO;
        _nextStepButton.alpha = 0.6;
    }
}

#pragma mark - UIAlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LYRegister" bundle:nil];
        LYVerifyViewController *verfyVC = [storyboard instantiateViewControllerWithIdentifier:@"VerifyViewController"];
        verfyVC.telephone = _phoneNumberTextFiled.phoneNumberString;
        verfyVC.password = _passwordTextFiled.text;
        
        [self.navigationController pushViewController:verfyVC animated:YES];
        
//        MBProgressHUD *hud = [Utils createHUD];
//        hud.labelText = @"正在请求";
//        
//        NSString *url = [NSString stringWithFormat:@"%@", MTAPI_REQUEST_CODE];
//        NSMutableDictionary *parameterDic = [NSMutableDictionary dictionary];
//        [parameterDic setObject:_phoneNumberTextFiled.phoneNumberString forKey:@"tel"];
//        
//        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//        
//        [manager POST:url parameters:parameterDic progress:nil success:^(NSURLSessionDataTask *task, id responsObject) {
//            [hud hide:YES];
//            
//            NSLog(@"JSON: %@", responsObject);
//            
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LYRegister" bundle:nil];
//            LYVerifyViewController *verfyVC = [storyboard instantiateViewControllerWithIdentifier:@"VerifyViewController"];
//            verfyVC.telephone = _phoneNumberTextFiled.phoneNumberString;
//            verfyVC.password = _passwordTextFiled.text;
//            
//            [self.navigationController pushViewController:verfyVC animated:YES];
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            NSLog(@"Error: %@", error);
//        }];
    }
}

@end
