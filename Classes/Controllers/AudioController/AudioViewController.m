//
//  AudioViewController.m
//  TestFolderAndFile
//
//  Created by user on 13-7-30.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "AudioViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AudioView.h"

@interface AudioViewController ()<AudioViewDelegate>
{
    
}



@end

@implementation AudioViewController
@synthesize m_currentDirectorPath;

- (void)dealloc
{
    self.m_currentDirectorPath = nil;
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.title = @"Audio";
    
    AudioView *audioView = [[AudioView alloc] initWithFrame:self.view.bounds];
    [audioView initializeRecorder:self.m_currentDirectorPath];
    audioView.audio_delegate = self;
    [self.view addSubview:audioView];
    [audioView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)saveFinishWillBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
