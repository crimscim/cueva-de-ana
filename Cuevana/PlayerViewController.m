//
//  PlayerViewController.m
//  Cuevana
//
//  Created by Camilo Vera Bezmalinovic on 5/16/13.
//  Copyright (c) 2013 Camilo Vera Bezmalinovic. All rights reserved.
//

#import "PlayerViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface PlayerViewController ()

@end

@implementation PlayerViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        [self configureButtonSubtitles];
    }
    return self;
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
    
    [self.buttonSubtitles setTitle:@"sldakj sdhjaksgd ajskhdg ajskdhg ajsdhgajskhd gajsdhg ajsdkh gasjdh adals dkjashd jkahsd kjahsdjkgasdahj gsdjah sgja sgdkajhs dgjahsdgç" forState:UIControlStateNormal];
    
    self.buttonSubtitles.frame = self.moviePlayer.view.bounds;
    [self.moviePlayer.view addSubview:self.buttonSubtitles];
    
    
    
    
}
@end
