//
//  TNearParksListVC.m
//  TingCheBao
//
//  Created by zhao on 14-5-2.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "TNearParksListVC.h"
#import "MyRequest.h"
#import "TNearParkModel.h"
#import "tooles.h"
#import "TParkingNavigateVC.h"

@interface TNearParksListVC () <MyRequestDelegate>
{
    NSMutableArray *listDatas;
}

@property (weak, nonatomic) IBOutlet UITableView *parkListTV;

@end

@implementation TNearParksListVC

@synthesize addressLabel;
@synthesize urlStr;
@synthesize parkListTV;

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
    
    addressLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"currentAddr"];
    
    listDatas = [NSMutableArray arrayWithCapacity:0];
    
    [parkListTV setBackgroundView:nil];
    [parkListTV setBackgroundColor:[UIColor clearColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestNearParksData:(NSString *)urlString
{
    [tooles showHUD:@"加载中..."];
    urlStr = urlString;
    MyRequest *request = [[MyRequest alloc] init];
    request.delegae = self;
    [request getUrl:urlStr sendTime:30];
}

#pragma mark -
#pragma mark MyRequest Delegate
- (void)requestResult:(NSDictionary *)resultDict formDataRequest:(MyRequest *)request
{
    NSArray *data = [resultDict objectForKey:@"data"];
    for (NSDictionary *dict in data) {
        TNearParkModel *nearParkModel = [[TNearParkModel alloc] initWithDictionary:dict];
        [listDatas addObject:nearParkModel];

    }
    
    [parkListTV reloadData];
    [tooles removeHUD:0.3];

}

- (void)requestFail:(NSString *)msg
{
    [tooles removeHUD:0.3];
    [tooles MsgBox:msg];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *path = [parkListTV indexPathForSelectedRow];
    TNearParkModel *model = [listDatas objectAtIndex:path.row];
    double startLatitude = [[[NSUserDefaults standardUserDefaults] stringForKey:@"latitude"] doubleValue];
    double startLongitude = [[[NSUserDefaults standardUserDefaults] stringForKey:@"longitude"] doubleValue];
    double endLatitude = [model.latitude doubleValue];
    double endLongitude = [model.longitude doubleValue];
    
    if ([segue.identifier isEqualToString:@"TParkingNavigateVC"]) {
        TParkingNavigateVC *parkingNavigateVC = segue.destinationViewController;
        [parkingNavigateVC setStartLatitude:startLatitude];
        [parkingNavigateVC setStartLongitude:startLongitude];
        [parkingNavigateVC setEndLatitude:endLatitude];
        [parkingNavigateVC setEndLongitude:endLongitude];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"parkListCell";
    
    TNearParkListCell *cell = (TNearParkListCell *)[tableView dequeueReusableCellWithIdentifier:@"parkListCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[TNearParkListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    TNearParkModel *model = [listDatas objectAtIndex:indexPath.row];
    [cell setCellContent:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
