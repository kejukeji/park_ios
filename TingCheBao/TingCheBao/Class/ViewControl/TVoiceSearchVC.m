//
//  TVoiceSearchVC.m
//  TingCheBao
//
//  Created by zhao on 14-5-2.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "TVoiceSearchVC.h"
#import "iflyMSC/IFlyRecognizerView.h"
#import "iflyMSC/IFlyRecognizerViewDelegate.h"
#import "TSearchParkingVC.h"

@interface TVoiceSearchVC () <IFlyRecognizerViewDelegate>
{
    IFlyRecognizerView      *_iflyRecognizerView;
}

@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (strong, nonatomic) IBOutlet UITextField *contentTF;

@property (weak, nonatomic) IBOutlet UIButton *noBtn;
@property (weak, nonatomic) IBOutlet UIButton *yesBtn;

@end

@implementation TVoiceSearchVC

@synthesize firstLabel;
@synthesize contentTF;
@synthesize yesBtn;
@synthesize noBtn;

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
    
    //初始化语音识别控件
    NSString *initString = [NSString stringWithFormat:@"appid=%@",XF_APPID];
    _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center initParam:initString];
    _iflyRecognizerView.delegate = self;
    
    [_iflyRecognizerView setParameter:@"domain" value:@"iat"];
    [_iflyRecognizerView setParameter:@"asr_audio_path" value:@"asrview.pcm"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_iflyRecognizerView setParameter:@"asr_audio_path" value:nil]; //当你再不需要保存音频时，请在必要的地方加上这行。
}

- (void)viewWillAppear:(BOOL)animated
{
    [firstLabel setText:@"请大声说出"];
    [contentTF setText:@"您要查找的位置"];
    [yesBtn setHidden:YES];
    [noBtn setHidden:YES];
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
    if ([segue.identifier isEqualToString:@"TSearchParkingVC"]) {
        TSearchParkingVC *searchParkingVC = segue.destinationViewController;
        [searchParkingVC setSearchStr:contentTF.text];
    }
}

- (IBAction)backVoice:(id)sender
{
    [contentTF setText:@""];
    [_iflyRecognizerView start];
}

- (IBAction)startVoice:(UIButton *)sender
{
    [_iflyRecognizerView start];
    NSLog(@"start listenning...");
}

#pragma mark delegate
- (void)onResult:(IFlyRecognizerView *)iFlyRecognizerView theResult:(NSArray *)resultArray
{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    firstLabel.text = @"您是否说的是";
    if ([contentTF.text isEqualToString:@"您要查找的位置"]) {
        contentTF.text = @"";
    }
    contentTF.text = [NSString stringWithFormat:@"%@%@",contentTF.text,result];
    [yesBtn setHidden:NO];
    [noBtn setHidden:NO];
}

- (void)onEnd:(IFlyRecognizerView *)iFlyRecognizerView theError:(IFlySpeechError *)error
{
    NSLog(@"errorCode:%d",[error errorCode]);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
