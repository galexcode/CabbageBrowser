//
//  FavController.m
//  MyBrowser
//
//  Created by Denny on 12-3-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FavController.h"
#import "Website.h"

@implementation FavController
@synthesize websites;
@synthesize tableview;
@synthesize menuWindow;
@synthesize urlClickedDelegate;
@synthesize backToMainDelegate;
@synthesize cruIndex;

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
    self.websites = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"favwebsites"]];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    [lpgr setMinimumPressDuration:1.0];
    [self.tableview addGestureRecognizer:lpgr];
}

-(void)longPressed:(UILongPressGestureRecognizer *)gestureRecognizer{
    CGPoint p = [gestureRecognizer locationInView:tableview];
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan){
        NSIndexPath *indexPath = [tableview indexPathForRowAtPoint:p]; 
        self.cruIndex = indexPath.row;
        [self openMenu];
    }
}

- (void)openMenu
{
    NSArray *array = [menuWindow subviews];
    if (!array || array.count == 0) {
        array = [[NSBundle mainBundle] loadNibNamed:@"QuickMenuView" owner:nil options:nil];
        for (UIView *subview in array) {
            [menuWindow addSubview:subview]; 
        }
    }
    
    UIView *backgroud = [array objectAtIndex:0]; 
    [backgroud setBackgroundColor:[UIColor colorWithPatternImage: [UIImage imageNamed: @"favbg.png"]]];
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
    
    Website *site = [NSKeyedUnarchiver unarchiveObjectWithData:[self.websites objectAtIndex:indexPath.row]] ;
    cell.textLabel.font = [UIFont fontWithName:@"UniSun-R" size:20];
    cell.textLabel.text = site.title;
    cell.detailTextLabel.text = site.url;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.websites.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self openWebsite:indexPath.row];
    NSLog(@"short clicked at row %d", indexPath.row);
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

-(void)deleteWebsite:(int)index
{
    if (index < 0 || index >= self.websites.count) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [self.websites removeObjectAtIndex:index];
    [defaults setObject:self.websites forKey:@"favwebsites"];
    [defaults synchronize];
}

- (IBAction)goBack:(id)sender 
{
    [self dismissModalViewControllerAnimated:YES];
    [self.backToMainDelegate onBack];
}
@end
