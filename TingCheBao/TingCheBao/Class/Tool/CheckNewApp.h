//
//  CheckNewApp.h
//  CheckNewApp
//
//  Created by 朱明 on 13-9-14.
//  Copyright (c) 2013年 user. All rights reserved.
//
#define kNewVersion @"NewVersion"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
typedef void (^UpdateBlock)(void);

@interface CheckNewApp : NSObject

@property(nonatomic,strong) UpdateBlock updateActionBlock;
//检查是否新版本
+(void)CheckNewApp:(id)viewcontroller AppID:(NSString*)Appid;

@end
