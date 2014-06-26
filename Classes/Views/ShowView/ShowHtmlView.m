//
//  ShowHtmlView.m
//  TestFolderAndFile
//
//  Created by user on 13-7-30.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "ShowHtmlView.h"

@interface ShowHtmlView()
{
    UIWebView *m_webView;
}

@property (nonatomic, retain) UIWebView *m_webView;

@end

@implementation ShowHtmlView
@synthesize m_webView;

- (void)dealloc
{
    self.m_webView = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGRect realFrame = frame;
        realFrame.size.height -= 44;
        self.m_webView = [[[UIWebView alloc] initWithFrame:realFrame] autorelease];
        [self addSubview:m_webView];
    }
    return self;
}

- (void)sentHtmlPath:(NSString *)htmlPath
{
    NSURL *url_ = [NSURL fileURLWithPath:htmlPath];
    NSURLRequest *requestURL = [NSURLRequest requestWithURL:url_];
    [m_webView loadRequest:requestURL];
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
