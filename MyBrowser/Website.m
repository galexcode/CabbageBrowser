//
//  Website.m
//  MyBrowser
//
//  Created by Denny on 12-3-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Website.h"

@implementation Website
@synthesize title;
@synthesize url;
@synthesize clickTimes;
@synthesize lastTime;
@synthesize year;
@synthesize month;
@synthesize week;
@synthesize weekday;
@synthesize day;

- (id)init
{
    self = [super init];
    if (self) {
        clickTimes = 0;
    }
    return self;
}

- (id)initWithTitle:(NSString *)titleStr url:(NSString *)urlStr
{
    self = [super init];
    if (self) {
        self.title = titleStr;
        self.url = urlStr;
        self.clickTimes = 0;
    }
    return self;
}

- (id)initWithTitle:(NSString *)t url:(NSString *)u year:(int)y month:(int)m week:(int)w day:(int)d weekday:(int)wd
{
    self = [super init];
    if (self) {
        self.title = t;
        self.url = u;
        self.clickTimes = 0;
        self.year = y;
        self.month = m;
        self.week = w;
        self.weekday = wd;
        self.day = d;
    }
    return self;
}

- (id) initWithCoder: (NSCoder *)coder     
{     
    if (self = [super init])     
    {     
        self.title = [coder decodeObjectForKey:@"title"];
        self.url = [coder decodeObjectForKey:@"url"]; 
        self.clickTimes = [coder decodeIntForKey:@"clickTimes"];
        self.lastTime = [coder decodeObjectForKey:@"lastTime"];
        self.year = [coder decodeIntForKey:@"year"];
        self.month = [coder decodeIntForKey:@"month"];
        self.week = [coder decodeIntForKey:@"week"];
        self.weekday = [coder decodeIntForKey:@"weekday"];
        self.day = [coder decodeIntForKey:@"day"];
    }     
    return self;     
}     
- (void) encodeWithCoder: (NSCoder *)coder     
{     
    [coder encodeObject:title forKey:@"title"];   
    [coder encodeObject:url forKey:@"url"];  
    [coder encodeInt:clickTimes forKey:@"clickTimes"];
    [coder encodeObject:lastTime forKey:@"lastTime"];
    [coder encodeInt:year forKey:@"year"];
    [coder encodeInt:month forKey:@"month"];
    [coder encodeInt:week forKey:@"week"];
    [coder encodeInt:weekday forKey:@"weekday"];
    [coder encodeInt:day forKey:@"day"];
}  

@end
