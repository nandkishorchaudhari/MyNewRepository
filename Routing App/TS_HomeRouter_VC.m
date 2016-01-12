//
//  TS_HomeRouter_VC.m
//  Routing App
//
//  Created by TacktileSystemsMac4 on 29/05/15.
//  Copyright (c) 2015 Tacktile Systems. All rights reserved.
//  Zip File Date : 02-06-15

#import "TS_HomeRouter_VC.h"
#import "SWRevealViewController.h"
#import "TS_ServerClass.h"
#import "AMTumblrHud.h"
#import "TS_DBLayer.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "NSUserDefaults+RMSaveCustomObject.h"

#define TABLEWIDTH2 self.tTableView1.bounds.size.width


@interface TS_HomeRouter_VC ()
{
    NSMutableArray* tAddressArray;
    NSArray* tcolorArray;
    UITextField* tTextFieldOfAddress;
    UITextField* tTextFieldOfNotes;
    UITextField* tTextFieldOfRouteName;
    UIButton* tBeginRoute;
    TS_ServerClass* tserverObj;
    int tCount;
    BOOL tisCheckOrBox;
    BOOL moved;
    BOOL isAddressList;
    int tFirstProperty;
    NSString* tFulladdress;
    UIAlertView* talertObj2;
    UIPickerView *tsetAddressPickerView;
    NSArray* tShowAddressInPickerVIewArray;
    UIBarButtonItem *customBarItem;
    int tarrayOfIndex;
    BOOL tisEditRoute;
    UITableView* tableViewWordHelp;
    int tdeleteSelectedAddress;
    NSArray* tLatituedArray;
    NSArray* tLongitudeArray;
    double tLat1;
    double tLong1;
    
  
    
}
@property(nonatomic, retain)AMTumblrHud * activityIndicator;
@end

@implementation TS_HomeRouter_VC


- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.tTableView1.delegate = self;
    self.tTableView1.dataSource =self;
    
    self.tTableView2.delegate = self;
    self.tTableView2.dataSource = self;
    
    
    UIImageView* timage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"BgImage.png"]];
    [self.tTableView1 setBackgroundView:timage];
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.bounds.size.width, 22)];
    TS_ServerClass * tserObj = [TS_ServerClass tsharedInstance];
    if(tserverObj.isReceipt == 0)
    {
        tserverObj.isReceipt++;
        tserverObj.isReceiptOnOff = true;
        
    }
    statusBarView.backgroundColor = [tserObj colorWithHexString:@"39aad6"];
    
    [self.navigationController.navigationBar addSubview:statusBarView];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;//UIStatusBarStyleLightContent;
    // Do any additional setup after loading the view.
    //SET TARGET AND ACTION OF MENU BUTTON
    self.tMenuBtn.target = self.revealViewController;
    self.tMenuBtn.action = @selector(revealToggle:);
    //ADD THE PAN GESTURE, SO THAT MENU GETS OPEN WHEN WE PAN ON THE SCREEN
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BgImage.png"]];
    bgImageView.frame = self.view.bounds;
    [self.view addSubview:bgImageView];
    [self.view sendSubviewToBack:bgImageView];
    
    [NSNotificationCenter defaultCenter];
    NSNotification* notification = [NSNotification notificationWithName:@"ReloadTableView" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (tReloadView:) name:@"ReloadTableView" object:nil];
    tFirstProperty = 1;

    
    
    self.title = @"Home Router";

    tAddressArray = [NSMutableArray new];
    tserverObj.tAddressArrayCopy = [NSMutableArray new];
    tserverObj = [TS_ServerClass tsharedInstance];
    tcolorArray = [[NSArray alloc]initWithObjects:@"8cdfff",@"5bcffc",@"45bfef",@"39aad6", nil];
    self.navigationItem.rightBarButtonItem =[self tlogicOfRightBarButton];
 
    if(tserverObj.tisRefreshHomeRouterView)
    {
        tserverObj.tisRefreshHomeRouterView = false;
        tisEditRoute = false;
        [self tResetTableView];
    }
    
    self.activityIndicator.hidden = YES;
 
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"RouteCompleted"])
    {
        self.title = @"";
        
        NSUserDefaults* tdefaultObj = [NSUserDefaults standardUserDefaults];
        tAddressArray = [NSMutableArray new];
        tAddressArray = [tdefaultObj rm_customObjectForKey:@"RouteInfoArray"];
        tserverObj.tNameOfRoute = [tdefaultObj valueForKey:@"RouteName"];
        
        [self performSegueWithIdentifier:@"segueDrawRoute" sender:self];
    }
   
    self.tRefOfBeginRoute.layer.cornerRadius = 3.0f;
    self.tRefOfDeleteRoute.layer.cornerRadius = 3.0f;
    self.tRefOfSavedRoute.layer.cornerRadius = 3.0f;
    [self tInitDataOfLongPressGestureRecognizer];
    
//    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"10D39AE7-020E-4467-9CB2-DD36366F899D"];
//    
//    //        CLBeaconRegion *region2 = [CLBeaconRegion initWithProximityUUID:uuid
//    //                                                            identifier:@"unique region identifier"];
//    
//    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc]
//                                    initWithProximityUUID:uuid
//                                     identifier:@"unique region"];
//    NSLog(@"UUID=%@\nBeacon=%@",uuid,beaconRegion.proximityUUID);
    

}

//- (BOOL) isWiFiEnabled {
//    
//    NSCountedSet * cset = [NSCountedSet new];
//    
//    struct ifaddrs *interfaces;
//    
//    if( ! getifaddrs(&interfaces) ) {
//        for( struct ifaddrs *interface = interfaces; interface; interface = interface->ifa_next) {
//            if ( (interface->ifa_flags & IFF_UP) == IFF_UP ) {
//                [cset addObject:[NSString stringWithUTF8String:interface->ifa_name]];
//            }
//        }
//    }
//    
//    return [cset countForObject:@"awdl0"] > 1 ? YES : NO;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    if(tserverObj.isTitle)
    {
    self.title = @"Home Router";
    }
    
    tisEditRoute = tserverObj.tisEditRouteOrNot;
    [self tInitAddressData];
//    tserverObj.tisEditRouteBeforeJourney = false;
    if(tserverObj.tisEditRouteBeforeJourney)
    {
        self.navigationItem.rightBarButtonItem =[self tlogicOfBackButton];
        [self.tMenuBtn setEnabled:NO];
        [_tRefOfBeginRoute setHidden:YES];
        [_tRefOfSavedRoute setHidden:YES];
        [_tRefOfDeleteRoute setHidden:YES];
        
        [self.tTableView1 reloadData];
    }
    else
    {
        self.navigationItem.rightBarButtonItem =[self tlogicOfRightBarButton];
        //SET TARGET AND ACTION OF MENU BUTTON
        [self.tMenuBtn setEnabled:YES];
        [_tRefOfBeginRoute setHidden:NO];
        [_tRefOfSavedRoute setHidden:NO];
        [_tRefOfDeleteRoute setHidden:NO];
        [self.tTableView1 reloadData];
    }
    
  
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
//    NetworkStatus status = [reachability w];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    
    self.activityIndicator.hidden = YES;
    if(!tserverObj.tisEditRouteBeforeJourney)
    {
    tserverObj.tIsExactProperty=0;
    }
    
}

#pragma mark-INITDATA



-(void)tInitDataOfLongPressGestureRecognizer
{
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0; //seconds
    lpgr.delegate = self;
    [self.tTableView1 addGestureRecognizer:lpgr];
}


-(void)tReloadView :(NSNotification *) notification
{
    tTextFieldOfRouteName.text = @"";
    tserverObj.tFirstTime = 0;
    tAddressArray = [NSMutableArray new];
    tserverObj.tAddressArrayCopy = [NSMutableArray new];
    [self.tTableView1 reloadData];
}
-(void)tInitAddressData
{
    if(tserverObj.isSaveRoutes)
    {
        TS_DBLayer* tdb = [TS_DBLayer new];
        
        NSLog(@"NameOfRoute=%@\nName=%@",tTextFieldOfRouteName.text,tserverObj.tNameOfRoute);
        NSLog(@"RouteId=%d",tserverObj.tSelectedRoute);
        NSMutableArray* tarry = [tdb tRerieveRoutesData:tserverObj.tSelectedRoute];
        if(tarry.count > 0)
        {
        tAddressArray = [tdb tRerieveRoutesData:tserverObj.tSelectedRoute];
        }
        TS_ParaAddress* tpara = [TS_ParaAddress new];
        if(tAddressArray.count > 0)
        {
        tpara = [tAddressArray objectAtIndex:0];
            NSLog(@"tLatitued=%f---Long=%f",tpara.tLatitude,tpara.tLongitude);
        }
        else
        {
        
//            tAddressArray = [tdb tRerieveRoutesData:[tdb treturnMaxId]];
        }
        NSLog(@"count=%ld\nIdentifier=%@",(unsigned long)tAddressArray.count,tpara.tidentifireName);
        [self.tTableView1 reloadData];
    }

   

}

-(void)tInitTextFieldData
{
    tTextFieldOfAddress.delegate = self;
    tTextFieldOfNotes.delegate = self;
    tTextFieldOfRouteName.delegate = self;
    tTextFieldOfRouteName.tag = 1;
    tTextFieldOfAddress.tag = 2;
    tTextFieldOfNotes.tag = 3;
    
    tTextFieldOfRouteName.returnKeyType = UIReturnKeyNext;
    tTextFieldOfAddress.returnKeyType = UIReturnKeyNext;
    tTextFieldOfNotes.returnKeyType = UIReturnKeyDone;
    
    tTextFieldOfRouteName.autocapitalizationType = UITextAutocorrectionTypeNo;
    tTextFieldOfAddress.autocorrectionType = UITextAutocorrectionTypeNo;
    tTextFieldOfNotes.autocorrectionType = UITextAutocorrectionTypeNo;
    tTextFieldOfRouteName.autocorrectionType = UITextAutocorrectionTypeNo;
    tTextFieldOfRouteName.inputAccessoryView = [self getToolbar:1];
    tTextFieldOfAddress.inputAccessoryView = [self getToolbar:2];
    tTextFieldOfNotes.inputAccessoryView = [self getToolbar:3];
    
}


#pragma mark -TABLE VIEW DELEGATES

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if(tableView.tag == 1)
    {
        return 2;
    }
    else if(tableView.tag == 700)
    {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag == 1)
    {
        if(section == 0)
        {
            
            return tAddressArray.count;
        }
        else if(section == 1)
        {
            
            
            return 0;
        }
        else
        {
            return 0;
        }
    }
    else if(tableView.tag == 700)
    {
        return tShowAddressInPickerVIewArray.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView.tag == 1)
    {
        if(tserverObj.tisRefreshView)
        {
        if(section == 0)
        {
            return 60;
        }
        else if(section == 1)
        {
            if(isAddressList)
            {
                return 50;
            }
            else
            {
                return 240;
            }
        }
        else if(section == 2)
        {
            return 60;
        }
    }
        else
        {
            if(section == 0)
            {
                return 60;
            }
            else if(section == 1)
            {
                if(isAddressList)
                {
                    return 50;
                }
                else
                {
                    return 240;
                }
            }
            else if(section == 2)
            {
                return 60;
            }

        }
        
    }
    
    else if(tableView.tag == 700)
    {
        return 0;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    if(tableView.tag == 1)
    {
    
    
    static NSString *cellIdentifier = @"cellIdentifier";
        
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UILabel* tLabelOfAddress;
    UILabel* tLabelAddressList;
    UIImageView* tArrowsImageView;
    
    
    if(!cell)
    {
        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        tLabelOfAddress = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.tTableView1.bounds.size.width - 60,44)];
        tLabelOfAddress.tag = 100;
        tLabelOfAddress.textAlignment = NSTextAlignmentLeft;
        [tLabelOfAddress setLineBreakMode:NSLineBreakByWordWrapping];
        [tLabelOfAddress setNumberOfLines:0];
        tLabelOfAddress.textColor = [tserverObj colorWithHexString:@"052430"];
        
        [cell.contentView addSubview:tLabelOfAddress];
        
        tArrowsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.tTableView1.bounds.size.width - 50, 12,20,20)];
        tArrowsImageView.image = [UIImage imageNamed:@"Arrow.png"];
        tArrowsImageView.tag = 101;
        [cell.contentView addSubview:tArrowsImageView];
        
        tLabelAddressList = [[UILabel alloc]initWithFrame:CGRectMake(50,0, self.tTableView1.bounds.size.width -70, 44)];
        tLabelAddressList.tag = 102;
        tLabelAddressList.textAlignment = NSTextAlignmentLeft;
        [tLabelAddressList setLineBreakMode:NSLineBreakByWordWrapping];
        [tLabelAddressList setNumberOfLines:0];
        
        [cell.contentView addSubview:tLabelAddressList];
        
        
        
        
    }
    else
    {
        tLabelOfAddress = (UILabel*)[cell.contentView viewWithTag:100];
        tArrowsImageView = (UIImageView*)[cell.contentView viewWithTag:101];
        tLabelAddressList = (UILabel*)[cell.contentView viewWithTag:102];
        
        
    }
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(self.tTableView1.tag == 1)
    {
        if(indexPath.section == 0)
        {
//            tArrowsImageView.hidden = NO;
//            tAddressImage.hidden = YES;
            tLabelAddressList.hidden = YES;
            tLabelOfAddress.hidden = NO;
            TS_ParaAddress* tpara = [TS_ParaAddress new];
            NSSortDescriptor *boolDescr = [[NSSortDescriptor alloc] initWithKey:@"tFirstProperty" ascending:NO selector:nil];
            
            // Combine the two
            NSArray *sortDescriptors = @[boolDescr];
            // Sort your array
            tAddressArray=  [NSMutableArray arrayWithArray: [tAddressArray sortedArrayUsingDescriptors:sortDescriptors]] ;
            tpara = [tAddressArray objectAtIndex:indexPath.row];
            
            tLabelOfAddress.text = tpara.taddress;
            tLabelOfAddress.font = [UIFont systemFontOfSize:14.0f];
            if(!tserverObj.tisEditRouteBeforeJourney)
            {
            cell.backgroundColor = [tserverObj colorWithHexString:[tcolorArray objectAtIndex:indexPath.row%4]];
            }
            else
            {
                if(indexPath.row < tserverObj.tIsExactProperty)
                {
                    cell.backgroundColor = [UIColor redColor];
                }
                else
                {
                cell.backgroundColor = [tserverObj colorWithHexString:[tcolorArray objectAtIndex:indexPath.row %4]];
                }
            }
            
            
        }
        else if(indexPath.section == 1)
        {
            
//            tAddressImage.hidden = NO;
            tArrowsImageView.hidden = YES;
            tLabelOfAddress.hidden = YES;
            tLabelAddressList.hidden = NO;
            tLabelAddressList.text = [tShowAddressInPickerVIewArray objectAtIndex:indexPath.row];
            tLabelAddressList.backgroundColor = [tserverObj colorWithHexString:@"c6efff"];
            cell.backgroundColor = [tserverObj colorWithHexString:@"ffffff"];
        }
    }
   
    }
    
    else
    {
        static NSString *cellIdentifier = @"cellIdentifier2";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        UILabel* tLabelOfAddress2;
        UIImageView* tAddressImage;
        if(!cell)
        {
            cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            tLabelOfAddress2 = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, self.tTableView1.bounds.size.width - 60,44)];
            tLabelOfAddress2.tag = 963;
            tLabelOfAddress2.textAlignment = NSTextAlignmentLeft;
            [tLabelOfAddress2 setLineBreakMode:NSLineBreakByWordWrapping];
            [tLabelOfAddress2 setNumberOfLines:0];
            tLabelOfAddress2.textColor = [tserverObj colorWithHexString:@"052430"];
            tLabelOfAddress2.font = [UIFont systemFontOfSize:12.0];
            [cell.contentView addSubview:tLabelOfAddress2];
            
            tAddressImage = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,30,44)];
            tAddressImage.tag = 104;
            tAddressImage.image = [UIImage imageNamed:@"AddressPin.png"];
            [tAddressImage setBackgroundColor:[tserverObj colorWithHexString:@"c6efff"]];
            
            [cell.contentView addSubview:tAddressImage];
            
        }
        else
        {
            tLabelOfAddress2 = (UILabel*)[cell.contentView viewWithTag:963];
            tAddressImage =(UIImageView*)[cell.contentView viewWithTag:104];
        }
        
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0,43,tableViewWordHelp.bounds.size.width,1)];
        lineView1.backgroundColor = [tserverObj colorWithHexString:@"636363"];
        [cell.contentView addSubview:lineView1];
        
        @try {
            tLabelOfAddress2.text = [tShowAddressInPickerVIewArray objectAtIndex:indexPath.row];
        }
        @catch (NSException *exception)
        {
            NSLog(@"Exception in Cell=%@",exception);
        }
        @finally {
            
        }
        
        tLabelOfAddress2.backgroundColor = [tserverObj colorWithHexString:@"c6efff"];
        cell.backgroundColor = [tserverObj colorWithHexString:@"ffffff"];
        NSLog(@"SecondTVC");
    }
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *tHeaderViewSection=[[UIView alloc]initWithFrame:CGRectMake(10,5,tableView.layer.bounds.size.width, 60)];
    if(tableView.tag == 1)
    {
    
    //    UIButton* tBtnRouteButton;
    UIButton* tBtnAddRoute;
    
    UILabel* tTextLabel;
//    UIImageView* timageView;
    
    UIButton* tShowRoutList;
    //    UIButton *tAddressBtn;
    
    
    UIButton* tBtncheckBox;
    
    
    if(section == 0)
    {
//        timageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,self.tTableView1.bounds.size.width, 60)];
        
        if(!tTextFieldOfRouteName)
        {
            if(tserverObj.tisEditRouteBeforeJourney)
            {
                tTextFieldOfRouteName = [[UITextField alloc]initWithFrame:CGRectMake(20,7, self.tTableView1.bounds.size.width - 80  , 44 )];
            }
            else
            {
                tTextFieldOfRouteName = [[UITextField alloc]initWithFrame:CGRectMake(20,7, self.tTableView1.bounds.size.width - 80 , 44 )];
            }
            
        }
        else
        {
            if(tserverObj.tisEditRouteBeforeJourney)
            {
             tTextFieldOfRouteName = [[UITextField alloc]initWithFrame:CGRectMake(20,7, self.tTableView1.bounds.size.width - 40  , 44 )];
            }
            else
            {
                tTextFieldOfRouteName = [[UITextField alloc]initWithFrame:CGRectMake(20,7, self.tTableView1.bounds.size.width - 80  , 44 )];
                NSLog(@"ServerRoutname=%@",tserverObj.tNameOfRoute);
                tTextFieldOfRouteName.text = tserverObj.tNameOfRoute;
            }
        }
        
        if(tserverObj.tisEditRouteBeforeJourney)
        {
        
        tShowRoutList = [[UIButton alloc]initWithFrame:CGRectMake(self.tTableView1.bounds.size.width - 65, 7, 0, 0)];
            tTextFieldOfRouteName.text = tserverObj.tNameOfRoute;
        }
        else
        {
            
            tShowRoutList = [[UIButton alloc]initWithFrame:CGRectMake(self.tTableView1.bounds.size.width - 65, 7, 40, 44)];
        }
//        timageView.image = [UIImage imageNamed:@"BgImage.png"];
        //        [tShowRoutList setBackgroundImage:[UIImage imageNamed:@"SavedRoutesIcon.png"] forState:UIControlStateNormal];
//        if(!tserverObj.tisEditRouteBeforeJourney)
//        {
        [tShowRoutList setImage:[UIImage imageNamed:@"SavedRoutesIcon.png"] forState:UIControlStateNormal];
        [tShowRoutList addTarget:self action:@selector(tShowListOfSavedRoutes) forControlEvents:UIControlEventTouchUpInside];
//        }
        tShowRoutList.layer.cornerRadius = 3.0f;
        [tShowRoutList setBackgroundColor:[tserverObj colorWithHexString:@"39aad6"]];
        
        tTextFieldOfRouteName.backgroundColor = [tserverObj colorWithHexString:@"39aad6"];
        
        tTextFieldOfRouteName.textColor = [tserverObj colorWithHexString:@"ffffff"];
        tTextFieldOfRouteName.placeholder = @"Enter route name";
        tTextFieldOfRouteName.textAlignment = NSTextAlignmentCenter;
        tTextFieldOfRouteName.layer.cornerRadius = 3.0f;
        tTextFieldOfRouteName.tag = 1;
        if(tserverObj.isSaveRoutes)
        {
            tTextFieldOfRouteName.text = tserverObj.tNameOfRoute;
            NSLog(@"RouteName=%@",tserverObj.tNameOfRoute);
            tTextFieldOfRouteName.userInteractionEnabled = NO;
        }
        else
        {
            
            tTextFieldOfRouteName.userInteractionEnabled = YES;
        }

        tHeaderViewSection.backgroundColor = [UIColor clearColor];

        [tHeaderViewSection addSubview:tShowRoutList];
        [tHeaderViewSection addSubview:tTextFieldOfRouteName];

    }
    else if(section == 1)
    {
        if(!tTextFieldOfAddress)
        {
            tTextFieldOfAddress = [[UITextField alloc]initWithFrame:CGRectMake(20, 5, self.tTableView1.bounds.size.width - 40, 44)];
            
        }
        
        tTextFieldOfAddress.backgroundColor = [UIColor lightGrayColor];
        tTextFieldOfAddress.placeholder = @"Enter address here....";
        [tTextFieldOfAddress setValue:[tserverObj colorWithHexString:@"636363"]
                           forKeyPath:@"_placeholderLabel.textColor"];
        tTextFieldOfAddress.tag = 2;
        tTextFieldOfAddress.keyboardType = UIKeyboardTypeASCIICapable;
        
        tTextFieldOfAddress.layer.borderWidth = 0.5f;
        tTextFieldOfAddress.layer.borderColor = [tserverObj colorWithHexString:@"8c8c8c"].CGColor;
        if(!tTextFieldOfNotes)
        {
            tTextFieldOfNotes = [[UITextField alloc]initWithFrame:CGRectMake(20,55,self.tTableView1.bounds.size.width - 40, 88)];
        }
        tTextFieldOfAddress.backgroundColor = [tserverObj colorWithHexString:@"ffffff"];
        tTextFieldOfAddress.delegate = self;
        tTextFieldOfNotes.backgroundColor = [UIColor lightGrayColor];
        tTextFieldOfNotes.placeholder = @"your note goes here....";
        [tTextFieldOfNotes setValue:[tserverObj colorWithHexString:@"636363"]
                           forKeyPath:@"_placeholderLabel.textColor"];
    
        tTextFieldOfNotes.layer.borderWidth = 0.5f;
        tTextFieldOfNotes.layer.borderColor = [tserverObj colorWithHexString:@"8c8c8c"].CGColor;
        tTextFieldOfNotes.backgroundColor = [tserverObj colorWithHexString:@"ffffff"];
        tTextFieldOfNotes.tag = 3;
        
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
        tTextFieldOfAddress.leftView = paddingView;
        tTextFieldOfAddress.leftViewMode = UITextFieldViewModeAlways;
        UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0,0, 5,20)];
        tTextFieldOfNotes.leftView = paddingView2;
        tTextFieldOfNotes.leftViewMode = UITextFieldViewModeAlways;
        
        tTextFieldOfAddress.layer.cornerRadius = 5.0f;
        tTextFieldOfNotes.layer.cornerRadius = 5.0f;
        [self tInitTextFieldData];
 
        
        
        tBtnAddRoute = [[UIButton alloc]initWithFrame:CGRectMake(TABLEWIDTH2 / 2 - (self.tTableView1.bounds.size.width/2)/2, 185,self.tTableView1.bounds.size.width/2,44)];
        tBtnAddRoute.backgroundColor = [tserverObj colorWithHexString:@"39aad6"];
        if(!tisEditRoute)
        {
        [tBtnAddRoute setTitle:@"Add to Route" forState:UIControlStateNormal];
        }
        else
        {
             [tBtnAddRoute setTitle:@"Edit Route" forState:UIControlStateNormal];
        }
        [tBtnAddRoute addTarget:self action:@selector(tAddrouteAddress :) forControlEvents:UIControlEventTouchUpInside];
        //       UIColor blackColor
        tBtnAddRoute.layer.cornerRadius = 3.0f;
        
        tBtncheckBox = [[UIButton alloc]initWithFrame:CGRectMake(20, 150, 20, 20)];
        [tBtncheckBox addTarget:self action:@selector(tBtnActionOfCheckBox) forControlEvents:UIControlEventTouchUpInside];
        
        if(!tisCheckOrBox)
        {
            [tBtncheckBox setBackgroundImage:[UIImage imageNamed:@"box@3x.png"] forState:UIControlStateNormal];
        }
        else
        {
            [tBtncheckBox setBackgroundImage:[UIImage imageNamed:@"checkbox@3x.png"] forState:UIControlStateNormal];
        }
        
        tTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(45,145,TABLEWIDTH2 / 2,30)];
        tTextLabel.font = [UIFont systemFontOfSize:12.0f];
        tTextLabel.text = @"Select as first property";
        tTextLabel.textColor = [tserverObj colorWithHexString:@"636363"];
        
        
        
        
        if(!isAddressList)
        {
            
            [tHeaderViewSection addSubview:tBtncheckBox];
            [tHeaderViewSection addSubview:tTextFieldOfNotes];
            [tHeaderViewSection addSubview:tTextLabel];
            [tHeaderViewSection addSubview:tBtnAddRoute];
        }
        
        //        [tHeaderViewSection addSubview:tAddressBtn];
        tHeaderViewSection.backgroundColor = [UIColor whiteColor];
        [tHeaderViewSection addSubview:tTextFieldOfAddress];
        
        
        
        
    }
    
  /*  else if(section == 2)
    {
        tBeginRoute = [[UIButton alloc]initWithFrame:CGRectMake(5,10,(TABLEWIDTH2/3)-7,44)];
        [tBeginRoute addTarget:self action:@selector(tBeginRoute) forControlEvents:UIControlEventTouchUpInside];
        //        [tBeginRoute setTitle:@"Route Info" forState:UIControlStateNormal];
        tBeginRoute.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        //        [tBeginRoute setBackgroundColor:[tserverObj colorWithHexString:@"636363"]];
        //        tBeginRoute.backgroundColor = [UIColor lightGrayColor];
        tBeginRoute.layer.cornerRadius = 5.0f;
        [tBeginRoute setBackgroundImage:[UIImage imageNamed:@"RouteInfoBtn.png"] forState:UIControlStateNormal];
        
        tsaveRoute = [[UIButton alloc]initWithFrame:CGRectMake(((TABLEWIDTH2/3)-7)+12,10,(TABLEWIDTH2/3)-7,44)];
        [tsaveRoute addTarget:self action:@selector(tSaveRoute) forControlEvents:UIControlEventTouchUpInside];
        //        [tsaveRoute setTitle:@"Save Route" forState:UIControlStateNormal];
        //        [tsaveRoute setBackgroundColor:[tserverObj colorWithHexString:@"636363"]];
        tsaveRoute.layer.cornerRadius = 5.0f;
        [tsaveRoute setBackgroundImage:[UIImage imageNamed:@"SaveRouteBtn.png"] forState:UIControlStateNormal];
        //        [tsaveRoute setImage:[UIImage imageNamed:@"SaveRouteBtn.png"] forState:UIControlStateNormal];
        tsaveRoute.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        
        tdeletRoute = [[UIButton alloc]initWithFrame:CGRectMake((((TABLEWIDTH2/3)-7)*2)+18 ,10,(TABLEWIDTH2/3)-7,44)];
        tdeletRoute.layer.cornerRadius = 5.0f;
        [tdeletRoute addTarget:self action:@selector(tDeleteRoute) forControlEvents:UIControlEventTouchUpInside];
        //        [tdeletRoute setTitle:@"Delete Route" forState:UIControlStateNormal];
        //        [tdeletRoute setBackgroundColor:[tserverObj colorWithHexString:@"636363"]];
        //        [UIColor greenColor]
        tdeletRoute.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [tdeletRoute setBackgroundImage:[UIImage imageNamed:@"DeleteRouteBtn.png"] forState:UIControlStateNormal];
        
        [tHeaderViewSection addSubview:tdeletRoute];
        [tHeaderViewSection addSubview:tsaveRoute];
        [tHeaderViewSection addSubview:tBeginRoute];
    }*/
    
//    tHeaderViewSection.backgroundColor = [UIColor whiteColor];
    }
    return tHeaderViewSection;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if(tableView.tag == 1)
    {
     if (indexPath.section == 0)
    {
        if(!tserverObj.tisEditRouteBeforeJourney)
        {
        tisEditRoute = true;
        tarrayOfIndex = (int)indexPath.row;
        TS_ParaAddress* tpara = [TS_ParaAddress new];
         tpara = [tAddressArray objectAtIndex:indexPath.row];
        tTextFieldOfAddress.text = tpara.taddress;
        tTextFieldOfNotes.text = tpara.tnotes;
        NSLog(@"Text=%@",tTextFieldOfAddress.text);
        [self.tTableView1 reloadData];
        }
        else
        {
            if(indexPath.row > tserverObj.tIsExactProperty-1)
            {
                tisEditRoute = true;
                tarrayOfIndex = (int)indexPath.row;
                TS_ParaAddress* tpara = [TS_ParaAddress new];
                tpara = [tAddressArray objectAtIndex:indexPath.row];
                tTextFieldOfAddress.text = tpara.taddress;
                tTextFieldOfNotes.text = tpara.tnotes;
                NSLog(@"Text=%@",tTextFieldOfAddress.text);
                [self.tTableView1 reloadData];
            }
            else
            {
                UIAlertView* talertobj = [[UIAlertView alloc]initWithTitle:@"You are completed this property." message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                talertobj.tag = 471;
                [talertobj show];
            }
        }
    }
    }
    else
    {
        if(isAddressList)
        {
            
            isAddressList = FALSE;
           
            @try
            {
                tTextFieldOfAddress.text = [tShowAddressInPickerVIewArray objectAtIndex:indexPath.row];
                NSLog(@"SelectedLat=%@\nLong=%@",[tLatituedArray objectAtIndex:indexPath.row],[tLongitudeArray objectAtIndex:indexPath.row]);
                NSString* tlat = [tLatituedArray objectAtIndex:indexPath.row];
                NSString* tlong = [tLongitudeArray objectAtIndex:indexPath.row];
                tLat1 = [tlat doubleValue];
                tLong1 = [tlong doubleValue];
            }
            @catch (NSException *exception)
            {
                NSLog(@"ExceptionInDidSelect=%@",exception);
            }
            @finally
            {
                
            }
            
        }
        [tableViewWordHelp removeFromSuperview];
        tableViewWordHelp = nil;
    }
    
    
}


#pragma mark-ACTION
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:self.tTableView1];
    
    NSIndexPath *indexPath = [self.tTableView1 indexPathForRowAtPoint:p];
    if (indexPath == nil) {
        NSLog(@"long press on table view but not on a row");
    } else if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIAlertView* talertObj = [[UIAlertView alloc]initWithTitle:@"Delete" message:@"Are you sure want to delete address?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"YES",@"NO", nil];
        talertObj.tag = 5824;
        [talertObj show];
        NSLog(@"long press on table view at row %d", indexPath.row);
        tdeleteSelectedAddress = (int)indexPath.row;
    } else {
        NSLog(@"gestureRecognizer.state = %d", gestureRecognizer.state);
    }
}
-(void)tResetTableView
{
    [tAddressArray removeAllObjects];
    isAddressList = false;
    tTextFieldOfRouteName.text = @"";
    tTextFieldOfAddress.text = @"";
    tTextFieldOfNotes.text = @"";
    tserverObj.isSaveRoutes = false;
    tserverObj.isSavedRouteOrNot = false;
    tserverObj.tForeginKey = 0;
    tTextFieldOfRouteName.userInteractionEnabled = YES;
    [self.tTableView1 reloadData];
    
    
    
    
}

-(void)tAddrouteAddress :(UIButton*) sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tTableView1];
    NSIndexPath *indexPath = [self.tTableView1 indexPathForRowAtPoint:buttonPosition];
    if(!tisEditRoute)
    {
       
        
    if(tTextFieldOfAddress.text.length != 0 )
    {
        tserverObj.tNameOfRoute = tTextFieldOfRouteName.text;
        if(tTextFieldOfNotes.text.length != 0)
        {
        tCount = 0;
        TS_ParaAddress* tpara = [TS_ParaAddress new];
        tpara.taddress = tTextFieldOfAddress.text;
        tpara.tnotes = tTextFieldOfNotes.text;
            tpara.tLatitude = tLat1;
            tpara.tLongitude = tLong1;
            
        #warning add lat Long in array
            
        if(tisCheckOrBox)
        {
            
            tpara.tFirstProperty = tFirstProperty;
            tFirstProperty ++;
        }
        else
        {
            tpara.tFirstProperty = 0;
        }
        
        [tAddressArray addObject:tpara];
        tTextFieldOfAddress.text = @"";
        tTextFieldOfNotes.text = @"";
        tisCheckOrBox = false;
        [self.tTableView1 reloadData];
    }//if notes are empty
        else
        {
            tCount = 0;
            TS_ParaAddress* tpara = [TS_ParaAddress new];
            tpara.taddress = tTextFieldOfAddress.text;
            tpara.tnotes = @"";
            tpara.tLatitude = tLat1;
            tpara.tLongitude = tLong1;
            
            if(tisCheckOrBox)
            {
                
                tpara.tFirstProperty = tFirstProperty;
                tFirstProperty ++;
            }
            else
            {
                tpara.tFirstProperty = 0;
            }
            
            [tAddressArray addObject:tpara];
            NSLog(@"Count After adding Route=%d",tAddressArray.count);
            tTextFieldOfAddress.text = @"";
            tTextFieldOfNotes.text = @"";
            tisCheckOrBox = false;
            [self.tTableView1 reloadData];
        }
        if(tserverObj.tisEditRouteBeforeJourney)
        {
        TS_DBLayer* tdb = [TS_DBLayer new];
        tserverObj.tRouteName = tTextFieldOfRouteName.text;
        [tdb tUpdateAddressData:tAddressArray];
        }
    }
    else
    {
        if(tTextFieldOfAddress.text.length == 0)
        {
            UIAlertView* talertObj = [[UIAlertView alloc]initWithTitle:nil message:@"Please input the address" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            talertObj.tag = 1;
            [talertObj show];
        }
        else if(tTextFieldOfNotes.text.length == 0)
        {
            UIAlertView* talertObj = [[UIAlertView alloc]initWithTitle:nil message:@"Please input the notes" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            talertObj.tag = 1;
            [talertObj show];
        }
        
    }
    }
    else
    {
        if(tTextFieldOfAddress.text.length != 0 )
        {
#warning change to Edit Route commented
            TS_DBLayer* tdb = [TS_DBLayer new];
            NSMutableArray* tarray = [NSMutableArray new];
            tarray = [tdb selectMaxId];
            NSSortDescriptor *lowestToHighest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
            [tarray sortUsingDescriptors:[NSArray arrayWithObject:lowestToHighest]];
            NSNumber* tid = [tarray objectAtIndex:0];
            int t = [tid intValue];
            NSLog(@"Array=%@",tarray);
            tisEditRoute = false;
            if(tTextFieldOfNotes.text.length != 0){
                
        TS_ParaAddress* tpara = [TS_ParaAddress new];
        tpara = [tAddressArray objectAtIndex:tarrayOfIndex];
        tpara.taddress = tTextFieldOfAddress.text;
//                if(tisCheckOrBox)
//                {
//                    t++;
//                    tpara.tFirstProperty = t;
//                }
        tpara.tnotes = tTextFieldOfNotes.text;
                
                NSLog(@"Notes=%@",tTextFieldOfNotes.text);
                if(tLat1 != 0.000000 && tLong1 != 0.000000)
                {
                tpara.tLatitude = tLat1;
                tpara.tLongitude = tLong1;
                }
#warning add lat Long in array
//        tpara.tFirstProperty = 0;
        [tAddressArray replaceObjectAtIndex:tarrayOfIndex withObject:tpara];
        tTextFieldOfAddress.text = @"";
        tTextFieldOfNotes.text = @"";
        tisCheckOrBox = false;
                //  EDIT THE ROW
                TS_DBLayer* tdb = [TS_DBLayer new];
                 tpara = [TS_ParaAddress new];
                for(int i = 0;i<tAddressArray.count;i++)
                {
                    
                    tpara = [tAddressArray objectAtIndex:i];
                    NSLog(@"Count=%ld\nAddress=%@\nNotes=%@\nIdentifier=%@",(unsigned long)tAddressArray.count,tpara.taddress,tpara.tnotes,tpara.tidentifireName);
                    
                    [tdb tUpdateAddressId:tpara];
                    
                }
        [self.tTableView1 reloadData];
                
            }//EMPTY NOTES
            else
            {
                TS_ParaAddress* tpara = [TS_ParaAddress new];
                tpara = [tAddressArray objectAtIndex:tarrayOfIndex];
                tpara.taddress = tTextFieldOfAddress.text;
                tpara.tnotes = @"";
                tpara.tLatitude = tLat1;
                tpara.tLongitude = tLong1;
//                if(tisCheckOrBox)
//                {
//                    t++;
//                    tpara.tFirstProperty = t;
//                }
                
                //        tpara.tFirstProperty = 0;
                [tAddressArray replaceObjectAtIndex:tarrayOfIndex withObject:tpara];
                tTextFieldOfAddress.text = @"";
                tTextFieldOfNotes.text = @"";
                tisCheckOrBox = false;
                //  EDIT THE ROW
                TS_DBLayer* tdb = [TS_DBLayer new];
                tpara = [TS_ParaAddress new];
                for(int i = 0;i<tAddressArray.count;i++)
                {
                    
                    tpara = [tAddressArray objectAtIndex:i];
                    NSLog(@"Count=%ld\nAddress=%@\nNotes=%@\nIdentifier=%@",(unsigned long)tAddressArray.count,tpara.taddress,tpara.tnotes,tpara.tidentifireName);
                    
                    [tdb tUpdateAddressId:tpara];
                    
                }
                [self.tTableView1 reloadData];
               
            }
            
            
            
            
             
             
            
        }
        else
        {
            if(tTextFieldOfAddress.text.length == 0)
            {
                UIAlertView* talertObj = [[UIAlertView alloc]initWithTitle:nil message:@"Please input the address" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                talertObj.tag = 1;
                [talertObj show];
            }
            else if(tTextFieldOfNotes.text.length == 0)
            {
                UIAlertView* talertObj = [[UIAlertView alloc]initWithTitle:nil message:@"Please input the notes" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                talertObj.tag = 1;
                [talertObj show];
            }
        }
        
    }
}



- (IBAction)tBeginRouteAction:(id)sender
{
    tserverObj.tisEditRouteOrNot = false;
    tserverObj.tNameOfRoute = tTextFieldOfRouteName.text;
    if(tserverObj.isNetworkAvailable)
    {
        if(tAddressArray.count > 0)
        {
        if(tserverObj.isSavedRouteOrNot)
        {
            self.activityIndicator.hidden = NO;
            self.activityIndicator = [[AMTumblrHud alloc] initWithFrame:CGRectMake((tBeginRoute.bounds.size.width/2) - 25, 12, 55, 20)];;
            self.activityIndicator.hudColor = [UIColor whiteColor]; //[UIColor magentaColor];
            [self.activityIndicator showAnimated:YES];
            [tBeginRoute addSubview:self.activityIndicator];
            
            
            [self performSegueWithIdentifier:@"segueDrawRoute" sender:self];
        }
        else
        {
            UIAlertView* talertObj = [[UIAlertView alloc]initWithTitle:nil message:@"This route is not saved." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            talertObj.tag = 459;
            [talertObj show];
        }
        }
        else
        {
            UIAlertView* talertObj = [[UIAlertView alloc]initWithTitle:nil message:@"Please insert address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            talertObj.tag = 459;
            [talertObj show];
        }
    }
    else
    {
        UIAlertView* talertObj = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"No Internet Connection!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        talertObj.tag = 112365;
        [talertObj show];
        
    }
}

- (IBAction)tSavedRouteAction:(id)sender
{
    TS_DBLayer* tdb = [TS_DBLayer new];
    if(tTextFieldOfRouteName.text.length != 0)
    {
        TS_ParaAddress* taddress = [TS_ParaAddress new];
        if(!tserverObj.isSaveRoutes)
        {
            
            tserverObj.isSaveRoutes= true;
            [tdb tInsertRouteNameAndAddress:tTextFieldOfRouteName.text];
            tserverObj.tRouteName = tTextFieldOfRouteName.text;
            [tdb tSaveAddressInDB:tAddressArray];
            
            for(int i = 0;i<tAddressArray.count;i++)
            {
            taddress = [tAddressArray objectAtIndex:i];
                NSLog(@"Count=%ld\nAddress=%@",(unsigned long)tAddressArray.count,taddress.taddress);
            }
        }
        else
        {
            if(!tisEditRoute)
            {
            NSLog(@"AddressUpdatedArray=%ld",(unsigned long)tAddressArray.count);
            tserverObj.tRouteName = tTextFieldOfRouteName.text;
            [tdb tUpdateAddressData:tAddressArray];
            for(int i = 0;i<tAddressArray.count;i++)
            {
                
                taddress = [tAddressArray objectAtIndex:i];
                 NSLog(@"Count=%ld\nAddress=%@",(unsigned long)tAddressArray.count,taddress.taddress);
                
            }
            }
            else
            {
                tisEditRoute = false;
                
                 TS_ParaAddress* tpara = [TS_ParaAddress new];
                for(int i = 0;i<tAddressArray.count;i++)
                {
                    
                    tpara = [tAddressArray objectAtIndex:i];
                    NSLog(@"Count=%ld\nAddress=%@\nNotes=%@\nIdentifier=%@==firstproperty=%d",(unsigned long)tAddressArray.count,tpara.taddress,tpara.tnotes,tpara.tidentifireName,tpara.tFirstProperty);
                    
                    [tdb tUpdateAddressId:tpara];
                    
                }
                
                
            }
        }
        
        tserverObj.isSavedRouteOrNot = TRUE;
    }
    else
    {
        UIAlertView* talertObj = [[UIAlertView alloc]initWithTitle:nil message:@"Please enter the route name." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        talertObj.tag = 852;
        [talertObj show];
    }
}

- (IBAction)tDeleteRouteAction:(id)sender
{
    if(tTextFieldOfRouteName.text.length != 0)
    {
        UIAlertView* talertObj = [[UIAlertView alloc]initWithTitle:@"Warning" message:[NSString stringWithFormat:@"Route Name : %@ are you sure want to delete?",tTextFieldOfRouteName.text] delegate:self cancelButtonTitle:nil otherButtonTitles:@"YES",@"NO",nil];
        talertObj.tag = 740;
        [talertObj show];
    }
    else
    {
        UIAlertView* talertObj = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"Please select the route."] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        talertObj.tag = 987;
        [talertObj show];
    }
}


-(void)tEndKeyboard
{
    [self.view endEditing:YES];
}

-(void)tBtnActionOfCheckBox
{
    tisCheckOrBox = !tisCheckOrBox;
    tCount = 0;
    [self.tTableView1 reloadData];
}

-(void)tSaveRoutesList
{
    [self performSegueWithIdentifier:@"segueSavedRoutes" sender:self];
}

-(void)btnColorPressed
{
    if(tserverObj.isNetworkAvailable)
    {
//        tTableViewofDropDownList.hidden = YES;
        isAddressList = true;
        //    talertObj2 = [[UIAlertView alloc]initWithTitle:nil message:@"Please wait...." delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        //    talertObj2.tag = 321;
        //    [talertObj2 show];
        NSString* address = tTextFieldOfAddress.text;
        
        
        
        
        
        NSString *esc_addr =  [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *req = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=false", esc_addr];
        // http://maps.googleapis.com/maps/api/geocode/json?address=%@&components=country:USA&sensor=false
        NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
        
        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        //    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:json options:kNilOptions error:nil];
        NSString* tformattedAddress=@"";
        NSLog(@"AddressDict=------%@",dictionary);
        if (result) {
            NSScanner *scanner = [NSScanner scannerWithString:result];
            if ([scanner scanUpToString:@"\"formatted_address\" :" intoString:nil] && [scanner scanString:@"\"formatted_address\" :" intoString:nil] ) {
                [scanner scanString:tformattedAddress intoString:nil];
                
            }
        }
        
        NSDictionary* tdict = [dictionary valueForKey:@"results"];
        NSLog(@"Results=%@",tdict);
        tShowAddressInPickerVIewArray = [tdict valueForKey:@"formatted_address"] ;
        if(tShowAddressInPickerVIewArray.count > 0)
        {
            
            tFulladdress = [tShowAddressInPickerVIewArray objectAtIndex:0];
            //        [self tInitPickerView];
            //    UIAlertView* talertObj = [[UIAlertView alloc]initWithTitle:@"Address :" message:[NSString stringWithFormat:@"%@",tFulladdress] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            //    talertObj.tag = 12;
            //    [talertObj show];
            NSLog(@"Address=%@-----DemoAddress=%@---COunt=%ld",[tdict valueForKey:@"formatted_address"],tFulladdress,(unsigned long)tShowAddressInPickerVIewArray.count);
        }else
        {
            isAddressList = false;
            UIAlertView* talertObj = [[UIAlertView alloc]initWithTitle:@"Address :" message:[NSString stringWithFormat:@"%@ sorry this is invalid address",tTextFieldOfAddress.text] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            talertObj.tag = 122;
            [talertObj show];
        }
        
        
        
        
        NSLog(@"ForamttedAddress=%@",tformattedAddress);
        [self.tTableView1 reloadData];
    }
    else
    {
        UIAlertView * talertObj =[[UIAlertView alloc]initWithTitle:@"Warning" message:@"No Internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        talertObj.tag = 123;
    }
}


-(void)tShowListOfSavedRoutes
{
    [self performSegueWithIdentifier:@"segueSavedRoutes" sender:self];
}
-(void)tBackButton
{
    [self performSegueWithIdentifier:@"segueDrawRoute" sender:self];
}
#pragma mark-LOGICAL METHOD

-(UIBarButtonItem*)tlogicOfRightBarButton
{
    UIImage *buttonImage;
    
    buttonImage = [UIImage imageNamed:@"InfoIcon.png"];
    
    
    
    //create the button and assign the image
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    
    //set the frame of the button to the size of the image (see note below)
    button.frame = CGRectMake(10, 0, buttonImage.size.width, buttonImage.size.height);
    [button sizeToFit];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -button.imageView.frame.size.width + 30, 0, button.imageView.frame.size.width - 60);
    
    //    [button addTarget:self action:@selector(tSaveRoutesList) forControlEvents:UIControlEventTouchUpInside];
    
    //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItem2 = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return customBarItem2;
    
}

-(UIBarButtonItem*)tlogicOfBackButton
{
    UIImage *buttonImage;
    
    buttonImage = [UIImage imageNamed:@"RightBackBtn.png"];
    
    
    
    //create the button and assign the image
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    
    //set the frame of the button to the size of the image (see note below)
    button.frame = CGRectMake(10, 0, buttonImage.size.width, buttonImage.size.height);
    [button sizeToFit];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -button.imageView.frame.size.width + 30, 0, button.imageView.frame.size.width - 60);
    
        [button addTarget:self action:@selector(tBackButton) forControlEvents:UIControlEventTouchUpInside];
    
    //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItem2 = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return customBarItem2;
}

-(UIBarButtonItem*)tLogicToAddLeftButton
{
    UIImage *buttonImage;
    buttonImage = [UIImage imageNamed:@"refresh.png"];
    
    
    
    //create the button and assign the image
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    
    //set the frame of the button to the size of the image (see note below)
    button.frame = CGRectMake(10, 0, buttonImage.size.width, buttonImage.size.height);
    [button sizeToFit];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -button.imageView.frame.size.width + 30, 0, button.imageView.frame.size.width - 80);
    
    [button addTarget:self action:@selector(tResetTableView) forControlEvents:UIControlEventTouchUpInside];
    
    //create a UIBarButtonItem with the button as a custom view
    customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    //SET TARGET AND ACTION OF MENU BUTTON
    //    customBarItem.target = self.revealViewController;
    
    
    
    
    return customBarItem;
}




#pragma mark-TOOLBAR AND TEXTFIELD DELEGATES

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.tag == 1)
    {
        [tTextFieldOfAddress becomeFirstResponder];
    }
    else if(textField.tag == 2)
    {
        [tTextFieldOfNotes becomeFirstResponder];
    }
    else if(textField.tag == 3)
    {
        [tTextFieldOfNotes resignFirstResponder];
        [self.view endEditing:YES];
        if(moved) {
            [self animateViewToPosition:self.view directionUP:NO];
        }
        moved = NO;
        
        
        return NO;
    }
    return NO;
}

-(UIToolbar*)getToolbar :(int)tagNumber
{
    UIToolbar* keyboardToolbar;
    
    keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
//    [keyboardToolbar setBarStyle:UIBarStyleDefault];
    keyboardToolbar.backgroundColor = [UIColor blueColor];
    UIBarButtonItem *extraSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    //    UIBarButtonItem *next;
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyboard)];
    [done setTintColor:[UIColor whiteColor]];
    
    
    if(tagNumber != 3)
    {
        UIBarButtonItem *next;
        next   = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(nextTextField:)];
        [next setTintColor:[UIColor whiteColor]];
        next.tag = tagNumber;
        [keyboardToolbar setItems:[[NSArray alloc] initWithObjects: done,extraSpace, next, nil]];
    }else{
        
        [keyboardToolbar setItems:[[NSArray alloc] initWithObjects: extraSpace, done, nil]];
    }
    
    
    
    return keyboardToolbar;
}

-(void)animateViewToPosition:(UIView *)viewToMove directionUP:(BOOL)up
{
    
    
    const int movementDistance = -135; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    viewToMove.frame = CGRectOffset(viewToMove.frame, 0, movement);
    [UIView commitAnimations];
    
}

-(void)animateViewToPosition2:(UIView *)viewToMove directionUP:(BOOL)up
{
    const int movementDistance = -120; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    viewToMove.frame = CGRectOffset(viewToMove.frame, 0, movement);
    [UIView commitAnimations];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField.tag == 2)
    {
        if(tAddressArray.count > 1)
        {
            if(!moved)
            {
                
                [self animateViewToPosition2:self.view directionUP:YES];
                moved = YES;
            }
        }
    }
    else if(textField.tag == 3 )
    {
        if(!moved)
        {
            [self animateViewToPosition:self.view directionUP:YES];
            moved = YES;
        }
    }
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
   
    
    NSLog(@"TEXT FIELD SHOULD END EDITING=%@",textField.text);
    if(textField.tag == 2)
    {
        
        if(tAddressArray.count > 1)
        {
            if(moved)
            {
            [self animateViewToPosition2:self.view directionUP:NO];
            moved = NO;
            }
            
        }
        if(textField.text.length == 1)
        {
            isAddressList= false;
            [tableViewWordHelp removeFromSuperview];
            tableViewWordHelp = nil;
        }
        
    }
    else if(textField.tag == 3)
    {
        [self animateViewToPosition:self.view directionUP:NO];
        moved = NO;
    }
    
}

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    NSLog(@"TExt Field Should clear");
    
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
   
    if(textField.text.length == 0)
   {
       [tableViewWordHelp removeFromSuperview];
                tableViewWordHelp = nil;
   }
    return YES;
}

-(void)nextTextField:(UITextField*) sender
{
    if(sender.tag == 1)
    {
        [tTextFieldOfAddress becomeFirstResponder];
    }
    else if(sender.tag == 2)
    {
        
        [tTextFieldOfNotes becomeFirstResponder];

        
    }
    else if(sender.tag == 3)
    {
        [tTextFieldOfNotes resignFirstResponder];
        
    }
    
}

-(void)dismissKeyboard
{
//    isAddressList = false;
    [self.view endEditing:YES];
//    [self.tTableView1 reloadData];
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(textField.tag == 2)
    {
  
//        if(textField.text.length > 0)
//        {
        NSLog(@"TextLength=%d",textField.text.length);
            NSString *substring = [NSString stringWithString:textField.text];
            substring = [substring stringByReplacingCharactersInRange:range withString:string];
//            tTextFieldOfAddress.text = substring;
//            NSLog(@"Text=%@",substring);
            [self tData:substring :textField];
            
//        }
        if(textField.text.length == 1)
        {
            [tableViewWordHelp removeFromSuperview];
            tableViewWordHelp = nil;
        }
        
        
    }
    else if(textField.tag == 1)
    {
        tserverObj.tNameOfRoute = textField.text;
        
    }
    return YES;
}



-(void)displayView :(UITextField*)sender
{
    CGPoint textFieldOriginInTableView = [sender convertPoint:sender.frame.origin toView:self.tTableView1];
    
    
    
    
    if(!tableViewWordHelp)
    {
        int height;
        if(textFieldOriginInTableView.y > self.tTableView1.bounds.size.height)
        {
            height = self.tTableView1.bounds.size.height;
            
        }else{
            height = textFieldOriginInTableView.y + 35;
        }
        tableViewWordHelp = [[UITableView alloc]initWithFrame:CGRectMake(20, self.tTableView1.frame.origin.y + height, self.view.bounds.size.width - 40, 300)];
        
        
        //        currentSender = sender;
        tableViewWordHelp.tag = 700;
        tableViewWordHelp.delegate = self;
        tableViewWordHelp.dataSource = self;
        tableViewWordHelp.backgroundColor = [UIColor clearColor];
        [tableViewWordHelp registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        tableViewWordHelp.separatorStyle = UITableViewCellSelectionStyleNone;
        [tableViewWordHelp reloadData];
        [self.view addSubview:tableViewWordHelp];
    }
    else
    {
        [tableViewWordHelp reloadData];
    }
    
    
}



-(void)tData:(NSString*)taddressString :(UITextField*)sender
{
   
    [self displayView:sender];
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Add code here to do background processing
        //
        //
       
    if(tserverObj.isNetworkAvailable)
    {
        //        tTableViewofDropDownList.hidden = YES;
        
        
        isAddressList = true;
        NSString* address = taddressString;
        
        NSString *esc_addr =  [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        NSString *req = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&components=country:us&sensor=false", esc_addr];
       
        NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
        
        NSDictionary *dictionary;
        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
        if(data != nil)
        {
            dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        }
        
        NSDictionary* tdict;// = [dictionary valueForKey:@"results"];
        
        
        @try {
            tdict = [dictionary valueForKey:@"results"];//predictions

            tShowAddressInPickerVIewArray = [tdict valueForKey:@"formatted_address"] ;// description
            NSDictionary* tdict2 = [tdict valueForKey:@"geometry"];
            NSDictionary* tdict3 = [tdict2 valueForKey:@"location"];
            tLatituedArray = [tdict3 valueForKey:@"lat"];
            tLongitudeArray = [tdict3 valueForKey:@"lng"];
            NSLog(@"Result=%@",tdict);
//            NSLog(@"Dict2=%@\nArrayOfLat=%@\nLong=%@",tdict3,tLatituedArray,tLongitudeArray);
            
            
        }
        @catch (NSException *exception) {
            NSLog(@"@@@@@@@@@@@@@@@@@@@@@@Exceptiopn=%@",exception);
        }
        @finally
        {
            
        }
        
        
    }
    else
    {
        UIAlertView * talertObj =[[UIAlertView alloc]initWithTitle:@"Warning" message:@"No Internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        talertObj.tag = 123;
    }
    
   
        dispatch_async( dispatch_get_main_queue(), ^{
            // Add code here to update the UI/send notifications based on the
            // results of the background processing
            @try {
                [tableViewWordHelp reloadData];
            }
            @catch (NSException *exception) {
                NSLog(@"@@@@@@@@@@@@@@@@@@@@@Exception=%@",exception);
            }
            @finally {
                
            }
            
        
        });
    });
    
}




-(void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    
    
    /* [tSearchArray removeAllObjects];
     
     for(NSString * relatedString in tNationNames)
     {
     NSRange subStringRange = [relatedString rangeOfString:substring options:NSCaseInsensitiveSearch];
     if(subStringRange.location == 0)
     {
     
     [tSearchArray addObject:relatedString];
     }
     }
     
     [autocompleteTableView reloadData];*/
    
    
}

//-(BOOL)searchDisplayController :(NSString *)searchString {
//    
//    NSLog(@"SearchString=%@",searchString);
//    [self.geocoder geocodeAddressString:searchString completionHandler:^(NSArray *placemarks, NSError *error) {
////        self.placemarks = placemarks;
////        [self.searchDisplayController.searchResultsTableView reloadData];
//        
//        NSLog(@"ArrayCount=%ld\nArrayObjects=%@",(unsigned long)placemarks.count,placemarks);
//        
//    }];
//    return YES;
//}


#pragma mark-ALERT VIEW DELEGATE
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 12)
    {
        if(buttonIndex == 1)
        {
            tTextFieldOfAddress.text = tFulladdress;
        }
    }
    else if(alertView.tag == 740)
    {
        if(buttonIndex == 0)
        {
            if(tTextFieldOfRouteName.text.length != 0)
            {
                TS_DBLayer* tdb = [TS_DBLayer new];
                [tdb tRetrieveRouteNameId:tTextFieldOfRouteName.text];
                [tdb tDeleteRouteData:tserverObj.tForeginKey];
                
                
                tTextFieldOfRouteName.text = @"";
                tTextFieldOfAddress.text = @"";
                tTextFieldOfNotes.text = @"";
                tserverObj.tNameOfRoute = @"";
                tserverObj.isSaveRoutes = false;
                
                tTextFieldOfRouteName.userInteractionEnabled = YES;
                [self.tTableView1 reloadData];
            }
        }
    }
    else if(alertView.tag == 5824)
    {
        if(buttonIndex == 0)
        {
        TS_ParaAddress* tpara = [TS_ParaAddress new];
        tpara = [tAddressArray objectAtIndex:tdeleteSelectedAddress];
        TS_DBLayer* tdb = [TS_DBLayer new];
        [tdb deleteData:tpara.tRouteId];
            [tAddressArray removeObjectAtIndex:tdeleteSelectedAddress];
            tTextFieldOfAddress.text = @"";
            tTextFieldOfNotes.text = @"";
            [self.tTableView1 reloadData];
        }
    }
    [talertObj2 dismissWithClickedButtonIndex:0 animated:YES];
}



#pragma mark-PREPARE FOR SEGUE
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"segueDrawRoute"])
    {
        
        //        TSUI_DrawRoute_VC* tobj = [segue destinationViewController];
        TS_ServerClass* tserverObj2 = [TS_ServerClass tsharedInstance];
        tserverObj2.taddressArray = [NSMutableArray new];
        for(int i=0;i<tAddressArray.count;i++)
        {
            [tserverObj.taddressArray addObject:[tAddressArray objectAtIndex:i]];
        }
    }
}

@end
/* APIS FOR AUTO COMLETE FEATURE
         //        NSString *req = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=false", esc_addr];//http://maps.googleapis.com/maps/api/geocode/json?address=%@&components=country:USA&sensor=false
 Autocomplete API ORIGINAL COMMENTED BEACUSE OVER_QUERY_LIMIT DATE:JUNE_02
 https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&components=country:us&sensor=false&key=AIzaSyA_YrKblffaJGykRDxYqCQqPUIJQEJtTqA
 
//https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&components=country:US&sensor=false&key=AIzaSyAD1Ej4W85i2phlyUgfL1XB4a5d29I8qDA
//http://maps.googleapis.com/maps/api/geocode/json?address=%@&components=country:USA&sensor=false     //original API
//https://maps.googleapis.com/maps/api/place/autocomplete/json?address=%@&components=country:USA&sensor=false
*/


