//
//  LYVerifyViewController.m
//  MSGLogin
//
//  Created by paomoliu on 15/11/15.
//  Copyright (c) 2015年 Sunshine Girls. All rights reserved.
//

#import "LYVerifyViewController.h"
#import "MTAPI.h"
#import "Utils.h"

static const int KVerifyCodeLength = 6;
static const int KCountDownSeconds = 60;  //倒计时总长

@interface LYVerifyViewController ()

@property (weak, nonatomic) IBOutlet UILabel        *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UITextField    *verificationCodeTextFiled;
@property (weak, nonatomic) IBOutlet UIButton       *acquireCodeButton;
@property (weak, nonatomic) IBOutlet UIButton       *accomplishButton;
@property (weak, nonatomic) IBOutlet UILabel        *timeLabel;
@property (weak, nonatomic) IBOutlet UIView         *acquireCodeView;

@property (weak, nonatomic) NSTimer *timer;

- (IBAction)reacquireVerificationCode:(id)sender;
- (IBAction)acomplishRegister:(id)sender;

@end

@implementation LYVerifyViewController
{
    int countDownSeconds;
}

//在倒计时未停止时，还需使倒计时停止，不然当进入其他页面时，它仍然未停止

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"验证码";
    
    _accomplishButton.enabled = NO;
    _accomplishButton.alpha = 0.6;
    
    countDownSeconds = KCountDownSeconds;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                       target:self
                                                     selector:@selector(timerFire)
                                                     userInfo:nil
                                                      repeats:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeButtonStateAndLimitLength) name:UITextFieldTextDidChangeNotification object:_verificationCodeTextFiled];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Count Down Handle

- (void)timerFire
{
    countDownSeconds--;
    
    int seconds = countDownSeconds;
    
    if (countDownSeconds == 0) {
        [_timer invalidate];  //停止倒计时
        
        _timeLabel.hidden = YES;        
        _acquireCodeView.hidden = NO;
    } else {
        [_timeLabel setText:[NSString stringWithFormat:@"%d", seconds]];
    }
}

#pragma mark - IBAction Methods

/**
 *  重新获取验证码
 */
- (IBAction)reacquireVerificationCode:(id)sender {
    MBProgressHUD *hud = [Utils createHUD];
    hud.labelText = @"正在请求";
    
    NSString *url = [NSString stringWithFormat:@"%@", MTAPI_REQUEST_CODE];
    NSMutableDictionary *parameterDic = [NSMutableDictionary dictionary];
    [parameterDic setObject:_telephone forKey:@"tel"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:url parameters:parameterDic progress:nil success:^(NSURLSessionDataTask *task, id responsObject) {
        [hud hide:YES];
        
        //重新启动倒计时
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

/**
 *  完成注册
 */
- (IBAction)acomplishRegister:(id)sender {
    NSString *mpassStr = [Utils md5String:_password];
    NSString *url = [NSString stringWithFormat:@"%@", MTAPI_REGISTER];
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    [parametersDic setObject:_telephone forKey:@"tel"];
    [parametersDic setObject:mpassStr forKey:@"password"];
    [parametersDic setObject:_verificationCodeTextFiled.text forKey:@"code"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:url parameters:parametersDic progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - Close Keyboard Method

/**
 *  关闭键盘
 */
- (IBAction)backgroundTap:(id)sender
{
    [self.verificationCodeTextFiled resignFirstResponder];
}

#pragma mark - Change Button State

/**
 *  改变登陆按钮的状态以及限制验证码输入长度
 */
- (void)changeButtonStateAndLimitLength
{
    if (_verificationCodeTextFiled.text.length > 0) {
        _accomplishButton.enabled = YES;
        _accomplishButton.alpha = 1.0;
    } else {
        _accomplishButton.enabled = NO;
        _accomplishButton.alpha = 0.6;
    }
    
    if (_verificationCodeTextFiled.text.length > KVerifyCodeLength)
        _verificationCodeTextFiled.text = [_verificationCodeTextFiled.text substringToIndex:KVerifyCodeLength];
}

@end
