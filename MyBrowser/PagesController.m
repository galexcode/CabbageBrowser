//
//  PagesController.m
//  Workman
//
//  Created by Denny on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PagesController.h"

@implementation PagesController
@synthesize addBut;
@synthesize okBut;
@synthesize scrollview;
@synthesize pageControl;
@synthesize titleLabel;
@synthesize subtitle;
@synthesize backToMainDelegate;
@synthesize pages;
@synthesize pageCount;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [scrollview setCanCancelContentTouches:NO];
    scrollview.clipsToBounds = NO;		// default is NO, we want to restrict drawing within our scrollview
    scrollview.scrollEnabled = YES;
    scrollview.showsHorizontalScrollIndicator = NO;
    
    // pagingEnabled property default is NO, if set the scroller will stop or snap at each photo
    // if you want free-flowing scroll, don't set this property.
    scrollview.pagingEnabled = YES;
    scrollview.bounces = YES;
    scrollview.directionalLockEnabled = YES;
    scrollview.delegate = self;
    
    
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PageView" owner:nil options:nil];
    UIView *view = [array objectAtIndex:0];
    if (self.pages) {
        for (int i = 0; i < [self.pages count]; i ++) {
            [view setBackgroundColor: [UIColor colorWithPatternImage: [UIImage imageNamed: @"appicon.png"]]];
            [scrollview addSubview:view];
        }
    }
    
    pageControl.numberOfPages = [pages count];
    pageControl.hidesForSinglePage = YES;
}

- (void)viewDidUnload
{
    [self setAddBut:nil];
    [self setOkBut:nil];
    [self setScrollview:nil];
    [self setPageControl:nil];
    [self setTitleLabel:nil];
    [self setSubtitle:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma scrollview delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)sView {
    NSInteger page = ((UIScrollView *)sView).contentOffset.x / [[UIScreen mainScreen] bounds].size.width;
    
    if (page == pageControl.currentPage) {
        NSLog(@"page == pageControl.currentPage");
        return;
    }
    pageControl.currentPage = page;
    
}

- (IBAction)addPage:(id)sender
{
    scrollview.frame = CGRectMake(0, 86, [[UIScreen mainScreen]bounds].size.width, 300);
    
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PageView" owner:nil options:nil];
    UIView *view = [array objectAtIndex:0];
    [view setBackgroundColor: [UIColor colorWithPatternImage: [UIImage imageNamed: @"appicon.png"]]];
    view.frame = CGRectMake(pageCount * (250+35)+35, 0, 200, 300);
    NSLog(@"scrollview.subviews.count:%d", scrollview.subviews.count);
    
//    UIView *temp = [[UIImageView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
//    [temp setBackgroundColor:[UIColor colorWithPatternImage: [UIImage imageNamed: @"appicon.png"]]];
    
    [scrollview addSubview:view];
    pageControl.numberOfPages = [pages count];
    pageControl.hidesForSinglePage = YES;
    self.scrollview.contentSize = CGSizeMake(1800, floor(array.count/2)*135+45);
    pageCount++;
}

- (IBAction)ok:(id)sender
{
    
}

@end
