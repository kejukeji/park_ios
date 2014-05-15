//
//  HBFormDataRequest.h
//  huoban
//
//  Created by zhao on 14-4-18.
//  Copyright (c) 2014年 ZHU. All rights reserved.
//

@class MyRequest;

@protocol MyRequestDelegate <NSObject>

- (void)requestResult:(NSDictionary *)resultDict formDataRequest:(MyRequest *)request;
- (void)requestFail:(NSString *)msg;

@end

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

@interface MyRequest : NSObject

@property (nonatomic, assign) id<MyRequestDelegate>delegae;

@property (nonatomic, weak) __block ASIHTTPRequest      *sendRequest;
@property (nonatomic, weak) __block ASIFormDataRequest  *formDataRequest;

- (void)getUrl:(NSString *)urlString sendTime:(NSInteger)time;  //get sendRequest
- (void)postUrl:(NSString *)urlString addPostValueKey:(NSDictionary *)valueDict addFileKey:(NSDictionary *)fileDict sendTime:(NSInteger)time;  //post sendRequest

@end
