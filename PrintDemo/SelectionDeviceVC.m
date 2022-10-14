//
//  SelectionDeviceVC.m
//  Printer
//
//  Created by 李善忠 on 2017/10/20.
//  Copyright © 2017年 李善忠. All rights reserved.
//

#import "SelectionDeviceVC.h"
#import "SelectionDeviceCell.h"
#import "MBLEManager.h"
#import "ProgressHUD.h"
#import "AppDelegate.h"
#import "PosCommand.h"
#import "TscCommand.h"

@interface SelectionDeviceVC ()<MBLEManagerDelegate,UITabBarDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTable;

@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSArray *rssiList;
@property (nonatomic,strong) MBLEManager *manager;
@property (weak, nonatomic) IBOutlet UIButton *refleshBtn;

@end

@implementation SelectionDeviceVC

#pragma mark - lazy
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}


+ (instancetype)controller{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SelectionDeviceVC *vc = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];


    self.navigationItem.title = @"蓝牙选择";
    self.manager = [MBLEManager sharedInstance];
    self.manager.delegate = self;
    [self.manager MstartScan];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 71;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SelectionDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectionDeviceCellID" forIndexPath:indexPath];
    
    CBPeripheral *peripheral = self.dataArr[indexPath.row];
    
    cell.titleLable.text = peripheral.name;
    
    NSNumber *rssi =_rssiList[indexPath.row];

    cell.subTitleLabel.text = [NSString stringWithFormat:@"RSSI:%zd",rssi.integerValue];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    CBPeripheral *peripheral = self.dataArr[indexPath.row];
    NSString *message =  [NSString stringWithFormat:@"正在连接%@",peripheral.name];
    [ProgressHUD show:message];
    // 连接周边
    
    
    [self.manager MconnectDevice:peripheral];
    self.manager.writePeripheral = peripheral;
}

#pragma mark - MSDKDelegate
- (void)MdidUpdatePeripheralList:(NSArray *)peripherals RSSIList:(NSArray *)rssiList{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _dataArr = [NSMutableArray arrayWithArray:peripherals];
        _rssiList = rssiList;
        [_myTable reloadData];

    });

}

/** 连接成功 */
- (void)MdidConnectPeripheral:(CBPeripheral *)peripheral{
    NSLog(@"%s",__func__);
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [ProgressHUD dismiss];
        NSNotification *notification =[NSNotification notificationWithName:ConnectBleSuccessNote object:nil userInfo:nil];
        //通过通知中心发送行程开始通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
            // 返回主页控制器
        [self.navigationController popToRootViewControllerAnimated:YES];
        if (_callBack){
            _callBack(nil);
        }

    });

    
    SharedAppDelegate.isConnectedBLE = YES;
    SharedAppDelegate.isConnectedWIFI = NO;

    
}

// 连接失败
- (void)MdidFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    //    [MBProgressHUD hideHUDForView:self.view animated:NO];
    //    [MBProgressHUD showError:@"连接失败" toView:self.view];
    [ProgressHUD dismiss];

    [ProgressHUD showError:@"连接失败"];
}

// 写入数据成功
- (void)MdidWriteValueForCharacteristic:(CBCharacteristic *)character error:(NSError *)error {
    
}
// 断开连接
- (void)MdidDisconnectPeripheral:(CBPeripheral *)peripheral isAutoDisconnect:(BOOL)isAutoDisconnect{
    
    if (isAutoDisconnect) {
        NSLog(@"自动断开...");
        [self.navigationController popToViewController:self animated:YES];
        [[[UIAlertView alloc] initWithTitle:@"device disconnect" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        [self scanAgain:nil];
    }else {
        NSLog(@"手动断开...");
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //        [MBProgressHUD hideHUDForView:self.view animated:NO];
    });
    
    NSLog(@"%s",__func__);
}

- (IBAction)scanAgain:(id)sender {
    [self.dataArr removeAllObjects];
    [self.myTable reloadData];
    [self.manager MdisconnectRootPeripheral];
    [self.manager MstartScan];
}

@end
