//
//  tooles.m
//  huoche
//
//  Created by kan xu on 11-1-22.
//  Copyright 2011 paduu. All rights reserved.
//

#import "tooles.h"
#import "FlatUIKit.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#include <netdb.h>
#include <net/if.h>
#include <dlfcn.h>
#import <CommonCrypto/CommonDigest.h>


#define MsgBox(msg) [self MsgBox:msg]

@implementation tooles

static MBProgressHUD *HUD;


//创建扫描仪
+(ZBarReaderViewController *)createReader:(id)object
{
    ZBarReaderViewController *reader=[ZBarReaderViewController new];
    reader.showsZBarControls=YES;
    reader.showsHelpOnFail=YES;
    reader.readerDelegate=object;
    reader.supportedOrientationsMask=ZBarOrientationMaskAll;
    ZBarImageScanner *scanner=[[ZBarImageScanner alloc]init];
    [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    return  reader;
}

+(NSInteger)CalculateDaysWith:(NSInteger)data

{
//    NSString *dateStr=@"2013-08-13 20:28:40";//传入时间
//    //将传入时间转化成需要的格式
//    NSDateFormatter *format=[[NSDateFormatter alloc] init];
//    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:data];
    
    NSLog(@"1363948516  = %@",confromTimesp);
    
    //获取当前时间
    NSDate *datecount = [NSDate date];
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate: date];
//    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
//    NSLog(@"enddate=%@",localeDate);
    
    
    double intervalTime = [confromTimesp timeIntervalSinceReferenceDate] - [datecount timeIntervalSinceReferenceDate];
    
    long lTime = (long)intervalTime;
//    NSInteger iSeconds = lTime % 60;
//    NSInteger iMinutes = (lTime / 60) % 60;
//    NSInteger iHours = (lTime / 3600)$;
    NSInteger iDays = lTime/60/60/24;
//    NSInteger iMonth = lTime/60/60/24/12;
//    NSInteger iYears = lTime/60/60/24/384;
    
    NSLog(@"相差M年d月 或者 %d日d时d分d秒",iDays);
    
    return iDays;
    
}




//程序中使用的，将日期显示成  2011年4月4日 星期一
+ (NSString *) Date2StrV:(NSDate *)indate{

	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] ]; //setLocale 方法将其转为中文的日期表达
//	dateFormatter.dateFormat = @"yyyy '-' MM '-' dd ' ' EEEE";
    dateFormatter.dateFormat =@"MM'-'dd";
    
	NSString *tempstr = [dateFormatter stringFromDate:indate];
	return tempstr;
}
//+ (NSString*)dicstore:(NSDictionary*)dic
//{
//    NSString *srot_str =nil;
//    NSArray * Keyarr = [dic allKeys];
//    [Keyarr sortedArrayUsingSelector:@selector(compare:)];
//    NSLog(@"keyarr = %@",Keyarr);
//    for (NSString *str in Keyarr) {
//        srot_str stringByAppendingString:[NSString stringWithFormat:@"%@=%@",str
//    }
//    return srot_str;
//}
//程序中使用的，提交日期的格式
+ (NSString *) Date2Str:(NSDate *)indate{
	
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] ];
	[dateFormatter setDateFormat:@"MM'-'dd"];
	NSString *tempstr = [dateFormatter stringFromDate:indate];
	return tempstr;	
}

//md5加密
+(NSString*)MD5:(NSString*)str
{
    //按key的首字母排序
    //md5加密
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
}

+(int)nsDateToInt:(NSDate*)date
{
    NSTimeInterval time = [date timeIntervalSince1970];
     int d = ( int)time;
    return d; //1295322949
}
//将int转换成NSDate再转成str
+(NSString*)intToNsdate2:(NSInteger)dateInt
{
    //    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    //    long long int date = (long long int)time;
    //    NSLog(@”date\n%d”, date); //1295322949
    NSDateFormatter *f = [[NSDateFormatter alloc]init];
    [f setDateFormat:@"yyyy"];
    NSString *year = [f stringFromDate:[NSDate date]];
    
    
    NSString *s =[NSString stringWithFormat:@"%i",dateInt]; //对应21:00
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:[s doubleValue]];
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    NSString *year1 = [f stringFromDate:d];
    if ([year isEqualToString:year1]) {
        [formatter1 setDateFormat:@"MM'-'dd"];
    }
    else
    {
        [formatter1 setDateFormat:@"MM'-'dd"];
    }
    NSString *showtimeNew = [formatter1 stringFromDate:d];
    
     //21:00 比d的时间 +8小时
    return showtimeNew;
}
+(NSString*)dataStrToStr:(NSString*)dataStr
{
     //对应21:00
    NSString *s = [dataStr substringToIndex:10];
    NSLog(@"s = -%@",s);
    
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:[s doubleValue]];
    //2011-01-18 13:00:00 +0000
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    //    [formatter1 setDateFormat:@"yyyy'-'MM'-'dd'"];
     [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *showtimeNew = [formatter1 stringFromDate:d];
    
    
    return showtimeNew;
}
//将int转换成NSDate再转成str
+(NSString*)intToNsdate:(NSInteger)dateInt
{
//    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
//    long long int date = (long long int)time;
//    NSLog(@”date\n%d”, date); //1295322949
    
    
    NSString *s =[NSString stringWithFormat:@"%i",dateInt]; //对应21:00
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:[s doubleValue]];
//2011-01-18 13:00:00 +0000
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
//    [formatter1 setDateFormat:@"yyyy'-'MM'-'dd'"];
    [formatter1 setDateFormat:@"MM'-'dd"];
    NSString *showtimeNew = [formatter1 stringFromDate:d];
    
    
    return showtimeNew;
}
//// 手机号码的有效性判断
//检测是否是手机号码
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+(BOOL)isAllNumber:(NSString *)numbers
{
    NSString *allnumber=@"^\\d{6}$";
    NSPredicate *regextestnumber=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",allnumber];
    if ([regextestnumber evaluateWithObject:numbers]==YES) {
        return YES;
    }
    else
        return NO;
}
// Get IP Address
+ (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

+(NSString *)getip
{
        BOOL success;
        struct ifaddrs * addrs;
        const struct ifaddrs * cursor;
        success = getifaddrs(&addrs) == 0;
        if (success) {
            cursor = addrs;
            while (cursor != NULL) {
                // the second test keeps from picking up the loopback address
                if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
                {
                    NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                    
                    if ([name isEqualToString:@"en0"])  // Wi-Fi adapter
                        
                        return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
                    
                }
                cursor = cursor->ifa_next;
                
            }
            freeifaddrs(addrs);
        }
    
        return nil;
    }
+(void)alertView:(NSString *)title
         Message:(NSString*)message
    button1Title:(NSString*)btnTitle1
    button2Title:(NSString*)btnTitle2
    button3Title:(NSString*)btnTitle3
        alertTag:(int)tag
        delegate:(id)delegate
{
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:btnTitle1 otherButtonTitles:btnTitle2,btnTitle3,nil];
    alertView.tag = tag;
    alertView.titleLabel.textColor = [UIColor cloudsColor];
    alertView.titleLabel.font = [UIFont systemFontOfSize:16];
    alertView.messageLabel.textColor = [UIColor cloudsColor];
    alertView.messageLabel.font = [UIFont flatFontOfSize:14];
    alertView.backgroundOverlay.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    alertView.alertContainer.backgroundColor = [UIColor midnightBlueColor];
    alertView.defaultButtonColor = [UIColor cloudsColor];
    alertView.defaultButtonShadowColor = [UIColor asbestosColor];
    alertView.defaultButtonFont = [UIFont systemFontOfSize:16];
    alertView.defaultButtonTitleColor = [UIColor asbestosColor];
    [alertView show];
}
#pragma mark - 判断是否是第一次进入客户端
#define kIsFirstEnter @"isfirstenter"
// 判断是否是第一次进入客户端
+ (BOOL) judgeFirstTime {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kIsFirstEnter]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsFirstEnter];
        return YES;
    }
    return NO;
}

// 根据nib创建对象
id loadObjectFromNib(NSString *nib, Class cls, id owner) {
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:nib owner:owner options:nil];
    for (id oneObj in nibs) {
        if ([oneObj isKindOfClass:cls]) {
            return oneObj;
        }
    }
    return nil;
}

//提示窗口
+ (void)MsgBox:(NSString *)msg{
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg
												   delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alert show];
		
}

//获得日期的具体信息，本程序是为获得星期，注意！返回星期是 int 型，但是和中国传统星期有差异
+ (NSDateComponents *) DateInfo:(NSDate *)indate{

	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | 
	NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;

	comps = [calendar components:unitFlags fromDate:indate];
	
	return comps;

//	week = [comps weekday];
//	month = [comps month];
//	day = [comps day];
//	hour = [comps hour];
//	min = [comps minute];
//	sec = [comps second];

}


//打开一个网址
+ (void) OpenUrl:(NSString *)inUrl{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:inUrl]];
}



//MBProgressHUD 的使用方式，只对外两个方法，可以随时使用(但会有警告！)，其中窗口的 alpha 值 可以在源程序里修改。
+ (void)showHUD:(NSString *)msg{
	
	HUD = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
	[[UIApplication sharedApplication].keyWindow addSubview:HUD];
	HUD.labelText = msg;
    //HUD.mode=MBProgressHUDModeText;
	[HUD show:YES];
}
+(MBProgressHUD *)getHUD:(NSString *)MSG
{
    HUD = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
	[[UIApplication sharedApplication].keyWindow addSubview:HUD];
	HUD.labelText = MSG;
	[HUD show:YES];
    return HUD;
}
+(MBProgressHUD *)getHUD:(NSString *)MSG andView:(UIView*)view
{
    HUD = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:HUD];
	HUD.labelText = MSG;
	[HUD show:YES];
    return HUD;
}
+(void)showTextHUD:(NSString *)labeltext
{
    HUD = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
	[[UIApplication sharedApplication].keyWindow addSubview:HUD];
    HUD.mode=MBProgressHUDModeText;
    HUD.labelText = labeltext;
	[HUD show:YES];
}
////验证用户名密码是否为空
//-(BOOL)determineAccount
//{
//    if ([_urserName.text length] == 0 ||[_passWord.text length] == 0) {
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"友情提示", nil) message:NSLocalizedString(@"账号和密码不能为空", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//        return FALSE;
//    }
//    return TRUE;
//}


+ (void)removeHUD:(NSInteger)time{
    [HUD hide:YES afterDelay:time];
	[HUD removeFromSuperViewOnHide];
	
}
+(NSString *)invertToDate:(NSTimeInterval)timeinterval
{
    NSDate *date=[NSDate dateWithTimeIntervalSince1970: timeinterval];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.timeZone=[NSTimeZone timeZoneWithName:@"beijing"];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *string=[formatter stringFromDate:date];
    string=[string substringWithRange:NSMakeRange(6,5)];
    return string;
}

//判断是否是今天
+(BOOL)isToday:(NSString*)dateStr
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSInteger d = ( int)time;
    
    
    return  [[self intToNsdate2:d]isEqualToString:dateStr];
}

@end
