//
//  TS_ParaAddress.h
//  Routing App
//
//  Created by TacktileSystemsMac4 on 09/05/15.
//  Copyright (c) 2015 Tacktile Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TS_ParaAddress : NSObject

@property(nonatomic, retain)NSString* taddress;
@property(nonatomic, retain)NSString* tnotes;
@property(nonatomic) int tFirstProperty;
@property(nonatomic)int tRouteId;
@property(nonatomic)NSString* tidentifireName;
@property(nonatomic)int tForeginKey;
@property(nonatomic)double tLatitude;
@property(nonatomic)double tLongitude;
@property(nonatomic)int tcompletedRouteOrNot;

@end
