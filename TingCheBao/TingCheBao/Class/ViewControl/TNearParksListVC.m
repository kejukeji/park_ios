//
//  TNearParksListVC.m
//  TingCheBao
//
//  Created by zhao on 14-5-2.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "TNearParksListVC.h"

@interface TNearParksListVC ()

@property (weak, nonatomic) IBOutlet UITableView *parkListTV;

@end

@implementation TNearParksListVC

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
    [parkListTV setBackgroundView:nil];
    [parkListTV setBackgroundColor:[UIColor clearColor]];
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
    NSLog(@"dsafasdfafadf");
    NSIndexPath *path = [parkListTV indexPathForSelectedRow];
    NSLog(@"path == %i",path.row);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"parkListCell";
    
    TNearParkListCell *cell = (TNearParkListCell *)[tableView dequeueReusableCellWithIdentifier:@"parkListCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[TNearParkListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell setCellContent];
    
    return cell;
}


@end
