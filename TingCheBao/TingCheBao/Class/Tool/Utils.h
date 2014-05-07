//
//  Utils.h
//  HMPro
//
//  Created by 小铁 on 12-12-15.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    NONE=0, //没有网络
    IS3G, //3G网络
    ISWIFI,  //
    ERROR //顺序循环
} NetWorkType;


@interface Utils : NSObject
+ (CGSize)getTextSize:(NSString * )text fontSize:(CGFloat) fontsize andConstrainWidth:(CGFloat) width;
+(UIImage*)scaleToSize:(UIImage*)img size:(CGSize)size;

+(BOOL)isEmail:(NSString *)input;
+ (BOOL)checkCurrentNetWork;

+ (NSString *)checkNetWorkType;
+(NSString *)getDocumentFilePathString:(NSString *)fileName;

+ (BOOL)isHaveFileAtPath:(NSString *)path;

@end
