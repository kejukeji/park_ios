//
//  TNearParkModel.m
//  TingCheBao
//
//  Created by zhao on 14-5-2.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "TNearParkModel.h"

@implementation TNearParkModel

@synthesize address;
@synthesize carbarnLast;
@synthesize carbarnTotal;
@synthesize latitude;
@synthesize longitude;
@synthesize detial;
@synthesize parkid;
@synthesize name;
@synthesize price;

- (TNearParkModel *)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        
        address = [NSString stringWithFormat:@"%@",[dic objectForKey:@"address"]];
        carbarnLast = [NSString stringWithFormat:@"%@",[dic objectForKey:@"carbarnLast"]];
        carbarnTotal = [NSString stringWithFormat:@"%@",[dic objectForKey:@"carbarnTotal"]];
        NSArray *cartEntrances = [dic objectForKey:@"cartEntrances"];
        for (NSDictionary *entrancesDict in cartEntrances) {
            latitude = [NSString stringWithFormat:@"%@",[entrancesDict objectForKey:@"latitude"]];
            longitude = [NSString stringWithFormat:@"%@",[entrancesDict objectForKey:@"longitude"]];
        }
        detial = [NSString stringWithFormat:@"%@",[dic objectForKey:@"detial"]];
        parkid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
        name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
        price = [NSString stringWithFormat:@"%@元/小时",[dic objectForKey:@"price"]];
    }
    
    return self;

}


@end
