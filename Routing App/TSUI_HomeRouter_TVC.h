//
//  TSUI_HomeRouter_TVC.h
//  Routing App
//
//  Created by TacktileSystemsMac4 on 04/05/15.
//  Copyright (c) 2015 Tacktile Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import "SWRevealViewController.h"
#import <CoreText/CoreText.h>
#import <CoreGraphics/CoreGraphics.h>

@interface TSUI_HomeRouter_TVC : UITableViewController<UIGestureRecognizerDelegate,UIAlertViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property(strong, nonatomic)UITableView* tTableViewofDropDownList;
@property (strong, nonatomic) IBOutlet UITableView *tTableView1;
@property (weak, nonatomic) IBOutlet UITableView *tTableView2;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *tMenuBtn;

@end
