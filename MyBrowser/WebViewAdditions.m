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
    NSLog(@"size.width:%f, size.height:%f",size.width,size.height);
	return size;
}

- (CGPoint)scrollOffset
{
	CGPoint pt;
	pt.x = [[self stringByEvaluatingJavaScriptFromString:@"window.pageXOffset"] integerValue];
	pt.y = [[self stringByEvaluatingJavaScriptFromString:@"window.pageYOffset"] integerValue];
    NSLog(@"pt.x:%f, pt.y:%f",pt.x,pt.y);
	return pt;
}
@end
