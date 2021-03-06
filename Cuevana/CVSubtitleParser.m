//
//  CVSrtParser.m
//  CVSrtParserApp
//
//  Created by Camilo Vera Bezmalinovic on 5/13/13.
//  Copyright (c) 2013 Toush. All rights reserved.
//

#import "CVSubtitleParser.h"

@interface CVSubtitleParser ()
@property (strong) NSMutableArray *arrayItems;
@end

@implementation CVSubtitleParser

#pragma mark - init
- (id)initWithContentOfURL:(NSURL*)url
{
    self = [super init];
    if (self)
    {
        self.arrayItems = [NSMutableArray new];
        [self parseSrtFileFromURL:url];
    }
    return self;
}

- (id)initWithContentString:(NSString*)content
{
    self = [super init];
    if (self)
    {
        self.arrayItems = [NSMutableArray new];
        [self parseSrtFileContent:content];
    }
    return self;
}

#pragma mark - Parsing
- (void)parseSrtFileFromURL:(NSURL*)url
{
    __weak CVSubtitleParser *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *srtContent = [[NSString alloc] initWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
        [weakSelf parseSrtFileContent:srtContent];
    });

}

- (void)parseSrtFileContent:(NSString*)content
{   //doble new line check (depending encode)
    NSArray *subsArray = [content componentsSeparatedByString:@"\r\n\r\n"];
    
    NSInteger count = subsArray.count;
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"HH:mm:ss,SSS"];
    
    NSUInteger timeIntervalZero = [formater dateFromString:@"00:00:00,000"].timeIntervalSince1970;
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for (NSUInteger i = 0 ; i < count ; i++)
    {
        NSString *element = subsArray[i];
        NSArray *split = [element  componentsSeparatedByString:@"\r\n"];
        
        NSInteger splitCount = split.count;
        
        if (splitCount < 2) continue;
        
        NSArray *times = [split[1] componentsSeparatedByString:@" --> "];
        
        NSDate *dateStart = [formater dateFromString:times[0]];
        NSDate *dateEnd   = [formater dateFromString:times[1]];
        
        CVSubtitleItem *item = [CVSubtitleItem new];
        item.timeStart = dateStart.timeIntervalSince1970-timeIntervalZero;
        item.timeEnd   = dateEnd.timeIntervalSince1970-timeIntervalZero;
        
        if (splitCount < 3) continue;
        
        NSString *text = split[2];
        
        for (NSUInteger t = 3; t < splitCount ; t++)
        {
            text = [text stringByAppendingFormat:@"\n%@",split[t]];
        }
        item.text = text;
        
        [tempArray addObject:item];
    }

    self.arrayItems = tempArray;
}

#pragma mark - Fetching
//binary search for result
- (CVSubtitleItem*)subtitleItemAtTime:(double)time
{
    NSUInteger count = self.arrayItems.count;
    
    if (count == 0) return nil;
    
    NSUInteger low   = 0;
    NSUInteger mid   = 0;
    NSUInteger high  = count;
    CVSubtitleItem *item  = nil;
    
    while (low <= high)
    {
        mid = (low+high)>>1;
        
        if (mid >= count) return nil;
        
        item = self.arrayItems[mid];
        
        if (time < item.timeStart && time < item.timeEnd)
        {
            high = mid-1;
        }
        else if (time > item.timeStart && time > item.timeEnd)
        {
            low = mid+1;
        }
        else
        {
            return item;
        }
    }
    return nil;//item; probably should be nil
}

@end

@implementation CVSubtitleItem
-(NSString*)description
{
    return [NSString stringWithFormat:@"CVSrtItem <%p> {%.03f --> %.03f,%@}",self,self.timeStart,self.timeEnd,self.text];
}
@end


