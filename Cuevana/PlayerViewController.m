//
//  PlayerViewController.m
//  Cuevana
//
//  Created by Camilo Vera Bezmalinovic on 5/16/13.
//  Copyright (c) 2013 Camilo Vera Bezmalinovic. All rights reserved.
//

#import "PlayerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CVSrtParser.h"
@interface PlayerViewController ()
@property (nonatomic,weak) NSTimer *timerCurrentTime;
@property (nonatomic,strong) CVSrtParser *subsParser;
@property (nonatomic,strong) CVSrtItem *currentSub;
@end

@implementation PlayerViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        [self installMovieNotificationObservers];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureButtonSubtitles];
}

- (void)setUrlSubs:(NSURL *)urlSubs
{
    _urlSubs = urlSubs;
    
    self.subsParser = [[CVSrtParser alloc] initWithContentOfURL:urlSubs];
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
    
    self.buttonSubtitles.frame = self.moviePlayer.view.bounds;
 
    
    if (self.moviePlayer.view.subviews.count > 0)
    {
        UIView *sView = self.moviePlayer.view.subviews[0];
        
        if (sView.subviews.count > 0)
        {
            UIView *ssView = sView.subviews[0];
            UIView *sssView = [ssView viewWithTag:1002];
            [sssView addSubview:self.buttonSubtitles];
        }
        else
        {
            [self.moviePlayer.view addSubview:self.buttonSubtitles];
        }
    }
    else
    {
        [self.moviePlayer.view addSubview:self.buttonSubtitles];
    }
    
}

- (void)setSubsText:(NSString*)text
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
-(void)installMovieNotificationObservers
{
    MPMoviePlayerController *player = self.moviePlayer;
    
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:player];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:player];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:player];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:player];
}

/* Handle movie load state changes. */
- (void)loadStateDidChange:(NSNotification *)notification
{
	MPMoviePlayerController *player = notification.object;
	MPMovieLoadState loadState = player.loadState;
    
	/* The load state is not known at this time. */
	if (loadState & MPMovieLoadStateUnknown)
	{
        
        NSLog(@"loadStateDidChange - unknown");
	}
	
	/* The buffer has enough data that playback can begin, but it
	 may run out of data before playback finishes. */
	if (loadState & MPMovieLoadStatePlayable)
	{
        NSLog(@"loadStateDidChange - playable");
	}
	
	/* Enough data has been buffered for playback to continue uninterrupted. */
	if (loadState & MPMovieLoadStatePlaythroughOK)
	{
        
        NSLog(@"loadStateDidChange - playthrough ok");
	}
	
	/* The buffering of data has stalled. */
	if (loadState & MPMovieLoadStateStalled)
	{
        NSLog(@"loadStateDidChange - stalled");
	}
}

/*  Notification called when the movie finished playing. */
- (void) moviePlayBackDidFinish:(NSNotification*)notification
{
    NSNumber *reason = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
	switch ([reason integerValue])
	{
            /* The end of the movie was reached. */
		case MPMovieFinishReasonPlaybackEnded:
            /*
             Add your code here to handle MPMovieFinishReasonPlaybackEnded.
             */
			break;
            
            /* An error was encountered during playback. */
		case MPMovieFinishReasonPlaybackError:
            NSLog(@"An error was encountered during playback: %@",notification.userInfo[@"error"]);
			break;
            
            /* The user stopped playback. */
		case MPMovieFinishReasonUserExited:

			break;
            
		default:
			break;
	}
}
- (void) mediaIsPreparedToPlayDidChange:(NSNotification*)notification
{
    NSLog(@"Prepared to Play?");
    [self.moviePlayer play];
}

/* Called when the movie playback state has changed. */
- (void)moviePlayBackStateDidChange:(NSNotification*)notification
{
	MPMoviePlayerController *player = notification.object;
    
	/* Playback is currently stopped. */
	if (player.playbackState == MPMoviePlaybackStateStopped)
	{
        NSLog(@"moviePlayBackStateDidChange - stopped");
        [self stopTimer];
	}
	/*  Playback is currently under way. */
	else if (player.playbackState == MPMoviePlaybackStatePlaying)
	{
        NSLog(@"moviePlayBackStateDidChange - playing");
        [self startTimer];
	}
	/* Playback is currently paused. */
	else if (player.playbackState == MPMoviePlaybackStatePaused)
	{
        NSLog(@"moviePlayBackStateDidChange - paused");
        [self stopTimer];
	}
	/* Playback is temporarily interrupted, perhaps because the buffer
	 ran out of content. */
	else if (player.playbackState == MPMoviePlaybackStateInterrupted)
	{
        NSLog(@"moviePlayBackStateDidChange - interrupted");
        [self stopTimer];
	}
}
#pragma mark - remove notifications
/* Remove the movie notification observers from the movie object. */
-(void)removeMovieNotificationHandlers
{
    MPMoviePlayerController *player = self.moviePlayer;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:player];
}

-(void)dealloc
{
    [self removeMovieNotificationHandlers];
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
        self.currentSub = [self.subsParser srtItemAtTime:current];
        
        if (self.currentSub == nil)
        {
            [self setSubsText:@""];
        }
        else
        {
            [self setSubsText:self.currentSub.text];
        }
        
    }
}


@end
