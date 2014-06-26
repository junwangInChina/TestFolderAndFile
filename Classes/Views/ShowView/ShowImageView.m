//
//  ShowImageView.m
//  TestFolderAndFile
//
//  Created by user on 13-7-30.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "ShowImageView.h"

@interface ShowImageView()
{
    UIImageView *m_showImageView;
}

@property (nonatomic, retain) UIImageView *m_showImageView;

@end

@implementation ShowImageView
@synthesize m_showImageView;

- (void)dealloc
{
    self.m_showImageView = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGRect realFrame = frame;
        realFrame.size.height -= 44;
        self.m_showImageView = [[[UIImageView alloc] initWithFrame:realFrame] autorelease];
        m_showImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:m_showImageView];
        
    }
    return self;
}

- (void)sentImagePath:(NSString *)imagePath
{
    m_showImageView.image = [UIImage imageWithContentsOfFile:imagePath];
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
