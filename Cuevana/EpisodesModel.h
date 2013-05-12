//
//  ChaptersModel.h
//  Cuevana
//
//  Created by Camilo Vera Bezmalinovic on 5/12/13.
//  Copyright (c) 2013 Camilo Vera Bezmalinovic. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SearchResultObject;
@protocol EpisodesModelDelegate;
@interface EpisodesModel : NSObject

@property (nonatomic,strong) NSArray *arraySeasons;

@property (nonatomic,weak) id <EpisodesModelDelegate> delegate;

- (void)getEpisodesForSearchResultObject:(SearchResultObject*)object;

@end

@protocol EpisodesModelDelegate <NSObject>
- (void)episodesModel:(EpisodesModel*)model didFinishLoadingSeasons:(NSArray*)seasons;
@end