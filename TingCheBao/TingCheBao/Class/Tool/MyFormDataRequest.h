//
//  HBFormDataRequest.h
//  huoban
//
//  Created by zhao on 14-4-18.
//  Copyright (c) 2014年 ZHU. All rights reserved.
//

@class MyFormDataRequest;

@protocol MyFormDataRequestDelegate <NSObject>

- (void)requestResult:(NSDictionary *)resultDict formDataRequest:(MyFormDataRequest *)request;

@end

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

@interface MyFormDataRequest : NSObject

@property (nonatomic, assign) id<MyFormDataRequestDelegate>delegae;

@property (nonatomic, strong) ASIHTTPRequest      *sendRequest;
@property (nonatomic, weak) __block ASIFormDataRequest  *formDataRequest;

- (void)getUrl:(NSString *)urlString sendTime:(NSInteger)time;  //get sendRequest
- (void)postUrl:(NSString *)urlString addPostValueKey:(NSDictionary *)valueDict addFileKey:(NSDictionary *)fileDict sendTime:(NSInteger)time;  //post sendRequest

@end
