//
//  ViewController.m
//  MyBrowser
//
//  Created by Denny on 12-3-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "FavController.h"
#import "HisController.h"
#import "PagesController.h"
#import "Website.h"
#import "WebViewAdditions.h"
#import <QuartzCore/QuartzCore.h>

@implementation ViewController
@synthesize titleLabel;
@synthesize urlInput;
@synthesize collectBut;
@synthesize webViewContainer;
@synthesize webView;
@synthesize scrollView;
@synthesize emailView;
@synthesize back;
@synthesize forward;
@synthesize favBut;
@synthesize historyBut;
@synthesize isBackClicked;
@synthesize isJumpOut;

@synthesize refreshBut;
@synthesize emailBut;
@synthesize emailLable;
@synthesize stackDepth;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	// Do any additional setup after loading the view, typically from a nib.
    [self.scrollView setBackgroundColor: [UIColor colorWithPatternImage: [UIImage imageNamed: @"backgroud.png"]]];
    [self.emailView setBackgroundColor: [UIColor colorWithPatternImage: [UIImage imageNamed: @"backgroud.png"]]];
    [self resetWebView];
    self.isBackClicked = false;
    self.isJumpOut = false;
    [self addQuickItem];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextualMenuAction:) name:@"TapAndHoldNotification" object:nil];
    
    [super viewDidLoad];
}

- (void)openContextualMenuAt:(CGPoint)pt
{
	// Load the JavaScript code from the Resources and inject it into the web page
	NSString *path = [[NSBundle mainBundle] pathForResource:@"JSTools" ofType:@"txt"];
    
	NSLog(@"%@",path);
	
	NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	
	NSLog(@"%@!!",jsCode);
	[self.webView stringByEvaluatingJavaScriptFromString: jsCode];
	
	
	
	
	// get the Tags at the touch location
	NSString *tags = [NSString stringWithString:[self.webView stringByEvaluatingJavaScriptFromString:
                                                 [NSString stringWithFormat:@"MyAppGetHTMLElementsAtPoint(%i,%i);",(NSInteger)pt.x,(NSInteger)pt.y]]];
	
	
	NSLog(@"%@,%d,%d~~~~~~~~",tags,(NSInteger)pt.x,(NSInteger)pt.y);
	
	// create the UIActionSheet and populate it with buttons related to the tags
//	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Contextual Menu"
//													   delegate:self cancelButtonTitle:@"Cancel"
//										 destructiveButtonTitle:nil otherButtonTitles:nil];
//	
//	// If a link was touched, add link-related buttons
//	if ([tags rangeOfString:@",A,"].location != NSNotFound) {
//		[sheet addButtonWithTitle:@"Open Link"];
//		[sheet addButtonWithTitle:@"Open Link in Tab"];
//		[sheet addButtonWithTitle:@"Download Link"];
//	}
//	// If an image was touched, add image-related buttons
//	if ([tags rangeOfString:@",IMG,"].location != NSNotFound) {
//		[sheet addButtonWithTitle:@"Save Picture"];
//	}
//	// Add buttons which should be always available
//	[sheet addButtonWithTitle:@"Save Page as Bookmark"];
//	[sheet addButtonWithTitle:@"Open Page in Safari"];
//	
//	[sheet showInView:webview];
}

- (void)contextualMenuAction:(NSNotification*)notification
{
    if(self.webView.isHidden || isJumpOut){
        return;
    }
	CGPoint pt;
	NSDictionary *coord = [notification object];
	pt.x = [[coord objectForKey:@"x"] floatValue];
	pt.y = [[coord objectForKey:@"y"] floatValue];
	
	// convert point from window to view coordinate system
	pt = [self.webView convertPoint:pt fromView:nil];
	
	// convert point from view to HTML coordinate system
	CGPoint offset  = [self.webView scrollOffset];
	CGSize viewSize = [self.webView frame].size;
	CGSize windowSize = [self.webView windowSize];
	
	CGFloat f = windowSize.width / viewSize.width;
	pt.x = pt.x * f + offset.x;
	pt.y = pt.y * f + offset.y;
	
	[self openContextualMenuAt:pt];
}

- (void)addQuickItem
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"quickitem" owner:self options:nil];

    for (int i=0; i<array.count; i++) {
        CGRect frame;
        UIButton *btn = [array objectAtIndex:i];
        
        frame.size.width = 120;//设置按钮坐标及大小
        frame.size.height = 120;
        frame.origin.x = (i%2)*(120+15)+30;
        frame.origin.y = floor(i/2)*(120+15)+30;
        [btn setFrame:frame];
        btn.titleLabel.font = [UIFont fontWithName:@"UniSun-R" size:20];
        
        btn.tag = i;
        [btn addTarget:self action:@selector(quickPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.scrollView addSubview:btn];
    }
    self.scrollView.contentSize = CGSizeMake(320, floor(array.count/2)*135+45);
    
    [self setWebViewHiden:YES];
}

- (void)quickPressed:(id)sender
{
    [self resetWebView];
    
    UIButton *btn = (UIButton *)sender;
    int index = btn.tag;
    NSString *urlStr;
    switch (index) {
        case 0:
            urlStr = @"http://www.google.com/";
            break;
        case 1:
            urlStr = @"http://www.baidu.com/";
            break;
        case 2:
            urlStr = @"http://wap.dianping.com/";
            break;
        case 3:
            urlStr = [self randomUrlStr];
            break;
            
        default:
            break;
    }
    if (!urlStr) {
        return;
    } else if ([urlStr isEqualToString:@"email:"]) {
        [self showEmailView];
        return;
    } else {
        self.urlInput.text = urlStr;
    }
    
    //清空webview
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.open();document.close()"];
    
    //播放动画
    self.webView.alpha = 0;
    CGAffineTransform oneTransform = CGAffineTransformMakeScale(0.1, 0.1);
    CGAffineTransform twoTransform = CGAffineTransformMakeTranslation(0, 0);
    CGAffineTransform newTransform = CGAffineTransformConcat(oneTransform, twoTransform);
    self.webView.transform = newTransform;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    
    self.webView.alpha = 1;
    oneTransform = CGAffineTransformMakeScale(1, 1);
    twoTransform = CGAffineTransformMakeTranslation(0, 0);
    newTransform = CGAffineTransformConcat(oneTransform, twoTransform);
    self.webView.transform = newTransform;
    [UIView commitAnimations];
    
    [self loadUrl:[NSURL URLWithString:urlStr]];
    
}

//随机网址计算
- (NSString *)randomUrlStr
{
    NSArray *defaultUrl = [[NSArray alloc]initWithObjects:@"http://3g.sina.com.cn/", @"http://3g.163.com/", @"http://3g.qq.com/", @"http://www.mac.com.cn/", @"email:", nil];
    int randomNum;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *savedHisWebsites = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"hiswebsites"]];
    if (!savedHisWebsites) {
        randomNum = arc4random() % (defaultUrl.count);
    } else {
        //简化处理，我让大部分几率(>50%)都可能命中随机库
        randomNum = arc4random() % 2;
        if (randomNum == 0) {
            randomNum = arc4random() % (defaultUrl.count);
        } else {
            randomNum = arc4random() % (defaultUrl.count + savedHisWebsites.count);
        }
    }
    
    NSString *result;
    if (randomNum < defaultUrl.count) {
        result = [defaultUrl objectAtIndex:randomNum];
    } else {
        Website *site = [NSKeyedUnarchiver unarchiveObjectWithData:[savedHisWebsites objectAtIndex:randomNum-defaultUrl.count]] ;
        NSString* temp = [site.url substringFromIndex:7];
        NSRange index = [temp rangeOfString:@"/"];
        temp = [temp substringToIndex:index.location];
        NSMutableString *text = [[NSMutableString alloc] initWithString:temp];
        [text insertString:@"http://" atIndex:0];
        result = text;
    }
    
    return result;
}

-(void)animationDidStop:(id)sender {
    [self go:sender];
}


- (void)setWebViewHiden:(BOOL)hiden
{
    [self.webView setHidden:hiden];
    [self.scrollView setHidden:!hiden];
    if (hiden) {
        [self.collectBut setEnabled:NO];
        [self setTitleAndUrl:nil];
    } else {
        [self setTitleAndUrl:self.webView];
        [self.emailView setHidden:YES];
    }
}

- (void)viewDidUnload
{
    [self setTitleLabel:nil];
    [self setUrlInput:nil];
    [self setCollectBut:nil];
    [self setWebView:nil];
    [self setScrollView:nil];
    [self setEmailView:nil];
    [self setBack:nil];
    [self setForward:nil];
    [self setFavBut:nil];
    [self setHistoryBut:nil];
    [self setRefreshBut:nil];
    [self setEmailBut:nil];
    [self setEmailLable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)collect:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *titleStr = self.titleLabel.text ? self.titleLabel.text : self.urlInput.text;
    NSString *urlStr = self.urlInput.text;
    
    if ([self addFavItem:defaults withTitle:titleStr urlStr:urlStr]) {
        [self.collectBut setImage:[UIImage imageNamed:@"collected"] forState:UIControlStateNormal];
    } else {
        if ([self removeFavItem:defaults withTitle:titleStr urlStr:urlStr]) {
            [self.collectBut setImage:[UIImage imageNamed:@"uncollected"] forState:UIControlStateNormal];
        } else {
            NSLog(@"Are you kidding me?!");
        }
    }
}

//返回YES表示添加成功，NO表示已经存在
- (BOOL)addFavItem:(NSUserDefaults *)defaults withTitle:(NSString *)titleStr urlStr:(NSString *)urlStr
{
    //test
    NSMutableArray *savedWebsites = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"favwebsites"]];
    if (!savedWebsites) {
        savedWebsites = [[NSMutableArray alloc]init];
    } else {
        for (int i = 0; i < savedWebsites.count; i ++) {
            Website *site = [NSKeyedUnarchiver unarchiveObjectWithData:[savedWebsites objectAtIndex:i]] ;
            if ([site.url isEqualToString:urlStr]) {
                return NO;
            }
        }
    }
    
    Website *site = [[Website alloc]initWithTitle:titleStr url:urlStr];
    NSData *udObject = [NSKeyedArchiver archivedDataWithRootObject:site];
    [savedWebsites addObject:udObject];
    [defaults setObject:savedWebsites forKey:@"favwebsites"];
    [defaults synchronize];
    
    return YES;
}

//返回YES表示取消收藏成功，NO表示还未收藏
- (BOOL)removeFavItem:(NSUserDefaults *)defaults withTitle:(NSString *)titleStr urlStr:(NSString *)urlStr
{
    //test
    NSMutableArray *savedWebsites = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"favwebsites"]];
    if (!savedWebsites) {
        return NO;
    } else {
        BOOL exit = false;
        int index;
        for (index = 0; index < savedWebsites.count; index ++) {
            Website *site = [NSKeyedUnarchiver unarchiveObjectWithData:[savedWebsites objectAtIndex:index]] ;
            if ([site.url isEqualToString:urlStr]) {
                exit = YES;
                break;
            }
        }
        if (!exit) {
            return NO;
        } else {
            [savedWebsites removeObjectAtIndex:index];
        }
    }
    
    [defaults setObject:savedWebsites forKey:@"favwebsites"];
    [defaults synchronize];
    
    return YES; 
}

- (IBAction)go:(id)sender {
    [self resetWebView];
    
    NSMutableString *text = [[NSMutableString alloc] initWithString:self.urlInput.text];
    if (![text hasPrefix:@"http"]) {
        [text insertString:@"http://" atIndex:0];
    }
    NSURL *url = [NSURL URLWithString:text];
    [self loadUrl:url];
}

- (void)loadUrl:(NSURL *)url
{ 
    [self setWebViewHiden:NO];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (IBAction)goBack:(id)sender 
{
    if (!self.emailView.isHidden) {
        [self.emailView setHidden:YES];
    } else if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self setWebViewHiden:YES];
        //结束刷新动画
        [self.refreshBut.layer removeAnimationForKey:@"rotateAnimation"];
    }
    [self setGoBackStutas];
}

- (IBAction)goForward:(id)sender 
{
    if ([self.webView isHidden]) {
        [self setWebViewHiden:NO];
    } else {
        [self.webView goForward];
    }
    [self setGoBackStutas];
}

- (void)setTitleAndUrl:(UIWebView *)wv
{
    if (wv) {
        self.titleLabel.text = [wv stringByEvaluatingJavaScriptFromString:@"document.title"];
        self.urlInput.text = wv.request.URL.absoluteString;
    } else {
        self.titleLabel.text = @"请输入网址";
        self.urlInput.text = nil;
    }
}

- (IBAction)gotoFav:(id)sender {
    FavController *view = [[FavController alloc] initWithNibName:@"FavController" bundle:[NSBundle mainBundle]];
    view.urlClickedDelegate = self;
    view.backToMainDelegate = self;
    view.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    self.isJumpOut = YES;
    [self presentModalViewController:view animated:YES];
}

- (IBAction)gotoHistory:(id)sender {
    HisController *view = [[HisController alloc] initWithNibName:@"HisController" bundle:[NSBundle mainBundle]];
    view.urlClickedDelegate = self;
    view.backToMainDelegate = self;
    view.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    self.isJumpOut = YES;
    [self presentModalViewController:view animated:YES];
}

- (IBAction)sendEmail:(id)sender
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"关于卷心菜浏览器我有一些建议"];
    
    // Set up recipients
    NSArray *toRecipients = [NSArray arrayWithObject:@"dengjun86@gmail.com"];
    
    [picker setToRecipients:toRecipients];
    
    // Attach an image to the email
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"" ofType:@"png"];
//    NSData *myData = [NSData dataWithContentsOfFile:path];
//    [picker addAttachmentData:myData mimeType:@"image/png" fileName:@""];
    
    // Fill out the email body text
    
    [self presentModalViewController:picker animated:YES];
}

//send email result
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{   
    [self dismissModalViewControllerAnimated:YES];
    
    if (result == MFMailComposeResultSent) {
        CABasicAnimation *theAnimation1=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        theAnimation1.toValue = [NSNumber numberWithFloat:(2 * M_PI)];
        
        theAnimation1.duration=0.3;
        theAnimation1.repeatCount = 5;
        
        CABasicAnimation *theAnimation2=[CABasicAnimation animationWithKeyPath:@"transform.scale"]; 
        theAnimation2.fromValue=[NSNumber numberWithFloat:1];
        theAnimation2.toValue = [NSNumber numberWithDouble:0];
        theAnimation2.duration=1.5;
        
        CABasicAnimation *theAnimation3=[CABasicAnimation animationWithKeyPath:@"transform.translation.x"]; 
        theAnimation3.fromValue=[NSNumber numberWithFloat:0];
        theAnimation3.toValue = [NSNumber numberWithDouble:90];
        theAnimation3.duration=1.5;
        
        CABasicAnimation *theAnimation4=[CABasicAnimation animationWithKeyPath:@"transform.translation.y"]; 
        theAnimation4.fromValue=[NSNumber numberWithFloat:0];
        theAnimation4.toValue = [NSNumber numberWithDouble:20];
        theAnimation4.duration=1.5;
        
        [self.emailBut.layer addAnimation:theAnimation1 forKey:@"emailButAnimation1"];
        [self.emailBut.layer addAnimation:theAnimation2 forKey:@"emailButAnimation2"];
        [self.emailBut.layer addAnimation:theAnimation3 forKey:@"emailButAnimation3"];
        [self.emailBut.layer addAnimation:theAnimation4 forKey:@"emailButAnimation4"];
        
        NSArray *says = [[NSArray alloc]initWithObjects:@"还有什么要说的么，亲？", @"再接再厉，我等着你呢", @"我不是每次都会来的", @"还要告诉我什么好东西么？", @"你可以继续点下面的按钮", nil];
        self.emailLable.text = [says objectAtIndex:arc4random() % (says.count)];
    }
    
}

- (void)showEmailView
{
    [self.emailView setHidden:NO];
    [self.back setEnabled:YES];
    [self.forward setEnabled:NO];
    
    //动画
    CABasicAnimation *theAnimation1=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    theAnimation1.toValue = [NSNumber numberWithFloat:(2 * M_PI)];
    
    theAnimation1.duration=0.3;
    theAnimation1.repeatCount = 5;
    
    CABasicAnimation *theAnimation2=[CABasicAnimation animationWithKeyPath:@"transform.scale"]; 
    theAnimation2.fromValue=[NSNumber numberWithFloat:0.1];
    theAnimation2.toValue = [NSNumber numberWithDouble:1.0];
    theAnimation2.duration=1.5;
    
    CABasicAnimation *theAnimation3=[CABasicAnimation animationWithKeyPath:@"transform.translation.x"]; 
    theAnimation3.fromValue=[NSNumber numberWithFloat:-40];
    theAnimation3.toValue = [NSNumber numberWithDouble:0];
    theAnimation3.duration=1.5;
    
    [self.emailBut.layer addAnimation:theAnimation1 forKey:@"emailButAnimation1"];
    [self.emailBut.layer addAnimation:theAnimation2 forKey:@"emailButAnimation2"];
    [self.emailBut.layer addAnimation:theAnimation3 forKey:@"emailButAnimation3"];
}

- (void)webViewDidFinishLoad:(UIWebView *)w
{
//    title.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self setTitleAndUrl:w];
    [self setGoBackStutas];
    
    //检查该网址是否已经收藏过
    [self.collectBut setEnabled:YES];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *savedWebsites = [defaults objectForKey:@"favwebsites"];
    if (!savedWebsites) {
        [self.collectBut setImage:[UIImage imageNamed:@"uncollected"] forState:UIControlStateNormal];
    } else {
        for (int i = 0; i < savedWebsites.count; i ++) {
            Website *site = [NSKeyedUnarchiver unarchiveObjectWithData:[savedWebsites objectAtIndex:i]] ;
            if ([site.url isEqualToString:self.urlInput.text]) {
                [self.collectBut setImage:[UIImage imageNamed:@"collected"] forState:UIControlStateNormal]; 
                break;
            }
        }
        [self.collectBut setImage:[UIImage imageNamed:@"uncollected"] forState:UIControlStateNormal];
    }
    
    //结束刷新动画
    [self.refreshBut.layer removeAnimationForKey:@"rotateAnimation"];
    
    //储存历史记录
    if ([self.urlInput.text isEqualToString:@"about:blank"]) {
        return;
    }
    
    NSMutableArray *savedHisWebsites = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"hiswebsites"]];
    if (!savedHisWebsites) {
        savedHisWebsites = [[NSMutableArray alloc]init];
    }
    
    //判断当最后一个url和当前相同则不存
    if (savedHisWebsites.count > 0) {
        Website *temp = [NSKeyedUnarchiver unarchiveObjectWithData:[savedHisWebsites objectAtIndex:(savedHisWebsites.count - 1)]];
        if ([self.urlInput.text isEqualToString:temp.url]) {
            return;
        }
    }
    
    NSDate *now = [NSDate date];
    unsigned units = NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:units fromDate:now];
    
    NSString *titlrStr;
    if (!self.titleLabel.text || [self.titleLabel.text isEqualToString:@""]) {
        titlrStr = self.urlInput.text;
    } else {
        titlrStr = self.titleLabel.text;
    }
    Website *site = [[Website alloc]initWithTitle:titlrStr url:self.urlInput.text year:components.year month:components.month week:components.week day:components.day weekday:components.weekday];
    NSData *udObject = [NSKeyedArchiver archivedDataWithRootObject:site];
    [savedHisWebsites addObject:udObject];
    [defaults setObject:savedHisWebsites forKey:@"hiswebsites"];
    [defaults synchronize];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.refreshBut.layer removeAnimationForKey:@"rotateAnimation"];
}

- (void)webViewDidStartLoad:(UIWebView *)w
{
    //刷新动画
    int direction = -1;
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:(2 * M_PI) * direction];
    rotationAnimation.duration = 1.0f;
    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.refreshBut.layer addAnimation:rotationAnimation forKey:@"rotateAnimation"];
    
    [self setGoBackStutas];
    [self.collectBut setEnabled:NO];
    [w stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none';"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = [request URL];
    urlInput.text = [url absoluteString];
    return YES;
}

- (void)setGoBackStutas
{
    if (self.webView.canGoBack || !self.webView.isHidden) {
        [self.back setEnabled:YES];
    } else {
        [self.back setEnabled:NO];
    }
    
    if (self.webView.canGoForward || self.webView.isHidden) {
        [self.forward setEnabled:YES];
    } else {
        [self.forward setEnabled:NO]; 
    }
}

-(void)onClick:(NSString *)urlStr
{
    if (webView.hidden) {
        [self resetWebView];
    }
    self.urlInput.text = urlStr;
    [self loadUrl:[NSURL URLWithString:urlStr]];
}

-(void)onBack
{
    self.isJumpOut = false;
}

-(void)refresh:(id)sender
{
    if (self.urlInput.text) {
        [self loadUrl:[NSURL URLWithString:self.urlInput.text]];
    }
}

- (void)resetWebView
{
    if (webView) {
        [webView removeFromSuperview];
        webView = nil;
    }
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 380)];
    webView.delegate = self;
    webView.hidden = YES;
    
    [[self webViewContainer] addSubview:webView];
}

@end
