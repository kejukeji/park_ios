//
//  TNearParkListCell.m
//  TingCheBao
//
//  Created by zhao on 14-5-2.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "TNearParkListCell.h"
#import <MapKit/MapKit.h>

@implementation TNearParkListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellContent:(TNearParkModel *)model
{
    [self.nameLabel setText:model.name];
    [self.addressLabel setText:model.address];
    
    NSInteger emptyNum = [model.last intValue];
    if (emptyNum > 0) {
        NSString *emptyStr = [NSString stringWithFormat:@"空车位%@个",model.last];
        if (!noiOS6) {
            NSDictionary *subStrAttribute1 = @{NSForegroundColorAttributeName: [UIColor blackColor]};
            NSDictionary *subStrAttribute2 = @{NSForegroundColorAttributeName: [UIColor redColor]};
            NSMutableAttributedString *attributdText = [[NSMutableAttributedString alloc] initWithString:emptyStr];
            [attributdText setAttributes:subStrAttribute1 range:NSMakeRange(0, 3)];
            [attributdText setAttributes:subStrAttribute2 range:NSMakeRange(3, emptyStr.length - 3)];
            [self.emptyPlaceLabel setAttributedText:attributdText];
        } else {
            [self.emptyPlaceLabel setText:emptyStr];
        }
    } else if (emptyNum == 0) {
        [self.emptyPlaceLabel setText:@"无空车位"];
    } else {
        [self.emptyPlaceLabel setText:@""];
    }
    
    //计算距离
    double locationLongitude = [[[NSUserDefaults standardUserDefaults] stringForKey:@"longitude"] doubleValue];
    
    double locationLatitude = [[[NSUserDefaults standardUserDefaults] stringForKey:@"latitude"] doubleValue];
    
    longitude = [model.longitude doubleValue];
    latitude = [model.latitude doubleValue];
    
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:locationLatitude longitude:locationLongitude];
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    [self.rangeLabel setAdjustsFontSizeToFitWidth:YES];

    double range = [newLocation distanceFromLocation :currentLocation] / 1000.0f;
    NSString *rangeStr = @"";
    if (range > 1) {
        rangeStr = [NSString stringWithFormat:@"距离%0.1fkm", range];
    } else {
        rangeStr = [NSString stringWithFormat:@"距离%im", (NSInteger)ceil(range * 1000.0f)];
    }
    
    if (!noiOS6) {
        NSDictionary *subStrAttribute1 = @{NSForegroundColorAttributeName: [UIColor blackColor]};
        NSDictionary *subStrAttribute2 = @{NSForegroundColorAttributeName: [UIColor redColor]};
        NSMutableAttributedString *attributdText = [[NSMutableAttributedString alloc] initWithString:rangeStr];
        [attributdText setAttributes:subStrAttribute1 range:NSMakeRange(0, 2)];
        [attributdText setAttributes:subStrAttribute2 range:NSMakeRange(2, rangeStr.length - 2)];
        [self.rangeLabel setAttributedText:attributdText];
    } else {
        [self.rangeLabel setText:rangeStr];
    }
}

- (IBAction)gotoNavigation:(UIButton *)sender
{
    [self.delegate gotoNavigationLongitude:longitude latitude:latitude];
}

@end
