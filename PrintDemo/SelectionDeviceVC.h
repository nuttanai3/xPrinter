//
//  SelectionDeviceVC.h
//  Printer
//
//  Created by 李善忠 on 2017/10/20.
//  Copyright © 2017年 李善忠. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^VoidBlock_id)(id);

#define ConnectBleSuccessNote @"ConnectBleSuccessNote"

@class CBPeripheral, CBCharacteristic;

@interface SelectionDeviceVC : UITableViewController

@property (nonatomic, strong)VoidBlock_id callBack;

+ (instancetype)controller;

#pragma mark - MSDKDelegate// 发现周边
- (void)MdidUpdatePeripheralList:(NSArray *)peripherals RSSIList:(NSArray *)rssiList;
// 连接周边
- (void)MdidConnectPeripheral:(CBPeripheral *)peripheral;
// 连接失败
- (void)MdidFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;
// 断开连接
- (void)MdidDisconnectPeripheral:(CBPeripheral *)peripheral isAutoDisconnect:(BOOL)isAutoDisconnect;
// 发送数据成功
- (void)MdidWriteValueForCharacteristic:(CBCharacteristic *)character error:(NSError *)error;

@end
