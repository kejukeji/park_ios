//
//  TParkingNavigateVC.m
//  TingCheBao
//
//  Created by zhao on 14-5-10.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "TParkingNavigateVC.h"
#import "BNCoreServices.h"

@interface TParkingNavigateVC () <BNNaviRoutePlanDelegate, BNNaviUIManagerDelegate,UINavigationControllerDelegate>
{
    UIView *subview;
}

//导航类型，分为模拟导航和真实导航
@property (assign, nonatomic) BN_NaviType naviType;

@end

@implementation TParkingNavigateVC

@synthesize startLatitude;
@synthesize startLongitude;
@synthesize endLatitude;
@synthesize endLongitude;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)onExitNaviUI
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onExitNaviUI) name:@"onExitNaviUI" object:nil];

    _naviType = BN_NaviTypeReal;
    [self startNavi];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onExitNaviUI" object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)startNavi
{
    NSMutableArray *nodesArray = [[NSMutableArray alloc]initWithCapacity:2];
    //起点 传入的是原始的经纬度坐标，若使用的是百度地图坐标，可以使用BNTools类进行坐标转化
    BNRoutePlanNode *startNode = [[BNRoutePlanNode alloc] init];
    startNode.pos = [[BNPosition alloc] init];
    startNode.pos.x = startLongitude;
    startNode.pos.y = startLatitude;
    [nodesArray addObject:startNode];
    
    
    //也可以在此加入若干个的途经点
    /*
     BNRoutePlanNode *midNode = [[BNRoutePlanNode alloc] init];
     midNode.pos = [[BNPosition alloc] init];
     midNode.pos.x = 116.12;
     midNode.pos.y = 39.05087;
     [nodesArray addObject:midNode];
     */
    //终点
    BNRoutePlanNode *endNode = [[BNRoutePlanNode alloc] init];
    endNode.pos = [[BNPosition alloc] init];
    endNode.pos.x = endLongitude;
    endNode.pos.y = endLatitude;
    [nodesArray addObject:endNode];
    
    [BNCoreServices_RoutePlan startNaviRoutePlan:BNRoutePlanMode_Recommend naviNodes:nodesArray time:nil delegete:self userInfo:nil];
}

#pragma mark - BNNaviRoutePlanDelegate
//算路成功回调
- (void)routePlanDidFinished:(NSDictionary *)userInfo
{
    NSLog(@"算路成功");
    NSLog(@"userInfo === %@",userInfo);

    //路径规划成功，开始导航
    [BNCoreServices_UI showNaviUI:_naviType delegete:self isNeedLandscape:YES];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    subview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [btn setFrame:CGRectMake(0, 0, 320, 50)];
    [btn addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    [subview addSubview:btn];
    
    [subview setBackgroundColor:[UIColor redColor]];
//    [self.view addSubview:view];
    [subview setAlpha:0.9];
    [[UIApplication sharedApplication].keyWindow addSubview:subview];

}

- (void)removeView
{
    [subview removeFromSuperview];
}
//算路失败回调
- (void)routePlanDidFailedWithError:(NSError *)error andUserInfo:(NSDictionary *)userInfo
{
    NSLog(@"算路失败");
    
    NSString *msg = @"";
    
    if ([error code] == BNRoutePlanError_LocationFailed) {
        NSLog(@"获取地理位置失败");
        msg = @"获取地理位置失败";
    }
    
    else if ([error code] == BNRoutePlanError_RoutePlanFailed)
    {
        NSLog(@"无法发起算路");
        msg = @"无法发起算路";

    }
    
    else if ([error code] == BNRoutePlanError_LocationServiceClosed)
    {
        NSLog(@"定位服务未开启");
        msg = @"定位服务未开启";
    }
    
    else if ([error code] == BNRoutePlanError_NodesTooNear)
    {
        NSLog(@"节点之间距离太近");
        msg = @"节点之间距离太近";

    }
    
    else if ([error code] == BNRoutePlanError_NodesInputError)
    {
        NSLog(@"节点输入有误");
        msg = @"节点输入有误";

    }
    
    else if ([error code] == BNRoutePlanError_WaitAMoment)
    {
        NSLog(@"上次算路取消了，需要等一会");
        msg = @"上次算路取消了，需要等一会";
    }
    
    NSLog(@"error code == %i",[error code]);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"算路失败" message:msg delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"重新计算", nil];
    [alert show];
}

//算路取消回调
- (void)routePlanDidUserCanceled:(NSDictionary*)userInfo {
    NSLog(@"算路取消");
    NSLog(@"userInfo === %@",userInfo);
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - BNNaviUIManagerDelegate

//退出导航回调
- (void)onExitNaviUI:(NSDictionary*)extraInfo
{
    NSLog(@"退出导航");
    [self dismissModalViewControllerAnimated:YES];
}

//退出导航声明页面回调
- (void)onExitexitDeclarationUI:(NSDictionary*)extraInfo
{
    NSLog(@"退出导航声明页面");
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self dismissModalViewControllerAnimated:YES];
    } else {
        [self startNavi];
    }
}

@end
