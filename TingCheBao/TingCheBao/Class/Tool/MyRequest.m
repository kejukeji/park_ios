//
//  HBFormDataRequest.m
//  huoban
//
//  Created by zhao on 14-4-18.
//  Copyright (c) 2014年 ZHU. All rights reserved.
//

#import "MyRequest.h"
#import "tooles.h"

@implementation MyRequest

@synthesize delegae;
@synthesize sendRequest;
@synthesize formDataRequest;

- (void)getUrl:(NSString *)urlString sendTime:(NSInteger)time  //get sendRequest
{
    NSLog(@"url == %@",urlString);

    if (sendRequest != nil) {
        [sendRequest clearDelegatesAndCancel];
        sendRequest = nil;
    }
    
    NSURL * url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    sendRequest = [ASIHTTPRequest requestWithURL:url];
    [sendRequest setTimeOutSeconds:30];
    [sendRequest setDelegate: self];
    [sendRequest startAsynchronous];
                   
    [sendRequest setCompletionBlock:^{
        NSError *error = nil;
        if (error) {
            NSLog(@"error = %@",error);
            return ;
        }
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[sendRequest responseData] options:kNilOptions error:&error];
        //        NSLog(@"result dic == %@",dic);
        if ([[dic objectForKey:@"status"] intValue] != 400) {
            NSLog(@"success");
            
            [delegae requestResult:dic formDataRequest:self];
        }
        else
        {
            [delegae requestFail:[dic objectForKey:@"errorMessage"]];
        }
        
    }];
    
    [formDataRequest setFailedBlock:^{
        [tooles MsgBox:@"请检查网络！！！"];
    }];
}

- (void)postUrl:(NSString *)urlString addPostValueKey:(NSDictionary *)valueDict addFileKey:(NSDictionary *)fileDict sendTime:(NSInteger)time  //post sendRequest
{
    NSLog(@"url == %@",urlString);
    if (formDataRequest != nil) {
        [formDataRequest clearDelegatesAndCancel];
        formDataRequest = nil;
    }
    
    formDataRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    [formDataRequest setDelegate:self];
    [formDataRequest setTimeOutSeconds:time];
    [formDataRequest setRequestMethod:@"POST"];
    
    if (valueDict != nil) {
        for (int i = 0; i < [valueDict count]; i++) {
            NSString *key = [[valueDict allKeys] objectAtIndex:i];
            NSString *value = [valueDict objectForKey:key];
            [formDataRequest addPostValue:value forKey:key];
            NSLog(@"key:  %@, value:  %@",key, value);
        }
    }
    
    if (fileDict != nil) {
        for (int i = 0; i < [fileDict count]; i++) {
            NSString *key = [[fileDict allKeys] objectAtIndex:i];
            NSData *value = [fileDict objectForKey:key];
            [formDataRequest addData:value forKey:key];
        }
    }
    
    [formDataRequest startAsynchronous];
    
    [formDataRequest setCompletionBlock:^{
        NSError *error = nil;
        if (error) {
            NSLog(@"error = %@",error);
            return ;
        }
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[formDataRequest responseData] options:kNilOptions error:&error];
//        NSLog(@"result dic == %@",dic);
        if ([[dic objectForKey:@"status"] intValue] != 400) {

            [delegae requestResult:dic formDataRequest:self];
        }
        else
        {
            [delegae requestFail:[dic objectForKey:@"errorMessage"]];
        }
        
    }];
    
    [formDataRequest setFailedBlock:^{
        [tooles MsgBox:@"请检查网络！！！"];
    }];
}

@end
