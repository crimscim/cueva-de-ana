//
//  PlayerViewController.h
//  Cuevana
//
//  Created by Camilo Vera Bezmalinovic on 5/16/13.
//  Copyright (c) 2013 Camilo Vera Bezmalinovic. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

@interface PlayerViewController : MPMoviePlayerViewController
@property(nonatomic,strong) UIView *viewPlayerControls;
@property(nonatomic,strong) UIView *viewPlayerVideoContent;

- (void)loadSubtitlesFromURL:(NSURL*)url;
- (void)setCurrentSubtitleText:(NSString*)text;
@end
