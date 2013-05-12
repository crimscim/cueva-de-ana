//
//  EpisodeResultObject.h
//  Cuevana
//
//  Created by Camilo Vera Bezmalinovic on 10/31/12.
//  Copyright (c) 2012 Camilo Vera Bezmalinovic. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SearchResultObject;
@interface EpisodeResultObject : NSObject

@property(nonatomic,strong) SearchResultObject *searchResultObject;
@property(nonatomic,strong) NSNumber *resultId;
@property(nonatomic,assign) NSInteger episodeNumber;
@property(nonatomic,assign) NSInteger seasonNumber;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSURL *url;
@property(nonatomic,assign) float rate;
@property(nonatomic,assign,getter = isHd) BOOL hd;
- (void)fillWithDictionary:(NSDictionary*)object;

@end
