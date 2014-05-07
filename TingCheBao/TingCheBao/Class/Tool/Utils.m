//
//  Utils.m
//  HMPro
//
//  Created by 小铁 on 12-12-15.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import "Utils.h"
#import "Reachability.h"

@implementation Utils
/**
 *	@brief	得到文字的Size
 *
 *	@param 	text 	内容
 *
 *	@return	文字的size
 */
+ (CGSize)getTextSize:(NSString * )text fontSize:(CGFloat) fontsize andConstrainWidth:(CGFloat) width

{
    
    UIFont *font = [UIFont systemFontOfSize:fontsize];
    CGSize titleSize = [text sizeWithFont:font
                        constrainedToSize:CGSizeMake(width, MAXFLOAT)
                            lineBreakMode:NSLineBreakByCharWrapping];
    return titleSize;
}
+(UIImage*)scaleToSize:(UIImage*)img size:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

+(BOOL)isEmail:(NSString *)input
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:input];
}

//检测网络
+ (NSString *)checkNetWorkType
{
    //    NetworkStatus status = [[Reachability reachabilityWithHostName:@"www.baidu.com"] currentReachabilityStatus];
	//检测当前的网络
	Reachability * hostReach = [Reachability reachabilityWithHostName: @"www.baidu.com"];
    //    [hostReach startNotifier];
    switch ([hostReach currentReachabilityStatus]) {
        case NotReachable:
            // 没有网络连接
            return @"NO";
            break;
        case ReachableViaWWAN:
            // 使用3G网络
            return @"3G";
            break;
        case ReachableViaWiFi:
            // 使用WiFi网络
            return @"WiFi";
            break;
        default:
            return @"Error";
            break;
    }
}


//检测网络
+ (BOOL)checkCurrentNetWork
{
	//检测当前的网络
    Reachability * hostReach = [Reachability reachabilityForInternetConnection];
    //    [hostReach startNotifier];
    switch ([hostReach currentReachabilityStatus]) {
        case NotReachable:
            // 没有网络连接
            return NO;
            break;
        case ReachableViaWWAN:
            // 使用3G网络
            return YES;
            break;
        case ReachableViaWiFi:
            // 使用WiFi网络
            return YES;
            break;
        default:
            return NO;
            break;
    }
}

+(NSString *)getDocumentFilePathString:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

+ (BOOL)isHaveFileAtPath:(NSString *)path
{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

@end
