//
//  TFindParkingSpaceVC.m
//  TingCheBao
//
//  Created by zhao on 14-4-28.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "TFindParkingSpaceVC.h"
#import "TNearParksListVC.h"
#import "TVoiceSearchVC.h"
#import "TSearchParkingVC.h"

@interface TFindParkingSpaceVC () 

@end

@implementation TFindParkingSpaceVC

@synthesize currentLocation;

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
    self.navigationController.navigationBar.barStyle = UIBaselineAdjustmentNone;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bar_bg.png"] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.clipsToBounds = YES;
//    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
//        self.navigationController.edgesForExtendedLayout = UIRectEdgeNone;
//        
//    }
    
    
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
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lf",currentLocation.coordinate.latitude] forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lf",currentLocation.coordinate.longitude] forKey:@"longitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([segue.identifier isEqualToString:@"TNearParksListVC"]) {
        TNearParksListVC *nearParksListVC = segue.destinationViewController;
        NSString *url = [NSString stringWithFormat:@"%@ssbusy/carbarn/latitude-longitude?latitude=%f&longitude=%f", TCB_URL,currentLocation.coordinate.latitude, currentLocation.coordinate.longitude];
        [nearParksListVC requestNearParksData:url];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
