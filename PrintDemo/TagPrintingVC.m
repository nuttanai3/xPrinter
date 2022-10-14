//
//  TagPrintingVC.m
//  PrintDemo
//
//  Created by samlee123 on 2018/5/1.
//  Copyright © 2018年 . All rights reserved.
//

#import "TagPrintingVC.h"
#import "MWIFIManager.h"
#import "MBLEManager.h"
#import "PosCommand.h"
#import "AppDelegate.h"
#import "ProgressHUD.h"
#import "TscCommand.h"

@interface TagPrintingVC ()<MBLEManagerDelegate, MWIFIManagerDelegate>

/** BLE */
@property (strong, nonatomic) MBLEManager *manager;
/** wifi */
@property (nonatomic, strong) MWIFIManager *wifiManager;

@end

@implementation TagPrintingVC

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
    TagPrintingVC *vc = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager.delegate = self;
    self.wifiManager.delegate = self;
    
}
- (void)viewWillDisappear:(BOOL)animated{
    
    self.manager.delegate = nil;
    self.wifiManager.delegate = nil;
}

//打印文字
- (IBAction)printTextAction:(id)sender {
    NSMutableData* dataM=[NSMutableData dataWithData:[MCommand initializePrinter]];

    //****tsc
    NSStringEncoding   gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    [dataM appendData:[MCommand setLableWidth:57]];
    [dataM appendData:[TscCommand gapBymmWithWidth:0 andHeight:0]];
    [dataM appendData:[TscCommand sizeBymmWithWidth:57 andHeight:30]];
    [dataM appendData:[TscCommand cls]];
    [dataM appendData:[TscCommand textWithX:0 andY:5 andFont:@"TSS24.BF2" andRotation:0 andX_mul:1 andY_mul:1 andContent:@"打印测试123456789abcdefghijklnmABCDEFGHIJK" usStrEnCoding:gbkEncoding]];
    [dataM appendData:[TscCommand print:1]];
    if (SharedAppDelegate.isConnectedBLE) {
            [self.manager MWriteCommandWithData:dataM];
 
    }else if(SharedAppDelegate.isConnectedWIFI){
        
            [self.wifiManager MWriteCommandWithData:dataM];
    }else{
            [ProgressHUD showError:@"请连接Wi-Fi或者蓝牙"];
    }
    
}

//打印二维码
- (IBAction)printQRCodeAction:(id)sender {
    

    //****tsc
    NSStringEncoding   gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);

    NSMutableData* dataM=[NSMutableData data];
    [dataM appendData:[TscCommand gapBymmWithWidth:0 andHeight:0]];
    [dataM appendData:[TscCommand sizeBymmWithWidth:58 andHeight:60]];
    [dataM appendData:[TscCommand cls]];
    
    [dataM appendData:[TscCommand qrCodeWithX:0 andY:0 andEccLevel:@"H" andCellWidth:6 andMode:@"M" andRotation:0 andContent:@"print" usStrEnCoding:gbkEncoding]];
    
    if (SharedAppDelegate.isConnectedBLE) {
        [dataM appendData:[TscCommand print:1]];
        [self.manager MWriteCommandWithData:dataM];
        
    }else if(SharedAppDelegate.isConnectedWIFI){
        [dataM appendData:[TscCommand print:1]];
        [self.wifiManager MWriteCommandWithData:dataM ];
    }else{
        [ProgressHUD showError:@"请连接Wi-Fi或者蓝牙"];
    }

}

//打印一维码
- (IBAction)printBarCodeAction:(id)sender {

    
    //****tsc
    NSStringEncoding   gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    NSMutableData* dataM=[NSMutableData data];
    [dataM appendData:[TscCommand gapBymmWithWidth:0 andHeight:0]];
    [dataM appendData:[TscCommand sizeBymmWithWidth:58 andHeight:60]];
    [dataM appendData:[TscCommand cls]];
    
    [dataM appendData:[TscCommand barcodeWithX:0 andY:0 andCodeType:@"128" andHeight:40 andHunabReadable:0 andRotation:0 andNarrow:2 andWide:2 andContent:@"3293829383928" usStrEnCoding:gbkEncoding]];

    if (SharedAppDelegate.isConnectedBLE) {
        [dataM appendData:[TscCommand print:1]];
        [self.manager MWriteCommandWithData:dataM];
        
    }else if(SharedAppDelegate.isConnectedWIFI){
        [dataM appendData:[TscCommand print:1]];
        [self.wifiManager MWriteCommandWithData:dataM ];
    }else{
        [ProgressHUD showError:@"请连接Wi-Fi或者蓝牙"];
    }
}


//打印图片
- (IBAction)printImageAction:(id)sender {
    

    //****tsc
    NSStringEncoding   gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    NSMutableData* dataM=[NSMutableData data];
    [dataM appendData:[TscCommand gapBymmWithWidth:0 andHeight:0]];
    [dataM appendData:[TscCommand sizeBymmWithWidth:58 andHeight:60]];
    [dataM appendData:[TscCommand cls]];
    
//    [dataM appendData:[TscCommand barcodeWithX:0 andY:0 andCodeType:@"128" andHeight:40 andHunabReadable:0 andRotation:0 andNarrow:2 andWide:2 andContent:@"3293829383928" usStrEnCoding:gbkEncoding]];
    
    [dataM appendData:[TscCommand bitmapWithX:1 andY:2 andMode:0 andImage:[UIImage imageNamed:@"XinYe"] andBmpType:Dithering andPaperHeight:1000]];

    if (SharedAppDelegate.isConnectedBLE) {
        [dataM appendData:[TscCommand print:1]];
        [self.manager MWriteCommandWithData:dataM];
        
    }else if(SharedAppDelegate.isConnectedWIFI){
        [dataM appendData:[TscCommand print:1]];
        [self.wifiManager MWriteCommandWithData:dataM ];
    }else{
        [ProgressHUD showError:@"请连接Wi-Fi或者蓝牙"];
    }
}


@end
