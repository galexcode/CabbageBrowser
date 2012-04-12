//
//  ViewController.h
//  MyBrowser
//
//  Created by Denny on 12-3-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyWindow.h"

@protocol UrlClickedDelegate <NSObject>

-(void)onClick:(NSString *)urlStr;

@end

@protocol BackToMainDelegate <NSObject>

-(void)onBack;

@end

@interface ViewController : UIViewController <UIWebViewDelegate, UrlClickedDelegate, BackToMainDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *urlInput;
@property (weak, nonatomic) IBOutlet UIButton *collectBut;
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIButton *back;
@property (weak, nonatomic) IBOutlet UIButton *forward;
@property (weak, nonatomic) IBOutlet UIButton *favBut;
@property (weak, nonatomic) IBOutlet UIButton *historyBut;
@property (weak, nonatomic) IBOutlet UIButton *windowsBut;

@property (weak, nonatomic) IBOutlet UIButton *refreshBut;

@property (nonatomic) BOOL isBackClicked;
@property (nonatomic) BOOL isJumpOut;

@property (nonatomic) int stackDepth;

- (IBAction)collect:(id)sender;
- (IBAction)refresh:(id)sender;
- (IBAction)go:(id)sender;
- (IBAction)goBack:(id)sender;
- (IBAction)goForward:(id)sender;
- (IBAction)gotoFav:(id)sender;
- (IBAction)gotoHistory:(id)sender;
- (IBAction)gotoPages:(id)sender;

- (void)addQuickItem;
- (void)setWebViewHiden:(BOOL)hiden;
- (void)quickPressed:(id)sender;
- (NSString *)randomUrlStr;
- (void)setTitleAndUrl:(UIWebView *)wv;

- (void)loadUrl:(NSURL *)url;
- (void)setGoBackStutas;
- (BOOL)addFavItem:(NSUserDefaults *)defaults withTitle:(NSString *)title urlStr:(NSString *)urlStr;
- (BOOL)removeFavItem:(NSUserDefaults *)defaults withTitle:(NSString *)title urlStr:(NSString *)urlStr;

@end
