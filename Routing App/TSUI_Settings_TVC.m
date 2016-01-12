//
//  TSUI_Settings_TVC.m
//  Routing App
//
//  Created by TacktileSystemsMac4 on 13/05/15.
//  Copyright (c) 2015 Tacktile Systems. All rights reserved.
//

#import "TSUI_Settings_TVC.h"
#import "TS_ServerClass.h"
#import "TS_ParaSort.h"

@interface TSUI_Settings_TVC ()
{
    TS_ServerClass* tserverObj;
    double tTotalDistance;
    double tTotalTimeOfRoute;
    BOOL isBtnOnOff;
    BOOL isReceiptOnOff;
    int isSelectTimeDuration;
    UIButton* button1;
    UIButton* button2;
    UIButton* button3;
    UIButton* button4;
    UIButton* button5;
    UIButton* button6;
    UITextField* tEmailArressTextField;
    
}
@end

@implementation TSUI_Settings_TVC

- (void)viewDidLoad
{
     [super viewDidLoad];
    self.tMenuBtn.target = self.revealViewController;
    self.tMenuBtn.action = @selector(revealToggle:);
    
    //ADD PAN GESTURE TO VIEW SO THAT THE VIEW CAN SHOW MENU WHEN THERE IS A PAN ON THE VIEW
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
   
    self.title = @"Settings";
    tserverObj = [TS_ServerClass tsharedInstance];
    [self tInitData];
    self.navigationItem.hidesBackButton = YES;
//    self.navigationItem.rightBarButtonItem = [self tLogicToAddLeftButton];
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.bounds.size.width, 22)];
    TS_ServerClass * tserObj = [TS_ServerClass tsharedInstance];
    statusBarView.backgroundColor = [tserObj colorWithHexString:@"39aad6"];
    
    [self.navigationController.navigationBar addSubview:statusBarView];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;//UIStatusBarStyleLightContent;
    
    UIImageView* timage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"BgImage.png"]];
    [self.tableView setBackgroundView:timage];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    NSUserDefaults* tdefaultObj = [NSUserDefaults standardUserDefaults];
    [tdefaultObj setObject:tEmailArressTextField.text forKey:@"EmailId"];
}


#pragma mark - TABLE VIEW DELEGATES
-(void)tInitDrawLine
{
    
}
-(void)tInitData
{
    tTotalDistance = 0;
    tTotalTimeOfRoute = 0;
    
    for(int i=0;i< tserverObj.tTotalTimeAndDistance.count;i++)
    {
        TS_ParaSort* tpara = [TS_ParaSort new];
        tpara = [tserverObj.tTotalTimeAndDistance objectAtIndex:i];
        tTotalDistance = tTotalDistance + tpara.tdistance;
        tTotalTimeOfRoute = tTotalTimeOfRoute + tpara.tTravelTime;
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 120;
    }
    else if(section == 1)
    {
        return 90;
    }
    else if(section == 2)
    {
        return 80;
    }
    else if(section == 3)
    {
        return 88;
    }
    else if(section == 4)
    {
        return 60;
    }
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    NSLog(@"Total Count of Array = %lu",(unsigned long)tserverObj.tTotalTimeAndDistance.count);
    // Return the number of rows in the section.
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell;
    static NSString *cellIdentifier = @"cellIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    UILabel* tTextLabel;
//    UILabel* ttotalDistance;
//    UIButton* button1;
//    UIButton* button2;
//    UIButton* button3;
//    UIButton* button4;
//    UIButton* button5;
//    
//    if(!cell)
//    {
//        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//        tTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,0,self.tableView.bounds.size.width / 2,30)];
//        tTextLabel.tag = 1;
//        
//        ttotalDistance = [[UILabel alloc]initWithFrame:CGRectMake(10,35,self.tableView.bounds.size.width , 30)];
//        ttotalDistance.tag = 2;
//        
//        button1 = [[UIButton alloc]initWithFrame:CGRectMake(10,65,30,30)];
//        [button1 setTitle:@"5 mint" forState:UIControlStateNormal];
//        button1.tag = 3;
//        
//        [cell.contentView addSubview:button1];
//        
//        button2 = [[UIButton alloc]initWithFrame:CGRectMake(60,65,30,30)];
//        [button2 setTitle:@"10 mint" forState:UIControlStateNormal];
//        button2.tag = 4;
//        [cell.contentView addSubview:button2];
//        
//        button3 = [[UIButton alloc]initWithFrame:CGRectMake(110,65,30,30)];
//        [button3 setTitle:@"15 mint" forState:UIControlStateNormal];
//        button3.tag = 5;
//        [cell.contentView addSubview:button3];
//        
//        button4 = [[UIButton alloc]initWithFrame:CGRectMake(160,65,30,30)];
//        [button4 setTitle:@"20 mint" forState:UIControlStateNormal];
//        button4.tag = 6;
//        [cell.contentView addSubview:button4];
//        
//        button5 = [[UIButton alloc]initWithFrame:CGRectMake(210,65,30,30)];
//        [button5 setTitle:@"20 mint" forState:UIControlStateNormal];
//        button5.tag = 7;
//        [cell.contentView addSubview:button5];
//        
//        [cell.contentView addSubview:tTextLabel];
//        [cell.contentView addSubview:ttotalDistance];
//        
//        
//        
//    }
//    else
//    {
//        tTextLabel = (UILabel*)[cell.contentView viewWithTag:1];
//        ttotalDistance = (UILabel*)[cell.contentView viewWithTag:2];
//        button1 = (UIButton*)[cell.contentView viewWithTag:3];
//        button2 = (UIButton*)[cell.contentView viewWithTag:4];
//        button3 = (UIButton*)[cell.contentView viewWithTag:5];
//        button4 = (UIButton*)[cell.contentView viewWithTag:6];
//        button5 = (UIButton*)[cell.contentView viewWithTag:7];
//    }
//    
//    tTextLabel.text = @"Choess duration :";
 
    
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tHeaderViewSection=[[UIView alloc]initWithFrame:CGRectMake(10,5,tableView.layer.bounds.size.width, 60)];
    UILabel* tTextLabel;
    UILabel* tTextLabel2;
    UILabel* tTextLabelOfnotes;
    UILabel* tTextLabelOfnotes2;
    UIButton* tBtnOnOff;
    UIImageView* tImageView;
    UILabel* tTextLabel3;
    UILabel* tTextLabel4;
    UIButton* tBtnOnOff2;
    UILabel* tTextLabelOfemail;
    

    
   
    
    
    if(section == 0)
    {
        tImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10,9,20,20)];
        tImageView.image = [UIImage imageNamed:@"Clock.png"];
        tHeaderViewSection.backgroundColor = [UIColor whiteColor];
        [tHeaderViewSection addSubview: tImageView];
        tTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(35,5,self.tableView.bounds.size.width / 2,30)];
        tTextLabel.text = @"Choose duration :";
        tTextLabel.tag = 1;
        
        [tHeaderViewSection addSubview:tTextLabel];
        tTextLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(35,30,self.tableView.bounds.size.width , 30)];
        tTextLabel2.tag = 2;
        tTextLabel2.text = @"How long will you spend at each property";
        tTextLabel2.textColor = [tserverObj colorWithHexString:@"3f3f3f"];
        tTextLabel2.font = [UIFont systemFontOfSize:12.0f];
        
        [tHeaderViewSection addSubview: tTextLabel2];
        
//        button1 = [[UIButton alloc]initWithFrame:CGRectMake(20,65,40,40)];
        button1 = [[UIButton alloc]initWithFrame:CGRectMake(15,65,35,35)];
        button1.titleLabel.textAlignment = NSTextAlignmentCenter;
        button1.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;

        [button1 setTitle:@"05  min" forState:UIControlStateNormal];

        button1.titleLabel.font = [UIFont systemFontOfSize : 11.0f];
        
        
        
        [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if(!tserverObj.isSettingButtonPressedOrNot)
        {
        button1.backgroundColor = [tserverObj colorWithHexString:@"39aad6"];
        }
        else
        {
            [self tIsButtonPressed];
        }
        button1.layer.cornerRadius = button1.bounds.size.width/2.0f;
        button1.tag = 3;
        
        [button1 addTarget:self action:@selector(tBtnAction :) forControlEvents:UIControlEventTouchUpInside];
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(44, 80,(((TABLEWIDTH/6)-7)*5), 5)];
        lineView1.backgroundColor = [tserverObj colorWithHexString:@"636363"];
        [tHeaderViewSection addSubview:lineView1];
        
        [tHeaderViewSection addSubview:button1];
       
       
        
//        button2 = [[UIButton alloc]initWithFrame:CGRectMake(70,65,40,40)];
        button2 = [[UIButton alloc]initWithFrame:CGRectMake(((TABLEWIDTH/6)-7)+20,65,35,35)];
        button2.titleLabel.textAlignment = NSTextAlignmentCenter;
        button2.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        button2.titleLabel.font = [UIFont systemFontOfSize : 11.0f];

       

        [button2 setTitle:@"10  min" forState:UIControlStateNormal];

        button2.tag = 4;
        
        button2.layer.cornerRadius = button2.bounds.size.width/2.0f;
        if(!tserverObj.isSettingButtonPressedOrNot)
        {
         button2.backgroundColor = [tserverObj colorWithHexString:@"636363"];
        }
        else
        {
            [self tIsButtonPressed];
        }
        [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button2 addTarget:self action:@selector(tBtnAction :) forControlEvents:UIControlEventTouchUpInside];
        [tHeaderViewSection addSubview:button2];
        
        
//        button3 = [[UIButton alloc]initWithFrame:CGRectMake(120,65,40,40)];
        button3 = [[UIButton alloc]initWithFrame:CGRectMake((((TABLEWIDTH/6)-7)*2) + 25,65,35,35)];
        button3.titleLabel.textAlignment = NSTextAlignmentCenter;
        button3.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        button3.titleLabel.font = [UIFont systemFontOfSize : 11.0f];
        [button3 setTitle:@"15  min" forState:UIControlStateNormal];
       
        button3.tag = 5;
        button3.layer.cornerRadius = button3.bounds.size.width/2.0f;
        if(!tserverObj.isSettingButtonPressedOrNot)
        {
         button3.backgroundColor = [tserverObj colorWithHexString:@"636363"];
        }else
        {
            [self tIsButtonPressed];
        }
        [button3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button3 addTarget:self action:@selector(tBtnAction :) forControlEvents:UIControlEventTouchUpInside];
        [tHeaderViewSection addSubview:button3];
        
//        button4 = [[UIButton alloc]initWithFrame:CGRectMake(170,65,40,40)];
         button4 = [[UIButton alloc]initWithFrame:CGRectMake((((TABLEWIDTH/6)-7) * 3) + 30,65,35,35)];
        button4.titleLabel.textAlignment = NSTextAlignmentCenter;
        button4.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        button4.titleLabel.font = [UIFont systemFontOfSize : 11.0f];
        [button4 setTitle:@"20  min" forState:UIControlStateNormal];
        button4.tag = 6;
        button4.layer.cornerRadius = button4.bounds.size.width/2.0f;
       
        if(!tserverObj.isSettingButtonPressedOrNot)
        {
         button4.backgroundColor = [tserverObj colorWithHexString:@"636363"];
        }
        else
        {
            [self tIsButtonPressed];
        }
        [button4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button4 addTarget:self action:@selector(tBtnAction :) forControlEvents:UIControlEventTouchUpInside];
        [tHeaderViewSection addSubview:button4];
        
//        button5 = [[UIButton alloc]initWithFrame:CGRectMake(220,65,40,40)];
         button5 = [[UIButton alloc]initWithFrame:CGRectMake((((TABLEWIDTH/6)-7) * 4) + 35,65,35,35)];
        button5.titleLabel.textAlignment = NSTextAlignmentCenter;
        button5.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        button5.titleLabel.font = [UIFont systemFontOfSize : 11.0f];
        [button5 setTitle:@"25  min" forState:UIControlStateNormal];
        button5.tag = 7;
        button5.layer.cornerRadius = button5.bounds.size.width/2.0;
   
        if(!tserverObj.isSettingButtonPressedOrNot)
        {
         button5.backgroundColor = [tserverObj colorWithHexString:@"636363"];
        }
        else
        {
            [self tIsButtonPressed];
        }
        [button5 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button5 addTarget:self action:@selector(tBtnAction :) forControlEvents:UIControlEventTouchUpInside];
        
        [tHeaderViewSection addSubview:button5];
        
        button6 = [[UIButton alloc]initWithFrame:CGRectMake((((TABLEWIDTH/6)-7) * 5) + 40,65,35,35)];
        button6.titleLabel.textAlignment = NSTextAlignmentCenter;
        button6.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        button6.titleLabel.font = [UIFont systemFontOfSize : 11.0f];
        [button6 setTitle:@"30  min" forState:UIControlStateNormal];
        button6.tag = 88;
        button6.layer.cornerRadius = button6.bounds.size.width/2.0;
        if(!tserverObj.isSettingButtonPressedOrNot)
        {
            button6.backgroundColor = [tserverObj colorWithHexString:@"636363"];
        }
        else
        {
            [self tIsButtonPressed];
        }
        [button6 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button6 addTarget:self action:@selector(tBtnAction :) forControlEvents:UIControlEventTouchUpInside];
        [tHeaderViewSection addSubview:button6];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 110,self.tableView.bounds.size.width, 1)];
        lineView.backgroundColor = [tserverObj colorWithHexString:@"9c9c9c"];
        [tHeaderViewSection addSubview:lineView];
        
        

    }
    else if(section == 1)
    {
        
        tTextLabelOfnotes = [[UILabel alloc]initWithFrame:CGRectMake(10,10,self.tableView.bounds.size.width - 100 , 30)];
        tTextLabelOfnotes.text = @"Notes pop-up:";
        tHeaderViewSection.backgroundColor = [UIColor whiteColor];
        [tHeaderViewSection addSubview:tTextLabelOfnotes];
        
        tTextLabelOfnotes2 = [[UILabel alloc]initWithFrame:CGRectMake(10,35,self.tableView.bounds.size.width - 100 , 30)];
        tTextLabelOfnotes2.textAlignment = NSTextAlignmentLeft;
        [tTextLabelOfnotes2 setLineBreakMode:NSLineBreakByWordWrapping];
        [tTextLabelOfnotes2 setNumberOfLines:0];
        tTextLabelOfnotes2.text = @"Notes will pop up as you arrive at each property";
        tTextLabelOfnotes2.font = [UIFont systemFontOfSize:12.0f];
        tTextLabelOfnotes2.textColor = [tserverObj colorWithHexString:@"3f3f3f"];
       
        [tHeaderViewSection addSubview:tTextLabelOfnotes2];
        
        tBtnOnOff = [[UIButton alloc]initWithFrame:CGRectMake(self.tableView.bounds.size.width - 60,25,44,28)];
        tBtnOnOff.tag = 10;
        if(!tserverObj.isNotesOnOff)
        {
        [tBtnOnOff setBackgroundImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
        }
        else
        {
            [tBtnOnOff setBackgroundImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
        }
        
        [tBtnOnOff addTarget:self action:@selector(tBtnActionOfOnOff:) forControlEvents:UIControlEventTouchUpInside];
        [tHeaderViewSection addSubview:tBtnOnOff];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 89,self.tableView.bounds.size.width, 1)];
        lineView.backgroundColor = [tserverObj colorWithHexString:@"9c9c9c"];
        [tHeaderViewSection addSubview:lineView];
        
        
    }

    else if(section == 2)
    {
        tTextLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(10,5,self.tableView.bounds.size.width - 100 , 30)];
        tTextLabel3.text = @"Receipt:";
        tTextLabel3.tag = 12;
        
        
        tHeaderViewSection.backgroundColor = [UIColor whiteColor];
        
        [tHeaderViewSection addSubview:tTextLabel3];
        
       
        
        tTextLabel4 = [[UILabel alloc]initWithFrame:CGRectMake(10,30,self.tableView.bounds.size.width - 100 , 30)];
        tTextLabel4.text = @"Send receipt after completing routes";
        tTextLabel4.textAlignment = NSTextAlignmentLeft;
        [tTextLabel4 setLineBreakMode:NSLineBreakByWordWrapping];
        [tTextLabel4 setNumberOfLines:0];
        tTextLabel4.font = [UIFont systemFontOfSize:12.0f];
        tTextLabel4.textColor = [tserverObj colorWithHexString:@"3f3f3f"];
        tTextLabel4.tag = 13;
        [tHeaderViewSection addSubview:tTextLabel4];
        
        tBtnOnOff2 = [[UIButton alloc]initWithFrame:CGRectMake(self.tableView.bounds.size.width - 60,24,44,28)];
        tBtnOnOff2.tag = 14;
      
        if(!tserverObj.isReceiptOnOff)
        {
            [tBtnOnOff2 setBackgroundImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
        }
        else
        {
            [tBtnOnOff2 setBackgroundImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
        }
        
        [tBtnOnOff2 addTarget:self action:@selector(tBtnActionOfOnOff2:) forControlEvents:UIControlEventTouchUpInside];
        [tHeaderViewSection addSubview:tBtnOnOff2];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 79,self.tableView.bounds.size.width, 1)];
        lineView.backgroundColor = [tserverObj colorWithHexString:@"9c9c9c"];
        [tHeaderViewSection addSubview:lineView];
    }
    
//    tHeaderViewSection.backgroundColor = [UIColor lightGrayColor];
//    [tHeaderViewSection addSubview:lineView];
    
    else if(section == 3)
    {
        tTextLabelOfemail = [[UILabel alloc]initWithFrame:CGRectMake(10,8 ,self.tableView.bounds.size.width - 20,30)];
        
        tTextLabelOfemail.text = @"Email Receipt :";
        tTextLabelOfemail.tag = 9874;
        
        
        if(!tEmailArressTextField)
        {
            tEmailArressTextField = [[UITextField alloc]initWithFrame:CGRectMake(10,38,self.tableView.bounds.size.width - 20,44)];
            
        }
        
        NSUserDefaults* tdefaultObj = [NSUserDefaults standardUserDefaults];
        tEmailArressTextField.text = [tdefaultObj valueForKey:@"EmailId"];
        
        tEmailArressTextField.placeholder = @"Enter email address";
        tEmailArressTextField.tag = 12321;
        tEmailArressTextField.delegate = self;
        tEmailArressTextField.layer.cornerRadius = 2.0f;
        tEmailArressTextField.layer.borderWidth = 0.5f;
        tEmailArressTextField.layer.borderColor = [tserverObj colorWithHexString:@"8c8c8c"].CGColor;
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
        tEmailArressTextField.leftView = paddingView;
        tEmailArressTextField.leftViewMode = UITextFieldViewModeAlways;
        tEmailArressTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        tEmailArressTextField.returnKeyType = UIReturnKeyDone;
//        tEmailArressTextField.k
        [tHeaderViewSection addSubview:tEmailArressTextField];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 87,self.tableView.bounds.size.width, 1)];
        lineView.backgroundColor = [tserverObj colorWithHexString:@"9c9c9c"];
        
        tHeaderViewSection.backgroundColor = [UIColor whiteColor];
        [tHeaderViewSection addSubview:tTextLabelOfemail];
        [tHeaderViewSection addSubview:lineView];
 
    }
    
     return tHeaderViewSection;
    
}

#pragma mark-ACTION
-(void)tBtnAction :(UIButton*)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
     NSUserDefaults* tdefaultObj = [NSUserDefaults standardUserDefaults];
    if(indexPath.section == 0)
    {
        tserverObj.isSettingButtonPressedOrNot = true;
    if(sender.tag == 3)
    {
        tserverObj.tisButtonPressedOrNot = 1;
        tserverObj.tisStopTimeOfEachProperty = 5;
        NSNumber* tStopTimer = [NSNumber numberWithInt:tserverObj.tisStopTimeOfEachProperty];
        [tdefaultObj setObject:tStopTimer forKey:@"StopTimer"];
        [self tIsButtonPressed];
        
        
    }
    else if(sender.tag == 4)
    {
        tserverObj.tisButtonPressedOrNot = 2;
        tserverObj.tisStopTimeOfEachProperty = 10;
        NSNumber* tStopTimer = [NSNumber numberWithInt:tserverObj.tisStopTimeOfEachProperty];
        [tdefaultObj setObject:tStopTimer forKey:@"StopTimer"];
        [self tIsButtonPressed];
    }
    else if(sender.tag == 5)
    {
        tserverObj.tisButtonPressedOrNot = 3;
        tserverObj.tisStopTimeOfEachProperty = 15;
        NSNumber* tStopTimer = [NSNumber numberWithInt:tserverObj.tisStopTimeOfEachProperty];
        [tdefaultObj setObject:tStopTimer forKey:@"StopTimer"];
        [self tIsButtonPressed];
    }
    else if(sender.tag == 6)
    {
        tserverObj.tisButtonPressedOrNot = 4;
        tserverObj.tisStopTimeOfEachProperty = 20;
        NSNumber* tStopTimer = [NSNumber numberWithInt:tserverObj.tisStopTimeOfEachProperty];
        [tdefaultObj setObject:tStopTimer forKey:@"StopTimer"];
        [self tIsButtonPressed];
    }
    else if(sender.tag == 7)
    {
        tserverObj.tisButtonPressedOrNot = 5;
        tserverObj.tisStopTimeOfEachProperty = 25;
        NSNumber* tStopTimer = [NSNumber numberWithInt:tserverObj.tisStopTimeOfEachProperty];
        [tdefaultObj setObject:tStopTimer forKey:@"StopTimer"];
        [self tIsButtonPressed];
    }
        else if(sender.tag == 88)
        {
            tserverObj.tisButtonPressedOrNot = 6;
            tserverObj.tisStopTimeOfEachProperty = 30;
            NSNumber* tStopTimer = [NSNumber numberWithInt:tserverObj.tisStopTimeOfEachProperty];
            [tdefaultObj setObject:tStopTimer forKey:@"StopTimer"];
            [self tIsButtonPressed];
        }
    }
}

-(void)tIsButtonPressed
{
    if(tserverObj.tisButtonPressedOrNot == 1)
    {
        button1.backgroundColor = [tserverObj colorWithHexString:@"39aad6"];
        button2.backgroundColor = [tserverObj colorWithHexString:@"636363"];
        button3.backgroundColor = [tserverObj colorWithHexString:@"636363"];
        button4.backgroundColor = [tserverObj colorWithHexString:@"636363"];
        button5.backgroundColor = [tserverObj colorWithHexString:@"636363"];
        button6.backgroundColor = [tserverObj colorWithHexString:@"636363"];
    }
    else if(tserverObj.tisButtonPressedOrNot == 2)
    {
        button1.backgroundColor = [tserverObj colorWithHexString:@"636363"];
        button2.backgroundColor = [tserverObj colorWithHexString:@"39aad6"];
        button3.backgroundColor = [tserverObj colorWithHexString:@"636363"];
        button4.backgroundColor = [tserverObj colorWithHexString:@"636363"];
        button5.backgroundColor = [tserverObj colorWithHexString:@"636363"];
        button6.backgroundColor = [tserverObj colorWithHexString:@"636363"];
    }
    else if(tserverObj.tisButtonPressedOrNot == 3)
    {
        button1.backgroundColor = [tserverObj colorWithHexString:@"636363"];
        button2.backgroundColor = [tserverObj colorWithHexString:@"636363"];
        button3.backgroundColor = [tserverObj colorWithHexString:@"39aad6"];
        button4.backgroundColor = [tserverObj colorWithHexString:@"636363"];
        button5.backgroundColor = [tserverObj colorWithHexString:@"636363"];
        button6.backgroundColor = [tserverObj colorWithHexString:@"636363"];
    }
    else if(tserverObj.tisButtonPressedOrNot == 4)
    {
        button1.backgroundColor = [tserverObj colorWithHexString:@"636363"];
        button2.backgroundColor = [tserverObj colorWithHexString:@"636363"];
        button3.backgroundColor = [tserverObj colorWithHexString:@"636363"];
        button4.backgroundColor = [tserverObj colorWithHexString:@"39aad6"];
        button5.backgroundColor = [tserverObj colorWithHexString:@"636363"];
        button6.backgroundColor = [tserverObj colorWithHexString:@"636363"];
    }
    else if(tserverObj.tisButtonPressedOrNot == 5)
    {
        button1.backgroundColor = [tserverObj colorWithHexString:@"636363"];
        button2.backgroundColor = [tserverObj colorWithHexString:@"636363"];
        button3.backgroundColor = [tserverObj colorWithHexString:@"636363"];
        button4.backgroundColor = [tserverObj colorWithHexString:@"636363"];
        button5.backgroundColor = [tserverObj colorWithHexString:@"39aad6"];
        button6.backgroundColor = [tserverObj colorWithHexString:@"636363"];
    }
    else if(tserverObj.tisButtonPressedOrNot == 6)
    {
        button1.backgroundColor = [tserverObj colorWithHexString:@"636363"];
        button2.backgroundColor = [tserverObj colorWithHexString:@"636363"];
        button3.backgroundColor = [tserverObj colorWithHexString:@"636363"];
        button4.backgroundColor = [tserverObj colorWithHexString:@"636363"];
        button5.backgroundColor = [tserverObj colorWithHexString:@"636363"];
        button6.backgroundColor = [tserverObj colorWithHexString:@"39aad6"];
    }
    
}

-(void)tBtnActionOfOnOff :(UIButton*)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    isBtnOnOff = !isBtnOnOff;
    tserverObj.isNotesOnOff = !tserverObj.isNotesOnOff;
    [self.tableView reloadData];
}

-(void)tBtnActionOfOnOff2 :(UIButton*)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
//    isBtnOnOff = !isBtnOnOff;
    tserverObj.isReceiptOnOff = !tserverObj.isReceiptOnOff;
    [self.tableView reloadData];
}

-(void)tBtnActionOfOnOff3 :(UIButton*)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    //    isBtnOnOff = !isBtnOnOff;
    //    tserverObj.isNotesOnOff = !tserverObj.isNotesOnOff;
    [self.tableView reloadData];
}

-(void)tBtnBackEvent
{
//    [self.navigationController popViewControllerAnimated:YES];
     [self performSegueWithIdentifier:@"segueBack" sender:self];
}

#pragma mark - LOGICAL METHODS
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

#pragma mark-TEXTFIELD DELEGATES

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"Text=%@",textField.text);
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.tag == 12321)
    {
        [tEmailArressTextField resignFirstResponder];
    }
    return NO;
}

@end
/*
 tTextLabel.text = @"Information :";
 //    TS_ParaSort* tpara = [TS_ParaSort new];
 //    tpara = [tserverObj.tTotalTimeAndDistance objectAtIndex:indexPath.row];
 ttotalDistance.text = [NSString stringWithFormat:@"Total Distance : %f",tTotalDistance];
 NSTimeInterval tTimeInterval = tTotalTimeOfRoute;
 ttotalTimeOfRoute.text = [NSString stringWithFormat:@"Expected time :%@",[tserverObj stringFromTimeInterval:tTimeInterval]];
*/