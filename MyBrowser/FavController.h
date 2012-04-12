//
//  FavController.h
//  MyBrowser
//
//  Created by Denny on 12-3-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"


@interface FavController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, readwrite) NSMutableArray * websites;

@property (assign, nonatomic) id<UrlClickedDelegate> urlClickedDelegate;
@property (assign, nonatomic) id<BackToMainDelegate> backToMainDelegate;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIView *menuWindow;

@property (nonatomic) int cruIndex;

- (IBAction)goBack:(id)sender;

- (void)openMenu;
- (void)closeMenu;

-(void)openWebsite:(int)index;
-(void)deleteWebsite:(int)index;
@end
