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
@property (nonatomic, copy) NSString *carbarnLast;
@property (nonatomic, copy) NSString *carbarnTotal;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *detial;
@property (nonatomic, copy) NSString *parkid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *price;

- (TNearParkModel *)initWithDictionary:(NSDictionary *)dic;

@end
