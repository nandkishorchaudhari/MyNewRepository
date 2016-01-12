////
////  TSUI_EditRoute_TVC.m
////  Routing App
////
////  Created by TacktileSystemsMac4 on 14/06/15.
////  Copyright (c) 2015 Tacktile Systems. All rights reserved.
////
//
//#import "TSUI_EditRoute_TVC.h"
//
//@interface TSUI_EditRoute_TVC ()
//{
//     TS_ServerClass* tserverObj;
//    NSMutableArray* tAddressArray;
//}
//@end
//
//@implementation TSUI_EditRoute_TVC
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    tserverObj = [TS_ServerClass tsharedInstance];
//
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//
//    // Return the number of rows in the section.
//    return 0;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    UITableViewCell *cell;
//    if(tableView.tag == 1)
//    {
//        
//        
//        static NSString *cellIdentifier = @"cellIdentifier";
//        
//        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//        UILabel* tLabelOfAddress;
//        UILabel* tLabelAddressList;
//        UIImageView* tArrowsImageView;
//        
//        
//        if(!cell)
//        {
//            cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//            tLabelOfAddress = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.tTableView1.bounds.size.width - 60,44)];
//            tLabelOfAddress.tag = 100;
//            tLabelOfAddress.textAlignment = NSTextAlignmentLeft;
//            [tLabelOfAddress setLineBreakMode:NSLineBreakByWordWrapping];
//            [tLabelOfAddress setNumberOfLines:0];
//            tLabelOfAddress.textColor = [tserverObj colorWithHexString:@"052430"];
//            
//            [cell.contentView addSubview:tLabelOfAddress];
//            
//            tArrowsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.tTableView1.bounds.size.width - 50, 12,20,20)];
//            tArrowsImageView.image = [UIImage imageNamed:@"Arrow.png"];
//            tArrowsImageView.tag = 101;
//            [cell.contentView addSubview:tArrowsImageView];
//            
//            tLabelAddressList = [[UILabel alloc]initWithFrame:CGRectMake(50,0, self.tTableView1.bounds.size.width -70, 44)];
//            tLabelAddressList.tag = 102;
//            tLabelAddressList.textAlignment = NSTextAlignmentLeft;
//            [tLabelAddressList setLineBreakMode:NSLineBreakByWordWrapping];
//            [tLabelAddressList setNumberOfLines:0];
//            
//            [cell.contentView addSubview:tLabelAddressList];
//            
//            
//            
//            
//        }
//        else
//        {
//            tLabelOfAddress = (UILabel*)[cell.contentView viewWithTag:100];
//            tArrowsImageView = (UIImageView*)[cell.contentView viewWithTag:101];
//            tLabelAddressList = (UILabel*)[cell.contentView viewWithTag:102];
//            
//            
//        }
//        
//        
//        if(self.tTableView1.tag == 1)
//        {
//            if(indexPath.section == 0)
//            {
//                //            tArrowsImageView.hidden = NO;
//                //            tAddressImage.hidden = YES;
//                tLabelAddressList.hidden = YES;
//                tLabelOfAddress.hidden = NO;
//                TS_ParaAddress* tpara = [TS_ParaAddress new];
//                NSSortDescriptor *boolDescr = [[NSSortDescriptor alloc] initWithKey:@"tFirstProperty" ascending:NO selector:nil];
//                
//                // Combine the two
//                NSArray *sortDescriptors = @[boolDescr];
//                // Sort your array
//                tAddressArray=  [NSMutableArray arrayWithArray: [tAddressArray sortedArrayUsingDescriptors:sortDescriptors]] ;
//                tpara = [tAddressArray objectAtIndex:indexPath.row];
//                
//                tLabelOfAddress.text = tpara.taddress;
//                tLabelOfAddress.font = [UIFont systemFontOfSize:14.0f];
//                cell.backgroundColor = [tserverObj colorWithHexString:[tcolorArray objectAtIndex:indexPath.row%4]];
//                
//                
//            }
//            else if(indexPath.section == 1)
//            {
//                
//                //            tAddressImage.hidden = NO;
//                tArrowsImageView.hidden = YES;
//                tLabelOfAddress.hidden = YES;
//                tLabelAddressList.hidden = NO;
//                tLabelAddressList.text = [tShowAddressInPickerVIewArray objectAtIndex:indexPath.row];
//                tLabelAddressList.backgroundColor = [tserverObj colorWithHexString:@"c6efff"];
//                cell.backgroundColor = [tserverObj colorWithHexString:@"ffffff"];
//            }
//        }
//        
//    }
//    
//    else
//    {
//        static NSString *cellIdentifier = @"cellIdentifier2";
//        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//        UILabel* tLabelOfAddress2;
//        UIImageView* tAddressImage;
//        if(!cell)
//        {
//            cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//            tLabelOfAddress2 = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, self.tTableView1.bounds.size.width - 60,44)];
//            tLabelOfAddress2.tag = 963;
//            tLabelOfAddress2.textAlignment = NSTextAlignmentLeft;
//            [tLabelOfAddress2 setLineBreakMode:NSLineBreakByWordWrapping];
//            [tLabelOfAddress2 setNumberOfLines:0];
//            tLabelOfAddress2.textColor = [tserverObj colorWithHexString:@"052430"];
//            tLabelOfAddress2.font = [UIFont systemFontOfSize:12.0];
//            [cell.contentView addSubview:tLabelOfAddress2];
//            
//            tAddressImage = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,30,44)];
//            tAddressImage.tag = 104;
//            tAddressImage.image = [UIImage imageNamed:@"AddressPin.png"];
//            [tAddressImage setBackgroundColor:[tserverObj colorWithHexString:@"c6efff"]];
//            
//            [cell.contentView addSubview:tAddressImage];
//            
//        }
//        else
//        {
//            tLabelOfAddress2 = (UILabel*)[cell.contentView viewWithTag:963];
//            tAddressImage =(UIImageView*)[cell.contentView viewWithTag:104];
//        }
//        
//        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0,43,tableViewWordHelp.bounds.size.width,1)];
//        lineView1.backgroundColor = [tserverObj colorWithHexString:@"636363"];
//        [cell.contentView addSubview:lineView1];
//        
//        @try {
//            tLabelOfAddress2.text = [tShowAddressInPickerVIewArray objectAtIndex:indexPath.row];
//        }
//        @catch (NSException *exception)
//        {
//            NSLog(@"Exception in Cell=%@",exception);
//        }
//        @finally {
//            
//        }
//        
//        tLabelOfAddress2.backgroundColor = [tserverObj colorWithHexString:@"c6efff"];
//        cell.backgroundColor = [tserverObj colorWithHexString:@"ffffff"];
//        NSLog(@"SecondTVC");
//    }
//    
//    return cell;
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    
//    UIView *tHeaderViewSection=[[UIView alloc]initWithFrame:CGRectMake(10,5,tableView.layer.bounds.size.width, 60)];
//    if(tableView.tag == 1)
//    {
//        
//        //    UIButton* tBtnRouteButton;
//        UIButton* tBtnAddRoute;
//        
//        UILabel* tTextLabel;
//        //    UIImageView* timageView;
//        
//        UIButton* tShowRoutList;
//        //    UIButton *tAddressBtn;
//        
//        
//        UIButton* tBtncheckBox;
//        
//        
//        if(section == 0)
//        {
//            //        timageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,self.tTableView1.bounds.size.width, 60)];
//            
//            if(!tTextFieldOfRouteName)
//            {
//                if(tserverObj.tisRefreshView)
//                {
//                    tTextFieldOfRouteName = [[UITextField alloc]initWithFrame:CGRectMake(20,7, self.tTableView1.bounds.size.width - 80 , 44 )];
//                }
//                else
//                {
//                    tTextFieldOfRouteName = [[UITextField alloc]initWithFrame:CGRectMake(20,7, self.tTableView1.bounds.size.width - 80 , 44 )];
//                }
//                
//            }
//            
//            if(tserverObj.tisRefreshView)
//            {
//                
//                tShowRoutList = [[UIButton alloc]initWithFrame:CGRectMake(self.tTableView1.bounds.size.width - 65, 7, 40, 44)];
//            }
//            else
//            {
//                tShowRoutList = [[UIButton alloc]initWithFrame:CGRectMake(self.tTableView1.bounds.size.width - 65, 7, 40, 44)];
//            }
//            //        timageView.image = [UIImage imageNamed:@"BgImage.png"];
//            //        [tShowRoutList setBackgroundImage:[UIImage imageNamed:@"SavedRoutesIcon.png"] forState:UIControlStateNormal];
//            [tShowRoutList setImage:[UIImage imageNamed:@"SavedRoutesIcon.png"] forState:UIControlStateNormal];
//            [tShowRoutList addTarget:self action:@selector(tShowListOfSavedRoutes) forControlEvents:UIControlEventTouchUpInside];
//            tShowRoutList.layer.cornerRadius = 3.0f;
//            [tShowRoutList setBackgroundColor:[tserverObj colorWithHexString:@"39aad6"]];
//            
//            tTextFieldOfRouteName.backgroundColor = [tserverObj colorWithHexString:@"39aad6"];
//            
//            tTextFieldOfRouteName.textColor = [tserverObj colorWithHexString:@"ffffff"];
//            tTextFieldOfRouteName.placeholder = @"Enter route name";
//            tTextFieldOfRouteName.textAlignment = NSTextAlignmentCenter;
//            tTextFieldOfRouteName.layer.cornerRadius = 3.0f;
//            tTextFieldOfRouteName.tag = 1;
//            if(tserverObj.isSaveRoutes)
//            {
//                tTextFieldOfRouteName.text = tserverObj.tNameOfRoute;
//                NSLog(@"RouteName=%@",tserverObj.tNameOfRoute);
//                tTextFieldOfRouteName.userInteractionEnabled = NO;
//            }
//            else
//            {
//                
//                tTextFieldOfRouteName.userInteractionEnabled = YES;
//            }
//            
//            tHeaderViewSection.backgroundColor = [UIColor clearColor];
//            
//            [tHeaderViewSection addSubview:tShowRoutList];
//            [tHeaderViewSection addSubview:tTextFieldOfRouteName];
//            
//        }
//        else if(section == 1)
//        {
//            if(!tTextFieldOfAddress)
//            {
//                tTextFieldOfAddress = [[UITextField alloc]initWithFrame:CGRectMake(20, 5, self.tTableView1.bounds.size.width - 40, 44)];
//                
//            }
//            
//            tTextFieldOfAddress.backgroundColor = [UIColor lightGrayColor];
//            tTextFieldOfAddress.placeholder = @"Enter address here....";
//            [tTextFieldOfAddress setValue:[tserverObj colorWithHexString:@"636363"]
//                               forKeyPath:@"_placeholderLabel.textColor"];
//            tTextFieldOfAddress.tag = 2;
//            tTextFieldOfAddress.keyboardType = UIKeyboardTypeASCIICapable;
//            
//            tTextFieldOfAddress.layer.borderWidth = 0.5f;
//            tTextFieldOfAddress.layer.borderColor = [tserverObj colorWithHexString:@"8c8c8c"].CGColor;
//            if(!tTextFieldOfNotes)
//            {
//                tTextFieldOfNotes = [[UITextField alloc]initWithFrame:CGRectMake(20,55,self.tTableView1.bounds.size.width - 40, 88)];
//            }
//            tTextFieldOfAddress.backgroundColor = [tserverObj colorWithHexString:@"ffffff"];
//            tTextFieldOfAddress.delegate = self;
//            tTextFieldOfNotes.backgroundColor = [UIColor lightGrayColor];
//            tTextFieldOfNotes.placeholder = @"your note goes here....";
//            [tTextFieldOfNotes setValue:[tserverObj colorWithHexString:@"636363"]
//                             forKeyPath:@"_placeholderLabel.textColor"];
//            
//            tTextFieldOfNotes.layer.borderWidth = 0.5f;
//            tTextFieldOfNotes.layer.borderColor = [tserverObj colorWithHexString:@"8c8c8c"].CGColor;
//            tTextFieldOfNotes.backgroundColor = [tserverObj colorWithHexString:@"ffffff"];
//            tTextFieldOfNotes.tag = 3;
//            
//            UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
//            tTextFieldOfAddress.leftView = paddingView;
//            tTextFieldOfAddress.leftViewMode = UITextFieldViewModeAlways;
//            UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0,0, 5,20)];
//            tTextFieldOfNotes.leftView = paddingView2;
//            tTextFieldOfNotes.leftViewMode = UITextFieldViewModeAlways;
//            
//            tTextFieldOfAddress.layer.cornerRadius = 5.0f;
//            tTextFieldOfNotes.layer.cornerRadius = 5.0f;
//            [self tInitTextFieldData];
//            
//            
//            
//            tBtnAddRoute = [[UIButton alloc]initWithFrame:CGRectMake(TABLEWIDTH2 / 2 - (self.tTableView1.bounds.size.width/2)/2, 185,self.tTableView1.bounds.size.width/2,44)];
//            tBtnAddRoute.backgroundColor = [tserverObj colorWithHexString:@"39aad6"];
//            if(!tisEditRoute)
//            {
//                [tBtnAddRoute setTitle:@"Add to Route" forState:UIControlStateNormal];
//            }
//            else
//            {
//                [tBtnAddRoute setTitle:@"Edit Route" forState:UIControlStateNormal];
//            }
//            [tBtnAddRoute addTarget:self action:@selector(tAddrouteAddress :) forControlEvents:UIControlEventTouchUpInside];
//            //       UIColor blackColor
//            tBtnAddRoute.layer.cornerRadius = 3.0f;
//            
//            tBtncheckBox = [[UIButton alloc]initWithFrame:CGRectMake(20, 150, 20, 20)];
//            [tBtncheckBox addTarget:self action:@selector(tBtnActionOfCheckBox) forControlEvents:UIControlEventTouchUpInside];
//            
//            if(!tisCheckOrBox)
//            {
//                [tBtncheckBox setBackgroundImage:[UIImage imageNamed:@"box@3x.png"] forState:UIControlStateNormal];
//            }
//            else
//            {
//                [tBtncheckBox setBackgroundImage:[UIImage imageNamed:@"checkbox@3x.png"] forState:UIControlStateNormal];
//            }
//            
//            tTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(45,145,TABLEWIDTH2 / 2,30)];
//            tTextLabel.font = [UIFont systemFontOfSize:12.0f];
//            tTextLabel.text = @"Select as first property";
//            tTextLabel.textColor = [tserverObj colorWithHexString:@"636363"];
//            
//            
//            
//            
//            if(!isAddressList)
//            {
//                
//                [tHeaderViewSection addSubview:tBtncheckBox];
//                [tHeaderViewSection addSubview:tTextFieldOfNotes];
//                [tHeaderViewSection addSubview:tTextLabel];
//                [tHeaderViewSection addSubview:tBtnAddRoute];
//            }
//            
//            //        [tHeaderViewSection addSubview:tAddressBtn];
//            tHeaderViewSection.backgroundColor = [UIColor whiteColor];
//            [tHeaderViewSection addSubview:tTextFieldOfAddress];
//            
//            
//            
//            
//        }
//        
//      
//    }
//    return tHeaderViewSection;
//    
//    
//}
//
//#pragma mark-TOOLBAR AND TEXTFIELD DELEGATES
//
//-(BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    if(textField.tag == 1)
//    {
//        [tTextFieldOfAddress becomeFirstResponder];
//    }
//    else if(textField.tag == 2)
//    {
//        [tTextFieldOfNotes becomeFirstResponder];
//    }
//    else if(textField.tag == 3)
//    {
//        [tTextFieldOfNotes resignFirstResponder];
//        [self.view endEditing:YES];
//        if(moved) {
//            [self animateViewToPosition:self.view directionUP:NO];
//        }
//        moved = NO;
//        
//        
//        return NO;
//    }
//    return NO;
//}
//
//-(UIToolbar*)getToolbar :(int)tagNumber
//{
//    UIToolbar* keyboardToolbar;
//    
//    keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
//    //    [keyboardToolbar setBarStyle:UIBarStyleDefault];
//    keyboardToolbar.backgroundColor = [UIColor blueColor];
//    UIBarButtonItem *extraSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    //    UIBarButtonItem *next;
//    
//    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyboard)];
//    [done setTintColor:[UIColor whiteColor]];
//    
//    
//    if(tagNumber != 3)
//    {
//        UIBarButtonItem *next;
//        next   = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(nextTextField:)];
//        [next setTintColor:[UIColor whiteColor]];
//        next.tag = tagNumber;
//        [keyboardToolbar setItems:[[NSArray alloc] initWithObjects: done,extraSpace, next, nil]];
//    }else{
//        
//        [keyboardToolbar setItems:[[NSArray alloc] initWithObjects: extraSpace, done, nil]];
//    }
//    
//    
//    
//    return keyboardToolbar;
//}
//
//-(void)animateViewToPosition:(UIView *)viewToMove directionUP:(BOOL)up
//{
//    
//    
//    const int movementDistance = -135; // tweak as needed
//    const float movementDuration = 0.3f; // tweak as needed
//    
//    int movement = (up ? movementDistance : -movementDistance);
//    [UIView beginAnimations: @"animateTextField" context: nil];
//    [UIView setAnimationBeginsFromCurrentState: YES];
//    [UIView setAnimationDuration: movementDuration];
//    viewToMove.frame = CGRectOffset(viewToMove.frame, 0, movement);
//    [UIView commitAnimations];
//    
//}
//
//-(void)animateViewToPosition2:(UIView *)viewToMove directionUP:(BOOL)up
//{
//    const int movementDistance = -120; // tweak as needed
//    const float movementDuration = 0.3f; // tweak as needed
//    
//    int movement = (up ? movementDistance : -movementDistance);
//    [UIView beginAnimations: @"animateTextField" context: nil];
//    [UIView setAnimationBeginsFromCurrentState: YES];
//    [UIView setAnimationDuration: movementDuration];
//    viewToMove.frame = CGRectOffset(viewToMove.frame, 0, movement);
//    [UIView commitAnimations];
//}
//
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    if(textField.tag == 2)
//    {
//        if(tAddressArray.count > 1)
//        {
//            if(!moved)
//            {
//                
//                [self animateViewToPosition2:self.view directionUP:YES];
//                moved = YES;
//            }
//        }
//    }
//    else if(textField.tag == 3 )
//    {
//        if(!moved)
//        {
//            [self animateViewToPosition:self.view directionUP:YES];
//            moved = YES;
//        }
//    }
//    
//}
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    
//    
//    
//    NSLog(@"TEXT FIELD SHOULD END EDITING=%@",textField.text);
//    if(textField.tag == 2)
//    {
//        
//        if(tAddressArray.count > 1)
//        {
//            if(moved)
//            {
//                [self animateViewToPosition2:self.view directionUP:NO];
//                moved = NO;
//            }
//            
//        }
//        if(textField.text.length == 1)
//        {
//            isAddressList= false;
//            [tableViewWordHelp removeFromSuperview];
//            tableViewWordHelp = nil;
//        }
//        
//    }
//    else if(textField.tag == 3)
//    {
//        [self animateViewToPosition:self.view directionUP:NO];
//        moved = NO;
//    }
//    
//}
//
//-(BOOL)textFieldShouldClear:(UITextField *)textField
//{
//    NSLog(@"TExt Field Should clear");
//    
//    return YES;
//}
//
//-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
//{
//    
//    if(textField.text.length == 0)
//    {
//        [tableViewWordHelp removeFromSuperview];
//        tableViewWordHelp = nil;
//    }
//    return YES;
//}
//
//-(void)nextTextField:(UITextField*) sender
//{
//    if(sender.tag == 1)
//    {
//        [tTextFieldOfAddress becomeFirstResponder];
//    }
//    else if(sender.tag == 2)
//    {
//        
//        [tTextFieldOfNotes becomeFirstResponder];
//        
//        
//    }
//    else if(sender.tag == 3)
//    {
//        [tTextFieldOfNotes resignFirstResponder];
//        
//    }
//    
//}
//
//-(void)dismissKeyboard
//{
//    //    isAddressList = false;
//    [self.view endEditing:YES];
//    //    [self.tTableView1 reloadData];
//}
//
//
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    
//    if(textField.tag == 2)
//    {
//        
//        //        if(textField.text.length > 0)
//        //        {
//        NSLog(@"TextLength=%d",textField.text.length);
//        NSString *substring = [NSString stringWithString:textField.text];
//        substring = [substring stringByReplacingCharactersInRange:range withString:string];
//        //            tTextFieldOfAddress.text = substring;
//        //            NSLog(@"Text=%@",substring);
//        [self tData:substring :textField];
//        
//        //        }
//        if(textField.text.length == 1)
//        {
//            [tableViewWordHelp removeFromSuperview];
//            tableViewWordHelp = nil;
//        }
//        
//        
//    }
//    
//    return YES;
//}
//
//
//
//-(void)displayView :(UITextField*)sender
//{
//    CGPoint textFieldOriginInTableView = [sender convertPoint:sender.frame.origin toView:self.tTableView1];
//    
//    
//    
//    
//    if(!tableViewWordHelp)
//    {
//        int height;
//        if(textFieldOriginInTableView.y > self.tTableView1.bounds.size.height)
//        {
//            height = self.tTableView1.bounds.size.height;
//            
//        }else{
//            height = textFieldOriginInTableView.y + 35;
//        }
//        tableViewWordHelp = [[UITableView alloc]initWithFrame:CGRectMake(20, self.tTableView1.frame.origin.y + height, self.view.bounds.size.width - 40, 300)];
//        
//        
//        //        currentSender = sender;
//        tableViewWordHelp.tag = 700;
//        tableViewWordHelp.delegate = self;
//        tableViewWordHelp.dataSource = self;
//        tableViewWordHelp.backgroundColor = [UIColor clearColor];
//        [tableViewWordHelp registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
//        tableViewWordHelp.separatorStyle = UITableViewCellSelectionStyleNone;
//        [tableViewWordHelp reloadData];
//        [self.view addSubview:tableViewWordHelp];
//    }
//    else
//    {
//        [tableViewWordHelp reloadData];
//    }
//    
//    
//}
//
//
//
//-(void)tData:(NSString*)taddressString :(UITextField*)sender
//{
//    
//    [self displayView:sender];
//    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        // Add code here to do background processing
//        //
//        //
//        
//        if(tserverObj.isNetworkAvailable)
//        {
//            //        tTableViewofDropDownList.hidden = YES;
//            
//            
//            isAddressList = true;
//            NSString* address = taddressString;
//            
//            NSString *esc_addr =  [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            //        NSString *req = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=false", esc_addr];//http://maps.googleapis.com/maps/api/geocode/json?address=%@&components=country:USA&sensor=false
//            NSString *req = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&components=country:us&sensor=false", esc_addr];
//            /*Autocomplete API ORIGINAL COMMENTED BEACUSE OVER_QUERY_LIMIT DATE:JUNE_02
//             https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&components=country:us&sensor=false&key=AIzaSyA_YrKblffaJGykRDxYqCQqPUIJQEJtTqA
//             */
//            //https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&components=country:US&sensor=false&key=AIzaSyAD1Ej4W85i2phlyUgfL1XB4a5d29I8qDA
//            //http://maps.googleapis.com/maps/api/geocode/json?address=%@&components=country:USA&sensor=false     //original API
//            //https://maps.googleapis.com/maps/api/place/autocomplete/json?address=%@&components=country:USA&sensor=false
//            NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
//            
//            NSDictionary *dictionary;
//            NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
//            if(data != nil)
//            {
//                dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//            }
//            
//            NSDictionary* tdict;// = [dictionary valueForKey:@"results"];
//            
//            
//            @try {
//                tdict = [dictionary valueForKey:@"results"];//predictions
//                
//                tShowAddressInPickerVIewArray = [tdict valueForKey:@"formatted_address"] ;// description
//                NSDictionary* tdict2 = [tdict valueForKey:@"geometry"];
//                NSDictionary* tdict3 = [tdict2 valueForKey:@"location"];
//                tLatituedArray = [tdict3 valueForKey:@"lat"];
//                tLongitudeArray = [tdict3 valueForKey:@"lng"];
//                NSLog(@"Result=%@",tdict);
//                //            NSLog(@"Dict2=%@\nArrayOfLat=%@\nLong=%@",tdict3,tLatituedArray,tLongitudeArray);
//                
//                
//            }
//            @catch (NSException *exception) {
//                NSLog(@"@@@@@@@@@@@@@@@@@@@@@@Exceptiopn=%@",exception);
//            }
//            @finally
//            {
//                
//            }
//            
//            
//        }
//        else
//        {
//            UIAlertView * talertObj =[[UIAlertView alloc]initWithTitle:@"Warning" message:@"No Internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            talertObj.tag = 123;
//        }
//        
//        
//        dispatch_async( dispatch_get_main_queue(), ^{
//            // Add code here to update the UI/send notifications based on the
//            // results of the background processing
//            @try {
//                [tableViewWordHelp reloadData];
//            }
//            @catch (NSException *exception) {
//                NSLog(@"@@@@@@@@@@@@@@@@@@@@@Exception=%@",exception);
//            }
//            @finally {
//                
//            }
//            
//            
//        });
//    });
//    
//}
//
//@end
