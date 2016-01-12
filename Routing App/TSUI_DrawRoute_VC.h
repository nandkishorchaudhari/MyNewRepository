//
//  TSUI_DrawRoute_VC.h
//  Routing App
//
//  Created by TacktileSystemsMac4 on 07/05/15.
//  Copyright (c) 2015 Tacktile Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreText/CoreText.h>
#import <CoreGraphics/CoreGraphics.h>
#import <MapKit/MapKit.h>
#import "TS_Annotation.h"
#import <AddressBookUI/AddressBookUI.h>
#import "SWRevealViewController.h"
#import <MessageUI/MessageUI.h>
#import "TS_DBLayer.h"
#import "SKPSMTPMessage.h"
#import "NSData+Base64Additions.h"

@interface TSUI_DrawRoute_VC : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate,UIAlertViewDelegate,MFMailComposeViewControllerDelegate,SKPSMTPMessageDelegate>

@property (weak, nonatomic) IBOutlet UILabel *tTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *tBtnBeginRouteReference;
@property (weak, nonatomic) IBOutlet UILabel *tLabelOfJourneyTimer;

@property (weak, nonatomic) IBOutlet UITextView *tTextViewReference;
@property (weak, nonatomic) IBOutlet UITextView *tTextViewOfButtons;

- (IBAction)tBtnBeginRoute:(id)sender;

@property(nonatomic, retain)NSMutableArray* taddressArray;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic,retain) MKPolyline *iRouteLine;
@property (strong, nonatomic) CLLocation *location;
@property (retain,nonatomic) CLLocationManager *tLocationManager;

- (IBAction)tBtnActionOfCancelRoute:(id)sender;

@end
