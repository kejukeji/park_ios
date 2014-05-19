//
//  TNearParksListVC.h
//  TingCheBao
//
//  Created by zhao on 14-5-2.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TNearParkListCell.h"
#import "EGORefreshTableHeaderView.h"

@interface TNearParksListVC : UIViewController <EGORefreshTableHeaderDelegate>
{
    BOOL                        reloading;
    BOOL                        isEnd;

    IBOutlet TNearParkListCell *parkListCell;
}

@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (nonatomic, copy)    NSString *urlStr;
@property (nonatomic, strong)  EGORefreshTableHeaderView *_refreshHeaderView;

- (void)requestNearParksData:(NSString *)urlString;

@end
