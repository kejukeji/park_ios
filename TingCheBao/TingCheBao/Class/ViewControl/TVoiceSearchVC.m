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
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"
#import "iflyMSC/IFlySpeechRecognizer.h"
#import "iflyMSC/IFlySpeechSynthesizer.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVAudioSession.h>
#import <AudioToolbox/AudioSession.h>

@interface TVoiceSearchVC () <IFlyRecognizerViewDelegate, IFlySpeechSynthesizerDelegate>
{
    IFlyRecognizerView      *_iflyRecognizerView;
    IFlySpeechSynthesizer  * _iFlySpeechSynthesizer;
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
    [_iflyRecognizerView start];
    
    //语音播报
    _iFlySpeechSynthesizer = [IFlySpeechSynthesizer createWithParams:initString delegate:self];
    _iFlySpeechSynthesizer.delegate = self;
    
    // 设置语音合成的参数
    [_iFlySpeechSynthesizer setParameter:@"speed" value:@"50"];//合成的语速,取值范围 0~100
    [_iFlySpeechSynthesizer setParameter:@"volume" value:@"50"];//合成的音量;取值范围 0~100
    //发音人,默认为”xiaoyan”;可以设置的参数列表可参考个 性化发音人列表;
    [_iFlySpeechSynthesizer setParameter:@"voice_name" value:@"xiaoyan"];
    [_iFlySpeechSynthesizer setParameter:@"sample_rate" value:@"8000"];//音频采样率,目前支持的采样率有 16000 和 8000;
    [_iFlySpeechSynthesizer setParameter:@"tts_audio_path" value:@"tts.pcm"];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [_iflyRecognizerView setParameter:@"asr_audio_path" value:nil]; //当你再不需要保存音频时，请在必要的地方加上这行。
    [_iFlySpeechSynthesizer stopSpeaking];
    _iFlySpeechSynthesizer = nil;
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
    
    //去除标点---因为有标点无法搜索
    NSString *string = [contentTF.text stringByReplacingOccurrencesOfString:@"，" withString:@""];
    NSString *searchStr = [string stringByReplacingOccurrencesOfString:@"。" withString:@""];

    
    [_iFlySpeechSynthesizer stopSpeaking];

    if ([segue.identifier isEqualToString:@"TSearchParkingVC"]) {
        TSearchParkingVC *searchParkingVC = segue.destinationViewController;
        [searchParkingVC setSearchStr:searchStr];
    }
}

- (IBAction)backVoice:(id)sender
{
    [_iFlySpeechSynthesizer stopSpeaking];

    [contentTF setText:@""];
    [_iflyRecognizerView start];
}

- (IBAction)startVoice:(UIButton *)sender
{
    [_iFlySpeechSynthesizer stopSpeaking];

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
    [_iFlySpeechSynthesizer startSpeaking:[NSString stringWithFormat:@"您是否说的是：%@",contentTF.text]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

/**
 * @fn      onCompleted
 * @brief   结束回调
 *
 * @param   error               -[out] 错误对象
 * @see
 */

- (void) onCompleted:(IFlySpeechError *) error
{
    NSLog(@"error == %@",error);
}

@end
