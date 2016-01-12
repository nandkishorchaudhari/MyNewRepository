//
//  AppDelegate.m
//  Routing App
//
//  Created by TacktileSystemsMac4 on 04/05/15.
//  Copyright (c) 2015 Tacktile Systems. All rights reserved.
//

#import "AppDelegate.h"
#import "TS_ServerClass.h"
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface AppDelegate ()
{
    UIAlertView* alertView_local;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    TS_ServerClass* tserverObj = [TS_ServerClass tsharedInstance];
    
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"topbar 320.png"] forBarMetrics:UIBarMetricsDefault];
//    
    [[UIToolbar appearance] setBarTintColor:[UIColor colorWithRed:0.106 green:0.376 blue:0.745 alpha:1]];
//    [[UIToolbar appearance] setTintColor:[UIColor whiteColor]];
    //**********APPLICATION STATUS BAR & NAVIGATION BAR COLOR WHITE***********//
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    TS_ServerClass* tserverObj = [TS_ServerClass tsharedInstance];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[tserverObj colorWithHexString:@"39aad6"]];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setBackgroundColor:[tserverObj colorWithHexString:@"39aad6"]];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    


//    [[UINavigationBar appearance] setBackgroundColor:[tserverObj colorWithHexString:@"39aad6"]];
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
////    [[UIToolbar appearance] setBarTintColor:[UIColor colorWithRed:0.106 green:0.376 blue:0.745 alpha:1]];
//    [[UIToolbar appearance] setTintColor:[UIColor whiteColor]];
    
    [self tInitLocationManager];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        UIUserNotificationType types = UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge;
        UIUserNotificationSettings * pushSettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:pushSettings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }

    UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    if (notification) {
        [self showAlarm:notification.alertBody];
        NSLog(@"AppDelegate didFinishLaunchingWithOptions");
//        application.applicationIconBadgeNumber = 0;
        
    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:-1];
    
    [self.window makeKeyAndVisible];
    
//    TS_ServerClass* tserverObj = [TS_ServerClass tsharedInstance];
    tserverObj.tShortAddressArray = [NSMutableArray new];
    
   
    
    return YES;
}
- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif
{
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
//    app.applicationIconBadgeNumber = notif.applicationIconBadgeNumber -1;
    notif.alertBody = @"GeoFencing";
    notif.soundName = UILocalNotificationDefaultSoundName;
    
    TS_ServerClass* tserverObj = [TS_ServerClass tsharedInstance];
    tserverObj.isBackgroundView = true;
    
    NSLog(@"Background Mode/nArrayOfIndex=%d",tserverObj.tIndexOfArray);
//    [self _showAlert:@"App is in background mode" withTitle:@"Notification"];
    
    
}
- (void) _showAlert:(NSString*)pushmessage withTitle:(NSString*)title
    {
        [alertView_local removeFromSuperview];
        alertView_local = [[UIAlertView alloc] initWithTitle:title message:pushmessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView_local show];
        
        if (alertView_local)
        {
        }
    }
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    TS_ServerClass* tserObj = [TS_ServerClass tsharedInstance];
    tserObj.tAppIsBackgroundOrNot = TRUE;
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    TS_ServerClass* tserObj = [TS_ServerClass tsharedInstance];
    tserObj.tAppIsBackgroundOrNot = FALSE;
    //HIDING BADGE VALUE
    [UIApplication sharedApplication].applicationIconBadgeNumber=-1;
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}


#pragma mark-LOGICAL METHOD
-(void)tInitLocationManager
{
    //INITIALISE THE LOCATION MANAGER IF NOT INITIALISED ALREADY
    if(nil == self.tLocationManager)
    {
        self.tLocationManager = [[CLLocationManager alloc] init];
    }
    //SET THE DELEGATE
    self.tLocationManager.delegate = self;
    
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        // Use one or the other, not both. Depending on what you put in info.plist
        [self.tLocationManager requestWhenInUseAuthorization];
        [self.tLocationManager requestAlwaysAuthorization];
    }
#endif
    //SETTING THE DISTANCE FILTER AND ACCURACY OF LOCATION MANAGER
    self.tLocationManager.distanceFilter = 50;
    self.tLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
    [self.tLocationManager startUpdatingLocation];
    [self.tLocationManager startMonitoringSignificantLocationChanges];
   
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{

}


- (void)showAlarm:(NSString *)text {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alarm"
                                                        message:text delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}


-(void)insert:(NSDate *)fire :(NSString*)tNotes
{
   
    
    
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
    self.localNotification = [[UILocalNotification alloc] init];
    if (self.localNotification == nil)
    {
        return;
    }
    else
    {
        self.localNotification.fireDate = fire;
        self.localNotification.alertAction = nil;
        self.localNotification.soundName = UILocalNotificationDefaultSoundName;
        self.localNotification.alertBody = [NSString stringWithFormat:@"%@",tNotes];
        self.localNotification.alertAction = NSLocalizedString(@"Read Msg", nil);
#warning BADGE VALUE COMMENTED
//        self.localNotification.applicationIconBadgeNumber=0;
        self.localNotification.repeatInterval=0;
        [[UIApplication sharedApplication] scheduleLocalNotification:self.localNotification];
    }
}

@end
