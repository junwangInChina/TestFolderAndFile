//
//  ShowUnkonwnView.m
//  TestFolderAndFile
//
//  Created by user on 13-7-30.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "ShowUnkonwnView.h"

@implementation ShowUnkonwnView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createMessageLbl];
    }
    return self;
}

- (void)createMessageLbl
{
    UILabel *wrongLbl = [[[UILabel alloc] initWithFrame:CGRectMake(50, 50, 220, 35)] autorelease];
    wrongLbl.text = @"Sorry,parse failed!";
    wrongLbl.textAlignment = NSTextAlignmentCenter;
    wrongLbl.font = [UIFont boldSystemFontOfSize:22];
    [self addSubview:wrongLbl];
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
