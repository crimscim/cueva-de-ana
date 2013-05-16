//
//  PlayerViewController.h
//  Cuevana
//
//  Created by Camilo Vera Bezmalinovic on 5/16/13.
//  Copyright (c) 2013 Camilo Vera Bezmalinovic. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

@interface PlayerViewController : MPMoviePlayerViewController
//using a button... just to use the vertical alignment
@property (nonatomic,strong) UIButton *buttonSubtitles;
@property (nonatomic,strong) NSURL *urlSubs;
@end
