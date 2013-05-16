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
    self.buttonSubtitles.autoresizingMask           = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    self.buttonSubtitles.titleLabel.layer.shadowColor   = [UIColor blackColor].CGColor;
    self.buttonSubtitles.titleLabel.layer.shadowRadius  = 2.0;
    self.buttonSubtitles.titleLabel.layer.shadowOpacity = 1;
    self.buttonSubtitles.titleLabel.layer.shadowOffset  = CGSizeMake(0, 0);
    
    self.buttonSubtitles.titleLabel.font          = [UIFont systemFontOfSize:20];
    self.buttonSubtitles.titleLabel.numberOfLines = 0;
    self.buttonSubtitles.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.buttonSubtitles setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.buttonSubtitles.frame = self.moviePlayer.view.bounds;
    [self.moviePlayer.view addSubview:self.buttonSubtitles];
    
    self.timerCurrentTime = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(didTriggerTimer:) userInfo:nil repeats:YES];
}

- (void)setSubs:(NSString*)text
{
    [self.buttonSubtitles setTitle:text forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)didTriggerTimer:(NSTimer*)timer
{
    double current = self.moviePlayer.currentPlaybackTime;
    
    if (current <= 0) return;
    
    if (self.currentSub == nil)
    {
        self.currentSub = [self.subsParser srtItemAtTime:current];
        
        if (self.currentSub == nil)
        {
            [self setSubs:@""];
        }
        else
        {
            [self setSubs:self.currentSub.text];
        }
        
    }
    else
    {
        if (current >= self.currentSub.timeStart && current <= self.currentSub.timeEnd)
        {
            //do nothing.. is the right sub
        }
        else
        {
            self.currentSub = [self.subsParser srtItemAtTime:current];
            
            if (self.currentSub == nil)
            {
                [self setSubs:@""];
            }
            else
            {
                [self setSubs:self.currentSub.text];
            }

        }
    }
}

- (void)dealloc
{
    if (self.timerCurrentTime != nil && self.timerCurrentTime.isValid)
    {
        [self.timerCurrentTime invalidate];
        self.timerCurrentTime = nil;
    }
}
@end
