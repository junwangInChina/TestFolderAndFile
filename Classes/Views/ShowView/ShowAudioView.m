//
//  ShowAudioView.m
//  TestFolderAndFile
//
//  Created by user on 13-7-30.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "ShowAudioView.h"
#import <AVFoundation/AVFoundation.h>

@interface ShowAudioView()
{
    AVAudioPlayer *m_player;
    
    UIButton *m_playBtn;
}

@property (nonatomic, retain) AVAudioPlayer *m_player;
@property (nonatomic, retain) UIButton *m_playBtn;

@end

@implementation ShowAudioView
@synthesize m_player;
@synthesize m_playBtn;

- (void)dealloc
{
    [self.m_player stop];
    self.m_player = nil;
    self.m_playBtn = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.m_playBtn = [self createBtn:CGRectMake(110, 220, 100, 40)];
        [m_playBtn setTitle:@"Play" forState:UIControlStateNormal];
        [m_playBtn addTarget:self action:@selector(playAudio) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:m_playBtn];
    }
    return self;
}

- (UIButton *)createBtn:(CGRect)btnFrame
{
    UIButton *button_ = [[[UIButton alloc] initWithFrame:btnFrame] autorelease];
    button_.layer.masksToBounds = YES;
    button_.layer.cornerRadius = 6.0;
    button_.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    button_.showsTouchWhenHighlighted = YES;
    
    return button_;
}

- (void)sentAudioPath:(NSString *)audioPath
{
    NSURL *url = [NSURL fileURLWithPath:audioPath];
    
    self.m_player = [[[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil] autorelease];
}

- (void)playAudio
{
    m_playBtn.hidden = YES;
    
    [self.m_player play];
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
