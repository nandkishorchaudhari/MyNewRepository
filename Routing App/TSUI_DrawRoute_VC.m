//
//  TSUI_DrawRoute_VC.m
//  Routing App
//
//  Created by TacktileSystemsMac4 on 07/05/15.
//  Copyright (c) 2015 Tacktile Systems. All rights reserved.
//

#import "TSUI_DrawRoute_VC.h"
#import "TS_ServerClass.h"
#import "TS_HomeRouter_VC.h"
#import "TS_ParaLatAndLong.h"
#import "TS_ParaAddress.h"
#import "TS_Annotation.h"
#import "TS_ParaSort.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#ifdef __IPHONE_8_0
#define GregorianCalendar NSCalendarIdentifierGregorian
#else
#define GregorianCalendar NSGregorianCalendar
#endif
// pad our map by 10% around the farthest annotations
#define MAP_PADDING 1.1

// we'll make sure that our minimum vertical span is about a kilometer
// there are ~111km to a degree of latitude. regionThatFits will take care of
// longitude, which is more complicated, anyway.
#define MINIMUM_VISIBLE_LATITUDE 0.01


#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface TSUI_DrawRoute_VC ()
{
    NSMutableArray* tLatLongArray;
    NSMutableArray* tTotalTimeAndDistance;
    int tRoutArrayCount;
    TS_ServerClass* tserverObj;
    AVAudioPlayer *tAudioPlayerObj;
    double tTotalDistance;
    double tTotalTimeOfRoute;
    int tTimerCount;
    NSString* tTotalDistanceOfJourney;
    NSString* tExpectedTimeOfJourney;
    NSString* tActualTimeOfJourney;
    int tIndexOfArray;
    double tLatitude;
    double tLongitude;
    UIView* tTextViewOfPopUps;
    UIButton* tnextBtnOfPopups;
    double tlat ;
    double tLong;
    double tSLat;
    double tSLong;
    double tDLat;
    double tDLong;
    NSString* tAddressOfCurrent;
    BOOL tisEndRoute;
    NSString* fileName2;
    double tmaxLat;
    double tminLat;
    double tmaxLong;
    double tminLong;
    
  
    
    NSString* tIdentifier;
    
    //PDF
    CGSize _pageSize;
    NSString *pdfPath;
    NSNumber *paidAmount;
    UIWebView* webViewPDF;
    NSNumber *balanceAmount;
    
    
    //iBeacon
    NSMutableDictionary *beaconPeripheralData;
    CBPeripheralManager *peripheralManager;
    
    
    
}
@end

@implementation TSUI_DrawRoute_VC
@synthesize taddressArray,tTextViewReference,tBtnBeginRouteReference,tLabelOfJourneyTimer;
#pragma mark-VIEW DELEGATE

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Route Direction Detail";
    
//    [self getPDFFileName];
    
    //TO CHECK THE LOCATION SERVICE ARE ENABLE OR NOT
    if([CLLocationManager locationServicesEnabled] &&
       [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        
    }
    else
    {
        //[tAlertViewForWait dismissWithClickedButtonIndex:-1 animated:YES];
        UIAlertView *tLocationUpdateFail = [[UIAlertView alloc]initWithTitle:@"Please enable location facility for this app in your device settings." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [tLocationUpdateFail show];
    }

    
    
    tTextViewReference.userInteractionEnabled = NO;
    tLabelOfJourneyTimer.hidden = YES;
    // Do any additional setup after loading the view.
    tserverObj = [TS_ServerClass tsharedInstance];
    tLabelOfJourneyTimer.font = [UIFont systemFontOfSize:12.0];
    [tLabelOfJourneyTimer setBackgroundColor:[tserverObj colorWithHexString:@"636363"]];
    tLabelOfJourneyTimer.text = @"";
    [tTextViewReference setBackgroundColor:[tserverObj colorWithHexString:@"ffffff"]];
     tBtnBeginRouteReference.layer.cornerRadius = 2.0f;
    [tBtnBeginRouteReference setBackgroundColor:[tserverObj colorWithHexString:@"636363"]];
    tLatLongArray = [[NSMutableArray alloc]init];
    tserverObj.tTotalTimeAndDistance = [NSMutableArray new];
 
    //SET BACKGROUND IMAGE 
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BgImage.png"]];
    bgImageView.frame = self.view.bounds;
    [self.view addSubview:bgImageView];
    [self.view sendSubviewToBack:bgImageView];
    
    
    UIImageView *imgView2 = [[UIImageView alloc]initWithFrame: self.tTextViewOfButtons.frame];
    imgView2.image = [UIImage imageNamed: @"myImage.jpg"];
    [self.tTextViewOfButtons addSubview: imgView2];
    [self.tTextViewOfButtons sendSubviewToBack: imgView2];
    
   
    
//    [self tSetupOfLocationManager];
//    [self tSetupOfMapView];
    if(!tserverObj.tisEditRouteBeforeJourney)
    {
    NSUserDefaults* tdefaultObj = [NSUserDefaults standardUserDefaults];
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"RouteCompleted"])
    {
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.rightBarButtonItem = [self tLogicToAddRightBarButton];
        self.navigationItem.leftBarButtonItem = nil;
//        NSData *data = [tdefaultObj objectForKey:@"RouteInfoArray"];
        tserverObj.taddressArray = [tdefaultObj rm_customObjectForKey:@"RouteInfoArray"];
        
//        tserverObj.taddressArray = [tdefaultObj valueForKey:@"RouteInfoArray"];
        NSString* index = [tdefaultObj valueForKey:@"IndexOfArray"];
        [tdefaultObj synchronize];
        tserverObj.tIndexOfArray = [index intValue];
        NSLog(@"ArrayIndex=%d",tserverObj.tIndexOfArray);
        NSString* tTimerCount2 = [tdefaultObj valueForKey:@"Timer"];
        tserverObj.tTimerCount = [tTimerCount2 intValue];
        tserverObj.tNameOfRoute = [tdefaultObj valueForKey:@"RouteName"];
        tLabelOfJourneyTimer.text = [NSString stringWithFormat:@"Journey Time:%@",[self timeFormatted:[tTimerCount2 intValue]]];
        NSString* tStopTime = [tdefaultObj valueForKey:@"StopTimer"];
        tserverObj.tisStopTimeOfEachProperty = [tStopTime intValue];
        tserverObj.tisEditRouteBeforeJourney = true;
        
        NSNumber* tnum = [tdefaultObj valueForKey:@"Lat"];
        tserverObj.tcurrentLat = [tnum doubleValue];
        NSNumber* tnum2 = [tdefaultObj valueForKey:@"Long"];
        tserverObj.tcurrentLong = [tnum2 doubleValue];
  
  
        
    }
    else
    {
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.rightBarButtonItem = [self tLogicToAddRightBarButton];
        self.navigationItem.leftBarButtonItem = [self tLogicToAddLeftButton];
        tserverObj.isTimerStartOrStop = false;
        tserverObj.tTimerCount = 0;
        tLabelOfJourneyTimer.text = [NSString stringWithFormat:@"Journey Time:%@",[self timeFormatted:tserverObj.tTimerCount]];
        tLabelOfJourneyTimer.textColor = [UIColor whiteColor];
        tserverObj.tisLastProperty = 0;
//        tserverObj.isSettingButtonPressedOrNot = false;
//        tserverObj.tisButtonPressedOrNot = 0;
        
        if(tserverObj.tisStopTimeOfEachProperty == 0)
        {
        tserverObj.tisStopTimeOfEachProperty = 5;
        }
        NSNumber* tStopTimer = [NSNumber numberWithInt:tserverObj.tisStopTimeOfEachProperty];
        [tdefaultObj setObject:tStopTimer forKey:@"StopTimer"];
        tserverObj.tIndexOfArray = 0;
        for(int i=0;i<tserverObj.taddressArray.count;i++)
        {
            
         NSNumber* tkeyObj = [NSNumber numberWithInt:0];
         [tdefaultObj setObject:tkeyObj forKey:[NSString stringWithFormat:@"%d",i]];
            
            
        }

    }
    }//IF ROUTING IS NOT STARTS
    else
    {
        tserverObj.isStopRegionMonitoring = false;
//        tserverObj.isNotesOnOff = true;
//        tserverObj.isReceiptOnOff = true;
        tisEndRoute = true;
        [self.tBtnBeginRouteReference setBackgroundImage:[UIImage imageNamed:@"EndBtn.png"] forState:UIControlStateNormal];
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.rightBarButtonItem = [self tLogicToAddRightBarButton];
        self.navigationItem.leftBarButtonItem = nil;
        [self tIdentifierNameMethod];
        TS_ParaAddress* tpara = [TS_ParaAddress new];
        if(tserverObj.taddressArray.count > tserverObj.tIsExactProperty)
        {
            if(tserverObj.tcustomizeGeogfencingIndex == 0)
            {
                tpara = [tserverObj.taddressArray objectAtIndex:tserverObj.tcustomizeGeogfencingIndex];
            }
            else
            {
                tpara = [tserverObj.taddressArray objectAtIndex:tserverObj.tcustomizeGeogfencingIndex-1];
            }
        }
        
        NSLog(@"ExactPorperty Reloads=%d",tserverObj.tIsExactProperty);
        
//        [self tInitDataPopUps:tpara];
    }
    
    for(int i = 0;i<tserverObj.taddressArray.count;i++)
    {
    TS_ParaLatAndLong* tpara = [TS_ParaLatAndLong new];
    TS_ParaAddress* tparaA = [TS_ParaAddress new];
        tparaA = [tserverObj.taddressArray objectAtIndex:i];
    tpara.tlatitude = tparaA.tLatitude;
    tpara.tlongitude = tparaA.tLongitude;
    
        tparaA = [tserverObj.taddressArray objectAtIndex:i];
        NSLog(@"Address=%@",tparaA.taddress);
    
    [tLatLongArray addObject:tpara];
    }
   
    [self tInitDataFindMax_Min_Lat_Long];
    [self tInitLocationManager];
    
    NSUserDefaults* tdefaultObj = [NSUserDefaults standardUserDefaults];
    [tdefaultObj setObject:tserverObj.tNameOfRoute forKey:@"RouteName"];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{

    
    if(tserverObj.isStopRegionMonitoring)
    {
        [self tInitStopMonitoring];
    }
    
//    tserverObj.isSaveRoutes = false;
    tserverObj.isTitle = true;
//    tserverObj.isSaveRoutes = false;
    
}

-(void)viewWillAppear:(BOOL)animated
{

}

#pragma mark-INITDATA

-(void)tInitDataFindMax_Min_Lat_Long
{
    
    NSSortDescriptor *boolDescr = [[NSSortDescriptor alloc] initWithKey:@"tlatitude" ascending:NO selector:nil];
    
    // Combine the two
    NSArray *sortDescriptors = @[boolDescr];
    // Sort your array
    NSArray* tmaxArray=  [NSMutableArray arrayWithArray: [tLatLongArray sortedArrayUsingDescriptors:sortDescriptors]];
   TS_ParaLatAndLong* tpara = [TS_ParaLatAndLong new];
        tpara = [tmaxArray objectAtIndex:0];
    tmaxLat = tpara.tlatitude;
    tmaxLong = tpara.tlongitude;
    
    NSSortDescriptor *boolDescr2 = [[NSSortDescriptor alloc] initWithKey:@"tlatitude" ascending:YES selector:nil];
    
    // Combine the two
    NSArray *sortDescriptors2 = @[boolDescr2];
    // Sort your array
    NSArray* tminArray=  [NSMutableArray arrayWithArray: [tLatLongArray sortedArrayUsingDescriptors:sortDescriptors2]];
    
    TS_ParaLatAndLong* tpara2 = [TS_ParaLatAndLong new];
    tpara2 = [tminArray objectAtIndex:0];
    tminLat = tpara2.tlatitude;
    tminLong = tpara2.tlongitude;

    
//     NSLog(@"MinLatLong===%f -- %f\nMaxLatLong===%f===%f",tminLat,tminLong,tmaxLat,tmaxLong);
    
    
}


-(void)tInitZoom
{
     NSMutableArray* tannotationArray = [NSMutableArray new];
    for(int i = 0;i<tserverObj.taddressArray.count;i++)
    {
        
        
        TS_ParaAddress* tparaAddress = [TS_ParaAddress new];
        tparaAddress = [tserverObj.taddressArray objectAtIndex:i];
        CLLocationCoordinate2D cord ;//= [self geoCodeUsingAddress:tparaAddress.taddress];
        cord.latitude = tparaAddress.tLatitude;
        cord.longitude = tparaAddress.tLongitude;
//        NSLog(@"lat=%f---Long=%f",cord.latitude,cord.longitude);
        TS_Annotation* tobj = [TS_Annotation new];
        tobj.coordinate = cord;
        tobj.title = tparaAddress.tnotes;
        NSString* firstString = [[tparaAddress.taddress componentsSeparatedByString:@","] objectAtIndex:0];
        tobj.subtitle = firstString;
      
      
        
        [tannotationArray addObject:tobj];
        
        
        
    }//end of for loop
    [self zoomToAnnotationsBounds:tannotationArray];
}

-(void)tGeneratePdfFile
{
     fileName2 = @"HomeRouter.PDF";
    
    NSArray *arrayPaths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pdfFileName = [path stringByAppendingPathComponent:fileName2];
    
//    NSLog(@"PDFFilePath=%@",path);
    
    
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];

    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
//    NSLog(@"Date=%@",dateString);
    
    NSString* textToDraw = [NSString stringWithFormat:@"\tHome Router Route Receipt\n\n%@\n%@\n%@\nDate: %@",tserverObj.tNameOfRoute,tTotalDistanceOfJourney,tExpectedTimeOfJourney,dateString];
//    NSLog(@"Home Router Route Receipt\n%@\n%@%@Date:",tserverObj.tNameOfRoute,tTotalDistanceOfJourney,tExpectedTimeOfJourney);
    CFStringRef stringRef = (__bridge CFStringRef)textToDraw;
//    NSLog(@"TEXT=%@",stringRef);
    // Prepare the text using a Core Text Framesetter.
    CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, stringRef, NULL);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(currentText);
    
    CGRect frameRect = CGRectMake(50,-200,500, 200);
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);
    
    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    
    // Create the PDF context using the default page size of 612 x 792.
    UIGraphicsBeginPDFContextToFile(pdfFileName, CGRectZero, nil);
    
    // Mark the beginning of a new page.
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
    
    // Get the graphics context.
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    // Core Text draws from the bottom-left corner up, so flip
    // the current transform prior to drawing.
    CGContextTranslateCTM(currentContext, 0, 100);
    CGContextScaleCTM(currentContext, 2.0, -2.0);
    
    // Draw the frame.
    CTFrameDraw(frameRef, currentContext);
    
    CFRelease(frameRef);
    CFRelease(stringRef);
    CFRelease(framesetter);
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
//    NSLog(@"PDFFilePath=%@",path);
    
}

-(void)tInitStopMonitoring
{
    for(int i = 0; i<tserverObj.taddressArray.count;i++)
    {
    TS_ParaAddress* tparaAddress = [TS_ParaAddress new];
    tparaAddress = [tserverObj.taddressArray objectAtIndex:i];
        CLLocationCoordinate2D cord;
        cord.latitude = tparaAddress.tLatitude;
        cord.longitude = tparaAddress.tLongitude;
    
    CLLocationCoordinate2D centre;
    centre.latitude = cord.latitude;
    centre.longitude = cord.longitude;
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:centre
                                                                 radius:30.0
                                                             identifier:tparaAddress.tidentifireName];
//        NSLog(@"Identifier=%@",tparaAddress.tidentifireName);
        [self.tLocationManager stopMonitoringForRegion:region];
        
    }
}

-(void)tInitDataPopUps :(TS_ParaAddress*)tpara
{
    //UIView* tTextViewOfPopUps; make this variable global
    tTextViewOfPopUps = [[UITextView alloc]initWithFrame:CGRectMake(50,50,self.view.bounds.size.width - 100,self.view.bounds.size.height / 2)];
    tTextViewOfPopUps.hidden = NO;
    tTextViewOfPopUps.backgroundColor = [tserverObj colorWithHexString:@"efefef"];
   
    
    UIButton* tnextPropertyBtn = [[UIButton alloc]initWithFrame:CGRectMake(tTextViewOfPopUps.bounds.size.width - (tTextViewOfPopUps.bounds.size.width - 5),tTextViewOfPopUps.bounds.size.height - 50,tTextViewOfPopUps.bounds.size.width - 10,44)];
    tnextPropertyBtn.tag = 65445;
    tnextPropertyBtn.layer.cornerRadius = 1.0f;
    NSLog(@"Count of ServerArray=%d\nIndex=%d",tserverObj.taddressArray.count,tserverObj.tcustomizeGeogfencingIndex);
    if(tserverObj.taddressArray.count == tserverObj.tcustomizeGeogfencingIndex)
    {
        
    [tnextPropertyBtn setTitle:@"End Route" forState:UIControlStateNormal];
        
    }
    else
    {
        if(tserverObj.tcustomizeGeogfencingIndex == 0)
        {
            [tnextPropertyBtn setTitle:@"Begin Route" forState:UIControlStateNormal];
        }
        else
        {
        [tnextPropertyBtn setTitle:@"Next Property" forState:UIControlStateNormal];
        }
    }
    
    [tnextPropertyBtn setBackgroundColor:[tserverObj colorWithHexString:@"1EC911"]];
    //BUTTON ACTION
    [tnextPropertyBtn addTarget:self action:@selector(tnextPropertyBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel* tTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(tTextViewOfPopUps.bounds.size.width - tTextViewOfPopUps.bounds.size.width,5,tTextViewOfPopUps.bounds.size.width,44)];
    tTitleLabel.tag = 41;
    tTitleLabel.text = tserverObj.tNameOfRoute;
//    NSLog(@"NameOfRoute=%@",tserverObj.tNameOfRoute);
    tTitleLabel.textAlignment = NSTextAlignmentCenter;
    [tTitleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [tTitleLabel setNumberOfLines:0];
    tTitleLabel.textColor = [tserverObj colorWithHexString:@"212121"];
    tTitleLabel.font = [UIFont systemFontOfSize:18.0f];
    
    UILabel* tAddressLabel = [[UILabel alloc]initWithFrame:CGRectMake(tTextViewOfPopUps.bounds.size.width - (tTextViewOfPopUps.bounds.size.width - 10),tTitleLabel.bounds.size.height + 5,tTextViewOfPopUps.bounds.size.width,88)];
    tAddressLabel.tag = 4112;
    tAddressLabel.text = [NSString stringWithFormat:@"%@",tpara.tnotes];
    tAddressLabel.textAlignment = NSTextAlignmentLeft;
    [tAddressLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [tAddressLabel setNumberOfLines:0];
    tAddressLabel.font = [UIFont systemFontOfSize:14.0f];
    
    
    [tTextViewOfPopUps addSubview: tTitleLabel];
    [tTextViewOfPopUps addSubview:tAddressLabel];
    [tTextViewOfPopUps addSubview:tnextPropertyBtn];
    
    [self.view addSubview:tTextViewOfPopUps];
    
}

-(void)tInitDataLocalNotification
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    // current time plus 10 secs
    NSDate *now = [NSDate date];
    NSDate *dateToFire = [now dateByAddingTimeInterval:5];
    
//    NSLog(@"now time: %@", now);
//    NSLog(@"fire time: %@", dateToFire);
    
    localNotification.fireDate = dateToFire;
    localNotification.alertBody = @"Time to get up!";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = 1; // increment
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Object 1", @"Key 1", @"Object 2", @"Key 2", nil];
    localNotification.userInfo = infoDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

-(void)tInitStartTimer
{
//    tLabelOfJourneyTimer.text = [NSString stringWithFormat:@"Journey Time:%@",[self timeFormatted:tserverObj.tTimerCount]];
    tserverObj.timer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(updateCountdown) userInfo:nil repeats: YES];
}
-(void)tInitTimer
{
    tserverObj.tGeoTimer = [NSTimer scheduledTimerWithTimeInterval: 15.0 target:self selector:@selector(tIdentifierNameMethod) userInfo:nil repeats: NO];
}
-(void)tIdentifierNameMethod
{
   
    TS_ParaAddress* tpara = [TS_ParaAddress new];
    if(tserverObj.taddressArray.count > tserverObj.tIsExactProperty)
    {
    tpara = [tserverObj.taddressArray objectAtIndex:tserverObj.tIsExactProperty];
        tIdentifier = tpara.tidentifireName;
        NSLog(@"NextIdentifier=%@",tIdentifier);
    }
}
-(void)tInitShowLabel
{
        tTotalDistance = 0;
        tTotalTimeOfRoute = 0;
        
        for(int i=0;i< tserverObj.tTotalTimeAndDistance.count;i++)
        {
            TS_ParaSort* tpara = [TS_ParaSort new];
            tpara = [tserverObj.tTotalTimeAndDistance objectAtIndex:i];
            tTotalDistance = tTotalDistance + tpara.tdistance;
            tTotalTimeOfRoute = tTotalTimeOfRoute + tpara.tTravelTime;// +(tserverObj.taddressArray.count *
        }
    tTotalTimeOfRoute = tTotalTimeOfRoute + (tserverObj.taddressArray.count * tserverObj.tisStopTimeOfEachProperty)*60;
    UILabel* tRouteNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(18,0,tTextViewReference.bounds.size.width-10,30)];
    tRouteNameLabel.text = tserverObj.tNameOfRoute;
    tRouteNameLabel.textColor = [tserverObj colorWithHexString:@"39aad6"];
    tRouteNameLabel.font = [UIFont systemFontOfSize:16.0f];
    
    
    
    UILabel* tFirstPropertyLabel = [[UILabel alloc]initWithFrame:CGRectMake(38,30,tTextViewReference.bounds.size.width /2 ,25)];
    tFirstPropertyLabel.textColor = [tserverObj colorWithHexString:@"2b2b2b"];
    TS_ParaAddress* tpara = [TS_ParaAddress new];
    tpara = [tserverObj.taddressArray objectAtIndex:0];
    
    UIImageView* tproperty = [[UIImageView alloc]initWithFrame:CGRectMake(15,34,16,16)];
    tproperty.image = [UIImage imageNamed:@"FirstProperty.png"];
    
    UILabel* tAddressOfFirstproperty = [[UILabel alloc]initWithFrame:CGRectMake(38,30,30,25)];
    tAddressOfFirstproperty.text = tpara.taddress;

    
    tFirstPropertyLabel.text = [NSString stringWithFormat:@"Beginning at property"];
//    tFirstPropertyLabel.text = [NSString stringWithFormat:@"Beginning at property [                        ]"];
    tFirstPropertyLabel.font = [UIFont systemFontOfSize:13.0f];
    UILabel* tlabel1 = [[UILabel alloc]initWithFrame:CGRectMake(tTextViewReference.bounds.size.width /2+ 10,30,20,25)];
    tlabel1.text = @"[";
    tlabel1.font = [UIFont systemFontOfSize:13.0f];
    tlabel1.textColor = [tserverObj colorWithHexString:@"2b2b2b"];
    [tTextViewReference addSubview:tlabel1];
    
    UILabel* taddress1 = [[UILabel alloc]initWithFrame:CGRectMake(tTextViewReference.bounds.size.width /2 + 16,30,tTextViewReference.bounds.size.width /2 - 50,25)];
    taddress1.text = tpara.taddress;
    taddress1.font = [UIFont systemFontOfSize:13.0f];
    taddress1.textColor = [tserverObj colorWithHexString:@"2b2b2b"];
    [tTextViewReference addSubview: taddress1];
    
    UILabel* tlabel2 = [[UILabel alloc]initWithFrame:CGRectMake((tTextViewReference.bounds.size.width /2 + 16) + (tTextViewReference.bounds.size.width /2 - 50),30,20,25)];
    tlabel2.text = @"]";
    tlabel2.font = [UIFont systemFontOfSize:13.0f];
    tlabel2.textColor = [tserverObj colorWithHexString:@"2b2b2b"];
    [tTextViewReference addSubview:tlabel2];
    
    UILabel* tdistance = [[UILabel alloc]initWithFrame:CGRectMake(38,60,tTextViewReference.bounds.size.width ,25)];
    tdistance.tag = 1;
    tdistance.text = [NSString stringWithFormat:@"Total miles : %0.1f miles",tTotalDistance*0.62137];
    tdistance.textColor = [tserverObj colorWithHexString:@"2b2b2b"];
    tdistance.font = [UIFont systemFontOfSize:13.0f];
    UIImageView* tdistance2 = [[UIImageView alloc]initWithFrame:CGRectMake(15,64,16,16)];
    tdistance2.image = [UIImage imageNamed:@"Miles.png"];
    UILabel* tTime = [[UILabel alloc]initWithFrame:CGRectMake(38,90,tTextViewReference.bounds.size.width, 25)];
    tTime.tag = 2;
    tTime.textColor = [tserverObj colorWithHexString:@"2b2b2b"];
    tTime.text = [NSString stringWithFormat:@"Total time :  %@",[tserverObj stringFromTimeInterval:tTotalTimeOfRoute]];
    tTime.font = [UIFont systemFontOfSize:13.0f];
    UIImageView* tTime2 = [[UIImageView alloc]initWithFrame:CGRectMake(15,94,16,16)];
    tTime2.image = [UIImage imageNamed:@"Clock.png"];
    tTotalDistanceOfJourney = tdistance.text;
    tExpectedTimeOfJourney = tTime.text;
    UILabel * tdate = [[UILabel alloc]initWithFrame:CGRectMake(38,120,tTextViewReference.bounds.size.width, 25)];
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay  fromDate:currDate];
    if(components.month == 6)
    {
//        NSLog(@"June");
    }
    
//    [dateFormatter setDateFormat:@"dd-MM-YY"];
    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    tdate.text = [NSString stringWithFormat:@"%@",dateString];
    tdate.textColor = [tserverObj colorWithHexString:@"2b2b2b"];
    tdate.font = [UIFont systemFontOfSize:13.0f];
    
    
    UIImageView* tdate2 = [[UIImageView alloc]initWithFrame:CGRectMake(15,124,16,16)];
    tdate2.image = [UIImage imageNamed:@"Date.png"];
    
    
//    [tTextViewReference addSubview:tAddressOfFirstproperty];
    
    tTextViewReference.layer.borderWidth = 0.9f;
    tTextViewReference.layer.borderColor = [tserverObj colorWithHexString:@"a2a2a2"].CGColor;
    
    UIView* shadowView = [[UIView alloc] initWithFrame:CGRectMake(0,0,tTextViewReference.bounds.size.width,2)];
    shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    shadowView.layer.shadowRadius = 5.0;
    shadowView.layer.shadowOffset = CGSizeMake(3.0, 3.0);
    shadowView.layer.opacity = 1.0;
    [tTextViewReference addSubview:shadowView];
//    tTextViewReference.layer.shadowColor = [tserverObj colorWithHexString:@"a2a2a2"].CGColor;
//    [tTextViewReference.layer setMasksToBounds:NO];
//    tTextViewReference.layer.shouldRasterize = YES;
//    [tTextViewReference.layer setShadowRadius:2.0f];
//    tTextViewReference.layer.shadowColor = [[UIColor blackColor] CGColor];
//    tTextViewReference.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
//    tTextViewReference.layer.shadowOpacity = 1.0f;
//    tTextViewReference.layer.shadowRadius = 1.0f;
    
    
    
     UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, -1,tTextViewReference.bounds.size.width, 1)];
     lineView.backgroundColor = [tserverObj colorWithHexString:@"9c9c9c"];
         [lineView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
         [lineView.layer setBorderWidth:1.5f];
     
         // drop shadow
         [lineView.layer setShadowColor:[UIColor blackColor].CGColor];
         [lineView.layer setShadowOpacity:0.8];
         [lineView.layer setShadowRadius:3.0];
         [lineView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, tTextViewReference.bounds.size.width,tTextViewReference.bounds.size.height - 1, 1)];
    lineView2.backgroundColor = [tserverObj colorWithHexString:@"9c9c9c"];
    
    tTextViewReference.maskView.layer.cornerRadius = 7.0f;
    tTextViewReference.layer.shadowRadius = 3.0f;
    tTextViewReference.layer.shadowColor = [UIColor blackColor].CGColor;
    tTextViewReference.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    tTextViewReference.layer.shadowOpacity = 0.5f;
    tTextViewReference.layer.masksToBounds = NO;
    
//    [tTextViewReference addSubview:lineView];
    [tTextViewReference addSubview:lineView2];
    
    
    [tTextViewReference addSubview:tproperty];
    [tTextViewReference addSubview:tdistance2];
    [tTextViewReference addSubview:tdate2];
    [tTextViewReference addSubview:tTime2];
    [tTextViewReference addSubview:tRouteNameLabel];
    [tTextViewReference addSubview:tFirstPropertyLabel];
    [tTextViewReference addSubview:tdistance];
    [tTextViewReference addSubview:tTime];
    [tTextViewReference addSubview:tdate];
    

}
-(void)tInitLocationManager
{
   //LOCATION SERVICE ENABLE WHEN USER CLICKS ON BEGIN ROUTE
    
   /* self.tLocationManager = [[CLLocationManager alloc] init];
 
    self.tLocationManager.delegate = self;
       self.tLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER)
    {
        // Use one or the other, not both. Depending on what you put in info.plist
        [self.tLocationManager requestWhenInUseAuthorization];
        [self.tLocationManager requestAlwaysAuthorization];
    }
#endif
    [self.tLocationManager startUpdatingLocation];
    
    float spanX = 0.58;
    float spanY = 0.58;
    self.location = self.tLocationManager.location;
//    NSLog(@"%@", self.location.description); //A quick NSLog to show us that location data is being received.
    MKCoordinateRegion region;
    region.center.latitude = self.tLocationManager.location.coordinate.latitude;
    region.center.longitude = self.tLocationManager.location.coordinate.longitude;
    
    tlat = self.tLocationManager.location.coordinate.latitude;
    tLong = self.tLocationManager.location.coordinate.longitude;
    
//    NSLog(@"@@@@FirstLatLong@@@=%f+++%f",self.tLocationManager.location.coordinate.latitude,self.tLocationManager.location.coordinate.longitude);
    
   
    
//    [self tGetAddress];
    
    region.span = MKCoordinateSpanMake(spanX, spanY);
    [self.mapView setRegion:region animated:YES];*/
    
    self.tLocationManager = [[CLLocationManager alloc] init];
    
    self.tLocationManager.delegate = self;
//    self.tLocationManager.desiredAccuracy = 10.0;
    self.tLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // Set a movement threshold for new events.
    _tLocationManager.distanceFilter = kCLDistanceFilterNone; // meters
//    self.tLocationManager.distanceFilter = kCLDistanceFilterNone;
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER)
    {
        // Use one or the other, not both. Depending on what you put in info.plist
        [self.tLocationManager requestWhenInUseAuthorization];
        [self.tLocationManager requestAlwaysAuthorization];
    }
#endif
    [self.tLocationManager startUpdatingLocation];
    
    float spanX = 0.58;
    float spanY = 0.58;
    self.location = self.tLocationManager.location;
    NSLog(@"%@", self.location.description); //A quick NSLog to show us that location data is being received.
    MKCoordinateRegion region;
    region.center.latitude = self.tLocationManager.location.coordinate.latitude;
    region.center.longitude = self.tLocationManager.location.coordinate.longitude;
    
    tlat = self.tLocationManager.location.coordinate.latitude;
    tLong = self.tLocationManager.location.coordinate.longitude;
    
    
    region.span = MKCoordinateSpanMake(spanX, spanY);
    [self.mapView setRegion:region animated:YES];
    
    [self tSetupOfMapView];
    [self createAnnotations];

    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
      
    
    [self generateRoute];
        dispatch_async( dispatch_get_main_queue(), ^{
            // Add code here to update the UI/send notifications based on the
            // results of the background processing
        });
    });
    
}



-(void)tInitLocationOfMapView :(NSString*)tIdentifier
{
}

- (void) zoomToAnnotationsBounds:(NSMutableArray *)annotations {
    
    CLLocationDegrees minLatitude = DBL_MAX;
    CLLocationDegrees maxLatitude = -DBL_MAX;
    CLLocationDegrees minLongitude = DBL_MAX;
    CLLocationDegrees maxLongitude = -DBL_MAX;
    
    for (TS_Annotation *annotation in annotations)
    {
        double annotationLat = annotation.coordinate.latitude;
        double annotationLong = annotation.coordinate.longitude;
        minLatitude = fmin(annotationLat, minLatitude);
        maxLatitude = fmax(annotationLat, maxLatitude);
        minLongitude = fmin(annotationLong, minLongitude);
        maxLongitude = fmax(annotationLong, maxLongitude);
    }
    
    // See function below
    [self setMapRegionForMinLat:minLatitude minLong:minLongitude maxLat:maxLatitude maxLong:maxLongitude];
    
    // If your markers were 40 in height and 20 in width, this would zoom the map to fit them perfectly. Note that there is a bug in mkmapview's set region which means it will snap the map to the nearest whole zoom level, so you will rarely get a perfect fit. But this will ensure a minimum padding.
    UIEdgeInsets mapPadding = UIEdgeInsetsMake(40.0, 10.0, 0.0, 10.0);
    CLLocationCoordinate2D relativeFromCoord = [self.mapView convertPoint:CGPointMake(0, 0) toCoordinateFromView:self.mapView];
    
    // Calculate the additional lat/long required at the current zoom level to add the padding
    CLLocationCoordinate2D topCoord = [self.mapView convertPoint:CGPointMake(0, mapPadding.top) toCoordinateFromView:self.mapView];
    CLLocationCoordinate2D rightCoord = [self.mapView convertPoint:CGPointMake(0, mapPadding.right) toCoordinateFromView:self.mapView];
    CLLocationCoordinate2D bottomCoord = [self.mapView convertPoint:CGPointMake(0, mapPadding.bottom) toCoordinateFromView:self.mapView];
    CLLocationCoordinate2D leftCoord = [self.mapView convertPoint:CGPointMake(0, mapPadding.left) toCoordinateFromView:self.mapView];
    
    double latitudeSpanToBeAddedToTop = relativeFromCoord.latitude - topCoord.latitude;
    double longitudeSpanToBeAddedToRight = relativeFromCoord.latitude - rightCoord.latitude;
    double latitudeSpanToBeAddedToBottom = relativeFromCoord.latitude - bottomCoord.latitude;
    double longitudeSpanToBeAddedToLeft = relativeFromCoord.latitude - leftCoord.latitude;
    
    maxLatitude = maxLatitude + latitudeSpanToBeAddedToTop;
    minLatitude = minLatitude - latitudeSpanToBeAddedToBottom;
    
    maxLongitude = maxLongitude + longitudeSpanToBeAddedToRight;
    minLongitude = minLongitude - longitudeSpanToBeAddedToLeft;
    
//    [self setMapRegionForMinLat:minLatitude minLong:minLongitude maxLat:maxLatitude maxLong:maxLongitude];
}

-(void) setMapRegionForMinLat:(double)minLatitude minLong:(double)minLongitude maxLat:(double)maxLatitude maxLong:(double)maxLongitude {
    
    MKCoordinateRegion region;
    region.center.latitude = (minLatitude + maxLatitude) / 2;
    region.center.longitude = (minLongitude + maxLongitude) / 2;
    region.span.latitudeDelta = (maxLatitude - minLatitude);
    region.span.longitudeDelta = (maxLongitude - minLongitude);
    
    // MKMapView BUG: this snaps to the nearest whole zoom level, which is wrong- it doesn't respect the exact region you asked for. See http://stackoverflow.com/questions/1383296/why-mkmapview-region-is-different-than-requested
    
    [self.mapView setRegion:region animated:YES];
}


#pragma mark-LOGICAL METHODS



-(void)tSetupOfLocationManager
{
    //INITIALISE THE LOCATION MANAGER IF NOT INITIALISED ALREADY
    if(nil == self.tLocationManager)
    {
        self.tLocationManager = [[CLLocationManager alloc] init];
    }
    //SET THE DELEGATE
    self.tLocationManager.delegate = self;
    [self.tLocationManager startUpdatingLocation];
    
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER)
    {
        // Use one or the other, not both. Depending on what you put in info.plist
        [self.tLocationManager requestWhenInUseAuthorization];
        [self.tLocationManager requestAlwaysAuthorization];
    }
#endif
    //SETTING THE DISTANCE FILTER AND ACCURACY OF LOCATION MANAGER
    //self.tLocationManager.distanceFilter = 20;
    self.tLocationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    
    
    [self.tLocationManager startMonitoringSignificantLocationChanges];
//NSLog(@"Current LatLong=%f---%f",self.tLocationManager.location.coordinate.latitude,self.tLocationManager.location.coordinate.longitude);
    
   
    //
    //    [self tInitUpdateLocation:tparaObj];
    
     [self createAnnotations];
//    NSLog(@"LatLongArray=%ld",(unsigned long)tLatLongArray.count);
    
    [self generateRoute];
 
    
    
    
}

-(void)tSetupOfMapView
{
    //SETTING UP MAP VIEW
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    
    [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];
    
  
    
    //SET THE VIEW AREA OF MAP
    MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
    
    
    region.center.latitude = self.tLocationManager.location.coordinate.latitude;
    region.center.longitude = self.tLocationManager.location.coordinate.longitude;
    
//    region.span.longitudeDelta = 10.005f;
//    region.span.longitudeDelta = 10.005f;
    region.span.longitudeDelta = 5.005f;
    region.span.longitudeDelta = 5.005f;
    
    
    

//    NSLog(@"MinLatLong===%f -- %f\nMaxLatLong===%f===%f",tminLat,tminLong,tmaxLat,tmaxLong);
    
    
    
    [self.mapView setRegion:region animated:YES];
    
    [self tInitZoom];
    
    CLLocationCoordinate2D cord;
    
    

    
    CLLocation* tloc = [self.tLocationManager location];
    cord = [tloc coordinate];
 
    
    
}

- (void)createAnnotations
{
    NSMutableArray* tannotationArray = [NSMutableArray new];
    
    
    for(int i = 0;i<tserverObj.taddressArray.count;i++)
    {
        
        
        TS_ParaAddress* tparaAddress = [TS_ParaAddress new];
        tparaAddress = [tserverObj.taddressArray objectAtIndex:i];
        
        CLLocationCoordinate2D cord ;//= [self geoCodeUsingAddress:tparaAddress.taddress];
        cord.latitude = tparaAddress.tLatitude;
        cord.longitude = tparaAddress.tLongitude;
        NSLog(@"lat=%f---Long=%f",cord.latitude,cord.longitude);
        TS_Annotation* tobj = [TS_Annotation new];
        tobj.coordinate = cord;
        tobj.title = tparaAddress.tnotes;
        
        NSString* firstString = [[tparaAddress.taddress componentsSeparatedByString:@","] objectAtIndex:0];
        tobj.subtitle = firstString;
        
        CLLocationCoordinate2D centre;
        centre.latitude = cord.latitude;
        centre.longitude = cord.longitude;
        NSLog(@"RegionMonitoring Identifiers = %@",tparaAddress.tidentifireName);
        
//        CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:centre
//                                                                     radius:20.00
//                                                                 identifier:tparaAddress.tidentifireName];
//
//       
//        [self.tLocationManager startMonitoringForRegion:region];//[[CLRegion alloc] initCircularRegionWithCenter:centre radius:20.0 identifier:@"Work"]];
        
//        [self.tLocationManager startMonitoringForRegion:[[CLCircularRegion alloc]initCircularRegionWithCenter:centre radius:0.0 identifier:tparaAddress.tidentifireName]];
        
        
        [self.mapView addAnnotation:tobj];
        
        [tannotationArray addObject:tobj];
        
        
        
    }//end of for loop
    
//    [self zoomToAnnotationsBounds:tannotationArray];

}

//CONVERT NSTIMEINTERVAL INTO STRING WITH SEC< MINUTES < HOURS
- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval
{
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
}

-(UIBarButtonItem*)tLogicToAddRightBarButton
{
    UIImage *buttonImage;
    
    buttonImage = [UIImage imageNamed:@"Edit.png"];
    
    
    
    //create the button and assign the image
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    
    //set the frame of the button to the size of the image (see note below)
    button.frame = CGRectMake(10, 0, buttonImage.size.width, buttonImage.size.height);
    [button sizeToFit];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -button.imageView.frame.size.width + 30, 0, button.imageView.frame.size.width - 60);
    
    [button addTarget:self action:@selector(tSettingsPage) forControlEvents:UIControlEventTouchUpInside];
    
    //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return customBarItem;
}

-(void)tPlaySoundFile
{
//    SystemSoundID soundID;
//    CFBundleRef mainBundle = CFBundleGetMainBundle();
//    CFURLRef ref = CFBundleCopyResourceURL(mainBundle, (CFStringRef)@"alert.wav", NULL, NULL);
//    AudioServicesCreateSystemSoundID(ref, &soundID);
//    AudioServicesPlaySystemSound(soundID);
    
    NSString *pathOfAudioFile = [[NSBundle mainBundle]
                                 pathForResource:@"notification" ofType:@"wav"];
    tAudioPlayerObj = [[AVAudioPlayer alloc]initWithContentsOfURL:
                       [NSURL fileURLWithPath:pathOfAudioFile] error:NULL];
    [tAudioPlayerObj play];
    
}

-(UIBarButtonItem*)tLogicToAddLeftButton
{
    UIImage *buttonImage;
    buttonImage = [UIImage imageNamed:@"backBtn.png"];
    
    
    
    //create the button and assign the image
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    
    //set the frame of the button to the size of the image (see note below)
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button sizeToFit];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -button.imageView.frame.size.width + 30, 0, button.imageView.frame.size.width - 30);
    
    [button addTarget:self action:@selector(tBtnBackEvent) forControlEvents:UIControlEventTouchUpInside];
    
    //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return customBarItem;
}

#pragma mark-ACTION


-(void)tnextPropertyBtn
{
    tTextViewOfPopUps.hidden = YES;
    if(tserverObj.tisEditRouteBeforeJourney)
    {
        if(tserverObj.tcustomizeGeogfencingIndex == 0)
        {
            self.navigationItem.leftBarButtonItem = nil;
  
            
         
            double tSourceLat = self.tLocationManager.location.coordinate.latitude;
            double tSourceLong = self.tLocationManager.location.coordinate.longitude;
    
            
            TS_ParaLatAndLong* tpara2 = [TS_ParaLatAndLong new];
            tpara2 = [tLatLongArray objectAtIndex:tserverObj.tcustomizeGeogfencingIndex];
            double tDestinationLat = tpara2.tlatitude;
            double tDestinationLong = tpara2.tlongitude;
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"RouteCompleted"];
            NSLog(@"SourceLatLong=%f-%f\nDestinationLatLong=%f-%f",tSourceLat,tSourceLong,tDestinationLat,tDestinationLong);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/maps?saddr=%f,%f&daddr=%f,%f",tSourceLat,tSourceLong,tDestinationLat,tDestinationLong]]];
        }
        else
        {
    if(tLatLongArray.count > tserverObj.tcustomizeGeogfencingIndex)
    {
    self.navigationItem.leftBarButtonItem = nil;
    TS_ParaLatAndLong* tpara1 = [TS_ParaLatAndLong new];
    
    tpara1 = [tLatLongArray objectAtIndex:tserverObj.tcustomizeGeogfencingIndex - 1];
    double tSourceLat = tpara1.tlatitude;
    double tSourceLong = tpara1.tlongitude;

    
    TS_ParaLatAndLong* tpara2 = [TS_ParaLatAndLong new];
    tpara2 = [tLatLongArray objectAtIndex:tserverObj.tcustomizeGeogfencingIndex];
    double tDestinationLat = tpara2.tlatitude;
    double tDestinationLong = tpara2.tlongitude;
     [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"RouteCompleted"];
    NSLog(@"SourceLatLong=%f-%f\nDestinationLatLong=%f-%f",tSourceLat,tSourceLong,tDestinationLat,tDestinationLong);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/maps?saddr=%f,%f&daddr=%f,%f",tSourceLat,tSourceLong,tDestinationLat,tDestinationLong]]];

    }
    else
    {
        tActualTimeOfJourney = [NSString stringWithFormat:@"%@",[self timeFormatted:((tserverObj.tisStopTimeOfEachProperty * 60) + (tserverObj.tTimerCount))]];
        UIAlertView* tAlertObj = [[UIAlertView alloc]initWithTitle:@"Routing Information" message:[NSString stringWithFormat:@"%@\n%@\n%@",tserverObj.tNameOfRoute,tTotalDistanceOfJourney,tExpectedTimeOfJourney] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
         [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"RouteCompleted"];
        tAlertObj.tag = 222;
        [tAlertObj show];
    }
        }
    }
    else
    {
        
    }
   
}
-(void)tBtnBackEvent
{
    [self tInitStopMonitoring];
    tserverObj.tIndexOfArray = 0;
    [self.navigationController popViewControllerAnimated:YES];
 
}
-(void)tSettingsPage
{

     [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)updateCountdown
{
    tserverObj.tTimerCount++;
//    NSLog(@"CountDownTimer=%d",tserverObj.tTimerCount);
    tLabelOfJourneyTimer.text = [NSString stringWithFormat:@"Journey Time:%@",[self timeFormatted:tserverObj.tTimerCount]];
     NSUserDefaults* tdefaultObj = [NSUserDefaults standardUserDefaults];
    NSNumber* tRoutingTimer = [NSNumber numberWithInt:tserverObj.tTimerCount];
    [tdefaultObj setObject:tRoutingTimer forKey:@"Timer"];
    
}
- (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}
- (IBAction)tBtnActionOfCancelRoute:(id)sender
{
    [self tInitStopMonitoring];
    NSUserDefaults* tdefaultObj = [NSUserDefaults standardUserDefaults];
    @try {
        [tdefaultObj setObject:nil forKey:@"IndexOfArray"];
        [tdefaultObj rm_setCustomObject:nil forKey:@"RouteInfoArray"];
        tserverObj.tisEditRouteBeforeJourney = false;
    }
    @catch (NSException *exception) {
//        NSLog(@"Exception--%@",exception);
    }
    @finally
    {
        
    }
    
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"RouteCompleted"];
    tserverObj.isStopRegionMonitoring = true;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - DRAW ROUTE

- (void)generateRoute
{
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.transportType = MKDirectionsTransportTypeAutomobile;
    
    CLLocationCoordinate2D tPlaceMarkDestination;
    CLLocationCoordinate2D tSourceCoordinate;

    TS_ParaLatAndLong* tpara = [TS_ParaLatAndLong new];
    
    /*DATE: May 13,2015
     COMMENTED FOR LOOP IT WILL REQUIRE IN FUTURE
     */
    
//    NSLog(@"Count=%lu",(unsigned long)tLatLongArray.count);
//    for(int i = 0; i < tLatLongArray.count ; i++)
//    {
//
//        if(i>=1)
//        {
    if(tLatLongArray.count !=0)
    {
    if(tLatLongArray.count  > tRoutArrayCount)
    {
        if(tRoutArrayCount == 0)
        {
            if(!tserverObj.tisEditRouteBeforeJourney)
            {
            tSourceCoordinate.latitude = self.tLocationManager.location.coordinate.latitude;
            tSourceCoordinate.longitude = self.tLocationManager.location.coordinate.longitude;
                tserverObj.tcurrentLat = self.tLocationManager.location.coordinate.latitude;
                tserverObj.tcurrentLong = self.tLocationManager.location.coordinate.longitude;
                NSUserDefaults* tdefaultObj = [NSUserDefaults standardUserDefaults];
                NSNumber* tnumber = [NSNumber numberWithDouble:tserverObj.tcurrentLat];
                [tdefaultObj setObject:tnumber forKey:@"Lat"];
                NSNumber* tnumber2 = [NSNumber numberWithDouble:tserverObj.tcurrentLong];
                [tdefaultObj setObject:tnumber2 forKey:@"Long"];
                
            }
            else
            {
                tSourceCoordinate.latitude = tserverObj.tcurrentLat;
                tSourceCoordinate.longitude = tserverObj.tcurrentLong;
            }
        }
        else
        {
            tpara = [tLatLongArray objectAtIndex:tRoutArrayCount -1];
            tSourceCoordinate.latitude = tpara.tlatitude;
            tSourceCoordinate.longitude = tpara.tlongitude;
        }
        
//        NSLog(@"IndexNumber=%dSourceCoordinates= Lat-%f--Long-%f",tRoutArrayCount,tSourceCoordinate.latitude,tSourceCoordinate.longitude);
    
    //CONVERT CLCOORDINATES INTO MKPLACEMARK.
    MKPlacemark *tPlaceMarkk=[[MKPlacemark alloc]initWithCoordinate:tSourceCoordinate addressDictionary:nil];
    
    //CONVERT CLLOCATION POINTS INTO MKMAPITEM.
    MKMapItem *tMapUserPoint=[[MKMapItem alloc]initWithPlacemark:tPlaceMarkk];
    request.source = tMapUserPoint;

        if(tRoutArrayCount == 0)
        {
            tpara = [tLatLongArray objectAtIndex:tRoutArrayCount];
            //THIS IS METHOD IS USED FOR GEOFENCYING
            //            [self dictToRegion:tpara];
            
            //DESTINATION COORDINATES GET FROM NOTIFICATION RESPONSE
            tPlaceMarkDestination.latitude = tpara.tlatitude;
            tPlaceMarkDestination.longitude = tpara.tlongitude;
        }
        else
        {
            
        
   
//        TS_ParaLatAndLong* tpara2 = [TS_ParaLatAndLong new];
            tpara = [tLatLongArray objectAtIndex:tRoutArrayCount];
            //THIS IS METHOD IS USED FOR GEOFENCYING
//            [self dictToRegion:tpara];

    //DESTINATION COORDINATES GET FROM NOTIFICATION RESPONSE
    tPlaceMarkDestination.latitude = tpara.tlatitude;
    tPlaceMarkDestination.longitude = tpara.tlongitude;
        }
//         NSLog(@"DestinationCoordinates= Lat-%f--Long-%f",tPlaceMarkDestination.latitude,tPlaceMarkDestination.longitude);
//        NSLog(@"Notes=%f",tpara.tlatitude);
    MKPlacemark *tPlaceMarkDestination2=[[MKPlacemark alloc]initWithCoordinate:tPlaceMarkDestination addressDictionary:nil];
    
    //CONVERT CLLOCATION POINTS INTO MKMAPITEM.
    MKMapItem *tTapPoints=[[MKMapItem alloc]initWithPlacemark:tPlaceMarkDestination2];
    request.destination=tTapPoints;
    request.requestsAlternateRoutes = YES;
    
    
    //SET MKDIRECTIONS
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
        
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error)
     {
         if (error)
         {
             // IF ERROR THIS MEANS THE ROUTE IS NOT AVAILABLE THEN WE WILL SHOW THE CONNECTING LINE
             CLLocationCoordinate2D coordinateArray[2];
             coordinateArray[0] = tSourceCoordinate;
             coordinateArray[1] = tPlaceMarkDestination;
             self.iRouteLine = [MKPolyline polylineWithCoordinates:coordinateArray count:2];
             [self.mapView setVisibleMapRect:[self.iRouteLine boundingMapRect]]; // route to be visible
             [self.mapView addOverlay:self.iRouteLine];
             
             if(tLatLongArray.count > tRoutArrayCount)
             {
                 tRoutArrayCount++;
                 [self generateRoute];
                 
             }
         }
         else
         {
             [self showRoute:response];
             
         }
     }];
        }//END OF SECOND IF.
    else
    {
        [self tInitShowLabel];
    }
    }//END OF FIRST IF

}

//TO DRAW THE ROUTE IF MKDIRECTION DID NOT RETURN ERRO
- (void)showRoute:(MKDirectionsResponse *)response
{
//    NSLog(@"Route Response=%@",response);
    NSMutableArray* tshortAdressArray = [NSMutableArray new];
    for (MKRoute *route in response.routes)
    {
        [tshortAdressArray addObject:route];
    }
//    NSLog(@"count=%ld",(unsigned long)tshortAdressArray.count);
    NSSortDescriptor *boolDescr = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES selector:nil];
    
    // Combine the two
    NSArray *sortDescriptors = @[boolDescr];
    // Sort your array
    tshortAdressArray=  [NSMutableArray arrayWithArray: [tshortAdressArray sortedArrayUsingDescriptors:sortDescriptors]] ;
    MKRoute* troute = [tshortAdressArray objectAtIndex:0];
    TS_ParaSort* tpara = [TS_ParaSort new];
    tpara.tdistance = (troute.distance/1609.344);
    tpara.tTravelTime = troute.expectedTravelTime;
//    NSLog(@"DistanceBetweenPoints=%f\nRequiredTime=%@\nDistanceInPAraObj=%f",(troute.distance/1609.344),[tserverObj stringFromTimeInterval:troute.expectedTravelTime],tpara.tdistance);
    
    [tserverObj.tTotalTimeAndDistance addObject:tpara];
    
//    NSLog(@"Route Steps Array = %@",troute.steps);
    //STEPS OF ROUTE DIRECTIONS INFORMATION
    for(int i=0;i<troute.steps.count;i++)
    {
        
    MKRouteStep* tsteps = [troute.steps objectAtIndex:i];
    NSString* tRouteSteps = tsteps.instructions;
//    NSLog(@"Step %d=%@",i,tRouteSteps);
    
        
    }
    
    
    
    [self.mapView addOverlay:troute.polyline level:MKOverlayLevelAboveLabels];
    
    //USED RECUSRSION INSTED OF FOR LOOP BECAUSE OF BOLCK OF CODES NOT RUN PROPERLY IN FOR LOOP
    if(tLatLongArray.count > tRoutArrayCount)
    {
        tRoutArrayCount++;
        [self generateRoute];
        
    }
   
}


#pragma mark-MAP VIEW DELEGATES AND LOCATION MANAGER DELEGATES

//- (void)registerBeaconRegionWithUUID:(NSUUID *)proximityUUID :(NSString*)identifier
//{
//    
//    // Create the beacon region to be monitored.
//    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc]
//                                    initWithProximityUUID:proximityUUID
//                                    identifier:identifier];
//    
//    // Create a dictionary of advertisement data.
////   beaconPeripheralData =
////    [beaconRegion peripheralDataWithMeasuredPower:nil];
////    
////    peripheralManager = [[CBPeripheralManager alloc]
////                                              initWithDelegate:selfqueue :nil options:nil];
//    
////     Start advertising your beacon's data.
//    [peripheralManager startAdvertising:beaconPeripheralData];
//
//    
//    // Register the beacon region with the location manager.
//    [self.tLocationManager startMonitoringForRegion:beaconRegion];
//    
//    
//}
//
//- (void)registerRegionWithCircularOverlay:(MKCircle*)overlay :(NSString*)identifier {
//    
//    // If the overlay's radius is too large, registration fails automatically,
//    // so clamp the radius to the max value.
//    CLLocationDistance radius = overlay.radius;
//    if (radius > self.tLocationManager.maximumRegionMonitoringDistance) {
//        radius = self.tLocationManager.maximumRegionMonitoringDistance;
//    }
//    
//    // Create the geographic region to be monitored.
//    CLCircularRegion *geoRegion = [[CLCircularRegion alloc]
//                                   initWithCenter:overlay.coordinate
//                                   radius:radius
//                                   identifier:identifier];
//    [self.tLocationManager startMonitoringForRegion:geoRegion];
//}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    
//    renderer.strokeColor = [UIColor redColor];
    renderer.strokeColor = [tserverObj colorWithHexString:@"39aad6"];
    
    renderer.alpha = 0.7;
    renderer.lineWidth = 4.0;

    return renderer;
}


//- (void)locationManager:(CLLocationManager *)manager
//        didRangeBeacons:(NSArray *)beacons
//               inRegion:(CLBeaconRegion *)region {
//    
//    if ([beacons count] > 0) {
//        CLBeacon *nearestExhibit = [beacons firstObject];
//        
//        // Present the exhibit-specific UI only when
//        // the user is relatively close to the exhibit.
//        if (CLProximityNear == nearestExhibit.proximity) {
////            [self presentExhibitInfoWithMajorValue:nearestExhibit.major.integerValue];
//            NSLog(@"Enter in region");
//            
//        } else {
////            [self dismissExhibitInfo];
//            NSLog(@"Exist from region");
//        }
//}
//}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"Enter in geofence=%@\nPassess iD=%@",region.identifier,tIdentifier);
    TS_ParaAddress* tpara = [TS_ParaAddress new];
    NSUserDefaults* tdefaultObj = [NSUserDefaults standardUserDefaults];
  if(!tserverObj.isNotesOnOff)
  {
   
//    for(int i=0;i<tserverObj.taddressArray.count;i++)
//    {
      NSLog(@"Exact Porperty in GeoFencing =%d",tserverObj.tIsExactProperty);
        if(tserverObj.taddressArray.count > tserverObj.tIsExactProperty)
        {
        tpara = [tserverObj.taddressArray objectAtIndex:tserverObj.tIsExactProperty];
        }
        
        if([tIdentifier isEqualToString:region.identifier])
        {
            tIdentifier = @"A";
            //FIRED TIMER
            [self tInitTimer];

            tserverObj.tisLastProperty++;
            tserverObj.tIsExactProperty++;

            [self tInitDataPopUps :tpara];
            [self tPlaySoundFile];
            
            AppDelegate *objApp=(AppDelegate*)[[UIApplication sharedApplication] delegate];
          
            if(tserverObj.tAppIsBackgroundOrNot)
            {
                NSDate *now = [NSDate date];
                NSLog(@"Notes=%@",tpara.tnotes);
                [self tOpensNativeApp];
                if(tpara.tnotes.length != 0)
                {
                tserverObj.tIndexOfArray++;
                [objApp insert:now :tpara.tnotes];
                }
                else
                {
                    tserverObj.tIndexOfArray++;
                    [objApp insert:now :@"Fence"];
                }
                
                
            }
           
          
        }//end of validation first if
//    }//end of for loop
    
    if(tserverObj.tisLastProperty == tserverObj.taddressArray.count)
    {
        tserverObj.tisLastProperty ++;
        [tserverObj.timer invalidate];
        tserverObj.timer = nil;
        tserverObj.isTimerStartOrStop = false;
        self.navigationItem.leftBarButtonItem = [self tLogicToAddLeftButton];
        tActualTimeOfJourney = [NSString stringWithFormat:@"%@",[self timeFormatted:((tserverObj.tisStopTimeOfEachProperty * 60) + (tserverObj.tTimerCount))]];
        UIAlertView* tAlertObj = [[UIAlertView alloc]initWithTitle:@"Routing Information" message:[NSString stringWithFormat:@"%@\n%@\n%@",tserverObj.tNameOfRoute,tTotalDistanceOfJourney,tExpectedTimeOfJourney] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        tAlertObj.tag = 222;
//        [tAlertObj show];
        AppDelegate *objApp=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        if(tserverObj.tAppIsBackgroundOrNot)
        {
            tserverObj.tIndexOfArray++;
            NSDate *now = [NSDate date];
//            [self tOpensNativeApp];
            if(tpara.tnotes.length !=0)
            {
            [objApp insert:now :tpara.tnotes];
            }
            else
            {
                [objApp insert:now :@"Fence"];
            }

            
        }
    }//if notification set to be of then this codes runs
  }
    else
    {
        for(int i=0;i<tserverObj.taddressArray.count;i++)
        {
            if(tserverObj.taddressArray.count > tserverObj.tIsExactProperty)
            {
                tpara = [tserverObj.taddressArray objectAtIndex:tserverObj.tIsExactProperty];
            }
            
            if([tIdentifier isEqualToString:region.identifier])
            {
                tIdentifier = @"A";
                
                
                //FIRED TIMER FOR GEOFENCING REGION
                [self tInitTimer];
                
                NSNumber* tkeyObj = [NSNumber numberWithInt:1];
                [tdefaultObj setObject:tkeyObj forKey:[NSString stringWithFormat:@"%d",i]];
                tserverObj.tisLastProperty++;
                tserverObj.tIsExactProperty++;
                
//                [self tInitDataPopUps :tpara];
                [self tPlaySoundFile];
                
                AppDelegate *objApp=(AppDelegate*)[[UIApplication sharedApplication] delegate];
                
                if(tserverObj.tAppIsBackgroundOrNot)
                {
                    NSDate *now = [NSDate date];
                    NSLog(@"Notes=%@",tpara.tnotes);
                    [self tOpensNativeApp];
                    if(tpara.tnotes.length != 0)
                    {
                        tserverObj.tIndexOfArray++;
                        [objApp insert:now :tpara.tnotes];
                    }
                    else
                    {
                        tserverObj.tIndexOfArray++;
                        //                    [objApp insert:now :[NSString stringWithFormat:@"Source -> Lat=%f-Long=%f\nDestination->Lat=%f-Long=%f",tSLat,tSLong,tDLat,tDLong]];
                        [objApp insert:now :@"Fence"];
                    }
                    
                    
                }
                
                
            }//end of validation first if
        }//end of for loop
        
        if(tserverObj.tisLastProperty == tserverObj.taddressArray.count)
        {
            tserverObj.tisLastProperty ++;
//            [self.tBtnBeginRouteReference setTitle:@"Begin Route" forState:UIControlStateNormal];
            [tserverObj.timer invalidate];
            tserverObj.timer = nil;
            tserverObj.isTimerStartOrStop = false;
            self.navigationItem.leftBarButtonItem = [self tLogicToAddLeftButton];
            tActualTimeOfJourney = [NSString stringWithFormat:@"%@",[self timeFormatted:((tserverObj.tisStopTimeOfEachProperty * 60) + (tserverObj.tTimerCount))]];
            UIAlertView* tAlertObj = [[UIAlertView alloc]initWithTitle:@"Routing Information" message:[NSString stringWithFormat:@"%@\n%@\n%@",tserverObj.tNameOfRoute,tTotalDistanceOfJourney,tExpectedTimeOfJourney] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            
            tAlertObj.tag = 222;
            [tAlertObj show];
//            [self getPDFFileName];
            AppDelegate *objApp=(AppDelegate*)[[UIApplication sharedApplication] delegate];
            
            if(tserverObj.tAppIsBackgroundOrNot)
            {
                tserverObj.tIndexOfArray++;
                NSDate *now = [NSDate date];
                [self tOpensNativeApp];
                if(tpara.tnotes.length !=0)
                {
                    [objApp insert:now :tpara.tnotes];
                }
                else
                {
                    [objApp insert:now :@"Fence"];
                }

                
            }
    }

}
}




-(void)tOpensNativeApp
{
    NSUserDefaults* tdefaultObj = [NSUserDefaults standardUserDefaults];
    NSMutableArray* tarray = [NSMutableArray new];
        tarray = [tdefaultObj rm_customObjectForKey:@"LatLongArray"];
    

    TS_ParaLatAndLong* tpara = [TS_ParaLatAndLong new];
    
    NSLog(@"ArrayOfIndexInNativeApp=%d",tserverObj.tIndexOfArray);
    
    NSLog(@"CountOfLatLongArray=%ld",(unsigned long)tLatLongArray.count);
    @try {
        tpara = [tLatLongArray objectAtIndex:tserverObj.tcustomizeGeogfencingIndex-1];
        double tSourceLat = tpara.tlatitude;
        double tSourceLong = tpara.tlongitude;
        tSLat = tpara.tlatitude;
        tSLong = tpara.tlongitude;
        
        
        TS_ParaLatAndLong* tpara2 = [TS_ParaLatAndLong new];
        tpara2 = [tLatLongArray objectAtIndex:tserverObj.tcustomizeGeogfencingIndex];
        double tDestinationLat = tpara2.tlatitude;
        double tDestinationLong = tpara2.tlongitude;
        tDLat = tDestinationLat;
        tDLong = tDestinationLong;
        //    tserverObj.tIndexOfArray++;
        NSNumber* tindex = [NSNumber numberWithInt:tserverObj.tIndexOfArray];
        [tdefaultObj setObject:tindex forKey:@"IndexOfArray"];
        NSLog(@"SourceLatLong=%f-%f\nDestinationLatLong=%f-%f",tSourceLat,tSourceLong,tDestinationLat,tDestinationLong);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/maps?saddr=%f,%f&daddr=%f,%f",tSourceLat,tSourceLong,tDestinationLat,tDestinationLong]]];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception=%@",exception);
    }
    @finally
    {
        
    }
    
    
 
}



-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
//    NSLog(@"lat=%f===Long=%f",self.tLocationManager.location.coordinate.latitude,self.tLocationManager.location.coordinate.longitude);
    [self tCalculateDistance];
}
-(void)tCalculateDistance
{
    

    if(tserverObj.taddressArray.count > tserverObj.tcustomizeGeogfencingIndex)
    {
    TS_ParaAddress* tpara = [TS_ParaAddress new];
    tpara = [tserverObj.taddressArray objectAtIndex:tserverObj.tcustomizeGeogfencingIndex];
    CLLocationCoordinate2D cord;
    cord.latitude = tpara.tLatitude;
    cord.longitude = tpara.tLongitude;
    
    
    CLLocation *locA = [[CLLocation alloc] initWithLatitude:cord.latitude longitude:cord.longitude];
    
    CLLocation *locB = [[CLLocation alloc] initWithLatitude:self.tLocationManager.location.coordinate.latitude longitude:self.tLocationManager.location.coordinate.longitude];//current location
    
    CLLocationDistance distance = [locB distanceFromLocation:locA];
    
    if(distance < 100.0)
    {
        AppDelegate *objApp=(AppDelegate*)[[UIApplication sharedApplication] delegate];
       
        
        if(tserverObj.tAppIsBackgroundOrNot)
        {
            
            tserverObj.tcustomizeGeogfencingIndex++;
            tserverObj.tIndexOfArray++;
            tserverObj.tIsExactProperty++;
            [self tInitDataPopUps :tpara];
            [self tPlaySoundFile];
        
            NSDate *now = [NSDate date];
            //            [self tOpensNativeApp];
            if(tpara.tnotes.length !=0)
            {
                [objApp insert:now :tpara.tnotes];
            }
            else
            {
                [objApp insert:now :@"Fence"];
            }
            
            
        }
        else
        {
            tserverObj.tcustomizeGeogfencingIndex++;
            tserverObj.tIndexOfArray++;
            NSDate *now = [NSDate date];
            //            [self tOpensNativeApp];
            if(tpara.tnotes.length !=0)
            {
                [objApp insert:now :tpara.tnotes];
            }
            else
            {
                [objApp insert:now :@"Fence"];
            }
        }
        [self tOpensNativeApp];
    }
        
    }
    
}
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPointAnnotation *ttemp = [MKPointAnnotation new];
    ttemp = annotation;
    
    
    static NSString* AnnotationIdentifier = @"Annotation";
    
    
    MKPinAnnotationView* pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    
    if (pinView == nil)
    {
        pinView = [[MKPinAnnotationView alloc]
                   initWithAnnotation:annotation
                   reuseIdentifier:AnnotationIdentifier];
        pinView.enabled = YES;
        pinView.canShowCallout = YES;
    }
    else
    {
        pinView.annotation = annotation;
        
    }
    
    MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];

     
     UIImageView* timageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,customPinView.bounds.size.width, customPinView.bounds.size.height)];
     UIImageView* timagView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, timageView.bounds.size.width+200, 80)];
     
     UILabel* tlabel = [UILabel new];
     tlabel.backgroundColor = [UIColor clearColor];
     [tlabel setFont:[UIFont systemFontOfSize:14.0f]];
     [tlabel setFrame:CGRectMake(0,40,timagView2.bounds.size.width/2 + 10,timagView2.bounds.size.height/2)];
     
     UIImage* timag = [[UIImage alloc]init];
     
     [timag drawInRect:CGRectMake(0,0,timageView.bounds.size.width,timageView.bounds.size.height - 10)];
     if (annotation == mapView.userLocation)
     {
         
     timag = [UIImage imageNamed:@"PinImage.png"];
         
    NSString* firstString = [NSString stringWithFormat:@"%@",[[tAddressOfCurrent componentsSeparatedByString:@","] objectAtIndex:0]];
         
         if([firstString isEqualToString:@"(null)"])
         {
             firstString = @"Current Location";
         }
      
         
     tlabel.text = firstString;
     [tlabel sizeToFit];
         
     }
     else
     {
         timag = [UIImage imageNamed:@"PinImage.png"];
         tlabel.text = ttemp.subtitle;
     [tlabel sizeToFit];
     
     }
     
     timageView.image = timag;
     customPinView.image = nil;
     [timagView2 addSubview:tlabel];
     [customPinView addSubview:timageView];
//     [customPinView addSubview:timagView2];

    customPinView.animatesDrop = NO;
    customPinView.canShowCallout = YES;
    
    
    return customPinView;
}

#pragma mark - GEOFENCYING
-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    NSLog(@"Region=%@\nStateOfRegion=%d",region,state);
}

#pragma mark-ALERT VIEW DELEGATE
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 222)
    {
        tserverObj.tisEditRouteBeforeJourney = false;
         [self getPDFFileName];
        if(tserverObj.isReceiptOnOff)
        {
        tserverObj.tisLastProperty = 0;
//        NSUserDefaults* tdefaultObj = [NSUserDefaults standardUserDefaults];
        
        
        
        TS_DBLayer* tdb = [TS_DBLayer new];
        [tdb tUpdateRouteData :tserverObj.tNameOfRoute];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"RouteCompleted"];
        [self.navigationController popViewControllerAnimated:YES];
            
        }
        else
        {
            NSUserDefaults* tdefaultObj = [NSUserDefaults standardUserDefaults];
            NSString* temailID = [tdefaultObj valueForKey:@"EmailId"];
//            NSLog(@"Str=%@",[tdefaultObj valueForKey:@"EmailId"]);
            if(![temailID isEqualToString:@""] && ![temailID isEqualToString:@"(null)"])
            {
                tserverObj.tisLastProperty = 0;
                //        NSUserDefaults* tdefaultObj = [NSUserDefaults standardUserDefaults];
               
                
                TS_DBLayer* tdb = [TS_DBLayer new];
                [tdb tUpdateRouteData :tserverObj.tNameOfRoute];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"RouteCompleted"];
                
                [self sendEmailInBackground];

                
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:nil
                                          message:@"Please enter receiver email id."
                                          delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
                alertView.tag = 101;
                [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
                // Display a numerical keypad for this text field
                UITextField *textField = [alertView textFieldAtIndex:0];
                textField.keyboardType = UIKeyboardTypeDefault;
                textField.keyboardType = UIKeyboardTypeEmailAddress;
                
                [alertView show];
            }
        }
        
        
    }
    else if(alertView.tag == 101)
    {
        tserverObj.tisEditRouteBeforeJourney = false;
            NSString* tstr =  [alertView textFieldAtIndex:0].text;
        NSUserDefaults* tdefaultObj = [NSUserDefaults standardUserDefaults];
        [tdefaultObj setObject:tstr forKey:@"EmailId"];
        tserverObj.tisLastProperty = 0;
//        [self getPDFFileName];
        [self sendEmailInBackground];
        TS_DBLayer* tdb = [TS_DBLayer new];
        [tdb tUpdateRouteData :tserverObj.tNameOfRoute];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"RouteCompleted"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark-NEW METHODS FOR IMPLEMNTING GEOFENCYING



- (IBAction)tBtnBeginRoute:(id)sender
{
  
    
    NSUserDefaults* tdefaultObj = [NSUserDefaults standardUserDefaults];
    tserverObj.tisEditRouteBeforeJourney = true;
    
    if(!tisEndRoute)
    {
        TS_ParaAddress* tobj2 = [TS_ParaAddress new];
        if(tserverObj.taddressArray.count > tserverObj.tIndexOfArray){
        tobj2 = [tserverObj.taddressArray objectAtIndex:tserverObj.tIndexOfArray];
        tIdentifier = tobj2.tidentifireName;
        }
        if(tserverObj.tIndexOfArray == 0)
        {
            tserverObj.isStopRegionMonitoring = false;
//            tserverObj.isNotesOnOff = true;
//            tserverObj.isReceiptOnOff = true;
            tisEndRoute = true;
            //        [self.tBtnBeginRouteReference setTitle:@"Next Route" forState:UIControlStateNormal];
            [self.tBtnBeginRouteReference setBackgroundImage:[UIImage imageNamed:@"EndBtn.png"] forState:UIControlStateNormal];
            self.navigationItem.leftBarButtonItem = nil;
            TS_ParaLatAndLong* tpara = [TS_ParaLatAndLong new];
            
            tpara = [tLatLongArray objectAtIndex:tserverObj.tIndexOfArray];
            NSNumber* tindex = [NSNumber numberWithInt:tserverObj.tIndexOfArray];
            [tdefaultObj setObject:tindex forKey:@"IndexOfArray"];
            [tdefaultObj rm_setCustomObject:tserverObj.taddressArray forKey:@"RouteInfoArray"];
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"RouteCompleted"];
            
            
            
            
            tLatitude = tpara.tlatitude;
            tLongitude = tpara.tlongitude;
            tserverObj.tIndexOfArray++;

            NSLog(@"SourceLatLong=%f-%f\nDestinationLatLong=%f-%f",self.tLocationManager.location.coordinate.latitude,self.tLocationManager.location.coordinate.longitude, tpara.tlatitude,tpara.tlongitude);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/maps?saddr=%f,%f&daddr=%f,%f",self.tLocationManager.location.coordinate.latitude,self.tLocationManager.location.coordinate.longitude, tpara.tlatitude,tpara.tlongitude]]];
            
            
        }
        else
        {
            if(tLatLongArray.count > tserverObj.tIndexOfArray)
            {
//                tserverObj.isNotesOnOff = true;
//                tserverObj.isReceiptOnOff = true;
                tserverObj.tisEditRouteBeforeJourney = false;
                //            [self.tBtnBeginRouteReference setTitle:@"Next Route" forState:UIControlStateNormal];
                [self.tBtnBeginRouteReference setBackgroundImage:[UIImage imageNamed:@"EndBtn.png"] forState:UIControlStateNormal];
                self.navigationItem.leftBarButtonItem = nil;
                [tserverObj.timer invalidate];
                tserverObj.timer = nil;

                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"RouteCompleted"];
                TS_ParaLatAndLong* tpara = [TS_ParaLatAndLong new];
                
                tpara = [tLatLongArray objectAtIndex:tserverObj.tIndexOfArray - 1];
                double tSourceLat = tpara.tlatitude;
                double tSourceLong = tpara.tlongitude;
                NSNumber* tindex = [NSNumber numberWithInt:tserverObj.tIndexOfArray];
                [tdefaultObj setObject:tindex forKey:@"IndexOfArray"];
                
                TS_ParaLatAndLong* tpara2 = [TS_ParaLatAndLong new];
                tpara2 = [tLatLongArray objectAtIndex:tserverObj.tIndexOfArray];
                double tDestinationLat = tpara2.tlatitude;
                double tDestinationLong = tpara2.tlongitude;
                tserverObj.tIndexOfArray++;
                NSLog(@"SourceLatLong=%f-%f\nDestinationLatLong=%f-%f",tSourceLat,tSourceLong,tDestinationLat,tDestinationLong);
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/maps?saddr=%f,%f&daddr=%f,%f",tSourceLat,tSourceLong,tDestinationLat,tDestinationLong]]];
                if(tLatLongArray.count == tserverObj.tIndexOfArray)
                {
                    
                    //            [self.tBtnBeginRouteReference setTitle:@"Begin Route" forState:UIControlStateNormal];
                    
                    [self.tBtnBeginRouteReference setBackgroundImage:[UIImage imageNamed:@"RouteInfoBtn.png"] forState:UIControlStateNormal];
                    
                    [tserverObj.timer invalidate];
                    tserverObj.timer = nil;
                    tActualTimeOfJourney = [NSString stringWithFormat:@"%@",[self timeFormatted:((tserverObj.tisStopTimeOfEachProperty * 60) + (tserverObj.tTimerCount))]];
                   UIAlertView* tAlertObj = [[UIAlertView alloc]initWithTitle:@"Routing Information" message:[NSString stringWithFormat:@"%@\n%@\n%@",tserverObj.tNameOfRoute,tTotalDistanceOfJourney,tExpectedTimeOfJourney] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    
                    tAlertObj.tag = 222;
                    [tAlertObj show];
                    
                }
                
            }
            else
            {
                self.navigationItem.leftBarButtonItem = [self tLogicToAddLeftButton];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"RouteCompleted"];
                //            [self.tBtnBeginRouteReference setTitle:@"Begin Route" forState:UIControlStateNormal];
                [self.tBtnBeginRouteReference setBackgroundImage:[UIImage imageNamed:@"RouteInfoBtn.png"] forState:UIControlStateNormal];
                [tserverObj.timer invalidate];
                tserverObj.timer = nil;
                tActualTimeOfJourney = [NSString stringWithFormat:@"%@",[self timeFormatted:((tserverObj.tisStopTimeOfEachProperty * 60) + (tserverObj.tTimerCount))]];
               UIAlertView* tAlertObj = [[UIAlertView alloc]initWithTitle:@"Routing Information" message:[NSString stringWithFormat:@"%@\n%@\n%@",tserverObj.tNameOfRoute,tTotalDistanceOfJourney,tExpectedTimeOfJourney] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                
                tAlertObj.tag = 222;
                [tAlertObj show];
                TS_DBLayer* tdb = [TS_DBLayer new];
                [tdb tUpdateRouteData :tserverObj.tNameOfRoute];
                
            }
            
        }
    }
    else
    {
        [self.tBtnBeginRouteReference setBackgroundImage:[UIImage imageNamed:@"RouteInfoBtn.png"] forState:UIControlStateNormal];
        
        [tserverObj.timer invalidate];
        tserverObj.timer = nil;
        
        tActualTimeOfJourney = [NSString stringWithFormat:@"%@",[self timeFormatted:((tserverObj.tisStopTimeOfEachProperty * 60) + (tserverObj.tTimerCount))]];
        UIAlertView* tAlertObj = [[UIAlertView alloc]initWithTitle:@"Routing Information" message:[NSString stringWithFormat:@"%@\n%@\n%@",tserverObj.tNameOfRoute,tTotalDistanceOfJourney,tExpectedTimeOfJourney] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        tAlertObj.tag = 222;
        [tAlertObj show];
        tserverObj.isStopRegionMonitoring = false;
       
        TS_DBLayer* tdb = [TS_DBLayer new];
        [tdb tUpdateRouteData :tserverObj.tNameOfRoute];
        
        
        
    }

}






#pragma mark-SEND EMAIL
-(void) sendEmailInBackground {
//    NSLog(@"Start Sending");
    SKPSMTPMessage *emailMessage = [[SKPSMTPMessage alloc] init];
    NSUserDefaults* tdefaultObj = [NSUserDefaults standardUserDefaults];
    NSString* temaildId = [tdefaultObj valueForKey:@"EmailId"];
  
     temaildId = [tdefaultObj valueForKey:@"EmailId"];
    
//    NSLog(@"EmailId=%@",temaildId);
    
    emailMessage.fromEmail = @"home.router12@gmail.com"; //sender email address
    
    emailMessage.toEmail = temaildId;  //receiver email address
    emailMessage.relayHost = @"smtp.gmail.com";
    //emailMessage.ccEmail =@"your cc address";
    //emailMessage.bccEmail =@"your bcc address";
    emailMessage.requiresAuth = YES;
    emailMessage.login = @"home.router12@gmail.com"; //sender email address
    emailMessage.pass = @"abcdefg!A"; //sender email password
    emailMessage.subject =@"Home Router Receipt";
    emailMessage.wantsSecure = NO;
    emailMessage.delegate = self; // you must include <SKPSMTPMessageDelegate> to your class
    NSString *messageBody = @"Receipt";
    
    NSDictionary *plainMsg = [NSDictionary
                              dictionaryWithObjectsAndKeys:@"text/plain",kSKPSMTPPartContentTypeKey,
                              messageBody,kSKPSMTPPartMessageKey,@"8bit",kSKPSMTPPartContentTransferEncodingKey,nil];
   
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"Home Router.PDF"];
    
    NSData *fileData = [NSData dataWithContentsOfFile:path];
    
    
    NSDictionary *vcfPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/directory;\r\n\tx-unix-mode=0644;\r\n\tname=\"Home Router.pdf\"",kSKPSMTPPartContentTypeKey,@"attachment;\r\n\tfilename=\"Home Router.pdf\"",kSKPSMTPPartContentDispositionKey,[fileData encodeBase64ForData],kSKPSMTPPartMessageKey,@"base64",kSKPSMTPPartContentTransferEncodingKey,nil];
    emailMessage.parts = [NSArray arrayWithObjects:plainMsg,vcfPart,nil];
    
    
    //     NSDictionary *fileMsg = [NSDictionary dictionaryWithObjectsAndKeys:@"text/directory;\r\n\tx-
    //     unix-mode=0644;\r\n\tname="invoice.pdf\"",kSKPSMTPPartContentTypeKey,@"attachment;\r\n\tfilename=\"invoice.pdf\"",kSKPSMTPPartContentDispositionKey,[fileData encodeBase64ForData],kSKPSMTPPartMessageKey,@"base64",kSKPSMTPPartContentTransferEncodingKey,nil]
    
//    NSString* fileName = @"HomeRouter";
//    NSString* strFormat = [NSString stringWithFormat:@"application/pdf;\r\n\tx-unix-mode=0644;\r\n\tname=\"%@\"", fileName];
//    //
//    NSString* strFormat2 = [NSString stringWithFormat:@"attachment;\r\n\tfilename=\"%@\"", fileName];
//  
//    NSDictionary *vcfPart = [NSDictionary dictionaryWithObjectsAndKeys: strFormat,kSKPSMTPPartContentTypeKey, strFormat2,kSKPSMTPPartContentDispositionKey, [fileData encodeWrappedBase64ForData],kSKPSMTPPartMessageKey,@"base64",kSKPSMTPPartContentTransferEncodingKey,nil];
//    //
//    emailMessage.parts = [NSArray arrayWithObjects:plainMsg,vcfPart,nil]; //including plain msg and attached file msg
    
    [emailMessage send];
    
    // sending email- will take little time to send so its better to use indicator with message showing sending...
}


// On success

-(void)messageSent:(SKPSMTPMessage *)message{
    
    NSLog(@"delegate - message sent");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message sent." message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    
}
// On Failure
-(void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error{
    
    // open an alert with just an OK button
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    NSLog(@"delegate - error(%d): %@", [error code], [error localizedDescription]);
    
}

#pragma mark-PDF GENERATION

-(void)getPDFFileName
{
    [self setupPDFDocumentNamed:@"NewPDF" Width:850 Height:1400];
    [self beginPDFPage];
    
    //SET ORGANISATION INFO
    CGRect nextSize1= [self timageRect];
    CGRect nextSize2=[self tAllTextRect:nextSize1];
    [self taddTextAndImage:nextSize2];
    
    [self finishPDF];
    
    
}

- (void)setupPDFDocumentNamed:(NSString*)name Width:(float)width Height:(float)height
{
    _pageSize = CGSizeMake(width, height);
    
    NSString *newPDFName = [NSString stringWithFormat:@"Home Router.PDF"];
    

  
    NSArray *arrayPaths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];

    
    pdfPath = [path stringByAppendingPathComponent:newPDFName];//[documentsDirectory stringByAppendingPathComponent:newPDFName];
    NSURL *url = [NSURL fileURLWithPath:pdfPath];
    
//    NSLog(@"Path=%@",pdfPath);
    UIGraphicsBeginPDFContextToFile(pdfPath, CGRectZero, nil);
}

- (void)beginPDFPage
{
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(10, 10, _pageSize.width, _pageSize.height), nil);
}


- (CGRect)addText:(NSString*)text withFrame:(CGRect)frame fontSize:(float)fontSize :(UIColor*)labelBackColor{
    //UIFont *font = [UIFont systemFontOfSize:fontSize];
    
    UILabel *gettingSizeLabel = [[UILabel alloc] init];
    [gettingSizeLabel setBackgroundColor:labelBackColor];
    gettingSizeLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:50]; // Your Font-style whatever you want to use.
    gettingSizeLabel.text = @"YOUR TEXT HERE";
    gettingSizeLabel.numberOfLines = 0;
    CGSize maximumLabelSize = CGSizeMake(310, 9999); // this width will be as per your requirement
    
    CGSize stringSize = [gettingSizeLabel sizeThatFits:maximumLabelSize];
    
    float textWidth = frame.size.width;
    
    if (textWidth < stringSize.width)
        textWidth = stringSize.width;
    if (textWidth > _pageSize.width)
        textWidth = _pageSize.width - frame.origin.x;
    
    CGRect renderingRect = CGRectMake(frame.origin.x, frame.origin.y, textWidth, stringSize.height);
    
    
    // Create text attributes
    
    NSDictionary *textAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:30.0],NSForegroundColorAttributeName: labelBackColor};
    
    // Create string drawing context
    NSStringDrawingContext *drawingContext = [[NSStringDrawingContext alloc] init];
    drawingContext.minimumScaleFactor = 10.5; // Half the font size
    
    
    [text drawWithRect:renderingRect
               options:NSStringDrawingUsesLineFragmentOrigin
            attributes:textAttributes
               context:drawingContext];
    
    
    frame = CGRectMake(frame.origin.x, frame.origin.y, textWidth, stringSize.height);
    
    return frame;
    
    
}

-   (CGRect)addLineWithFrame:(CGRect)frame withColor:(UIColor*)color {
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(currentContext, color.CGColor);
    
    // this is the thickness of the line
    CGContextSetLineWidth(currentContext, frame.size.height);
    
    CGPoint startPoint = frame.origin;
    CGPoint endPoint = CGPointMake(frame.origin.x + frame.size.width, frame.origin.y);
    
    CGContextBeginPath(currentContext);
    CGContextMoveToPoint(currentContext, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(currentContext, endPoint.x, endPoint.y);
    
    CGContextClosePath(currentContext);
    CGContextDrawPath(currentContext, kCGPathFillStroke);
    
    return frame;
    
}


- (CGRect)addImage:(UIImage*)image atPoint:(CGPoint)point {
    
    CGRect imageFrame = CGRectMake(point.x, point.y, image.size.width, image.size.height);
    [image drawInRect:imageFrame];
    
    return imageFrame;
    
}

- (void)finishPDF {
    UIGraphicsEndPDFContext();
}


#pragma mark- Add Text To PDF
#pragma get logo image from folder
- (UIImage*)loadImage :(NSString*)nameOfImg
{
    
    UIImage* image;
    
    image = [UIImage imageNamed:@"180.png"];
    CGFloat height = 320/3;  // or whatever you need
    CGFloat width = 320/3;
    
    CGSize newSize = CGSizeMake (width, height);
    //CGInterpolationQuality InterpQual = kCGInterpolationHigh;
    UIImage *returnImage=[self imageWithImage:image convertToSize:newSize];
    
    return returnImage;
}

#pragma edit image size
- (UIImage *)imageWithImage:(UIImage* )image convertToSize:(CGSize)size
{
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
    
}
#pragma Company Info
-(CGRect)timageRect
{
    CGRect textRect;
    UIImage *anImage = [self loadImage:@"180.png"];
    [self addImage:anImage atPoint:CGPointMake(_pageSize.width/2 - 30,10)];
    
    //        c38c9ea00ef34cbc29180fbe7c5f310689f630e5
    
    return textRect;
}

#pragma Client Info
-(CGRect)tAllTextRect:(CGRect)rectY
{
    
    [self addLineWithFrame:CGRectMake(50,rectY.origin.y + rectY.size.height + 110, _pageSize.width/2.5,rectY.size.height+ 10 )
                 withColor:[UIColor clearColor]];
 
    CGRect textInvNo = [self addText:[NSString stringWithFormat:@"Home Router Route Receipt"] withFrame:CGRectMake(_pageSize.width/2- 150,  rectY.origin.y + rectY.size.height + 140, 400, 200) fontSize:80.0f :[UIColor blackColor]];
    
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
    NSString *dateString = [NSString stringWithFormat:@"Date    : %@",[dateFormatter stringFromDate:currDate]];
//    NSLog(@"Date=%@",dateString);
    
    [self addText:dateString withFrame:CGRectMake(70, textInvNo.origin.y + textInvNo.size.height + 40, 400, 200) fontSize:70.0f :[UIColor blackColor]];
    
    
    
    
    CGRect textClientOrg = [self addText:tserverObj.tNameOfRoute
                               withFrame:CGRectMake(70,rectY.origin.y + rectY.size.height + 180, 400, 200) fontSize:48.0f :[UIColor blackColor]];
    
    [self addText:tTotalDistanceOfJourney
        withFrame:CGRectMake(70,rectY.origin.y + rectY.size.height + 220, 400, 200) fontSize:48.0f :[UIColor blackColor]];
    
   
    
    [self addText:tExpectedTimeOfJourney  withFrame:CGRectMake(70,rectY.origin.y + rectY.size.height + 258, 400, 200) fontSize:48.0f :[UIColor blackColor]];
    
    
    
    return textClientOrg;
    
}


#pragma AMOUNT INFORMATION

-(void)taddTextAndImage:(CGRect)rectY
{
    [self addLineWithFrame:CGRectMake(50,rectY.origin.y + rectY.size.height + 110, _pageSize.width/2,rectY.size.height+ 10 )
                 withColor:[UIColor clearColor]];
    
}


@end
/// IMPORTANT METHOD

/*
 
 
 //THIS METHOD COMMENTED ON DATE 03-06-15
 
 //- (CLLocationCoordinate2D) geoCodeUsingAddress:(NSString *)address
 //{
 //    NSLog(@"Address=%@",address);
 ////    NSLog(@"Address=%@",address);
 //    double latitude = 0, longitude = 0;
 //    NSString *esc_addr =  [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 //    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
 //    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
 //    if (result) {
 //        NSScanner *scanner = [NSScanner scannerWithString:result];
 //        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
 //            [scanner scanDouble:&latitude];
 //            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
 //                NSLog(@"Lat=%f---Long=%f",latitude,longitude);
 //                [scanner scanDouble:&longitude];
 //                NSLog(@"Lat=%f---Long=%f",latitude,longitude);
 //            }
 //        }
 //    }
 //    CLLocationCoordinate2D center;
 //    center.latitude = latitude;
 //    center.longitude = longitude;
 //
 //    TS_ParaLatAndLong* tpara = [TS_ParaLatAndLong new];
 //
 //    tpara.tlatitude = latitude;
 //    tpara.tlongitude = longitude;
 //
 //    [tLatLongArray addObject:tpara];
 //    NSLog(@"LatLongStartToEnd---\nLat=%f\nLong=%f",tpara.tlatitude,tpara.tlongitude);
 //
 //
 //    return center;
 //}
 //THIS METHOD IS USED FOR SECONDARY OPTION FOR ADDRESS
 //- (void)reverseGeocode:(CLLocation *)location {
 //    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
 //    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
 //        NSLog(@"Finding address");
 //        if (error) {
 //            NSLog(@"Error %@", error.description);
 //        } else {
 //            CLPlacemark *placemark = [placemarks lastObject];
 //            NSString* taddress = [NSString stringWithFormat:@"%@", ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO)];
 //            NSLog(@"Address=%@",taddress);
 //        }
 //    }];
 //}
 
 */


/*
 NSUserDefaults* tdefaultObj = [NSUserDefaults standardUserDefaults];
 
 if(!tisEndRoute)
 {
 if(tserverObj.tIndexOfArray == 0)
 {
 tserverObj.isStopRegionMonitoring = false;
 tserverObj.isNotesOnOff = true;
 tisEndRoute = true;
 //        [self.tBtnBeginRouteReference setTitle:@"Next Route" forState:UIControlStateNormal];
 [self.tBtnBeginRouteReference setBackgroundImage:[UIImage imageNamed:@"EndBtn.png"] forState:UIControlStateNormal];
 self.navigationItem.leftBarButtonItem = nil;
 TS_ParaLatAndLong* tpara = [TS_ParaLatAndLong new];
 
 tpara = [tLatLongArray objectAtIndex:tserverObj.tIndexOfArray];
 NSNumber* tindex = [NSNumber numberWithInt:tserverObj.tIndexOfArray];
 [tdefaultObj setObject:tindex forKey:@"IndexOfArray"];
 [tdefaultObj rm_setCustomObject:tserverObj.taddressArray forKey:@"RouteInfoArray"];
 
 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"RouteCompleted"];
 
 
 
 
 tLatitude = tpara.tlatitude;
 tLongitude = tpara.tlongitude;
 tserverObj.tIndexOfArray++;
 [self g];
 NSLog(@"SourceLatLong=%f-%f\nDestinationLatLong=%f-%f",self.tLocationManager.location.coordinate.latitude,self.tLocationManager.location.coordinate.longitude, tpara.tlatitude,tpara.tlongitude);
 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/maps?saddr=%f,%f&daddr=%f,%f",self.tLocationManager.location.coordinate.latitude,self.tLocationManager.location.coordinate.longitude, tpara.tlatitude,tpara.tlongitude]]];
 
 
 }
 else
 {
 if(tLatLongArray.count > tserverObj.tIndexOfArray)
 {
 tserverObj.isNotesOnOff = true;
 //            [self.tBtnBeginRouteReference setTitle:@"Next Route" forState:UIControlStateNormal];
 [self.tBtnBeginRouteReference setBackgroundImage:[UIImage imageNamed:@"EndBtn.png"] forState:UIControlStateNormal];
 self.navigationItem.leftBarButtonItem = nil;
 [tserverObj.timer invalidate];
 tserverObj.timer = nil;
 [self tInitStartTimer];
 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"RouteCompleted"];
 TS_ParaLatAndLong* tpara = [TS_ParaLatAndLong new];
 
 tpara = [tLatLongArray objectAtIndex:tserverObj.tIndexOfArray - 1];
 double tSourceLat = tpara.tlatitude;
 double tSourceLong = tpara.tlongitude;
 NSNumber* tindex = [NSNumber numberWithInt:tserverObj.tIndexOfArray];
 [tdefaultObj setObject:tindex forKey:@"IndexOfArray"];
 
 TS_ParaLatAndLong* tpara2 = [TS_ParaLatAndLong new];
 tpara2 = [tLatLongArray objectAtIndex:tserverObj.tIndexOfArray];
 double tDestinationLat = tpara2.tlatitude;
 double tDestinationLong = tpara2.tlongitude;
 tserverObj.tIndexOfArray++;
 NSLog(@"SourceLatLong=%f-%f\nDestinationLatLong=%f-%f",tSourceLat,tSourceLong,tDestinationLat,tDestinationLong);
 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/maps?saddr=%f,%f&daddr=%f,%f",tSourceLat,tSourceLong,tDestinationLat,tDestinationLong]]];
 if(tLatLongArray.count == tserverObj.tIndexOfArray)
 {
 
 //            [self.tBtnBeginRouteReference setTitle:@"Begin Route" forState:UIControlStateNormal];
 
 [self.tBtnBeginRouteReference setBackgroundImage:[UIImage imageNamed:@"RouteInfoBtn.png"] forState:UIControlStateNormal];
 
 [tserverObj.timer invalidate];
 tserverObj.timer = nil;
 tActualTimeOfJourney = [NSString stringWithFormat:@"%@",[self timeFormatted:((tserverObj.tisStopTimeOfEachProperty * 60) + (tserverObj.tTimerCount))]];
 UIAlertView* tAlertObj = [[UIAlertView alloc]initWithTitle:@"Routing Information" message:[NSString stringWithFormat:@"Total Distance : %@\nExpected Time : %@\nActual Time : %@",tTotalDistanceOfJourney,tExpectedTimeOfJourney,tActualTimeOfJourney] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
 
 tAlertObj.tag = 222;
 [tAlertObj show];
 
 }
 
 }
 else
 {
 self.navigationItem.leftBarButtonItem = [self tLogicToAddLeftButton];
 [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"RouteCompleted"];
 //            [self.tBtnBeginRouteReference setTitle:@"Begin Route" forState:UIControlStateNormal];
 [self.tBtnBeginRouteReference setBackgroundImage:[UIImage imageNamed:@"RouteInfoBtn.png"] forState:UIControlStateNormal];
 [tserverObj.timer invalidate];
 tserverObj.timer = nil;
 
 
 }
 
 }
 }
 else
 {
 [self.tBtnBeginRouteReference setBackgroundImage:[UIImage imageNamed:@"RouteInfoBtn.png"] forState:UIControlStateNormal];
 
 [tserverObj.timer invalidate];
 tserverObj.timer = nil;
 
 tActualTimeOfJourney = [NSString stringWithFormat:@"%@",[self timeFormatted:((tserverObj.tisStopTimeOfEachProperty * 60) + (tserverObj.tTimerCount))]];
 UIAlertView* tAlertObj = [[UIAlertView alloc]initWithTitle:@"Routing Information" message:[NSString stringWithFormat:@"Total Distance : %@\nExpected Time : %@\nActual Time : %@",tTotalDistanceOfJourney,tExpectedTimeOfJourney,tActualTimeOfJourney] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
 
 tAlertObj.tag = 222;
 [tAlertObj show];
 tserverObj.isStopRegionMonitoring = false;
 
 }

 */

/*
 
 Find ADDRESS
 //-(void)tFindAddressFromCoordinates
 //{
 //
 //
 //
 //
 //    CLLocationCoordinate2D cord;
 //    cord.latitude= tlat;
 //    cord.longitude=tLong;
 //
 //    NSLog(@"Lat=%f--Long=%f",tlat,tLong);
 //
 //    CLLocation* tlocation = [[CLLocation alloc] initWithLatitude:cord.latitude longitude:cord.longitude];
 //
 //    CLGeocoder *ceo = [[CLGeocoder alloc]init];
 //
 //    [ceo reverseGeocodeLocation:tlocation
 //              completionHandler:^(NSArray* placemarks, NSError *error)
 //     {
 //         CLPlacemark *placemark = [placemarks objectAtIndex:0];
 //         NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
 //
 //
 //         tAddressOfCurrent = locatedAt;
 //         NSLog(@"Address=%@",tAddressOfCurrent);
 //     }
 //
 //     ];
 //
 //}
 
 GOOGLE APIS
 
 1.https://maps.googleapis.com/maps/api/directions/json?origin=Toronto&destination=Montreal&avoid=highways&mode=bicycling
 2.https://maps.googleapis.com/maps/api/directions/json?origin=Toronto&destination=Montreal&key=API_KEY
 
 -(void)tPlayAudioFile :(NSString*)tAlertType
 {
 int Number = [tAlertType intValue];
 //
 if(Number == 1)
 {
 
 
 SystemSoundID soundID;
 CFBundleRef mainBundle = CFBundleGetMainBundle();
 CFURLRef ref = CFBundleCopyResourceURL(mainBundle, (CFStringRef)@"A.mp3", NULL, NULL);
 AudioServicesCreateSystemSoundID(ref, &soundID);
 AudioServicesPlaySystemSound(soundID);
 
 }
 else if(Number == 2)
 {
 SystemSoundID soundID;
 CFBundleRef mainBundle = CFBundleGetMainBundle();
 CFURLRef ref = CFBundleCopyResourceURL(mainBundle, (CFStringRef)@"alert.wav", NULL, NULL);
 AudioServicesCreateSystemSoundID(ref, &soundID);
 AudioServicesPlaySystemSound(soundID);
 }
 
 
 }

 COUNT DOWN TIMER
 //    NSString *dateString = @"14-12-2012";
 //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
 //
 //    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
 //    NSDate *dateFromString = [[NSDate alloc] init];
 //    // voila!
 //    dateFromString = [dateFormatter dateFromString:dateString];
 //
 //
 //    NSDate *now = [NSDate date];
 //    NSCalendar *calendar = [NSCalendar currentCalendar];
 //
 //
 //
 //    NSDateComponents *componentsHours = [calendar components:NSCalendarUnitHour fromDate:now];
 //    NSDateComponents *componentMint = [calendar components:NSCalendarUnitMinute fromDate:now];
 //    NSDateComponents *componentSec = [calendar components:NSCalendarUnitSecond fromDate:now];
 //
 //
 //
 //
 //    NSCalendar *calendar2 = [[NSCalendar alloc] initWithCalendarIdentifier:GregorianCalendar];
 //    NSDateComponents *componentsDaysDiff = [GregorianCalendar components:NSDayCalendarUnit
 //                                                                fromDate:now
 //                                                                  toDate:dateFromString
 //                                                                 options:0];
 //
 //
 //
 //    lblDaysSetting.text=[NSString stringWithFormat:@"%02d",componentsDaysDiff.day];
 //    lblHouresSetting.text=[NSString stringWithFormat:@"%02d",(24-componentsHours.hour)];
 //    lblMinitSetting.text=[NSString stringWithFormat:@"%02d",(60-componentMint.minute)];
 //    lblSecSetting.text=[NSString stringWithFormat:@"%02d",(60-componentSec.second)];
 */

/*
 Important Method of Begin Route
 - (IBAction)tBtnBeginRoute:(id)sender
 {
 NSString* locationToShow = @"Nagpur";
 //     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps?q=%@", locationToShow]]];
 
 TS_ParaLatAndLong* tpara = [TS_ParaLatAndLong new];
 tpara = [tLatLongArray objectAtIndex:0];
 
 
 //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps?q=\"%f,%f\"", tpara.tlatitude,tpara.tlongitude]]];
 
 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/maps?saddr=%f,%f&daddr=%f,%f",self.tLocationManager.location.coordinate.latitude,self.tLocationManager.location.coordinate.longitude, tpara.tlatitude,tpara.tlongitude]]];
 
 //    UIApplication *app = [UIApplication sharedApplication];
 //    [app openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/?q=%@",locationToShow]]];
 
 if(!tserverObj.isTimerStartOrStop)
 {
 tserverObj.isNotesOnOff = false;
 tserverObj.isNotesOnOff = true;
 tserverObj.isTimerStartOrStop = true;
 self.navigationItem.leftBarButtonItem = nil;
 [self.tBtnBeginRouteReference setTitle:@"Stop Routing" forState:UIControlStateNormal];
 [self tInitStartTimer];
 //    tBtnBeginRouteReference.userInteractionEnabled = NO;
 }
 else
 {
 [self.tBtnBeginRouteReference setTitle:@"Begin Route" forState:UIControlStateNormal];
 [tserverObj.timer invalidate];
 tserverObj.timer = nil;
 tserverObj.isTimerStartOrStop = false;
 self.navigationItem.leftBarButtonItem = [self tLogicToAddLeftButton];
 }
 
 
 
 
 }
*/