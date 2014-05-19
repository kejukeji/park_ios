//
//  TNearParkModel.h
//  TingCheBao
//
//  Created by zhao on 14-5-2.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TNearParkModel : NSObject

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *distance;
@property (nonatomic, copy) NSString *cartEntrancesid;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *dayPrice;
@property (nonatomic, copy) NSString *parkid;
@property (nonatomic, copy) NSString *last;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *nightPrice;

@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *total;
@property (nonatomic, copy) NSString *type;


- (TNearParkModel *)initWithDictionary:(NSDictionary *)dic;

@end
