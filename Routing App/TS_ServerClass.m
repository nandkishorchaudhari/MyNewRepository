//
//  TS_ServerClass.m
//  Routing App
//
//  Created by TacktileSystemsMac4 on 07/05/15.
//  Copyright (c) 2015 Tacktile Systems. All rights reserved.
//

#import "TS_ServerClass.h"
#import "TSUI_DrawRoute_VC.h"
#import <SystemConfiguration/SystemConfiguration.h>

static TS_ServerClass* tserverObj = nil;
@implementation TS_ServerClass

@synthesize taddressArray,tRouteName,tForeginKey,tSelectedRoute,tNameOfRoute,isSaveRoutes,tTotalTimeAndDistance,isNotesOnOff,timer,isSavedRouteOrNot,tTimerCount,isTimerStartOrStop,tisLastProperty,isSettingButtonPressedOrNot,tisButtonPressedOrNot,tisStopTimeOfEachProperty,tIndexOfArray,tAppIsBackgroundOrNot,tisEditRouteOrNot,tisRefreshView,tisRefreshHomeRouterView,isReceiptOnOff,isStopRegionMonitoring,tShortAddressArray,tAddressArrayCopy,isTitle,isBackgroundView,isReceipt,tIsExactProperty,tGeoTimer,tisEditRouteBeforeJourney,tisEditRoute,tcurrentLong,tcurrentLat,tFirstTime,tcustomizeGeogfencingIndex;

#pragma mark-INSTANCE METHOD

+(id)tsharedInstance
{
    if(tserverObj == nil)
    {
        tserverObj = [TS_ServerClass new];
    }
    return tserverObj;
}


#pragma mark - Colour HEX String to UIColor object
-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


#pragma mark-EPOCH TIME

-(NSDate*)getDateFromEpoch :(long long)epochtime
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:epochtime/1000];
    return date;
}

-(NSString*)tGetTime :(NSDate*)tDate
{
    NSString* string=@"";
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay  fromDate:tDate];
    
    if(components.day == 1 || components.day == 21 || components.day == 31){
        string = @"st";
    }else if (components.day == 2 || components.day == 22){
        string = @"nd";
    }else if (components.day == 3 || components.day == 23){
        string = @"rd";
    }
    else{
        string = @"th";
    }
    
    NSDateFormatter *prefixDateFormatter = [[NSDateFormatter alloc] init];    [prefixDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    
    //   [prefixDateFormatter setDateFormat:[NSString stringWithFormat:@"h:mma,d'%@' MMMM",string]];
    [prefixDateFormatter setDateFormat:[NSString stringWithFormat:@"h:mm:s , d'%@' MMMM YYYY",string]];
    return  [prefixDateFormatter stringFromDate:tDate];
    
}

#pragma mark-CONVET STRING FROM TIME INTERVAL
//CONVERT NSTIMEINTERVAL INTO STRING WITH SEC< MINUTES < HOURS
- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval
{
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [NSString stringWithFormat:@"%02ld hr %02ld min", (long)hours, (long)minutes];
}
#pragma mark-LOGICAL METHOD
-(void)tStartRouteTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(updateCountdown) userInfo:nil repeats: YES];
}

-(void)updateCountdown
{
//    TSUI_DrawRoute_VC* tobj = [TSUI_DrawRoute_VC new];
//    tTimerCount++;
//    [tobj updateCountdown:tTimerCount];
}
-(bool)isNetworkAvailable
{
    SCNetworkReachabilityFlags flags;
    SCNetworkReachabilityRef address = SCNetworkReachabilityCreateWithName(NULL, "www.apple.com" );
    Boolean success = SCNetworkReachabilityGetFlags(address, &flags);
    CFRelease(address);
    
    bool canReachOnExistingConnection =     success
    && !(flags & kSCNetworkReachabilityFlagsConnectionRequired)
    && (flags & kSCNetworkReachabilityFlagsReachable);
    
    if( canReachOnExistingConnection )
        NSLog(@"Network available");
    else
        NSLog(@"Network not available");
    
    return canReachOnExistingConnection;
}


@end
