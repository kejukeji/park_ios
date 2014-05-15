//
//  THomePageVC.m
//  TingCheBao
//
//  Created by zhao on 14-4-28.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "THomePageVC.h"
#import "BMapKit.h"
#import "TFindParkingSpaceVC.h"

@interface THomePageVC () <BMKMapViewDelegate, BMKSearchDelegate, UINavigationControllerDelegate>
{
    CLLocation *currentLocation;
    BMKSearch  *search;
}

@property (nonatomic, strong) BMKMapView *mapView;;

@end

@implementation THomePageVC

@synthesize homeScrollView;
@synthesize adScrollview;
@synthesize mapView;

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
    // Do any additional setup after loading the view.

    mapView = [[BMKMapView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:mapView];
    
    mapView.showsUserLocation = NO;//先关闭显示的定位图层
    mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    mapView.showsUserLocation = YES;//显示定位图层

    search = [[BMKSearch alloc]init];

    self.navigationController.delegate = self;
    
    [homeScrollView setContentSize:CGSizeMake(320, 504)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [mapView viewWillAppear];
    [mapView setDelegate:self];
    search.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放

}

-(void)viewWillDisappear:(BOOL)animated {
    [mapView viewWillDisappear];
    mapView.delegate = nil; // 不用时，置nil
    search.delegate = nil; // 此处记得不用的时候需要置nil，否则影响内存的释放
}


#pragma mark -
#pragma mark mapViewDelegate

- (void)mapView:(BMKMapView *)mapView1 didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    BMKCoordinateRegion region;
    region.center.latitude  = userLocation.location.coordinate.latitude;
    region.center.longitude = userLocation.location.coordinate.longitude;
    region.span.latitudeDelta  = 0.2;
    region.span.longitudeDelta = 0.2;
    if (mapView)
    {
        mapView.region = region;
        NSLog(@"当前的坐标是: %f,%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    }
    currentLocation = userLocation.location;
    
    BOOL flag = [search reverseGeocode:userLocation.location.coordinate];
	if (flag) {
		NSLog(@"ReverseGeocode search success.");
        
	}
    else{
        NSLog(@"ReverseGeocode search failed!");
    }
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
    if ([segue.identifier isEqualToString:@"TFindParkingSpaceVC"]) {
        TFindParkingSpaceVC *findParkingVC = segue.destinationViewController;
        NSLog(@"currentLocation.latitude == %f",currentLocation.coordinate.latitude);
        NSLog(@"currentLocation.longitude == %f",currentLocation.coordinate.longitude);
        [findParkingVC setCurrentLocation:currentLocation];
    }
}


#pragma mark -
#pragma mark - navigationController delegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self) {
        [navigationController setNavigationBarHidden:YES animated:NO];
    } else if ([navigationController isNavigationBarHidden]) {
        [navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)onGetAddrResult:(BMKSearch*)searcher result:(BMKAddrInfo*)result errorCode:(int)error;
{
	if (error == 0) {
		BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
		item.coordinate = result.geoPt;
		item.title = result.strAddr;
        NSString* showmeg;
        showmeg = [NSString stringWithFormat:@"%@",item.title];
        [[NSUserDefaults standardUserDefaults] setObject:showmeg forKey:@"currentAddr"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

}

@end
