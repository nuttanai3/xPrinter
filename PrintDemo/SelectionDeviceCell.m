//
//  SelectionDeviceCell.m
//  Printer
//
//  Created by 李善忠 on 2017/10/20.
//  Copyright © 2017年 李善忠. All rights reserved.
//

#import "SelectionDeviceCell.h"

@implementation SelectionDeviceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
