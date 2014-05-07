//
//  CheckNewApp.m
//  CheckNewApp
//
//  Created by 朱明 on 13-9-14.
//  Copyright (c) 2013年 user. All rights reserved.
//

#define kSearchAppStroreURL  @"http://itunes.apple.com/lookup?id=%@"

#import "TAppDelegate.h"
#import "CheckNewApp.h"
#import "tooles.h"
@implementation CheckNewApp
@synthesize updateActionBlock;
+(void)ShowMessage:(NSString *)message delegate:(id)delegate
{
    @autoreleasepool {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"当前有新版本" message:message delegate:delegate cancelButtonTitle:@"取消" otherButtonTitles:@"更新",@"下次不再提醒",nil];
        [alert show];
    }
    
    //[alert release];
}

+(void)CheckNewApp:(id)viewcontroller AppID:(NSString*)Appid
{
    if ([viewcontroller isKindOfClass:[TAppDelegate class]]) {
        @autoreleasepool {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:kSearchAppStroreURL,Appid]];
                NSError *error=nil;
                NSURLRequest *request=[NSURLRequest requestWithURL:url];
                NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
                if (!data) {return ;}
                NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                
                NSArray *resaultarry=[dict objectForKey:@"results"];
                NSDictionary *resaultdict=[resaultarry objectAtIndex:0];
                NSString *newversionstr=[resaultdict objectForKey:@"version"];
                NSString *currentverision=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                [[NSUserDefaults standardUserDefaults] setObject:newversionstr forKey:kNewVersion];
                [[NSUserDefaults standardUserDefaults] setObject:[resaultdict objectForKey:@"trackViewUrl"] forKey:@"trackViewUrl"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSComparisonResult resault=[newversionstr compare:currentverision];
                    if (resault>0) {//提醒有新版本
                        
                        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
                        
                        [self ShowMessage:[resaultdict objectForKey:@"releaseNotes"] delegate:viewcontroller];
                    }
                    else{
                        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];//清空提醒标志
                    }
                });
            });
        }
    }
    else
    {
        @autoreleasepool {
            [tooles showHUD:@"检测更新中......"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:kSearchAppStroreURL,Appid]];
                NSError *error=nil;
                NSURLRequest *request=[NSURLRequest requestWithURL:url];
                NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
                if (!data) {return ;}
                NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                
                NSArray *resaultarry=[dict objectForKey:@"results"];
                NSDictionary *resaultdict=[resaultarry objectAtIndex:0];
                NSString *newversionstr=[resaultdict objectForKey:@"version"];
                NSString *currentverision=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                [[NSUserDefaults standardUserDefaults] setObject:newversionstr forKey:kNewVersion];
                [[NSUserDefaults standardUserDefaults] setObject:[resaultdict objectForKey:@"trackViewUrl"] forKey:@"trackViewUrl"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSComparisonResult resault=[newversionstr compare:currentverision];
                    if (resault>0) {//提醒有新版本
                        [tooles removeHUD:0];
                        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
                        
                        [self ShowMessage:[resaultdict objectForKey:@"releaseNotes"] delegate:viewcontroller];
                    }
                    else{
                        [tooles removeHUD:0];
                        [tooles MsgBox:@"你已经是最新版本"];
                        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];//清空提醒标志
                    }
                });
            });
        }
    }
}


@end
