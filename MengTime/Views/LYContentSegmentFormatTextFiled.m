//
//  LYContentSegmentFormatTextFiled.m
//  MSGLogin
//
//  Created by paomoliu on 15/11/17.
//  Copyright (c) 2015年 Sunshine Girls. All rights reserved.
//

#import "LYContentSegmentFormatTextFiled.h"

#import "Utils.h"

@interface LYContentSegmentFormatTextFiled () <UITextFieldDelegate>
{
    NSString *previousText;                         //保存TextFiled改变前的文本
}

@property (strong, nonatomic)NSRegularExpression *noSpacesPhoneNumberRegularEx;

@end

@implementation LYContentSegmentFormatTextFiled

@synthesize phoneNumberString;

- (instancetype)initWithFrame:(CGRect)frame
{
    NSLog(@"initWithFrame");
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
        [self addTarget:self
                 action:@selector(reformatPhoneNumber:)
       forControlEvents:UIControlEventEditingChanged];
        self.noSpacesPhoneNumberRegularEx = [Utils phoneNumberRegularExpression];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    NSLog(@"initWithCoder");
    if (self = [super initWithCoder:aDecoder]) {
        self.delegate = self;
        [self addTarget:self
                 action:@selector(reformatPhoneNumber:)
       forControlEvents:UIControlEventEditingChanged];
        self.noSpacesPhoneNumberRegularEx = [Utils phoneNumberRegularExpression];
    }
    
    return self;
}

#pragma mark - TextFiled Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"shouldChangeCharactersInRange");
    previousText = textField.text;                      //保存修改前的文本
    
    NSLog(@"textFiled text = %@", textField.text);
    NSLog(@"string = %@", string);
    
    return YES;        //返回YES，表示修改生效；反之，不做修改，即textFiled的内容不变
}

#pragma mark - Reformat Phone Number Methods

/**
 *  重新定制文本框中手机号显示的格式
 *
 *  @param textFiled 需要更换文本显示格式的文本框
 */
- (void)reformatPhoneNumber:(UITextField *)textFiled
{
    NSLog(@"reformatPhoneNumber");
    NSLog(@"textFiled is %@", textFiled.text);
    
    NSString *phoneNumberWithoutSpaces = [self phoneNumberStringWithoutSpaces:textFiled.text];
    NSLog(@"phoneNumberWithoutSpaces is %@", phoneNumberWithoutSpaces);
    if ([phoneNumberWithoutSpaces length] >= 11)
        phoneNumberString = [phoneNumberWithoutSpaces substringToIndex:11];
    if ([phoneNumberWithoutSpaces length] > 11) {
        NSLog(@"1111111");
        textFiled.text = previousText;
        return;
    }
    
    NSString *phoneNumberWithSpaces = [self insertSpacesToPhoneNumberString:phoneNumberWithoutSpaces];
    
    textFiled.text = phoneNumberWithSpaces;
    NSLog(@"\n");
}

/**
 *  去掉字符串中的空格
 *
 *  @param string 手机号字符串
 *
 *  @return 返回无空格的手机号字符串
 */
- (NSString *)phoneNumberStringWithoutSpaces:(NSString *)string
{
    NSLog(@"phoneNumberStringWithoutSpaces");
    NSLog(@"string = %@", string);
    return [self.noSpacesPhoneNumberRegularEx stringByReplacingMatchesInString:string                            //搜索的字符串
                                                                       options:0                                 //
                                                                         range:NSMakeRange(0, string.length)     //字符串搜索的范围
                                                                  withTemplate:@""];                             //替换匹配时使用的替换字符
}

/**
 *  向手机号字符串中插入空格
 *
 *  @param string 无空格的手机号字符串
 *
 *  @return 返回插入空格的手机号字符串
 */
- (NSString *)insertSpacesToPhoneNumberString:(NSString *)string
{
    NSLog(@"insertSpacesToPhoneNumberString");
    NSMutableString *formattedString = [NSMutableString string];
    NSUInteger stringLength = [string length];
    
    for (NSUInteger i = 0; i < stringLength; i++) {
        if (i == 3 || i == 7) {
            [formattedString appendString:@" "];
        }
        
        unichar character = [string characterAtIndex:i];
        NSString *stringToAdd = [NSString stringWithCharacters:&character length:1];
        
        [formattedString appendString:stringToAdd];
    }

    return formattedString;
}

@end
