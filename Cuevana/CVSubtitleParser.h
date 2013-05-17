//
//  CVSrtParser.h
//  CVSrtParserApp
//
//  Created by Camilo Vera Bezmalinovic on 5/13/13.
//  Copyright (c) 2013 Toush. All rights reserved.
//

#import <Foundation/Foundation.h>


@class CVSubtitleItem;
@interface CVSubtitleParser : NSObject
- (id)initWithContentOfURL:(NSURL*)url;
- (id)initWithContentString:(NSString*)content;
//time in seconds (accept milliseconds)
- (CVSubtitleItem*)subtitleItemAtTime:(double)time;
@end

@interface CVSubtitleItem : NSObject
@property (assign) double timeStart;
@property (assign) double timeEnd;
@property (strong) NSString *text;
@end

