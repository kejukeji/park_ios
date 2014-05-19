//
//  TNearParkListCell.h
//  TingCheBao
//
//  Created by zhao on 14-5-2.
//  Copyright (c) 2014年 zhao. All rights reserved.
//
@protocol TNearParkListCellDelegate <NSObject>

- (void)gotoNavigationLongitude:(double)longitude latitude:(double)latitude;

@end

#import <UIKit/UIKit.h>
#import "TNearParkModel.h"

@interface TNearParkListCell : UITableViewCell
{
    double longitude;
    double latitude;
}

@property (nonatomic, assign) id<TNearParkListCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *rangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *emptyPlaceLabel;

- (void)setCellContent:(TNearParkModel *)model;
- (IBAction)gotoNavigation:(UIButton *)sender;

@end
