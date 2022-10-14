//
//  ZZDataTool.m
//  YiDa
//
//  Created by 李善忠 on 2017/7/11.
//  Copyright © 2017年 SanDu. All rights reserved.
//

#import "ZZDataTool.h"

@implementation ZZDataTool

+ (instancetype)sharedTool {
    
    static id instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc] init];
        
    });
    
    return instance;
    
}
#pragma mark - int 与 NSData 转换

/**
 十进制转换十六进制
 
 @param decimal 十进制数
 @return 十六进制数
 */
+ (NSString *)getHexByDecimal:(NSInteger)decimal {
    
    NSString *hex =@"";
    NSString *letter;
    NSInteger number;
    for (int i = 0; i<9; i++) {
        
        number = decimal % 16;
        decimal = decimal / 16;
        switch (number) {
                
            case 10:
                letter =@"A"; break;
            case 11:
                letter =@"B"; break;
            case 12:
                letter =@"C"; break;
            case 13:
                letter =@"D"; break;
            case 14:
                letter =@"E"; break;
            case 15:
                letter =@"F"; break;
            default:
                letter = [NSString stringWithFormat:@"%ld", number];
        }
        hex = [letter stringByAppendingString:hex];
        if (decimal == 0) {
            
            break;
        }
    }
    return hex;
}



//int转data

-(NSData *)intToData:(int)i{
    
    NSData *data = [NSData dataWithBytes: &i length: sizeof(i)];
    
    return data;
    
}
//data转int

-(int)dataToInt:(NSData *)data{
    
    int i;
    
    [data getBytes:&i length:sizeof(i)];
    
    return i;
    
}
#pragma mark - 字符串与NSData转换

//16进制字符转(不带0x),转NSData

-(NSData *)hexToBytes:(NSString *)str{
    
    NSMutableData * data = [NSMutableData data];
    
    for (int i = 0; i+2 <= str.length; i+=2) {
        
        NSString * subString = [str substringWithRange:NSMakeRange(i, 2)];
        
        NSScanner * scanner = [NSScanner scannerWithString:subString];
        
        uint number;
        
        [scanner scanHexInt:&number];
        
        [data appendBytes:&number length:1];
        
    }
    return data.copy;
    
}
//普通字符串,转NSData

- (NSData *)stringToBytes:(NSString *)str{
    
    return [str dataUsingEncoding:NSASCIIStringEncoding];
    
}
//NSdata 转16进制字符串

- (NSString *)hexadecimalStringWithData:(NSData *)data

{
    
    /* Returns hexadecimal string of NSData. Empty string if data is empty.  */
    
    const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
    
    if (!dataBuffer)
        
    {
        
        return [NSString string];
        
    }
    NSUInteger          dataLength  = [data length];
    
    NSMutableString    *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i)
        
    {
        
        [hexString appendFormat:@"%02x", (unsigned int)dataBuffer[i]];
        
    }
    return [NSString stringWithString:hexString];
    
}

@end
