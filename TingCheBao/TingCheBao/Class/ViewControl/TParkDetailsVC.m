//
//  TParkDetailsVC.m
//  TingCheBao
//
//  Created by zhao on 14-5-17.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "TParkDetailsVC.h"
#import "TNearParkModel.h"
#import <MapKit/MapKit.h>
#import "TParkingNavigateVC.h"

@interface TParkDetailsVC ()
{
    double endLatitude;
    double endLongitude;
}

@property (weak, nonatomic) IBOutlet UILabel *currentAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *emptyPlaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *nightPriceLabel;

@end

@implementation TParkDetailsVC

@synthesize parkModel;
@synthesize currentAddressLabel;
@synthesize nameLabel;
@synthesize addressLabel;
@synthesize distanceLabel;
@synthesize emptyPlaceLabel;
@synthesize dayPriceLabel;
@synthesize nightPriceLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    currentAddressLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"currentAddr"];
    
    [self setContentData];
}

- (void)setContentData
{
    [self.nameLabel setText:parkModel.name];
    [self.addressLabel setText:parkModel.address];
    
    NSInteger emptyNum = [parkModel.last intValue];
    if (emptyNum > 0) {
        NSString *emptyStr = [NSString stringWithFormat:@"空车位%@个",parkModel.last];
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
    
    double longitude = [parkModel.longitude doubleValue];
    double latitude = [parkModel.latitude doubleValue];
    
    endLatitude = latitude;
    endLongitude = longitude;
    
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:locationLatitude longitude:locationLongitude];
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    [self.distanceLabel setAdjustsFontSizeToFitWidth:YES];
    
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
        [self.distanceLabel setAttributedText:attributdText];
    } else {
        [self.distanceLabel setText:rangeStr];
    }
    
    dayPriceLabel.text = parkModel.dayPrice;
    nightPriceLabel.text = parkModel.nightPrice;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    double startLatitude = [[[NSUserDefaults standardUserDefaults] stringForKey:@"latitude"] doubleValue];
    double startLongitude = [[[NSUserDefaults standardUserDefaults] stringForKey:@"longitude"] doubleValue];
    
    if ([segue.identifier isEqualToString:@"toTParkingNavigateVC"]) {
        TParkingNavigateVC *parkingNavigateVC = segue.destinationViewController;
        [parkingNavigateVC setStartLatitude:startLatitude];
        [parkingNavigateVC setStartLongitude:startLongitude];
        [parkingNavigateVC setEndLatitude:endLatitude];
        [parkingNavigateVC setEndLongitude:endLongitude];
    }
}


@end
