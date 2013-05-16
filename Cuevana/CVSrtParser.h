//
//  CVSrtParser.h
//  CVSrtParserApp
//
//  Created by Camilo Vera Bezmalinovic on 5/13/13.
//  Copyright (c) 2013 Toush. All rights reserved.
//

#import <Foundation/Foundation.h>


@class CVSrtItem;
@interface CVSrtParser : NSObject
- (id)initWithContentOfURL:(NSURL*)url;
- (id)initWithContentString:(NSString*)content;
//time in seconds (accept milliseconds)
- (CVSrtItem*)srtItemAtTime:(double)time;
@end

@interface CVSrtItem : NSObject
@property (assign) double timeStart;
@property (assign) double timeEnd;
@property (assign) double duration;
@property (strong) NSString *text;
@end

