//
//  TSearchParkingVC.m
//  TingCheBao
//
//  Created by zhao on 14-5-10.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "TSearchParkingVC.h"
#import "BMapKit.h"
#import "TNearParksListVC.h"
#import "PullingRefreshTableView.h"

@interface TSearchParkingVC () <BMKSearchDelegate, UITextFieldDelegate>
{
    BMKSearch      *search;
    NSMutableArray *searchDatas;
    BMKAddrInfo    *addrInfo;
    NSString       *cityName;
}

@property (strong, nonatomic) IBOutlet UITextField *searchTF;

@property (weak, nonatomic) IBOutlet UITableView *searchTV;

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
    
    [searchTF setDelegate:self];
    
    [searchTF setText:searchStr];
    NSLog(@"searchTF.text == %@",searchTF.text);
//    [searchTF becomeFirstResponder];
    
    searchDatas = [NSMutableArray arrayWithCapacity:0];

    search = [[BMKSearch alloc] init];
    
    cityName = [[NSUserDefaults standardUserDefaults] stringForKey:@"currentCityName"];

    if (searchStr.length > 0) {
        [search suggestionSearch:searchStr inCity:cityName];
    } else {
        NSMutableArray *historys = [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:@"searchHistory"];
        if (historys > 0) {
            for (int i = historys.count - 1; i < historys.count; i--) {
                NSString *str = historys[i];
                [searchDatas addObject:str];
            }
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    search.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
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

    if (searchDatas.count > 0) {
        [searchDatas removeAllObjects];
    }
    [search suggestionSearch:searchTF.text inCity:cityName];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    [self.view endEditing:YES];
    
//    NSIndexPath *path = [searchTV indexPathForSelectedRow];
    
//    BMKPoiInfo *info = [searchDatas objectAtIndex:path.row];
    
    double gotoAtitude = addrInfo.geoPt.latitude;
    double gotoLongitude = addrInfo.geoPt.longitude;
    
    if ([segue.identifier isEqualToString:@"toTNearParksListVC"]) {
        TNearParksListVC *nearParksListVC = segue.destinationViewController;
        NSString *url = [NSString stringWithFormat:@"%@park/v1/carbarn/latitude-longitude?latitude=%f&longitude=%f", TCB_URL,gotoAtitude, gotoLongitude];
        [nearParksListVC requestNearParksData:url];
    }
}

- (void)onGetSuggestionResult:(BMKSearch*)searcher result:(BMKSuggestionResult*)result errorCode:(int)error
{
    for (NSString *districtList in result.keyList) {
        [searchDatas addObject:districtList];
    }
    [searchTV reloadData];
}

- (void)onGetAddrResult:(BMKSearch*)searcher result:(BMKAddrInfo*)result errorCode:(int)error;
{
	addrInfo = result;
    [self performSegueWithIdentifier:@"toTNearParksListVC" sender:nil];
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
    
    NSString *address = [searchDatas objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:address];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *address = [searchDatas objectAtIndex:indexPath.row];
    
    NSMutableArray *historys = [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:@"searchHistory"];
    
    if (historys.count == 0) {
        [historys addObject:address];
    } else {
        for (int i = 0; i < historys.count; i++) {
            NSString *str = historys[i];
            if (![address isEqualToString:str] && i == historys.count - 1) { //不同的增加
                [historys addObject:address];
            }
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:historys forKey:@"searchHistory"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [search geocode:address withCity:cityName];

}

@end
