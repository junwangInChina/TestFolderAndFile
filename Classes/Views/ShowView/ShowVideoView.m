//
//  ShowVideoView.m
//  TestFolderAndFile
//
//  Created by user on 13-7-30.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "ShowVideoView.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ShowVideoView()
{
    MPMoviePlayerController *m_MPMoviePlayerControl;
}

@property (nonatomic, retain) MPMoviePlayerController *m_MPMoviePlayerControl;

@end

@implementation ShowVideoView
@synthesize m_MPMoviePlayerControl;

- (void)dealloc
{
    [self.m_MPMoviePlayerControl stop];
    self.m_MPMoviePlayerControl = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGRect realFrame = frame;
        realFrame.size.height -= 44;
        [self createMediaPlayerControl:realFrame];
    }
    return self;
}

- (void)createMediaPlayerControl:(CGRect)rect_
{
    self.m_MPMoviePlayerControl = [[[MPMoviePlayerController alloc] init] autorelease];
    m_MPMoviePlayerControl.controlStyle = MPMovieControlStyleDefault;
    [m_MPMoviePlayerControl prepareToPlay];
    [m_MPMoviePlayerControl.view setFrame:rect_];  // player的尺寸
    [self addSubview: m_MPMoviePlayerControl.view];
}

- (void)sentVideoPath:(NSString *)videoPath
{
    NSURL *videoURL = [NSURL fileURLWithPath:videoPath];
    self.m_MPMoviePlayerControl.contentURL = videoURL;
    [self.m_MPMoviePlayerControl play];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
