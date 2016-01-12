//
//  TS_ServerClass.h
//  Routing App
//
//  Created by TacktileSystemsMac4 on 07/05/15.
//  Copyright (c) 2015 Tacktile Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TS_ServerClass : NSObject

@property(nonatomic,retain)NSMutableArray* taddressArray;
@property(nonatomic, retain)NSMutableArray* tTotalTimeAndDistance;//USED IN DRAW ROUTE MODULE
@property(nonatomic, retain)NSString* tRouteName;
@property(nonatomic)int tForeginKey;
@property(nonatomic)int tSelectedRoute;
@property(nonatomic, retain)NSString* tNameOfRoute;
@property(nonatomic)BOOL isSaveRoutes;
@property(nonatomic)BOOL isNotesOnOff;
@property(nonatomic)BOOL isSavedRouteOrNot;
@property(nonatomic)BOOL isTimerStartOrStop;
@property(nonatomic)int tTimerCount;
@property(nonatomic)int tisLastProperty;
@property(nonatomic)int tisButtonPressedOrNot;
@property(nonatomic)int tisStopTimeOfEachProperty;
@property(nonatomic)BOOL isSettingButtonPressedOrNot;
@property(nonatomic)int tIndexOfArray;
@property(nonatomic, retain)NSTimer* timer;
@property(nonatomic, retain)NSTimer* tGeoTimer;
@property(nonatomic)BOOL tAppIsBackgroundOrNot;
@property(nonatomic)BOOL tisEditRouteOrNot;
@property(nonatomic)BOOL tisRefreshView;
@property(nonatomic)BOOL tisRefreshHomeRouterView;
@property(nonatomic)BOOL isReceiptOnOff;
@property(nonatomic)BOOL isStopRegionMonitoring;
@property(nonatomic)BOOL isTitle;
@property(nonatomic)BOOL isBackgroundView;
@property(nonatomic)BOOL tisEditRouteBeforeJourney;
@property(nonatomic)BOOL tisEditRoute;
@property(nonatomic)int isReceipt;
@property(nonatomic)int tIsExactProperty;
@property(nonatomic)int tFirstTime;
@property(nonatomic)int tcustomizeGeogfencingIndex;
@property(nonatomic, retain)NSMutableArray* tShortAddressArray;
@property(nonatomic,retain)NSMutableArray* tAddressArrayCopy;
@property(nonatomic)double tcurrentLat;//USED FOR EDIT ROUTE
@property(nonatomic)double tcurrentLong;//USED FOR EDIT ROUTE


+(id)tsharedInstance;
-(UIColor*)colorWithHexString:(NSString*)hex;
-(NSString*)tGetTime :(NSDate*)tDate;
-(NSDate*)getDateFromEpoch :(long long)epochtime;
- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval;
-(void)tStartRouteTimer;
-(bool)isNetworkAvailable;
@end
