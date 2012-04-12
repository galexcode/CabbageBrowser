//
//  WebViewAdditions.m
//  tppispig
//
//  Created by gao wei on 10-7-15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WebViewAdditions.h"

@implementation UIWebView(WebViewAdditions)

- (CGSize)windowSize
{
	CGSize size;
	size.width = [[self stringByEvaluatingJavaScriptFromString:@"window.innerWidth"] integerValue];
	size.height = [[self stringByEvaluatingJavaScriptFromString:@"window.innerHeight"] integerValue];
	return size;
}

- (CGPoint)scrollOffset
{
	CGPoint pt;
	pt.x = [[self stringByEvaluatingJavaScriptFromString:@"window.pageXOffset"] integerValue];
	pt.y = [[self stringByEvaluatingJavaScriptFromString:@"window.pageYOffset"] integerValue];
	return pt;
}
@end
