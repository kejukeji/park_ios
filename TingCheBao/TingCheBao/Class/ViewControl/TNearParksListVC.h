//
//  TNearParksListVC.h
//  TingCheBao
//
//  Created by zhao on 14-5-2.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TNearParkListCell.h"

@interface TNearParksListVC : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (nonatomic, copy) NSString *urlStr;

- (void)requestNearParksData:(NSString *)urlString;

@end
