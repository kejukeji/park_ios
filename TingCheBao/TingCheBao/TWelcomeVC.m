//
//  TWelcomeVC.m
//  TingCheBao
//
//  Created by zhao on 14-5-17.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "TWelcomeVC.h"

@interface TWelcomeVC ()

@property (weak, nonatomic) IBOutlet UIButton *startBtn;

@end

@implementation TWelcomeVC

@synthesize welcomeScroll;
@synthesize welcomePage;
@synthesize firstImgView;
@synthesize secondImgView;
@synthesize thirdImgView;
@synthesize startBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    //增加标识，用于判断是否是第一次启动应用...
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunchTag"]) {
        NSLog(@"初次加载");
        //搜索历史
        NSMutableArray *historys = [NSMutableArray arrayWithCapacity:0];
        [[NSUserDefaults standardUserDefaults] setObject:historys forKey:@"searchHistory"];
        [[NSUserDefaults standardUserDefaults] synchronize];

    } else {
        [self.firstImgView setImage:[UIImage imageNamed:(iPhone5?@"Default-568h@2x.png":@"Default.png")]];
        [self.welcomePage setHidden:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunchTag"]) {
        NSLog(@"初次加载");
    } else {
        [self performSegueWithIdentifier:@"toTMainNavigation" sender:nil];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [welcomeScroll setContentSize:CGSizeMake(960, 480 + (iPhone5?88:0))];
    
    [firstImgView setImage:[UIImage imageNamed:(iPhone5?@"first-568h@2x.png":@"first.png")]];
    [secondImgView setImage:[UIImage imageNamed:(iPhone5?@"second-568h@2x.png":@"second.png")]];
    [thirdImgView setImage:[UIImage imageNamed:(iPhone5?@"third-568h@2x.png":@"third.png")]];

    [startBtn setFrame:CGRectMake(738, 157 + (iPhone5?60:0), 125, 45)];
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
}

#pragma mark -
#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = 320;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) +1;
    self.welcomePage.currentPage = page;
    
}
- (IBAction)gotoHomePage:(UIButton *)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunchTag"];

    [self performSegueWithIdentifier:@"toTMainNavigation" sender:nil];
}

@end
