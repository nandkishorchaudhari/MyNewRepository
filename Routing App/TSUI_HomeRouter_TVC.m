//
//  TSUI_HomeRouter_TVC.m
//  Routing App
//
//  Created by TacktileSystemsMac4 on 04/05/15.
//  Copyright (c) 2015 Tacktile Systems. All rights reserved.
// **********Main Copy**********

#import "TSUI_HomeRouter_TVC.h"
#import "TSUI_DrawRoute_VC.h"
#import "TS_ServerClass.h"
#import "TS_ParaAddress.h"
#import "TS_DBLayer.h"
#import "AMTumblrHud.h"



@interface TSUI_HomeRouter_TVC ()
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
    
}
@property(nonatomic, retain)AMTumblrHud * activityIndicator;
@end

@implementation TSUI_HomeRouter_TVC
@synthesize tTableViewofDropDownList;
- (void)viewDidLoad {
    [super viewDidLoad];
    

    //SET TARGET AND ACTION OF MENU BUTTON
    self.tMenuBtn.target = self.revealViewController;
    self.tMenuBtn.action = @selector(revealToggle:);
    //ADD THE PAN GESTURE, SO THAT MENU GETS OPEN WHEN WE PAN ON THE SCREEN
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    [NSNotificationCenter defaultCenter];
    NSNotification* notification = [NSNotification notificationWithName:@"ReloadTableView" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (tReloadView:) name:@"ReloadTableView" object:nil];
    tFirstProperty = 1;
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.bounds.size.width, 22)];
    TS_ServerClass * tserObj = [TS_ServerClass tsharedInstance];
    statusBarView.backgroundColor = [tserObj colorWithHexString:@"39aad6"];

    [self.navigationController.navigationBar addSubview:statusBarView];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;//UIStatusBarStyleLightContent;

    
    self.title = @"Home Router";
//    UITapGestureRecognizer* tTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tEndKeyboard)];
//    [self.view addGestureRecognizer:tTapGesture];
    tAddressArray = [NSMutableArray new];
    tserverObj = [TS_ServerClass tsharedInstance];
    tcolorArray = [[NSArray alloc]initWithObjects:@"8cdfff",@"5bcffc",@"45bfef",@"39aad6", nil];
    self.navigationItem.rightBarButtonItem =[self tlogicOfRightBarButton];
//    self.navigationItem.leftBarButtonItem = [self tLogicToAddLeftButton];
     tTableViewofDropDownList = [[UITableView alloc]initWithFrame:CGRectMake(0,200, self.tableView.bounds.size.width, 200) style:UITableViewStyleGrouped];
    tTableViewofDropDownList.backgroundColor = [UIColor redColor];
    tTableViewofDropDownList.delegate = self;
    tTableViewofDropDownList.dataSource = self;
    tTableViewofDropDownList.hidden = YES;
    
    self.activityIndicator.hidden = YES;
//    [self tInitPickerView];
//    self.tTableView1.tag = 1000;
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"RouteCompleted"])
    {
        self.title = @"";
        [self performSegueWithIdentifier:@"segueDrawRoute" sender:self];
    }
    
//    [self tGeneratePdfFile];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self tInitAddressData];
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.activityIndicator.hidden = YES;
}

#pragma mark-INITDATA

-(void)tGeneratePdfFile
{
    NSString* fileName = @"Invoice.PDF";
    
    NSArray *arrayPaths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pdfFileName = [path stringByAppendingPathComponent:fileName];
    
    NSLog(@"PDFFilePath=%@",path);
    NSString* textToDraw = @"Hello World";
    CFStringRef stringRef = (__bridge CFStringRef)textToDraw;
    
    // Prepare the text using a Core Text Framesetter.
    CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, stringRef, NULL);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(currentText);
    
    CGRect frameRect = CGRectMake(0, 0, 300, 50);
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
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    // Draw the frame.
    CTFrameDraw(frameRef, currentContext);
    
    CFRelease(frameRef);
    CFRelease(stringRef);
    CFRelease(framesetter);
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
}

-(void)tInitPickerView
{
   
    tsetAddressPickerView=[UIPickerView new];
    tsetAddressPickerView.frame=CGRectMake(0.0, self.tableView.bounds.size.height / 3,self.tableView.layer.bounds.size.width,220.0) ;
    
    tsetAddressPickerView.dataSource=self;
    tsetAddressPickerView.delegate=self;
//    tsetAddressPickerView=[[NSMutableArray alloc]initWithObjects:@"",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil];
    tsetAddressPickerView.backgroundColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    tsetAddressPickerView.tag=111;
    //CGAFFINETRANSFORM USED TO SET HEIGHT OF PICKER VIEW.
//    CGAffineTransform t0 = CGAffineTransformMakeTranslation (0, tsetAddressPickerView.bounds.size.height/8);
//    CGAffineTransform s0 = CGAffineTransformMakeScale       (1.0, 1.1);
//    CGAffineTransform t1 = CGAffineTransformMakeTranslation (0, -tsetAddressPickerView.bounds.size.height/2);
//    tsetAddressPickerView.transform = CGAffineTransformConcat          (t0, CGAffineTransformConcat(s0, t1));
    [self.tableView addSubview:tsetAddressPickerView];
}
#pragma mark-PICKER VIEWS DELEGATES.
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 1;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = [NSString stringWithFormat:@"%@",[tShowAddressInPickerVIewArray objectAtIndex:row] ];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return attString;
    
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if(component == 0)
    {
        return [tShowAddressInPickerVIewArray count];
    }
    return 0;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    tTextFieldOfAddress.text = [tShowAddressInPickerVIewArray objectAtIndex:row];
    
    tsetAddressPickerView.hidden = YES;
    
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"InitDataWithReloadForList" object:nil];
    //    UIAlertView *talertOBJ2=[[UIAlertView alloc]initWithTitle:nil message:@"Are Sure you want set timmer" delegate:self cancelButtonTitle:nil otherButtonTitles:@"YES",@"NO", nil];
    //    [talertOBJ2 show];
    
    
}
-(void)tReloadView :(NSNotification *) notification
{
    tTextFieldOfRouteName.text = @"";
    tAddressArray = [NSMutableArray new];
    [self.tableView reloadData];
}
-(void)tInitAddressData
{
    if(tserverObj.isSaveRoutes)
    {
        TS_DBLayer* tdb = [TS_DBLayer new];
       
        NSLog(@"NameOfRoute=%@\nName=%@",tTextFieldOfRouteName.text,tserverObj.tNameOfRoute);
       
       tAddressArray = [tdb tRerieveRoutesData:tserverObj.tSelectedRoute];
        NSLog(@"count=%ld",(unsigned long)tAddressArray.count);
        [self.tableView reloadData];
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
    tTextFieldOfRouteName.inputAccessoryView = [self getToolbar:1];
    tTextFieldOfAddress.inputAccessoryView = [self getToolbar:2];
    tTextFieldOfNotes.inputAccessoryView = [self getToolbar:3];
  
}

#pragma mark -TABLE VIEW DELEGATES

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

if(tableView.tag == 1)
{
    return 3;
}
    else if(tableView.tag == 2)
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
        if(isAddressList)
        {
        return tShowAddressInPickerVIewArray.count;
        }
        
        return 0;
    }
        else
        {
            return 0;
        }
    }
    else if(tableView.tag == 2)
    {
        return 2;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView.tag == 1)
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
    else if(tableView.tag == 2)
    {
        return 44;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  

    UITableViewCell *cell;
    static NSString *cellIdentifier = @"cellIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UILabel* tLabelOfAddress;
    UILabel* tLabelAddressList;
    UIImageView* tArrowsImageView;
    UIImageView* tAddressImage;
    
    if(!cell)
    {
        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        tLabelOfAddress = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.tableView.bounds.size.width - 60,44)];
        tLabelOfAddress.tag = 100;
        tLabelOfAddress.textAlignment = NSTextAlignmentLeft;
        [tLabelOfAddress setLineBreakMode:NSLineBreakByWordWrapping];
        [tLabelOfAddress setNumberOfLines:0];
        tLabelOfAddress.textColor = [tserverObj colorWithHexString:@"052430"];
        
        [cell.contentView addSubview:tLabelOfAddress];
        
        tArrowsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.tableView.bounds.size.width - 50, 12,20,20)];
        tArrowsImageView.image = [UIImage imageNamed:@"Arrow.png"];
        tArrowsImageView.tag = 101;
        [cell.contentView addSubview:tArrowsImageView];
        
        tLabelAddressList = [[UILabel alloc]initWithFrame:CGRectMake(50,0, self.tableView.bounds.size.width -70, 44)];
        tLabelAddressList.tag = 102;
        tLabelAddressList.textAlignment = NSTextAlignmentLeft;
        [tLabelAddressList setLineBreakMode:NSLineBreakByWordWrapping];
        [tLabelAddressList setNumberOfLines:0];
        
        [cell.contentView addSubview:tLabelAddressList];
        
        tAddressImage = [[UIImageView alloc]initWithFrame:CGRectMake(20,0,30,44)];
        tAddressImage.tag = 104;
        tAddressImage.image = [UIImage imageNamed:@"AddressPin.png"];
        [tAddressImage setBackgroundColor:[tserverObj colorWithHexString:@"c6efff"]];
        
        [cell.contentView addSubview:tAddressImage];
       
        
    }
    else
    {
        tLabelOfAddress = (UILabel*)[cell.contentView viewWithTag:100];
        tArrowsImageView = (UIImageView*)[cell.contentView viewWithTag:101];
        tLabelAddressList = (UILabel*)[cell.contentView viewWithTag:102];
        tAddressImage =(UIImageView*)[cell.contentView viewWithTag:104];
        
    }
    
    
    if(self.tTableView1.tag == 1)
    {
    if(indexPath.section == 0)
    {
        tArrowsImageView.hidden = NO;
        tAddressImage.hidden = YES;
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
        cell.backgroundColor = [tserverObj colorWithHexString:[tcolorArray objectAtIndex:indexPath.row%4]];

        
    }
        else if(indexPath.section == 1)
        {
        
            tAddressImage.hidden = NO;
            tArrowsImageView.hidden = YES;
            tLabelOfAddress.hidden = YES;
            tLabelAddressList.hidden = NO;
            tLabelAddressList.text = [tShowAddressInPickerVIewArray objectAtIndex:indexPath.row];
            tLabelAddressList.backgroundColor = [tserverObj colorWithHexString:@"c6efff"];
        }
    }
    return cell;
    
   }

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   
     UIView *tHeaderViewSection=[[UIView alloc]initWithFrame:CGRectMake(10,5,tableView.layer.bounds.size.width, 60)];
    
   
//    UIButton* tBtnRouteButton;
    UIButton* tBtnAddRoute;
    
    UILabel* tTextLabel;
    UIButton* tsaveRoute;
    UIButton* tdeletRoute;
   
    UIButton* tShowRoutList;
//    UIButton *tAddressBtn;

    
    UIButton* tBtncheckBox;

    
    if(section == 0)
    {
       if(!tTextFieldOfRouteName)
       {
        tTextFieldOfRouteName = [[UITextField alloc]initWithFrame:CGRectMake(20,5, self.tableView.bounds.size.width - 80 , 44 )];
       }
        
        tShowRoutList = [[UIButton alloc]initWithFrame:CGRectMake(self.tableView.bounds.size.width - 65, 5, 40, 44)];
//        [tShowRoutList setBackgroundImage:[UIImage imageNamed:@"SavedRoutesIcon.png"] forState:UIControlStateNormal];
        [tShowRoutList setImage:[UIImage imageNamed:@"SavedRoutesIcon.png"] forState:UIControlStateNormal];
        [tShowRoutList addTarget:self action:@selector(tShowListOfSavedRoutes) forControlEvents:UIControlEventTouchUpInside];
        tShowRoutList.layer.cornerRadius = 3.0f;
        [tShowRoutList setBackgroundColor:[tserverObj colorWithHexString:@"39aad6"]];
        tTextFieldOfRouteName.backgroundColor = [tserverObj colorWithHexString:@"39aad6"];
        tTextFieldOfRouteName.textColor = [tserverObj colorWithHexString:@"ffffff"];
        tTextFieldOfRouteName.placeholder = @"Enter route name";
        tTextFieldOfRouteName.textAlignment = NSTextAlignmentCenter;
        tTextFieldOfRouteName.layer.cornerRadius = 3.0f;
        if(tserverObj.isSaveRoutes)
        {
            tTextFieldOfRouteName.text = tserverObj.tNameOfRoute;
            tTextFieldOfRouteName.userInteractionEnabled = NO;
        }
//        tTextFieldOfRouteName.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;//UILineBreakModeCharacterWrap;
        
        [tHeaderViewSection addSubview:tShowRoutList];
        [tHeaderViewSection addSubview:tTextFieldOfRouteName];
    }
    else if(section == 1)
    {
        if(!tTextFieldOfAddress)
        {
            tTextFieldOfAddress = [[UITextField alloc]initWithFrame:CGRectMake(20, 5, self.tableView.bounds.size.width - 40, 44)];
            
        }
        
        tTextFieldOfAddress.backgroundColor = [UIColor lightGrayColor];
        tTextFieldOfAddress.placeholder = @"Enter address here....";
        tTextFieldOfAddress.tag = 1;
    
        tTextFieldOfAddress.layer.borderWidth = 0.5f;
                tTextFieldOfAddress.layer.borderColor = [tserverObj colorWithHexString:@"8c8c8c"].CGColor;
        if(!tTextFieldOfNotes)
        {
            tTextFieldOfNotes = [[UITextField alloc]initWithFrame:CGRectMake(20,55,self.tableView.bounds.size.width - 40, 88)];
        }
        tTextFieldOfAddress.backgroundColor = [tserverObj colorWithHexString:@"ffffff"];
        tTextFieldOfNotes.backgroundColor = [UIColor lightGrayColor];
        tTextFieldOfNotes.placeholder = @"your note goes here....";
        tTextFieldOfNotes.layer.borderWidth = 0.5f;
        tTextFieldOfNotes.layer.borderColor = [tserverObj colorWithHexString:@"8c8c8c"].CGColor;
        tTextFieldOfNotes.backgroundColor = [tserverObj colorWithHexString:@"ffffff"];
       
        
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
        tTextFieldOfAddress.leftView = paddingView;
        tTextFieldOfAddress.leftViewMode = UITextFieldViewModeAlways;
        UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
        tTextFieldOfNotes.leftView = paddingView2;
        tTextFieldOfNotes.leftViewMode = UITextFieldViewModeAlways;
        
        tTextFieldOfAddress.layer.cornerRadius = 5.0f;
        tTextFieldOfNotes.layer.cornerRadius = 5.0f;
        [self tInitTextFieldData];
//        [tTextFieldOfAddress addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
//         tAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [tAddressBtn addTarget:self action:@selector(btnColorPressed) forControlEvents:UIControlEventTouchUpInside];
//        tAddressBtn.frame = CGRectMake(self.tableView.bounds.size.width - 60, 5, 40, 40);
//        [tAddressBtn setBackgroundImage:[UIImage imageNamed:@"pointer@2x.png"] forState:UIControlStateNormal];
        
        
        tBtnAddRoute = [[UIButton alloc]initWithFrame:CGRectMake(TABLEWIDTH / 2 - (self.tableView.bounds.size.width/2)/2, 185,self.tableView.bounds.size.width/2,44)];
        tBtnAddRoute.backgroundColor = [tserverObj colorWithHexString:@"39aad6"];
        [tBtnAddRoute setTitle:@"Add to Route" forState:UIControlStateNormal];
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
        
        tTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(45,145,TABLEWIDTH / 2,30)];
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
        [tHeaderViewSection addSubview:tTextFieldOfAddress];
        
        
       
        
    }
    
    else if(section == 2)
    {
        tBeginRoute = [[UIButton alloc]initWithFrame:CGRectMake(5,10,(TABLEWIDTH/3)-7,44)];
        [tBeginRoute addTarget:self action:@selector(tBeginRoute) forControlEvents:UIControlEventTouchUpInside];
//        [tBeginRoute setTitle:@"Route Info" forState:UIControlStateNormal];
        tBeginRoute.titleLabel.font = [UIFont systemFontOfSize:14.0f];
//        [tBeginRoute setBackgroundColor:[tserverObj colorWithHexString:@"636363"]];
//        tBeginRoute.backgroundColor = [UIColor lightGrayColor];
        tBeginRoute.layer.cornerRadius = 5.0f;
        [tBeginRoute setBackgroundImage:[UIImage imageNamed:@"RouteInfoBtn.png"] forState:UIControlStateNormal];
        
        tsaveRoute = [[UIButton alloc]initWithFrame:CGRectMake(((TABLEWIDTH/3)-7)+12,10,(TABLEWIDTH/3)-7,44)];
        [tsaveRoute addTarget:self action:@selector(tSaveRoute) forControlEvents:UIControlEventTouchUpInside];
//        [tsaveRoute setTitle:@"Save Route" forState:UIControlStateNormal];
//        [tsaveRoute setBackgroundColor:[tserverObj colorWithHexString:@"636363"]];
        tsaveRoute.layer.cornerRadius = 5.0f;
        [tsaveRoute setBackgroundImage:[UIImage imageNamed:@"SaveRouteBtn.png"] forState:UIControlStateNormal];
//        [tsaveRoute setImage:[UIImage imageNamed:@"SaveRouteBtn.png"] forState:UIControlStateNormal];
         tsaveRoute.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        
        tdeletRoute = [[UIButton alloc]initWithFrame:CGRectMake((((TABLEWIDTH/3)-7)*2)+18 ,10,(TABLEWIDTH/3)-7,44)];
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
    }
    
    
    return tHeaderViewSection;
   
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isAddressList)
    {
        isAddressList = FALSE;
        tTextFieldOfAddress.text = [tShowAddressInPickerVIewArray objectAtIndex:indexPath.row];
    }
    [self.tableView reloadData];
}


#pragma mark-ACTION
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
    [self.tableView reloadData];
    
 
    
    
}

-(void)tAddrouteAddress :(UIButton*) sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    if(tTextFieldOfAddress.text.length != 0 && tTextFieldOfNotes.text.length !=0)
    {
        tCount = 0;
        TS_ParaAddress* tpara = [TS_ParaAddress new];
        tpara.taddress = tTextFieldOfAddress.text;
        tpara.tnotes = tTextFieldOfNotes.text;
        
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
    [self.tableView reloadData];
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

-(void)tBeginRoute
{
    if(tserverObj.isNetworkAvailable)
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
        UIAlertView* talertObj = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"No Internet Connection!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        talertObj.tag = 112365;
        [talertObj show];

    }
}

-(void)tSaveRoute
{
    TS_DBLayer* tdb = [TS_DBLayer new];
    if(tTextFieldOfRouteName.text.length != 0)
    {
    if(!tserverObj.isSaveRoutes)
    {
    
    
    [tdb tInsertRouteNameAndAddress:tTextFieldOfRouteName.text];
    tserverObj.tRouteName = tTextFieldOfRouteName.text;
    [tdb tSaveAddressInDB:tAddressArray];
    }
    else
    {
        NSLog(@"AddressUpdatedArray=%ld",(unsigned long)tAddressArray.count);
        tserverObj.tRouteName = tTextFieldOfRouteName.text;
        [tdb tUpdateAddressData:tAddressArray];
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

-(void)tDeleteRoute
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
    [self.tableView reloadData];
}

-(void)tSaveRoutesList
{
    [self performSegueWithIdentifier:@"segueSavedRoutes" sender:self];
}

-(void)btnColorPressed
{
    if(tserverObj.isNetworkAvailable)
    {
    tTableViewofDropDownList.hidden = YES;
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
    [self.tableView reloadData];
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

#pragma mark-LOGICAL METHOD

- (void)reverseGeocode:(CLLocation *)location {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    NSLog(@"Location : Lat--%f>>Long--%f",location.coordinate.latitude,location.coordinate.longitude);
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Finding address");
        if (error) {
            NSLog(@"Error %@", error.description);
        } else {
            CLPlacemark *placemark = [placemarks lastObject];
            NSString* taddress = [NSString stringWithFormat:@"%@", ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO)];
            tFulladdress = taddress;
            UIAlertView* talertObj = [[UIAlertView alloc]initWithTitle:@"Address :" message:[NSString stringWithFormat:@"%@",taddress] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            talertObj.tag = 12;
            [talertObj show];
            NSLog(@"Address=%@",taddress);
        }
    }];
}


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
    [keyboardToolbar setBarStyle:UIBarStyleDefault];
    
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
    if(textField.tag == 2)
    {
    if(tAddressArray.count > 1)
    {
        [self animateViewToPosition2:self.view directionUP:NO];
        moved = NO;

    }
    }
  else if(textField.tag == 3)
    {
        [self animateViewToPosition:self.view directionUP:NO];
        moved = NO;
    }

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
    [self.view endEditing:YES];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
   if(textField.tag == 2)
   {
    
    NSString *substring = [NSString stringWithString:textField.text];
    substring = [substring stringByReplacingCharactersInRange:range withString:string];
//    tTextFieldOfAddress.text = substring;
    [self tData:substring];
//    [self searchAutocompleteEntriesWithSubstring:substring];
   }
    
    
    return YES;
}


-(void)tData:(NSString*)taddressString
{
    if(tserverObj.isNetworkAvailable)
    {
//        tTableViewofDropDownList.hidden = YES;
        isAddressList = true;
        NSString* address = taddressString;
        
        NSString *esc_addr =  [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        NSString *req = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=false", esc_addr];//http://maps.googleapis.com/maps/api/geocode/json?address=%@&components=country:USA&sensor=false
         NSString *req = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&components=country:us&sensor=false", esc_addr];
        
        //https://maps.googleapis.com/maps/api/place/autocomplete/json?address=%@&components=country:USA&sensor=false
        NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
        
        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

        
        NSDictionary* tdict = [dictionary valueForKey:@"results"];
        tShowAddressInPickerVIewArray = [tdict valueForKey:@"formatted_address"] ;

        
    }
    else
    {
        UIAlertView * talertObj =[[UIAlertView alloc]initWithTitle:@"Warning" message:@"No Internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        talertObj.tag = 123;
    }
    
    [self.tableView reloadData];
    [tTextFieldOfAddress becomeFirstResponder];

}


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
            }
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

/*
 tBeginRoute = [[UIButton alloc]initWithFrame:CGRectMake(self.tableView.bounds.size.width / 2 - (self.tableView.bounds.size.width/2)/2,0, self.tableView.bounds.size.width / 2, 44)];
 else if(tableView.tag == 2)
 {
 UITableViewCell *cell;
 static NSString *cellIdentifier = @"cellIdentifier";
 cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
 UILabel* tLabelOfAddress;
 
 UIImageView* tArrowsImageView;
 
 if(!cell)
 {
 cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
 tLabelOfAddress = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.tableView.bounds.size.width - 60,44)];
 tLabelOfAddress.tag = 100;
 tLabelOfAddress.textAlignment = NSTextAlignmentLeft;
 [tLabelOfAddress setLineBreakMode:NSLineBreakByWordWrapping];
 [tLabelOfAddress setNumberOfLines:0];
 
 [cell.contentView addSubview:tLabelOfAddress];
 tArrowsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.tableView.bounds.size.width - 50, 6,32,32)];
 tArrowsImageView.image = [UIImage imageNamed:@"arrow@3x"];
 [cell.contentView addSubview:tArrowsImageView];
 
 
 }
 else
 {
 tLabelOfAddress = (UILabel*)[cell.contentView viewWithTag:100];
 tArrowsImageView = (UIImageView*)[cell.contentView viewWithTag:101];
 }
 cell.textLabel.text = [tShowAddressInPickerVIewArray objectAtIndex:indexPath.row];
 return cell;
 }

 */


