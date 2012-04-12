//
//  Website.h
//  MyBrowser
//
//  Created by Denny on 12-3-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Website : NSObject <NSCoding>

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *url;
@property (nonatomic) int clickTimes;
@property (strong, nonatomic) NSString *lastTime;
@property (nonatomic) int year;
@property (nonatomic) int month;
@property (nonatomic) int week;
@property (nonatomic) int day;
@property (nonatomic) int weekday;


- (id)initWithTitle:(NSString *)title url:(NSString *)url;

- (id)initWithTitle:(NSString *)titleStr url:(NSString *)urlStr year:(int)year month:(int)month week:(int)week day:(int)day weekday:(int)weekday;

@end
