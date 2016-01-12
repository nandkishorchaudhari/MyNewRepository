//
//  TSUI_SavedRoutes_TVC.m
//  Routing App
//
//  Created by TacktileSystemsMac4 on 09/05/15.
//  Copyright (c) 2015 Tacktile Systems. All rights reserved.
//

#import "TSUI_SavedRoutes_TVC.h"
#import "TS_DBLayer.h"
#import "TS_ServerClass.h"
#import "TS_ParaAddress.h"
#import "TS_ParaRouteName.h"

@interface TSUI_SavedRoutes_TVC ()
{
    NSMutableArray* taddressArrayList;
}
@end

@implementation TSUI_SavedRoutes_TVC

#pragma mark-VIEW DELEGATES

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tMenuBtn.target = self.revealViewController;
    self.tMenuBtn.action = @selector(revealToggle:);
    
    //ADD PAN GESTURE TO VIEW SO THAT THE VIEW CAN SHOW MENU WHEN THERE IS A PAN ON THE VIEW
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.title = @"Saved Routes";
    taddressArrayList = [NSMutableArray new];
    TS_DBLayer* tdb = [TS_DBLayer new];
    taddressArrayList = [tdb tRetrieveSaveRoutesList];
    self.navigationItem.hidesBackButton = YES;
//    self.navigationItem.rightBarButtonItem = [self tLogicToAddLeftButton];
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.bounds.size.width, 22)];
    TS_ServerClass * tserObj = [TS_ServerClass tsharedInstance];
    statusBarView.backgroundColor = [tserObj colorWithHexString:@"39aad6"];
    
    [self.navigationController.navigationBar addSubview:statusBarView];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;//UIStatusBarStyleLightContent;

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TABLE VIEW DELEGATES

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return taddressArrayList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    static NSString *cellIdentifier = @"cellIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UIImageView* tImageView;
    UILabel* tTextLabel;
    UIButton* button1;
    
    if(!cell)
    {
        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        tTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(80,5,self.tableView.bounds.size.width/2, 44)];
        tTextLabel.tag = 1;
        tTextLabel.font = [UIFont systemFontOfSize:15.0f];
        
        [cell.contentView addSubview:tTextLabel];
        
        tImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 40,40)];
        tImageView.tag = 2;
        tImageView.image = [UIImage imageNamed:@"settings.png"];
        
        [cell.contentView addSubview:tImageView];
        button1 = [[UIButton alloc]initWithFrame:CGRectMake(0,0, 20,20)];
        [button1 setTitle:@"5 mint" forState:UIControlStateNormal];
        
    }
    else
    {
        tTextLabel = (UILabel*)[cell.contentView viewWithTag:1];
        tImageView = (UIImageView*)[cell.contentView viewWithTag:2];
    }
    TS_ServerClass* tserverObj = [TS_ServerClass tsharedInstance];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59,self.tableView.bounds.size.width, 1)];
    lineView.backgroundColor = [tserverObj colorWithHexString:@"9c9c9c"];
    
//    [lineView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
//    [lineView.layer setBorderWidth:1.5f];
//    
//    // drop shadow
//    [lineView.layer setShadowColor:[UIColor blackColor].CGColor];
//    [lineView.layer setShadowOpacity:0.8];
//    [lineView.layer setShadowRadius:3.0];
//    [lineView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    [cell.contentView addSubview:lineView];
     [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    TS_ParaRouteName* tpara = [TS_ParaRouteName new];
    tpara = [taddressArrayList objectAtIndex:indexPath.row];
    tTextLabel.text = tpara.trouteName;
   
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TS_ServerClass* tserverObj = [TS_ServerClass tsharedInstance];
    
    TS_ParaRouteName* tpara = [TS_ParaRouteName new];
    tpara = [taddressArrayList objectAtIndex:indexPath.row];
    tserverObj.tNameOfRoute = tpara.trouteName;
    tserverObj.tSelectedRoute = tpara.tdbid;
    NSLog(@"NameOfRoute=%@",tserverObj.tNameOfRoute);
    tserverObj.isSaveRoutes = true;
    tserverObj.isSavedRouteOrNot = TRUE;
    tserverObj.tisRefreshHomeRouterView = false;
//    [self.navigationController popViewControllerAnimated:YES];
    [self performSegueWithIdentifier:@"segueBack" sender:self];
    

}

#pragma mark-LOGICAL METHOD

-(UIBarButtonItem*)tLogicToAddLeftButton
{
    UIImage *buttonImage;
    buttonImage = [UIImage imageNamed:@"new_back_button@3x.png"];
    
    
    
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
-(void)tBtnBackEvent
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
