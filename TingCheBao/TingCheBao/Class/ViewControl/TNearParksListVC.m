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
#import "TParkDetailsVC.h"
#import "TNearParkModel.h"

@interface TNearParksListVC () <MyRequestDelegate, UITableViewDataSource, UITableViewDelegate, TNearParkListCellDelegate>
{
    int           currentIndex;

    NSMutableArray *listDatas;
    TNearParkModel *detailModel;
    double endLatitude;
    double endLongitude;
}

@property (strong, nonatomic) UITableView *parkListTV;

@end

@implementation TNearParksListVC

@synthesize addressLabel;
@synthesize urlStr;
@synthesize parkListTV;

@synthesize _refreshHeaderView;

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
    currentIndex = 1;

    parkListTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, 460 - (iPhone5?88:0) - 88) style:UITableViewStylePlain];
    [parkListTV setRowHeight:83.0f];
    [parkListTV setSeparatorStyle:UITableViewCellSeparatorStyleNone];  //取消单元格之间的分隔线
    [parkListTV setDataSource:self];
    [parkListTV setDelegate:self];
    [self.view addSubview:parkListTV];
    
    [parkListTV setBackgroundView:nil];
    [parkListTV setBackgroundColor:[UIColor clearColor]];
    
    [self requestNearParksData:urlStr];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestNearParksData:(NSString *)urlString
{
    urlStr = urlString;
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -70.0f, parkListTV.frame.size.width,70.0f)];
        view.delegate = self;
        view.backgroundColor = [UIColor clearColor];
        [parkListTV addSubview:view];
        self._refreshHeaderView = view;
    }
    [parkListTV setContentOffset:CGPointMake(0, -65) animated:NO];
    [_refreshHeaderView egoRefreshScrollViewDidScroll:parkListTV];
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:parkListTV];
}

-(void)refaushTableViewData
{
    if(urlStr == nil)
    {
        return;
    }
    
//    [tooles showHUD:@"加载中..."];
    
    NSString *url = [NSString stringWithFormat:@"%@&page_show=%i",urlStr, currentIndex];
    
    MyRequest *request = [[MyRequest alloc] init];
    request.delegae = self;
    [request getUrl:url sendTime:30];
}

#pragma mark - EGORefreshTableHeaderDelegate

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    currentIndex = 1;
    [listDatas removeAllObjects];
    [parkListTV reloadData];
    [self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return reloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    return [NSDate date];
}

/**
 *	@brief	 开始下拉刷新
 */
- (void)reloadTableViewDataSource
{
    [self refaushTableViewData];
	reloading = YES;
}

/**
 *	@brief	结束下拉刷新
 */
- (void)doneLoadingTableViewData
{
	reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:parkListTV];
}

- (void)drawRect:(CGRect)rect
{
    [super.view drawRect:rect];
    /***************** 下拉刷新 *****************/
    
    
    // Drawing code
}

/************************************   下拉刷新部分 *****************************************/
#pragma mark - UITableView -> UIScrollviewDelegate
/**
 *	@brief	表格滚动时自动调用
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

/**
 *	@brief	结束拖拽时自动调用
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate

{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark MyRequest Delegate
- (void)requestResult:(NSDictionary *)resultDict formDataRequest:(MyRequest *)request
{
    [self doneLoadingTableViewData];

    NSArray *data = [resultDict objectForKey:@"data"];
    for (NSDictionary *dict in data) {
        TNearParkModel *nearParkModel = [[TNearParkModel alloc] initWithDictionary:dict];
        [listDatas addObject:nearParkModel];

    }
    currentIndex++;
    [parkListTV reloadData];
    [tooles removeHUD:0.3];

}

- (void)requestFail:(NSString *)msg
{
    [self doneLoadingTableViewData];

    [tooles removeHUD:0.3];
    [tooles MsgBox:msg];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//    NSIndexPath *path = [parkListTV indexPathForSelectedRow];
//    TNearParkModel *model = [listDatas objectAtIndex:path.row];
    double startLatitude = [[[NSUserDefaults standardUserDefaults] stringForKey:@"latitude"] doubleValue];
    double startLongitude = [[[NSUserDefaults standardUserDefaults] stringForKey:@"longitude"] doubleValue];
    
    if ([segue.identifier isEqualToString:@"toTParkingNavigateVC"]) {
        TParkingNavigateVC *parkingNavigateVC = segue.destinationViewController;
        [parkingNavigateVC setStartLatitude:startLatitude];
        [parkingNavigateVC setStartLongitude:startLongitude];
        [parkingNavigateVC setEndLatitude:endLatitude];
        [parkingNavigateVC setEndLongitude:endLongitude];
    }
    
    if ([segue.identifier isEqualToString:@"toTParkDetailsVC"]) {
        TParkDetailsVC *parkDetailsVC = segue.destinationViewController;
        parkDetailsVC.parkModel = detailModel;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"listCell";
    
    TNearParkListCell *cell = (TNearParkListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"TNearParkListCell" owner:self options:nil];
        cell = parkListCell;
    }
    
    if (((listDatas.count % 10) == 0) && indexPath.row == [listDatas count] - 1) {
        
        NSString *url = [NSString stringWithFormat:@"%@&page_show=%i",urlStr, currentIndex];
        
        MyRequest *request = [[MyRequest alloc] init];
        request.delegae = self;
        [request getUrl:url sendTime:30];
        NSLog(@"url === %@",url);
    }
    
    TNearParkModel *model = [listDatas objectAtIndex:indexPath.row];
    [cell setCellContent:model];
    [cell setDelegate:self];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    detailModel = [listDatas objectAtIndex:indexPath.row];

    [self performSegueWithIdentifier:@"toTParkDetailsVC" sender:nil];
}

#pragma mark - TNearParkListCellDelegate

- (void)gotoNavigationLongitude:(double)longitude latitude:(double)latitude
{
    endLatitude = latitude;
    endLongitude = longitude;
    [self performSegueWithIdentifier:@"toTParkingNavigateVC" sender:nil];
}

@end
