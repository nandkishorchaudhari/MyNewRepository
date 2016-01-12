//
//  TS_HomeRouter_VC.h
//  Routing App
//
//  Created by TacktileSystemsMac4 on 29/05/15.
//  Copyright (c) 2015 Tacktile Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import <CoreGraphics/CoreGraphics.h>
#import "RoutingApp.pch"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"




@interface TS_HomeRouter_VC : UIViewController<UIGestureRecognizerDelegate,UIAlertViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *tMenuBtn;
@property (strong, nonatomic) IBOutlet UITableView *tTableView1;

@property(strong, nonatomic)UITableView* tTableView2;

@property(nonatomic, retain)CLGeocoder *geocoder;
@property(nonatomic, retain)CLPlacemark* placemarks;
@property (weak, nonatomic) IBOutlet UIButton *tRefOfBeginRoute;
@property (weak, nonatomic) IBOutlet UIButton *tRefOfSavedRoute;
@property (weak, nonatomic) IBOutlet UIButton *tRefOfDeleteRoute;


- (IBAction)tBeginRouteAction:(id)sender;
- (IBAction)tSavedRouteAction:(id)sender;

- (IBAction)tDeleteRouteAction:(id)sender;

@end
