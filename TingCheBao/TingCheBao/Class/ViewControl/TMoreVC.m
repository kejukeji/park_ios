//
//  TMoreVC.m
//  TingCheBao
//
//  Created by zhao on 14-5-17.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "TMoreVC.h"
#import "TMoreCell.h"
#import "TAboutOurVC.h"
#import "TContactVC.h"
#import "TFeedbackVC.h"
#import "UMFeedback.h"
#import "MobClick.h"

@interface TMoreVC ()

@property (strong, nonatomic) IBOutlet UITableView *moreTV;
@property (weak, nonatomic) IBOutlet UIImageView *moreIconImg;

@end

@implementation TMoreVC

@synthesize moreTV;
@synthesize moreIconImg;

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
    [moreIconImg setHighlighted:YES];
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"moreCell";
    
    TMoreCell *cell = (TMoreCell *)[tableView dequeueReusableCellWithIdentifier:@"moreCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[TMoreCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    switch (indexPath.row) {
        case 0:
            [cell.nameLabel setText:@"关于我们"];
            break;
        case 1:
            [cell.nameLabel setText:@"联系我们"];
            break;
        case 2:
            [cell.nameLabel setText:@"版本更新"];
            break;
        case 3:
            [cell.nameLabel setText:@"反馈意见"];
            break;
        case 4:
            [cell.nameLabel setText:@"告诉朋友"];
            break;
        default:
            break;
    }
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"toTAboutOurVC" sender:nil];
            break;
        case 1:
            [self performSegueWithIdentifier:@"toTContactVC" sender:nil];
            break;
        case 2:
        {
            [MobClick startWithAppkey:UM_KEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];
            [MobClick updateOnlineConfig];  //在线参数配置
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];

        }
            break;
        case 3:
            [UMFeedback showFeedback:self withAppkey:UM_KEY];

//            [self performSegueWithIdentifier:@"toFeedbackVC" sender:nil];
            break;
        case 4:
            NSLog(@"告诉朋友");
            break;
        default:
            break;
    }
}

- (void)onlineConfigCallBack:(NSNotification *)note {
    
    NSLog(@"online config has fininshed and note = %@", note.userInfo);
}

- (IBAction)gotoHomePage:(UIButton *)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)gotoVoice:(UIButton *)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoVoice" object:nil];
}

@end
