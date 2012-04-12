//
//  Page.h
//  Workman
//
//  Created by Denny on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Page : NSObject

@property (strong, nonatomic) NSString *titleStr;
@property (strong, nonatomic) NSString *subtitleStr;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIWebView *webview;

@end
