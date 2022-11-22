//
//  BillPrintingVC.m
//  PrintDemo
//
//  Created by samlee123 on 2018/5/1.
//  Copyright © 2018年 . All rights reserved.
//

#import "BillPrintingVC.h"
#import "MWIFIManager.h"
#import "MBLEManager.h"
#import "PosCommand.h"
#import "AppDelegate.h"
#import "ProgressHUD.h"
@interface BillPrintingVC ()<MBLEManagerDelegate, MWIFIManagerDelegate>

/** BLE */
@property (strong, nonatomic) MBLEManager *manager;
/** wifi */
@property (nonatomic, strong) MWIFIManager *wifiManager;
@property (nonatomic, strong) MWIFIManager *wifiManager2;
    
@end

@implementation BillPrintingVC

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
    }
    return _wifiManager;
}
+ (instancetype)controller{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BillPrintingVC *vc = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager.delegate = self;
    _wifiManager = [[MWIFIManager alloc] init];
    _wifiManager.delegate = self;
    _wifiManager.callBackBlock = ^(NSData *data) {};
    [self.wifiManager MDisConnect];
    [self.wifiManager MConnectWithHost: @"192.168.2.110"
                                  port:(UInt16)[@"9100" integerValue]
                            completion:^(BOOL isConnect) {}];
    _wifiManager2 = [[MWIFIManager alloc] init];
    _wifiManager2.delegate = self;
    _wifiManager2.callBackBlock = ^(NSData *data) {};
    [self.wifiManager2 MDisConnect];
    [self.wifiManager2 MConnectWithHost: @"192.168.2.112"
                                   port:(UInt16)[@"9100" integerValue]
                             completion:^(BOOL isConnect) {}];
}
- (void)viewWillDisappear:(BOOL)animated{
    
    self.manager.delegate = nil;
    self.wifiManager.delegate = nil;
    self.wifiManager2.delegate = nil;
}

//打印文字
- (IBAction)printTextAction:(id)sender {
    
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSMutableData* dataM = [NSMutableData dataWithData:[MCommand initializePrinter]];
    int width = 58;
    [dataM appendData:[MCommand setLableWidth:width]];
    [dataM appendData:[MCommand setPrintAreaWidthWithnL:width*8%256 andnH:width*8/256]];
    [dataM appendData: [@"打印测试123456789abcdefghijklnmABCDEFGHIJK" dataUsingEncoding: gbkEncoding]];
    [dataM appendData:[MCommand printAndFeedLine]];
    if (SharedAppDelegate.isConnectedBLE) {
        
            [self.manager MWriteCommandWithData:dataM];
        
    }else if(SharedAppDelegate.isConnectedWIFI){
        
        
            [self.wifiManager MWriteCommandWithData:dataM];
    }else{
        
        [ProgressHUD showError:@"请连接Wi-Fi或者蓝牙"];
    }
    

}

//打印图片
- (IBAction)printImageAction:(id)sender {
    
    UIImage* img = [UIImage imageNamed:@"billExample2"];
//    UIImage* img2 = [UIImage imageNamed:@"fakeTaxi"];
    NSMutableData* dataM = [NSMutableData dataWithData:[MCommand initializePrinter]];
    if(SharedAppDelegate.isConnectedWIFI){
        [dataM appendData:[MCommand setTempData]];
    }
    NSData *data = [MCommand printRasteBmpWithM:RasterNolmorWH andImage:img andType:Dithering andPaperHeight: 10000];
    [dataM appendData:data];
//    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//    [dataM appendData: [@"打印测试123456789abcdefghijklnmABCDEFGHIJK" dataUsingEncoding: gbkEncoding]];
    [dataM appendData:[MCommand printAndFeedLine]];
    [dataM appendData:[MCommand printAndFeedLine]];
    [dataM appendData:[MCommand printAndFeedLine]];
    [dataM appendData:[MCommand printAndFeedLine]];
    [dataM appendData:[MCommand printAndFeedLine]];
    [dataM appendData:[MCommand printAndFeedLine]];
    [dataM appendData:[MCommand printAndFeedLine]];
    [dataM appendData:[MCommand printAndFeedLine]];
    [dataM appendData:[MCommand printAndFeedLine]];
    [dataM appendData:[MCommand printAndFeedLine]];
    [dataM appendData:[MCommand printAndFeedLine]];
    [dataM appendData:[MCommand printAndFeedLine]];
    [dataM appendData:[MCommand printAndFeedLine]];
    [dataM appendData:[MCommand printAndFeedLine]];
    [dataM appendData:[MCommand printAndFeedLine]];
    [dataM appendData:[MCommand printAndFeedLine]];
    [dataM appendData:[MCommand printAndFeedLine]];
    [dataM appendData:[MCommand printAndFeedLine]];
    [dataM appendData:[MCommand printAndFeedLine]];
    [dataM appendData:[MCommand printAndFeedLine]];
    [dataM appendData:[MCommand selectCutPageModelAndCutpage:0]];
//    if (SharedAppDelegate.isConnectedBLE) {
//        [self.manager MWriteCommandWithData:dataM];
//
//    }else if(SharedAppDelegate.isConnectedWIFI){
//        [self.wifiManager MWriteCommandWithData:dataM];
//
//    }else{
//
//        [ProgressHUD showError:@"请连接Wi-Fi或者蓝牙"];
//    }
    [self.wifiManager MWriteCommandWithData:dataM];
    [self.wifiManager2 MWriteCommandWithData:dataM];
}

//打印二维码
- (IBAction)printQRCodeAction:(id)sender {
    NSMutableData* dataM=[NSMutableData dataWithData:[MCommand initializePrinter]];

    [dataM appendData:[MCommand selectAlignment:1]];
    
    [dataM appendData:[MCommand printQRCode:4 level:0x30 code:@"print" useEnCodeing:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)]];
    
    [dataM appendData:[MCommand printAndFeedLine]];
    
    if (SharedAppDelegate.isConnectedBLE) {
        [self.manager MWriteCommandWithData:dataM];
        
    }else if(SharedAppDelegate.isConnectedWIFI){
        [self.wifiManager MWriteCommandWithData:dataM];
        
    }else{
        
        [ProgressHUD showError:@"请连接Wi-Fi或者蓝牙"];
    }
}

//打印条码
- (IBAction)printBarCodeAction:(id)sender {
    NSMutableData* dataM=[NSMutableData dataWithData:[MCommand initializePrinter]];
    [dataM appendData:[MCommand selectHRICharactersPrintMition:2]];

    [dataM appendData:[MCommand selectAlignment:1]];
    [dataM appendData:[MCommand setBarcodeHeight:35]];
    [dataM appendData:[MCommand printBarcodeWithM:05  andContent:@"12345678" useEnCodeing:NSASCIIStringEncoding]];
    [dataM appendData:[MCommand printAndFeedLine]];
    
    if (SharedAppDelegate.isConnectedBLE) {
        [self.manager MWriteCommandWithData:dataM];
        
    }else if(SharedAppDelegate.isConnectedWIFI){
        [self.wifiManager MWriteCommandWithData:dataM];
        
    }else{
        
        [ProgressHUD showError:@"请连接Wi-Fi或者蓝牙"];
    }
}
@end
