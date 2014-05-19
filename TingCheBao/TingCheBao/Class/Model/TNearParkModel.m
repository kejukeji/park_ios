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
@synthesize distance;
@synthesize cartEntrancesid;
@synthesize latitude;
@synthesize longitude;
@synthesize dayPrice;
@synthesize parkid;
@synthesize last;
@synthesize name;
@synthesize nightPrice;

@synthesize tel;
@synthesize total;
@synthesize type;

- (TNearParkModel *)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        
        address = [NSString stringWithFormat:@"%@",[dic objectForKey:@"address"]];
        dayPrice = [NSString stringWithFormat:@"%@",[dic objectForKey:@"dayPrice"]];
        last = [NSString stringWithFormat:@"%@", [dic objectForKey:@"last"]];
        parkid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
        name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
        nightPrice = [NSString stringWithFormat:@"%@",[dic objectForKey:@"nightPrice"]];
        tel = [NSString stringWithFormat:@"%@",[dic objectForKey:@"tel"]];
        total = [NSString stringWithFormat:@"%@",[dic objectForKey:@"total"]];
        type = [NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
        NSArray *cartEntrances = [dic objectForKey:@"cartEntrances"];
        for (NSDictionary *dict in cartEntrances) {
            distance = [dict objectForKey:@"distance"];
            latitude = [dict objectForKey:@"latitude"];
            longitude = [dict objectForKey:@"longitude"];
            cartEntrancesid = [dict objectForKey:@"id"];
        }
    }
    
    return self;

}

@end
