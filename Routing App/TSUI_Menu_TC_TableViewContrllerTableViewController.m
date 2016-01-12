//
//  TSUI_Menu_TC_TableViewContrllerTableViewController.m
//  Routing App
//
//  Created by TacktileSystemsMac4 on 22/05/15.
//  Copyright (c) 2015 Tacktile Systems. All rights reserved.
//

#import "TSUI_Menu_TC_TableViewContrllerTableViewController.h"
#import "TS_ServerClass.h"

@interface TSUI_Menu_TC_TableViewContrllerTableViewController ()
{
    //ARRAY  FOR MENUS
    NSArray* tArray;
}
@end

@implementation TSUI_Menu_TC_TableViewContrllerTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    TS_ServerClass* tserverObj = [TS_ServerClass tsharedInstance];
    
    //INITIALISE ARRAY
    tArray = @[@"Home",@"Completed Routes",@"Saved Routes",@"Settings"];
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.bounds.size.width, 22)];
    TS_ServerClass * tserObj = [TS_ServerClass tsharedInstance];
    statusBarView.backgroundColor = [tserObj colorWithHexString:@"39aad6"];
    
    [self.navigationController.navigationBar addSubview:statusBarView];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;//UIStatusBarStyleLightContent;
    
    self.tableView.backgroundColor = [tserObj colorWithHexString:@"26292d"];
//    self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 PURPOSE : DATA SOURCE AND DELEGATES OF TABLE VIEW CONROLLER
 DEVELOPED BY : MADHURI
 DATE : 22 MAY
 STATUS : OK
 */

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // RETURN THE NUMBER OF MENU.
    return [tArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 4)
    {
        return 600;
    }
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  
    UILabel* tMenuText;
    UIImageView* timageView;
    
    if(!cell)
    {
        //IF CELL NOT INITIALISED, INITIALISE IT
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        tMenuText = [[UILabel alloc]initWithFrame:CGRectMake(60,10, self.tableView.bounds.size.width - 40, 44)];
        tMenuText.textColor = [UIColor whiteColor];
        tMenuText.tag = 1;
        [cell.contentView addSubview:tMenuText];
        
        timageView = [[UIImageView alloc]initWithFrame:CGRectMake(30,20,20,20)];
        timageView.tag = 2;
        [cell.contentView addSubview:timageView];
    }
    else
    {
        tMenuText = (UILabel*)[cell.contentView viewWithTag:1];
        timageView = (UIImageView*)[cell.contentView viewWithTag:2];
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 59,self.tableView.bounds.size.width - 100, 1)];
    TS_ServerClass* tserverObj = [TS_ServerClass tsharedInstance];
    lineView.backgroundColor = [tserverObj colorWithHexString:@"44494e"];
    [cell.contentView addSubview:lineView];
    
    tMenuText.text = [tArray objectAtIndex:indexPath.row];
    
    if(indexPath.row == 0)
    {
        timageView.image = [UIImage imageNamed:@"Home.png"];
    }
    else if(indexPath.row == 1)
    {
        timageView.image = [UIImage imageNamed:@"CompletedRoutes.png"];
    }
    else if(indexPath.row == 2)
    {
        timageView.image = [UIImage imageNamed:@"SavedRoutes.png"];
    }
    else if(indexPath.row == 3)
    {
        timageView.image = [UIImage imageNamed:@"SettingInfo.png"];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    // Configure the cell...
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tHeaderViewSection=[[UIView alloc]initWithFrame:CGRectMake(10,5,tableView.layer.bounds.size.width, 60)];
    TS_ServerClass* tserverObj = [TS_ServerClass tsharedInstance];
//    [tHeaderViewSection setBackgroundColor:[tserverObj colorWithHexString:@"26292d"]];
    tHeaderViewSection.backgroundColor = [UIColor clearColor];
     return tHeaderViewSection;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SWRevealViewController *revealController = self.revealViewController;
    
    UIViewController *newFrontController = nil;
    
#warning add home button at top
    TS_ServerClass* tserverObj = [TS_ServerClass tsharedInstance];
    tserverObj.tisRefreshView = true;
    tserverObj.tisRefreshHomeRouterView = true;
    tserverObj.tisEditRouteOrNot = false;
    if(indexPath.row == 0)
    {
        
        newFrontController =[self.storyboard instantiateViewControllerWithIdentifier:@"Home"];
    }
   else if(indexPath.row == 1)
    {
        newFrontController =[self.storyboard instantiateViewControllerWithIdentifier:@"Completed Route"];
    }
    else if(indexPath.row == 2)
    {
        //FIRST HAVE TO ASSIGN THE STORYBOARD ID OF THIS VIEW AS red
        newFrontController = [self.storyboard instantiateViewControllerWithIdentifier:@"red"];
    }
    else if(indexPath.row == 3)
    {
        //FIRST HAVE TO ASSIGN THE STORYBOARD ID OF THIS VIEW AS blue
        newFrontController = [self.storyboard instantiateViewControllerWithIdentifier:@"blue"];
    }
 
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newFrontController];
    [revealController pushFrontViewController:navigationController animated:YES];
}

#pragma mark - Navigation
/*
 PURPOSE : NAVIGATE TO THE PROPER VIEW CONTROLLER WHEN THE SEGUE IS OF REVEALVIEWCONTROLLER
 DEVELOPED BY : MADHURI
 DATE : 22 MAY
 STATUS : OK
 */

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender

{
    //COPY AND PAST THIS AS IT IS, IT HANDLES THE NAVIGATION WHEN THE SEGUE IS OF TYPE REVEAL VIEW CONTROLLER
    
    if([segue isKindOfClass:[SWRevealViewControllerSegue class]])
    {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*)segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc)
        {
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            
            [navController setViewControllers:@[dvc] animated:NO];
            [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
        };
    }
}


@end
