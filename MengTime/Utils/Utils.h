//
//  Utils.h
//  MSGLogin
//
//  Created by paomoliu on 15/11/20.
//  Copyright (c) 2015年 Sunshine Girls. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (NSRegularExpression *)phoneNumberRegularExpression;
+ (BOOL)checkPhoneNumberValid:(NSString *)phoneNumberString;
+ (BOOL)checkPaswordValid:(NSString *)password;
+ (NSString *)md5String:(NSString *)str;

+ (MBProgressHUD *)createHUD;

+ (void)createAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle;

+ (void)setBackgroundImage:(UIImage *)image view:(UIView *)view;

@end
