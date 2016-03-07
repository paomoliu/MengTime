//
//  LYLoginViewController.m
//  MSGLogin
//
//  Created by paomoliu on 15/11/15.
//  Copyright (c) 2015年 Sunshine Girls. All rights reserved.
//

#import "LYLoginViewController.h"
#import "LYContentSegmentFormatTextFiled.h"
#import "LYRegisterViewController.h"

#import "Utils.h"
#import "MTAPI.h"

@interface LYLoginViewController ()

@property (weak, nonatomic) IBOutlet LYContentSegmentFormatTextFiled    *accountTextFiled;
@property (weak, nonatomic) IBOutlet UITextField                        *passwordTextFiled;
@property (weak, nonatomic) IBOutlet UIButton                           *loginButton;
@property (weak, nonatomic) IBOutlet UIButton                           *visualButton;

- (IBAction)loginWithPhoneNumber:(id)sender;
- (IBAction)loginWithQQ:(id)sender;
- (IBAction)loginWithSina:(id)sender;
- (IBAction)registerNewAccount:(id)sender;
- (IBAction)retrievePassword:(id)sender;
- (IBAction)visualPassword:(id)sender;

@end

@implementation LYLoginViewController
{
    //BOOL isSecuryTextEntry;        //判断密码是否明文显示，默认YES，非明文
    TencentOAuth *tencentOAuth;
    NSArray *permissions;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //isSecuryTextEntry = YES;
    
    _loginButton.enabled = NO;
    _loginButton.alpha = 0.6;
    
    //初始化TencenOAuth对象
    tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1104924013" andDelegate:self];
    
    //设置需要的权限列表
    permissions = [NSArray arrayWithObjects:@"get_user_info", @"get_simple_userinfo", @"add_t", nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeButtonState) name:UITextFieldTextDidChangeNotification object:_accountTextFiled];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeButtonState) name:UITextFieldTextDidChangeNotification object:_passwordTextFiled];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];   //移除所有的监听
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Login and Register Methods

/**
 *  使用手机号登录
 */
- (IBAction)loginWithPhoneNumber:(id)sender {
    NSLog(@"login");
    if (![Utils checkPhoneNumberValid:_accountTextFiled.phoneNumberString]) {
        [Utils createAlertViewWithTitle:@"手机号错误"
                                message:@"你输入的是一个无效的手机号"
                      cancelButtonTitle:@"确定"];
    } else {
        NSString *mpassString = [Utils md5String:_passwordTextFiled.text];
        NSLog(@"md5 passString = %@", mpassString);
        NSLog(@"tel = %@", _accountTextFiled.phoneNumberString);
        
        NSString *url = [NSString stringWithFormat:@"%@", MTAPI_LOGIN];
        NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
        [parametersDic setObject:_accountTextFiled.phoneNumberString forKey:@"tel"];
        [parametersDic setObject:mpassString forKey:@"password"];
        
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:url parameters:parametersDic progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"response = %@", responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            NSLog(@"+++++++++Error = %@", error);
        }];
//        if (1) {
//            DQAlertView *alertView = [[DQAlertView alloc] initWithTitle:@"登录失败"
//                                                                message:@"账号或者密码错误~"
//                                                      cancelButtonTitle:@"我知道了"
//                                                       otherButtonTitle:nil];
//            [alertView show];
//        }
    }
}

/**
 *  使用QQ帐号授权登录
 */
- (IBAction)loginWithQQ:(id)sender {
    [tencentOAuth authorize:permissions inSafari:NO];
}

/**
 *  使用新浪微博帐号授权登录
 */
- (IBAction)loginWithSina:(id)sender {
}

/**
 *  使用手机号注册新账号
 */
- (IBAction)registerNewAccount:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LYRegister" bundle:nil];
    LYRegisterViewController *registerVC = [storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    registerVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self.navigationController pushViewController:registerVC animated:NO];
    //[self presentViewController:registerVC animated:YES completion:nil];
}

/**
 *  找回密码
 */
- (IBAction)retrievePassword:(id)sender {
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

#pragma mark - Close Keyboard Method

/** 关闭键盘 **/
- (IBAction)backgroundTap:(id)sender
{
    [self.accountTextFiled resignFirstResponder];
    [self.passwordTextFiled resignFirstResponder];
}

#pragma mark - Check TextField Is NUll

- (BOOL)checkTextfieldIsNull
{
    if (_accountTextFiled.text.length > 0 && _passwordTextFiled.text.length > 0)
        return NO;
    
    return YES;
}

#pragma mark - Change Button State

/** 改变登陆按钮的状态 **/
- (void)changeButtonState
{
    if (![self checkTextfieldIsNull]) {
        _loginButton.enabled = YES;
        _loginButton.alpha = 1.0;
    } else {
        _loginButton.enabled = NO;
        _loginButton.alpha = 0.6;
    }
}

#pragma mark - UITextFiled Delegate Methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _accountTextFiled) {
        if ([_accountTextFiled.text length] >= 13) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - Tencent Session Delegate

- (void)tencentDidLogin
{
    NSLog(@"qq授权登录成功");
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
    NSLog(@"非网络错误导致登录失败");
}

- (void)tencentDidNotNetWork
{
    NSLog(@"网络错误导致登录失败");
}

@end
