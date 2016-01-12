//
//  AppDelegate.h
//  Routing App
//
//  Created by TacktileSystemsMac4 on 04/05/15.
//  Copyright (c) 2015 Tacktile Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (retain,nonatomic) CLLocationManager *tLocationManager;
@property(retain,nonatomic)UILocalNotification* localNotification;
-(void)insert:(NSDate *)fire :(NSString*)tNotes;

@end

