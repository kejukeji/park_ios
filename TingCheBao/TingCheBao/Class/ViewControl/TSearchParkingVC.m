//
//  TSearchParkingVC.m
//  TingCheBao
//
//  Created by zhao on 14-5-10.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "TSearchParkingVC.h"
#import "BMapKit.h"
#import "TParkingNavigateVC.h"

@interface TSearchParkingVC () <BMKSearchDelegate>
{
    BMKSearch  *search;
    NSMutableArray *searchDatas;
}

@property (strong, nonatomic) IBOutlet UITextField *searchTF;
@property (strong, nonatomic) IBOutlet UITableView *searchTV;

@end

@implementation TSearchParkingVC

@synthesize searchStr;
@synthesize searchTF;
@synthesize searchTV;

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
    [searchTF setText:searchStr];
    NSLog(@"searchTF.text == %@",searchTF.text);
//    [searchTF becomeFirstResponder];
    
    searchDatas = [NSMutableArray arrayWithCapacity:0];

    search = [[BMKSearch alloc] init];
    search.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    if (searchTF.text.length > 0) {
        [search poiSearchInCity:@"上海" withKey:searchTF.text pageIndex:1];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

-(void)viewWillDisappear:(BOOL)animated {
    search.delegate = nil; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchParking:(id)sender
{
    [self.view endEditing:YES];

    [search poiSearchInCity:@"上海" withKey:searchTF.text pageIndex:1];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    [self.view endEditing:YES];
    
    NSIndexPath *path = [searchTV indexPathForSelectedRow];
    BMKPoiInfo *info = [searchDatas objectAtIndex:path.row];
    double startLatitude = [[[NSUserDefaults standardUserDefaults] stringForKey:@"latitude"] doubleValue];
    double startLongitude = [[[NSUserDefaults standardUserDefaults] stringForKey:@"longitude"] doubleValue];
    double endLatitude = info.pt.latitude;
    double endLongitude = info.pt.longitude;
    
    if ([segue.identifier isEqualToString:@"TParkingNavigateVC"]) {
        TParkingNavigateVC *parkingNavigateVC = segue.destinationViewController;
        [parkingNavigateVC setStartLatitude:startLatitude];
        [parkingNavigateVC setStartLongitude:startLongitude];
        [parkingNavigateVC setEndLatitude:endLatitude];
        [parkingNavigateVC setEndLongitude:endLongitude];
    }
}

- (void)onGetPoiResult:(BMKSearch*)searcher result:(NSArray*)poiResultList searchType:(int)type errorCode:(int)error;
{
    for (BMKPoiResult *result in poiResultList) {
        for (BMKPoiInfo *info in result.poiInfoList) {
            [searchDatas addObject:info];
        }
    }
    [searchTV reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return searchDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"listCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    BMKPoiInfo *info = [searchDatas objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:info.address];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
