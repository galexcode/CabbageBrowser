//
//  ViewController.h
//  MyBrowser
//
//  Created by Denny on 12-3-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "MyWindow.h"

@protocol UrlClickedDelegate <NSObject>

-(void)onClick:(NSString *)urlStr;

@end

@protocol BackToMainDelegate <NSObject>

-(void)onBack;

@end

@interface ViewController : UIViewController <UIWebViewDelegate, UrlClickedDelegate, BackToMainDelegate,MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *urlInput;
@property (weak, nonatomic) IBOutlet UIButton *collectBut;

@property (strong, nonatomic) IBOutlet UIView *webViewContainer;
@property (strong, nonatomic) UIWebView *webView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet UIButton *back;
@property (weak, nonatomic) IBOutlet UIButton *forward;
@property (weak, nonatomic) IBOutlet UIButton *favBut;
@property (weak, nonatomic) IBOutlet UIButton *historyBut;

@property (weak, nonatomic) IBOutlet UIButton *refreshBut;
@property (weak, nonatomic) IBOutlet UIButton *emailBut;
@property (weak, nonatomic) IBOutlet UILabel *emailLable;

@property (nonatomic) BOOL isBackClicked;
@property (nonatomic) BOOL isJumpOut;

@property (nonatomic) int stackDepth;

- (IBAction)collect:(id)sender;
- (IBAction)refresh:(id)sender;
- (IBAction)sendEmail:(id)sender;
- (IBAction)go:(id)sender;
- (IBAction)goBack:(id)sender;
- (IBAction)goForward:(id)sender;
- (IBAction)gotoFav:(id)sender;
- (IBAction)gotoHistory:(id)sender;

- (void)addQuickItem;
- (void)setWebViewHiden:(BOOL)hiden;
- (void)quickPressed:(id)sender;
- (NSString *)randomUrlStr;
- (void)setTitleAndUrl:(UIWebView *)wv;
- (void)showEmailView;

- (void)loadUrl:(NSURL *)url;
- (void)setGoBackStutas;
- (BOOL)addFavItem:(NSUserDefaults *)defaults withTitle:(NSString *)title urlStr:(NSString *)urlStr;
- (BOOL)removeFavItem:(NSUserDefaults *)defaults withTitle:(NSString *)title urlStr:(NSString *)urlStr;

- (void)resetWebView;
@end
