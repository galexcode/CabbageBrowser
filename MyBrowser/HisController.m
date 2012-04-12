//
//  FavController.m
//  MyBrowser
//
//  Created by Denny on 12-3-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HisController.h"
#import "Website.h"

@implementation HisController
@synthesize websites;
@synthesize tableview;
@synthesize menuWindow;
@synthesize urlClickedDelegate;
@synthesize backToMainDelegate;
@synthesize cruIndex;
@synthesize rowInSec0;
@synthesize rowInSec1;
@synthesize rowInSec2;
@synthesize rowInSec3;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

//计算按时间分类
-(void)initData
{
    //今天的时间
    NSDate *now = [NSDate date];
    unsigned units = NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:units fromDate:now];
    
    for (int i = 0; i < self.websites.count; i ++) {
        Website *site = [NSKeyedUnarchiver unarchiveObjectWithData:[self.websites objectAtIndex:self.websites.count-i-1]] ;
        if (components.day == site.day) {
            rowInSec0++;
        } else if (components.day - site.day < 7) {
            rowInSec1++;
        } else if (site.month < components.month) {
            rowInSec2++;
        } else if (site.year < components.year) {
            rowInSec3 = self.websites.count - i;
            break;
        }
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.cruIndex = -1;
    
    [self.menuWindow setBackgroundColor: [UIColor colorWithPatternImage: [UIImage imageNamed: @"touming.png"]]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.websites = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"hiswebsites"]];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    [lpgr setMinimumPressDuration:1.0];
    [self.tableview addGestureRecognizer:lpgr];
    
    [self initData];
}

-(void)longPressed:(UILongPressGestureRecognizer *)gestureRecognizer{
    CGPoint p = [gestureRecognizer locationInView:tableview];
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan){
        NSIndexPath *indexPath = [tableview indexPathForRowAtPoint:p]; 
        self.cruIndex = [self indexInWebsites:indexPath];
        NSLog(@"longPressed at row:%d", indexPath.row);
        [self openMenu];
    }
}

- (void)openMenu
{
    NSArray *array = [menuWindow subviews];
    if (!array || array.count == 0) {
        array = [[NSBundle mainBundle] loadNibNamed:@"QuickMenuView" owner:nil options:nil];
        for (UIView *subview in array) {
            if ([subview isKindOfClass:[UIImageView class]] == YES) {
                [(UIImageView *)subview setImage:[UIImage imageNamed: @"hisbg.png"]];
            }
            [menuWindow addSubview:subview]; 
        }
    }
    
    UIView *backgroud = [array objectAtIndex:0]; 
    backgroud.alpha = 0.0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    backgroud.alpha = 1.0;
    
    
    UIButton *menuView1 = [array objectAtIndex:1];
    menuView1.transform = CGAffineTransformMakeTranslation(-180, 180);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    menuView1.transform = CGAffineTransformMakeTranslation(30, 180);
    [menuView1 addTarget:self action:@selector(goClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *menuView2 = [array objectAtIndex:2]; 
    [menuView2 setBackgroundImage:[UIImage imageNamed: @"addfav.png"] forState:UIControlStateNormal];
    menuView2.transform = CGAffineTransformMakeTranslation(500, 180);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    menuView2.transform = CGAffineTransformMakeTranslation(190, 180);
    [menuView2 addTarget:self action:@selector(delClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *menuView3 = [array objectAtIndex:3];   
    menuView3.transform = CGAffineTransformMakeTranslation(110, 580);
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    menuView3.transform = CGAffineTransformMakeTranslation(110, 330);
    [menuView3 addTarget:self action:@selector(cancelClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [UIView commitAnimations];
    [menuWindow setHidden:NO];
}

- (void)closeMenu
{
    [UIView setAnimationDelegate:self];
    NSArray *array = [menuWindow subviews];
    UIView *backgroud = [array objectAtIndex:0];
    
    UIButton *menuView1 = [array objectAtIndex:1];     
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    menuView1.transform = CGAffineTransformMakeTranslation(-180, 180);
    
    
    UIButton *menuView2 = [array objectAtIndex:2];  
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    menuView2.transform = CGAffineTransformMakeTranslation(500, 180);
    
    UIButton *menuView3 = [array objectAtIndex:3];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    menuView3.transform = CGAffineTransformMakeTranslation(110, 580);
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{  
        backgroud.alpha = 1.0;
        backgroud.alpha = 0.0;
    } completion:^(BOOL finished){
        if (finished){
            NSLog(@"finished");
            [menuWindow setHidden:YES];
        }
    }];
    [UIView commitAnimations];
}

-(IBAction) goClicked:(id)sender
{
    [self openWebsite:self.cruIndex];
    [self closeMenu];
}

-(IBAction) delClicked:(id)sender
{
    [self deleteWebsite:self.cruIndex];
    [self.tableview reloadData];
    [self closeMenu];
}

-(IBAction) cancelClicked:(id)sender
{
    [self closeMenu];
}

- (void)viewDidUnload
{
    [self setTableview:nil];
    [self setMenuWindow:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"mycell"];
    }
    
    Website *site = [NSKeyedUnarchiver unarchiveObjectWithData:[self.websites objectAtIndex:[self indexInWebsites:indexPath]]] ;
    cell.textLabel.font = [UIFont fontWithName:@"UniSun-R" size:20];
    cell.textLabel.text = site.title;
    cell.detailTextLabel.text = site.url;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *result;
    switch (section) {
        case 0:
            result = @"今日";
            break;
        case 1:
            result = @"过去一个礼拜";
            break;
        case 2:
            result = @"过去一个月";
            break;
        case 3:
            result = @"往前";
            break;
        default:
            break;
    }
    return result;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return rowInSec0;
        case 1:
            return rowInSec1;
        case 2:
            return rowInSec2;
        case 3:
            return rowInSec3;
            
        default:
            return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self openWebsite:[self indexInWebsites:indexPath]];
}

//根据indexPath来判断在array中什么位置
-(int)indexInWebsites:(NSIndexPath *)indexPath
{
    int index;
    switch (indexPath.section) {
        case 0:
            index = self.websites.count-indexPath.row-1;
            break;
        case 1:
            index = self.websites.count-rowInSec0-indexPath.row-1;
            break;
        case 2:
            index = self.websites.count-rowInSec0-rowInSec1-indexPath.row-1;
            break;
        case 3:
            index = self.websites.count-rowInSec0-rowInSec1-rowInSec2-indexPath.row-1;
            break;
            
        default:
            break;
    }
    return index;
}

-(void)openWebsite:(int)index;
{
    if (index < 0 || index >= self.websites.count) {
        return;
    }
    Website *site = [NSKeyedUnarchiver unarchiveObjectWithData:[self.websites objectAtIndex:index]] ;
    [self.urlClickedDelegate onClick:site.url];
    [self dismissModalViewControllerAnimated:YES];
}

//历史记录页面删除功能为添加收藏
-(void)deleteWebsite:(int)index
{
//    if (index < 0 || index >= self.websites.count) {
//        return;
//    }
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [self.websites removeObjectAtIndex:index];
//    [defaults setObject:self.websites forKey:@"hiswebsites"];
//    [defaults synchronize];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *savedWebsites = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"favwebsites"]];
    Website *site = [NSKeyedUnarchiver unarchiveObjectWithData:[self.websites objectAtIndex:index]] ;
    if (savedWebsites) {
        for (int i = 0; i < savedWebsites.count; i ++) {
            Website *temp = [NSKeyedUnarchiver unarchiveObjectWithData:[savedWebsites objectAtIndex:i]] ;
            if ([temp.url isEqualToString:site.url]) {
                return;
            }
        }
    }
    
    Website *newSite = [[Website alloc]initWithTitle:site.title url:site.url];
    NSData *udObject = [NSKeyedArchiver archivedDataWithRootObject:newSite];
    [savedWebsites addObject:udObject];
    [defaults setObject:savedWebsites forKey:@"favwebsites"];
    [defaults synchronize];
    
}

- (IBAction)goBack:(id)sender 
{
    [self dismissModalViewControllerAnimated:YES];
    [self.backToMainDelegate onBack];
}
@end
