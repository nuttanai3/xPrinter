//
//  ZZDataTool.h
//  YiDa
//
//  Created by 李善忠 on 2017/7/11.
//  Copyright © 2017年 SanDu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ZZDataShare [ZZDataTool sharedTool]

@interface ZZDataTool : NSObject

+ (instancetype)sharedTool;

#pragma mark - int 与 NSData 转换

//int转data

-(NSData *)intToData:(int)i;
+ (NSString *)getHexByDecimal:(NSInteger)decimal;

//data转int

-(int)dataToInt:(NSData *)data;

#pragma mark - 字符串与NSData转换

//16进制数字字符串转,转NSData

- (NSData *)hexToBytes:(NSString *)str;

//普通字符串,转NSData

- (NSData *)stringToBytes:(NSString *)str;

//NSdata 转16进制普通字符串

- (NSString *)hexadecimalStringWithData:(NSData *)data;

- (NSString *)hexRepresentationWithSpaces_AS:(BOOL)spaces withData:(NSData *)data;

- (NSString *)hexRepresentationWithSymbol:(NSString *)symbol withData:(NSData *)data;

#pragma mark - 字符串与字符串之间转换

//十六进制数字字符串转换为10进制数字字符串的。

- (NSString *)hexNumberStringToNumberString:(NSString *)hexNumberString;

//十进制数字字符串转换为16进制数字字符串的。

- (NSString *)numberStringToHexNumberString:(NSString *)numberString;

// 十六进制转换为普通字符串的。

- (NSString *)stringFromHexString:(NSString *)hexString;

//普通字符串转换为十六进制的。

- (NSString *)hexStringFromString:(NSString *)string;

#pragma mark - Dictionary 转 Json String

-(NSString *)dictionaryToJsonStr:(id)dic;



@end
