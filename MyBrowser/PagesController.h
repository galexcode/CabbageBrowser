//
//  PagesController.h
//  Workman
//
//  Created by Denny on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface PagesController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *addBut;
@property (weak, nonatomic) IBOutlet UIButton *okBut;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;

@property (assign, nonatomic) id<BackToMainDelegate> backToMainDelegate;

@property (nonatomic) int pageCount; 

@property (strong, readwrite) NSMutableArray * pages;

- (IBAction)addPage:(id)sender;
- (IBAction)ok:(id)sender;

@end
