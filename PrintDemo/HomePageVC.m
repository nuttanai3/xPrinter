//
//  HomePageVC.m
//  PrintDemo
//
//  Created by samlee123 on 2018/5/1.
//  Copyright © 2018年 . All rights reserved.
//

#import "HomePageVC.h"
#import "TagPrintingVC.h"
#import "BillPrintingVC.h"
#import "SelectionDeviceVC.h"
#import "ProgressHUD.h"
#import "UIView+Toast.h"
#import "MWIFIManager.h"
#import "AppDelegate.h"

@interface HomePageVC ()<MWIFIManagerDelegate,MBLEManagerDelegate>{

}
/** BLE */
@property (strong, nonatomic) MBLEManager *manager;
/** wifi */
@property (nonatomic, strong) MWIFIManager *wifiManager;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property (weak, nonatomic) IBOutlet UITextView *reciveDataTextView;

@property (weak, nonatomic) IBOutlet UITextField *ipAddressTF;
@end

@implementation HomePageVC

- (MBLEManager *)manager
{
    if (!_manager)
    {
        _manager = [MBLEManager sharedInstance];
        _manager.delegate = self;
        
    }
    
    return _manager;
}
- (MWIFIManager *)wifiManager
{
    if (!_wifiManager)
    {
        _wifiManager = [MWIFIManager shareWifiManager];
        _wifiManager.delegate = self;
        __weak typeof(self) weakSelf = self;
        _wifiManager.callBackBlock = ^(NSData *data) {
            
            NSString * str  = [weakSelf convertDataToHexStr:data];
            weakSelf.reciveDataTextView.text = str;
        };
    }
    return _wifiManager;
}
- (NSString *)convertDataToHexStr:(NSData *)data
{
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return string;
}


- (void)dealloc{
    [self.manager removeObserver:self forKeyPath:@"writePeripheral.state" context:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"not connected";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectBle:) name:ConnectBleSuccessNote object:nil];

}

- (void)connectBle:(NSNotification *)text{
    
    [self.statusBtn setTitle:@"Disconnect" forState:UIControlStateNormal];
    SharedAppDelegate.isConnectedWIFI = NO;
    SharedAppDelegate.isConnectedBLE = YES ;

    
}

- (IBAction)connect:(id)sender {
    
    if ([ _ipAddressTF.text isEqualToString:@""]) {
        
        [ProgressHUD showError:@"Please enter an IP address"];
        return;
    }
    
    
    // Disconnect the original connection first
    [self.wifiManager MDisConnect];
    
    [ProgressHUD show:@"connecting"];
    
    //connect to wifi
    [self.wifiManager MConnectWithHost:_ipAddressTF.text
                                   port:(UInt16)[@"9100" integerValue]
                             completion:^(BOOL isConnect) {
                                 
                             }];
    
    
    
    
}

- (void)MWIFIManager:(MWIFIManager *)manager didConnectedToHost:(NSString *)host port:(UInt16)port{
    
    [ProgressHUD dismiss];
    SharedAppDelegate.isConnectedWIFI = YES;
    SharedAppDelegate.isConnectedBLE = NO;
    [self.statusBtn setTitle:@"Disconnect" forState:UIControlStateNormal];

    NSString *message =  @"WI-FI connection is successful";
    [self.view makeToast:message duration:2 Mition:CSToastMitionCenter];

}


//Disconnect
- (void)MWIFIManagerDidDisconnected:(MWIFIManager *)manager{
    
    if (!manager.isAutoDisconnect) {
        //        self.myTab.hidden = YES;
    }
    [self.statusBtn setTitle:@"not connected" forState:UIControlStateNormal];

    SharedAppDelegate.isConnectedWIFI = NO;
    
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    
 
    self.manager.delegate = self;
    self.wifiManager.delegate = self;
    
    [self.manager addObserver:self
                   forKeyPath:@"writePeripheral.state"
                      options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                      context:nil];
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (object == self.manager && [keyPath isEqualToString:@"writePeripheral.state"])
    {
        // Update the connection status of bluetooth
        switch (self.manager.writePeripheral.state) {
            case CBPeripheralStateDisconnected:
            {
                [self.statusBtn setTitle:@"not connected" forState:UIControlStateNormal];
                SharedAppDelegate.isConnectedBLE = NO;
                
                break;
            }
                
            case CBPeripheralStateConnecting:
            {
                [self.statusBtn setTitle:@"device is connecting" forState:UIControlStateNormal];
                break;
            }
            case CBPeripheralStateConnected:
            {

                
                [self.statusBtn setTitle:@"connected" forState:UIControlStateNormal];

                SharedAppDelegate.isConnectedBLE = YES;
                
                break;
            }
            case CBPeripheralStateDisconnecting:
            {
                [self.statusBtn setTitle:@"not connected" forState:UIControlStateNormal];
                SharedAppDelegate.isConnectedBLE = NO;

                
                break;
            }
            default:
                break;
        }  ;
    }
}


- (IBAction)connectBleAction:(id)sender {
    
    SelectionDeviceVC *vc = [SelectionDeviceVC controller];
    vc.callBack = ^(id x){
        SharedAppDelegate.isConnectedBLE = YES;
        SharedAppDelegate.isConnectedWIFI = NO;
        [self.statusBtn setTitle:@"Disconnect" forState:UIControlStateNormal];
        NSString *message =  @"Bluetooth connection successful";
        [self.view makeToast:message duration:2 Mition:CSToastMitionCenter];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)pushBillAction:(id)sender {
    
    BillPrintingVC *vc = [BillPrintingVC controller];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)pushTagAction:(id)sender {
    
    
    TagPrintingVC *vc = [TagPrintingVC controller];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (IBAction)disConnectAction:(id)sender {
    if (!SharedAppDelegate.isConnectedWIFI&&!SharedAppDelegate.isConnectedBLE){
        return;
    }
    if (SharedAppDelegate.isConnectedWIFI){
        [self.wifiManager MDisConnect];
    }
    if (SharedAppDelegate.isConnectedBLE){
        [self.manager MdisconnectRootPeripheral];
    }
}

@end
