//
//  HisController.h
//  MyBrowser
//
//  Created by Denny on 12-3-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface HisController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, readwrite) NSMutableArray * websites;

@property (assign, nonatomic) id<UrlClickedDelegate> urlClickedDelegate;
@property (assign, nonatomic) id<BackToMainDelegate> backToMainDelegate;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIView *menuWindow;

@property (nonatomic) int cruIndex;
@property (nonatomic) int rowInSec0;
@property (nonatomic) int rowInSec1;
@property (nonatomic) int rowInSec2;
@property (nonatomic) int rowInSec3;

- (IBAction)goBack:(id)sender;

- (void)openMenu;
- (void)closeMenu;

-(void)openWebsite:(int)index;
-(void)deleteWebsite:(int)index;
-(int)indexInWebsites:(NSIndexPath *)indexPath;

-(void)initData;
@end
