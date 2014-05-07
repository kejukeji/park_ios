//
//  tooles.h
//  huoche
//
//  Created by kan xu on 11-1-22.
//  Copyright 2011 paduu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "ZBarSDK.h"

@interface tooles : NSObject {	
	


}
+(ZBarReaderViewController *)createReader:(id)object;
+(NSString*)dataStrToStr:(NSString*)dataStr;
+ (NSString *)getIPAddress;
+(NSString *)getip;
+ (NSString *)Date2StrV:(NSDate *)indate;
+ (NSString *)Date2Str:(NSDate *)indate;
+ (void)MsgBox:(NSString *)msg;

+ (NSDateComponents *)DateInfo:(NSDate *)indate;
+(NSString*)MD5:(NSString*)str;
+ (void)OpenUrl:(NSString *)inUrl;

+ (void)showHUD:(NSString *)msg;
+(void)showTextHUD:(NSString *)labeltext;
+ (void)removeHUD:(NSInteger)time;
+(NSString*)intToNsdate2:(NSInteger)dateInt;
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
+(BOOL)isAllNumber:(NSString *)numbers;
+(NSString*)intToNsdate:(NSInteger)dateInt;
+(int)nsDateToInt:(NSDate*)date;
+(void)alertView:(NSString *)title
         Message:(NSString*)message
    button1Title:(NSString*)btnTitle1
    button2Title:(NSString*)btnTitle2
    button3Title:(NSString*)btnTitle3
        alertTag:(int)tag
        delegate:(id)delegate;
+ (BOOL) judgeFirstTime;
id loadObjectFromNib(NSString *nib, Class cls, id owner);
+(NSString *)invertToDate:(NSTimeInterval)timeinterval;
+(MBProgressHUD *)getHUD:(NSString *)MSG;
+(MBProgressHUD *)getHUD:(NSString *)MSG andView:(UIView*)view;
+(NSInteger)CalculateDaysWith:(NSInteger)data;
+(BOOL)isToday:(NSString*)dateStr;

@end
