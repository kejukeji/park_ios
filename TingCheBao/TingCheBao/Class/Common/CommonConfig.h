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
#define noiOS6 ((floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_5_1)?YES:NO)

#define TCB_URL @"http://121.199.251.166/"
#define BM_KEY @"edMyXrVdItOfqBDLjNoGRBQT"
#define XF_APPID @"535e66db"
#define UM_KEY @"537830a256240b8c33014c56"

#endif
