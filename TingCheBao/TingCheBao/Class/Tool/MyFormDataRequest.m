//
//  HBFormDataRequest.m
//  huoban
//
//  Created by zhao on 14-4-18.
//  Copyright (c) 2014年 ZHU. All rights reserved.
//

#import "MyFormDataRequest.h"
#import "tooles.h"

@implementation MyFormDataRequest

@synthesize delegae;
@synthesize sendRequest;
@synthesize formDataRequest;

- (void)getUrl:(NSString *)urlString sendTime:(NSInteger)time  //get sendRequest
{
    
}

- (void)postUrl:(NSString *)urlString addPostValueKey:(NSDictionary *)valueDict addFileKey:(NSDictionary *)fileDict sendTime:(NSInteger)time  //post sendRequest
{
    NSLog(@"url == %@",urlString);
    if (formDataRequest != nil) {
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
        if ([[dic objectForKey:@"status"] intValue] != 10) {
            NSLog(@"success");

            [delegae requestResult:dic formDataRequest:self];
        }
        else
        {
            [[NSNotificationCenter  defaultCenter]postNotificationName:@"goToLoginVC" object:nil];
            [tooles MsgBox:[dic objectForKey:@"msg"]];
        }
        
    }];
    
    [formDataRequest setFailedBlock:^{
        [tooles MsgBox:@"请检查网络！！！"];
    }];
}

@end
