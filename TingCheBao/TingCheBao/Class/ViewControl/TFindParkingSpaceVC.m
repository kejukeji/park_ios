//
//  TFindParkingSpaceVC.m
//  TingCheBao
//
//  Created by zhao on 14-4-28.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "TFindParkingSpaceVC.h"
#import "TNearParksListVC.h"
#import "TVoiceSearchVC.h"
#import "TSearchParkingVC.h"
#import "BMapKit.h"
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"
#import "iflyMSC/IFlySpeechRecognizer.h"
#import "iflyMSC/IFlySpeechSynthesizer.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVAudioSession.h>
#import <AudioToolbox/AudioSession.h>
#import "tooles.h"

@interface TFindParkingSpaceVC ()  <BMKMapViewDelegate, BMKSearchDelegate, IFlySpeechSynthesizerDelegate>
{
    BMKSearch              *search;
    IFlySpeechSynthesizer  * _iFlySpeechSynthesizer;
}

@property (nonatomic, strong) BMKMapView *mapView;

@property (weak, nonatomic) IBOutlet UIImageView *homeIconImg;

@end

@implementation TFindParkingSpaceVC

@synthesize currentLocation;
@synthesize homeIconImg;
@synthesize mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)gotoVoice
{
    [self performSegueWithIdentifier:@"toTVoiceSearchVC" sender:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoVoice) name:@"gotoVoice" object:nil];
    [homeIconImg setHighlighted:YES];
    
    self.navigationController.navigationBar.barStyle = UIBaselineAdjustmentNone;
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bar_bg.png"] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.clipsToBounds = YES;
//    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
//        self.navigationController.edgesForExtendedLayout = UIRectEdgeNone;
//        
//    }
    
    mapView = [[BMKMapView alloc] initWithFrame:CGRectZero];
    
    mapView.showsUserLocation = NO;//先关闭显示的定位图层
    mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    mapView.showsUserLocation = YES;//显示定位图层
    
    [tooles showHUD:@"正在获取您的位置..."];
    
    search = [[BMKSearch alloc] init];
    
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",XF_APPID];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [mapView viewWillAppear];
    [mapView setDelegate:self];
    search.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    [mapView viewWillDisappear];
    mapView.delegate = nil; // 不用时，置nil
    search.delegate = nil; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _iFlySpeechSynthesizer = nil;
}

#pragma mark -
#pragma mark mapViewDelegate

- (void)mapView:(BMKMapView *)mapView1 didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    BMKCoordinateRegion region;
    region.center.latitude  = userLocation.location.coordinate.latitude;
    region.center.longitude = userLocation.location.coordinate.longitude;
    region.span.latitudeDelta  = 0.2;
    region.span.longitudeDelta = 0.2;
    if (mapView)
    {
        mapView.region = region;
        NSLog(@"当前的坐标是: %f,%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    }
    currentLocation = userLocation.location;
    
    BOOL flag = [search reverseGeocode:userLocation.location.coordinate];
	if (flag) {
		NSLog(@"ReverseGeocode search success.");
        
	}
    else{
        NSLog(@"ReverseGeocode search failed!");
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    [_iFlySpeechSynthesizer stopSpeaking];

    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lf",currentLocation.coordinate.latitude] forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lf",currentLocation.coordinate.longitude] forKey:@"longitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([segue.identifier isEqualToString:@"toTNearParksListVC"]) {
        TNearParksListVC *nearParksListVC = segue.destinationViewController;
        NSString *url = [NSString stringWithFormat:@"%@park/v1/carbarn/latitude-longitude?latitude=%f&longitude=%f", TCB_URL,currentLocation.coordinate.latitude, currentLocation.coordinate.longitude];
        nearParksListVC.urlStr = url;
//        [nearParksListVC requestNearParksData:url];
    }
}

- (void)onGetAddrResult:(BMKSearch*)searcher result:(BMKAddrInfo*)result errorCode:(int)error;
{
	if (error == 0) {
		BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
		item.coordinate = result.geoPt;
		item.title = result.strAddr;
        NSString *cityName = result.addressComponent.city;
        NSString* showmeg;
        showmeg = [NSString stringWithFormat:@"%@",item.title];
        [[NSUserDefaults standardUserDefaults] setObject:showmeg forKey:@"currentAddr"];
        [[NSUserDefaults standardUserDefaults] setObject:cityName forKey:@"currentCityName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [tooles removeHUD:0];

        NSString *playStr = [NSString stringWithFormat:@"您好,我是您的停车小秘,您现在的位置是:%@,请告诉我您要去哪里",showmeg];
        [_iFlySpeechSynthesizer startSpeaking:playStr];
    }
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

/** 播放进度回调
 
 @param progress 播放进度，0-100
 */

- (void) onSpeakProgress:(int) progress
{
    if (progress == 100) {  //播放完毕后停止
        _iFlySpeechSynthesizer = nil;
    }
}

@end
