//
//  TSUI_CompletedRoutes_VC.m
//  Routing App
//
//  Created by TacktileSystemsMac4 on 22/05/15.
//  Copyright (c) 2015 Tacktile Systems. All rights reserved.
//

#import "TSUI_CompletedRoutes_VC.h"
#import "SWRevealViewController.h"
#import "TS_ServerClass.h"

@interface TSUI_CompletedRoutes_VC ()

@end

@implementation TSUI_CompletedRoutes_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tMenuBtn.target = self.revealViewController;
    self.tMenuBtn.action = @selector(revealToggle:);
    
    self.title = @"Completed Routes";
    
    //ADD PAN GESTURE TO VIEW SO THAT THE VIEW CAN SHOW MENU WHEN THERE IS A PAN ON THE VIEW
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.bounds.size.width, 22)];
    TS_ServerClass * tserObj = [TS_ServerClass tsharedInstance];
    statusBarView.backgroundColor = [tserObj colorWithHexString:@"39aad6"];
    
    [self.navigationController.navigationBar addSubview:statusBarView];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;//UIStatusBarStyleLightContent;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
