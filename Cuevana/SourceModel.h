//
//  SourceModel.h
//  Cuevana
//
//  Created by Camilo Vera Bezmalinovic on 5/12/13.
//  Copyright (c) 2013 Camilo Vera Bezmalinovic. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SourceModelDelegate;

@class EpisodeResultObject;
@class SearchResultObject;
@class SourceResultObject;

@interface SourceModel : NSObject
@property (nonatomic,strong) NSArray *arraySources;
@property (nonatomic,strong) NSArray *arraySubtitles;
@property (nonatomic,weak) id <SourceModelDelegate> delegate;

- (void)getSourcesForEpisodeResultObject:(EpisodeResultObject*)object;
- (void)getSourcesForSearchResultObject:(SearchResultObject*)object;
- (void)getSourceFileForSourceResultObject:(SourceResultObject*)object;

@end

@protocol SourceModelDelegate <NSObject>
- (void)sourceModel:(SourceModel*)model didFinishLoadingSources:(NSArray*)sources;
- (void)sourceModel:(SourceModel*)model didFinishLoadingSourceURL:(NSURL*)url;
- (void)sourceModel:(SourceModel*)model didFinishLoadingSubtitles:(NSArray*)subsArray;
@end