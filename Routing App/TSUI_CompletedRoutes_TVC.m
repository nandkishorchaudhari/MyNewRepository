//
//  TSUI_CompletedRoutes_TVC.m
//  Routing App
//
//  Created by TacktileSystemsMac4 on 05/06/15.
//  Copyright (c) 2015 Tacktile Systems. All rights reserved.
//

#import "TSUI_CompletedRoutes_TVC.h"
#import "TS_ServerClass.h"
#import "TS_ParaAddress.h"
#import "TS_ParaRouteName.h"
#import "TS_DBLayer.h"


@interface TSUI_CompletedRoutes_TVC ()
{
    NSMutableArray* taddressArrayList;
}

@end

@implementation TSUI_CompletedRoutes_TVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tMenuBtn.target = self.revealViewController;
    self.tMenuBtn.action = @selector(revealToggle:);
    
    self.title = @"Completed Routes";
    
    taddressArrayList = [NSMutableArray new];
    TS_DBLayer* tdb = [TS_DBLayer new];
    taddressArrayList = [tdb tRetrieveCompletedRoutesList];
    NSLog(@"CountOfCompletedRoute=%lu",(unsigned long)taddressArrayList.count);
    
    
    //ADD PAN GESTURE TO VIEW SO THAT THE VIEW CAN SHOW MENU WHEN THERE IS A PAN ON THE VIEW
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.bounds.size.width, 22)];
    TS_ServerClass * tserObj = [TS_ServerClass tsharedInstance];
    statusBarView.backgroundColor = [tserObj colorWithHexString:@"39aad6"];
    
    [self.navigationController.navigationBar addSubview:statusBarView];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;//
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

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



@end
