//
//  PlayerViewController.m
//  Cuevana
//
//  Created by Camilo Vera Bezmalinovic on 5/16/13.
//  Copyright (c) 2013 Camilo Vera Bezmalinovic. All rights reserved.
//

#import "PlayerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CVSubtitleParser.h"
@interface PlayerViewController ()
//using a button... just to use the vertical alignment easily
@property (nonatomic,strong) UIButton *buttonSubtitles;
@property (nonatomic,strong) CVSubtitleParser *subsParser;
@property (nonatomic,strong) CVSubtitleItem *currentSub;
@property (nonatomic,weak) NSTimer *timerCurrentTime;
@end

@implementation PlayerViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        [self addNotifications];
        [self configureSubViews];
    }
    return self;
}
- (void)configureSubViews
{
    if (self.moviePlayer.view.subviews.count > 0)
    {
        UIView *view = self.moviePlayer.view.subviews[0];
        if (view.subviews.count > 0)
        {
            UIView *sView = view.subviews[0];
            self.viewPlayerVideoContent = [sView viewWithTag:1002];
            self.viewPlayerControls     = [sView viewWithTag:1003];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureButtonSubtitles];
}
- (void)loadSubtitlesFromURL:(NSURL*)url
{
     self.subsParser = [[CVSubtitleParser alloc] initWithContentOfURL:url];
}

- (void)configureButtonSubtitles
{
    self.buttonSubtitles = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.buttonSubtitles.clipsToBounds              = NO;
    self.buttonSubtitles.backgroundColor            = [UIColor clearColor];
    self.buttonSubtitles.userInteractionEnabled     = NO;
    self.buttonSubtitles.contentVerticalAlignment   = UIControlContentVerticalAlignmentBottom;
    self.buttonSubtitles.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.buttonSubtitles.autoresizingMask           = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.buttonSubtitles.contentEdgeInsets          = UIEdgeInsetsMake(0, 0, 10, 0);
    
    self.buttonSubtitles.titleLabel.layer.shadowColor   = [UIColor blackColor].CGColor;
    self.buttonSubtitles.titleLabel.layer.shadowRadius  = 2.0;
    self.buttonSubtitles.titleLabel.layer.shadowOpacity = 1;
    self.buttonSubtitles.titleLabel.layer.shadowOffset  = CGSizeMake(0, 0);
    
    
    BOOL isIpad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
    self.buttonSubtitles.titleLabel.font          = [UIFont systemFontOfSize:isIpad?40:28];
    self.buttonSubtitles.titleLabel.numberOfLines = 0;
    self.buttonSubtitles.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.buttonSubtitles setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
 
    
    if (self.viewPlayerVideoContent)
    {
        self.buttonSubtitles.frame = self.viewPlayerVideoContent.bounds;
        [self.viewPlayerVideoContent addSubview:self.buttonSubtitles];
    }
    else
    {
        self.buttonSubtitles.frame = self.moviePlayer.view.bounds;
        [self.moviePlayer.view addSubview:self.buttonSubtitles];
    }
    
}

- (void)setCurrentSubtitleText:(NSString*)text
{
    [self.buttonSubtitles setTitle:text forState:UIControlStateNormal];
}

- (void)startTimer
{
    [self stopTimer];
    self.timerCurrentTime = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(didTriggerTimer:) userInfo:nil repeats:YES];

}
- (void)stopTimer
{
    if (self.timerCurrentTime != nil && self.timerCurrentTime.isValid)
    {
        [self.timerCurrentTime invalidate];
        self.timerCurrentTime = nil;
    }
}

//these methods are from the Apple tutorial
-(void)addNotifications
{
    MPMoviePlayerController *player = self.moviePlayer;
    
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveLoadStateDidChangeNotification:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:player];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceivePlayBackDidFinishNotification:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:player];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveIsPreparedToPlayDidChangeNotification:)
                                                 name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:player];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceivePlayBackStateDidChangeNotification:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:player];
}
#pragma mark - Notificacions
/* Handle movie load state changes. */
- (void)didReceiveLoadStateDidChangeNotification:(NSNotification *)notification
{
	MPMoviePlayerController *player = notification.object;
	MPMovieLoadState loadState = player.loadState;
    
	if (loadState & MPMovieLoadStateUnknown)
	{
        NSLog(@"loadStateDidChange - unknown");
	}

	if (loadState & MPMovieLoadStatePlayable)
	{
        NSLog(@"loadStateDidChange - playable");
	}
	
	if (loadState & MPMovieLoadStatePlaythroughOK)
	{
        NSLog(@"loadStateDidChange - playthrough ok");
	}
	
	if (loadState & MPMovieLoadStateStalled)
	{
        NSLog(@"loadStateDidChange - stalled");
	}
}

/*  Notification called when the movie finished playing. */
- (void)didReceivePlayBackDidFinishNotification:(NSNotification*)notification
{
    NSNumber *reason = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
	switch ([reason integerValue])
	{
		case MPMovieFinishReasonPlaybackEnded:

			break;
            
		case MPMovieFinishReasonPlaybackError:
            NSLog(@"Playback error: %@",notification.userInfo[@"error"]);
			break;
            
		case MPMovieFinishReasonUserExited:

			break;
            
		default:
			break;
	}
}
- (void)didReceiveIsPreparedToPlayDidChangeNotification:(NSNotification*)notification
{
    [self.moviePlayer play];
}

/* Called when the movie playback state has changed. */
- (void)didReceivePlayBackStateDidChangeNotification:(NSNotification*)notification
{
	MPMoviePlayerController *player = notification.object;
    
	if (player.playbackState == MPMoviePlaybackStateStopped)
	{
        [self stopTimer];
	}
	else if (player.playbackState == MPMoviePlaybackStatePlaying)
	{
        [self startTimer];
	}
	else if (player.playbackState == MPMoviePlaybackStatePaused)
	{
        [self stopTimer];
	}
	else if (player.playbackState == MPMoviePlaybackStateInterrupted)
	{
        [self stopTimer];
	}
}
#pragma mark - remove notifications
/* Remove the movie notification observers from the movie object. */
-(void)removeNotifications
{
    MPMoviePlayerController *player = self.moviePlayer;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:player];
}

#pragma mark - Timer
- (void)didTriggerTimer:(NSTimer*)timer
{
    double current = self.moviePlayer.currentPlaybackTime;
    
    if (isnan(current)|| current <= 0 || self.buttonSubtitles==nil) return;
    
    
    if (current >= self.currentSub.timeStart && current <= self.currentSub.timeEnd)
    {
        //do nothing.. is the right sub
    }
    else
    {
        self.currentSub = [self.subsParser subtitleItemAtTime:current];
        
        if (self.currentSub == nil)
        {
            [self setCurrentSubtitleText:@""];
        }
        else
        {
            [self setCurrentSubtitleText:self.currentSub.text];
        }
        
    }
}
#pragma mark - EOF
-(void)dealloc
{
    [self removeNotifications];
}
@end
