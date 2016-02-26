//
//  Utils.m
//  MSGLogin
//
//  Created by paomoliu on 15/11/20.
//  Copyright (c) 2015年 Sunshine Girls. All rights reserved.
//

#import "Utils.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Utils

/**
 *  创建一个电话号码的正则表达式实例
 *
 *  @return 返回创建的正则表达式实例
 */
+ (NSRegularExpression *)phoneNumberRegularExpression
{
    return [NSRegularExpression regularExpressionWithPattern:@"[^0-9]+"   //^用在一行开头，它匹配必须以0～9开头；＋匹配它之前的元素一次或多次
                                                     options:0
                                                       error:nil];
}

/**
 *  验证手机号格式是否正确
 *
 *  @return 文本框中手机号格式正确返回YES，否则返回NO
 */
+ (BOOL)checkPhoneNumberValid:(NSString *)phoneNumberString
{
    /**
     *  手机号码
     *  移动：134[0-8],135,136,137,138,139,150,151,152,157[0-79],158,159,178,182,183,184,187,188
     *  联通：130,131,132,155,156,176,185,186
     *  电信：133,153,177,180,181,189
     */
    NSString *CM = @"^1(34[0-8]|57[0-79]|(3[5-9]|5[0-289]|78|8[2-478])\\d)\\d{7}$";     //中国移动：China Mobile
    NSString *CU = @"^1(3[0-2]|5[56]|76|8[56])\\d{8}$";                                 //中国联通：China Unicom
    NSString *CT = @"^1(33|53|77|8[019])\\d{8}$";                                     //中国电信：China Telecom
    
    NSPredicate *predicateCM = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *predicateCU = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *predicateCT = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    BOOL resultCM = [predicateCM evaluateWithObject:phoneNumberString];
    BOOL resultCU = [predicateCU evaluateWithObject:phoneNumberString];
    BOOL resultCT = [predicateCT evaluateWithObject:phoneNumberString];
    
    if (resultCM || resultCU || resultCT) {
        return YES;
    }
    
    return NO;
}

/**
 *  验证注册时，密码设置是否有效
 *
 *  @param password 设置的账号密码
 *
 *  @return 注册时文本框中设置的密码格式正确返回YES，否则返回NO
 */
+ (BOOL)checkPaswordValid:(NSString *)password
{
    NSString *match = @"^[A-Za-z0-9]{8,16}+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", match];
    
    if ([predicate evaluateWithObject:password]) {
        return YES;
    }
    
    return NO;
}

/**
 *  对密码进行MD5加密
 *
 *  @param str 密码
 *
 *  @return 返回加密后的密码字符串
 */
+ (NSString *)md5String:(NSString *)str
{
    const char *string = str.UTF8String;
    int length = (int)strlen(string);
    unsigned char bytes[CC_MD5_DIGEST_LENGTH];  //开一个16字节（128位：md5加密出来是128位）的空间
    
    CC_MD5(string, length, bytes);  //官方封装好的加密方法，把string字符串转换成32位16进制数列，存储到bytes这个空间中
    
    NSMutableString *hash = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02X", bytes[i]];  //X表示16进制，%02表示不足两位用0补齐，如果多余两位不影响
    }
    
    return hash;
}

+ (MBProgressHUD *)createHUD
{
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:window];
    hud.mode = MBProgressHUDModeDeterminate;
    [window addSubview:hud];
    [hud show:YES];
    hud.removeFromSuperViewOnHide = YES;
    
    return hud;
}

+ (void)createAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:cancelButtonTitle
                                              otherButtonTitles:nil];
    
    [alertView show];
}

/**
 *  给视图添加背景图
 *
 *  @param image 背景图
 *  @param view  要添加背景图的视图
 */
+ (void)setBackgroundImage:(UIImage *)image view:(UIView *)view
{
    UIColor *bgColor = [UIColor colorWithPatternImage:image];
    [view setBackgroundColor:bgColor];
}

@end
