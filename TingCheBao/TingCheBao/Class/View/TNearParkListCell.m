//
//  TNearParkListCell.m
//  TingCheBao
//
//  Created by zhao on 14-5-2.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "TNearParkListCell.h"

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
    [self.nameLabel setText:@"上海"];
    [self.addressLabel setText:@"hh"];
    [self.priceLabel setText:@"fdsf"];
    [self.emptyPlaceLabel setText:@"dfsdsfsd"];
    [self.rangeLabel setText:@"fdsfsdfasd"];
}

- (void)setCellContent
{
    [self.nameLabel setText:@"上海"];
    [self.addressLabel setText:@"hh"];
    [self.priceLabel setText:@"fdsf"];
    [self.emptyPlaceLabel setText:@"dfsdsfsd"];
    [self.rangeLabel setText:@"fdsfsdfasd"];
    [self.contentView addSubview:self.nameLabel];
}

@end
