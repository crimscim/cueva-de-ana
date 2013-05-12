//
//  SourcesViewController.h
//  Cuevana
//
//  Created by Camilo Vera Bezmalinovic on 11/1/12.
//  Copyright (c) 2012 Camilo Vera Bezmalinovic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchResultObject;
@class EpisodeResultObject;

@interface SourcesViewController : UIViewController

- (id)initWithSearchResult:(SearchResultObject*)resultObject;
- (id)initWithEpisodeResult:(EpisodeResultObject*)resultObject;
@end
