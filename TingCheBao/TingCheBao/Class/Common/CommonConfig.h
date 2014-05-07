//
//  CommonConfig.h
//  TingCheBao
//
//  Created by zhao on 14-5-2.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#ifndef TingCheBao_CommonConfig_h
#define TingCheBao_CommonConfig_h

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define noiOS7 ((floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)?YES:NO)

#define TCB_URL @"http://park.kejukeji.com/"
#define BM_KEY @"yeN9Z1zcQhzn7mtNLb3nC6kK"

#endif
