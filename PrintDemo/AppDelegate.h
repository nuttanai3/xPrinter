//
//  AppDelegate.h
//  PrintDemo
//
//  Created by samlee123 on 2018/5/1.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSDK.h"

#define SharedAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//是否连接蓝牙
@property (assign, nonatomic) BOOL isConnectedBLE;
//是否连接Wi-Fi
@property (assign, nonatomic) BOOL isConnectedWIFI;

@end

