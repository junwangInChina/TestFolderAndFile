//
//  AudioView.m
//  TestFolderAndFile
//
//  Created by user on 13-7-30.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "AudioView.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioView()
{
    UIButton *m_audioBtn;
    
    UIImageView *m_showVoiceImage;
    
    NSTimer *m_changeImageTimer;
    
    AVAudioRecorder *m_recorder;
	AVAudioSession *m_session;
}

@property (nonatomic, retain) UIButton *m_audioBtn;
@property (nonatomic, retain) UIImageView *m_showVoiceImage;
@property (nonatomic, retain) AVAudioRecorder *m_recorder;
@property (nonatomic, retain) AVAudioSession *m_session;

@end

@implementation AudioView
@synthesize m_audioBtn;
@synthesize m_showVoiceImage;
@synthesize m_recorder;
@synthesize m_session;
@synthesize audio_delegate;

- (void)dealloc
{
    self.m_audioBtn = nil;
    self.m_showVoiceImage = nil;
    self.m_recorder = nil;
    self.m_session = nil;
    self.audio_delegate = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.m_audioBtn = [self createBtn:CGRectMake(110, 220, 100, 40)];
        [m_audioBtn setTitle:@"Star" forState:UIControlStateNormal];
        [m_audioBtn addTarget:self action:@selector(startAudio) forControlEvents:UIControlEventTouchDown];
        [m_audioBtn addTarget:self action:@selector(finishAudio) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:m_audioBtn];
        
        self.m_showVoiceImage = [self createImageView:CGRectMake(125, 63, 75, 111)];
        [m_showVoiceImage setImage:[UIImage imageNamed:@"record_animate_01.png"]];
        [self addSubview:m_showVoiceImage];
    }
    return self;
}

- (void)initializeRecorder:(NSString *)currentPath
{
    //录音设置
    NSMutableDictionary *recordSetting = [[[NSMutableDictionary alloc]init] autorelease];
    //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
    //录音通道数  1 或 2
    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    //线性采样位数  8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //录音的质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    NSString *audioName = [NSString stringWithFormat:@"%@.aac",[CommonDeal getNowDateTime]];
    NSString *audiopath = [currentPath stringByAppendingPathComponent:audioName];
    NSURL *url = [NSURL fileURLWithPath:audiopath];
    
    NSError *error;
    // Create recorder
    self.m_recorder = [[[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&error] autorelease];
    m_recorder.meteringEnabled = YES;
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

- (UIImageView *)createImageView:(CGRect)imageFrame
{
    UIImageView *imageView_ = [[[UIImageView alloc] initWithFrame:imageFrame] autorelease];
    imageView_.backgroundColor = [UIColor clearColor];
    
    return imageView_;
}

- (void)startAudio
{
    [self.m_audioBtn setTitle:@"Finish" forState:UIControlStateNormal];
    
    if ([self startAudioSession])
    {
        
        if ([self.m_recorder prepareToRecord])
        {
            [self.m_recorder record];
        }
    }
    else
    {
        [CommonDeal showAlertWithTitle:@"Information" andMsgBody:@"No Audio Input Available"];
    }
    
    m_changeImageTimer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(detectionVoice) userInfo:nil repeats:YES];
}

- (BOOL) startAudioSession
{
	NSError *error;
	self.m_session = [AVAudioSession sharedInstance];
	
	if (![m_session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error])
	{
		NSLog(@"Error: %@", [error localizedDescription]);
		return NO;
	}
	
	if (![m_session setActive:YES error:&error])
	{
		NSLog(@"Error: %@", [error localizedDescription]);
		return NO;
	}
	return m_session.inputAvailable;
}

- (void)finishAudio
{
    [self.m_audioBtn setTitle:@"Star" forState:UIControlStateNormal];
    m_audioBtn.hidden = YES;
    
    
    double cTime = self.m_recorder.currentTime;
    if (cTime > 2)
    {
        //如果录制时间<2 不发送
        NSLog(@"发出去");
    }
    else
    {
        //删除记录的文件
        [m_recorder deleteRecording];
        //删除存储的
    }
    [m_recorder stop];
    
    [CommonDeal showAlertWithTitle:@"Success" andMsgBody:@"Save success"];
    
    if (self.audio_delegate && [self.audio_delegate respondsToSelector:@selector(saveFinishWillBack)])
    {
        [self.audio_delegate saveFinishWillBack];
    }
    
    if (m_changeImageTimer)
    {
        [m_changeImageTimer invalidate];
        m_changeImageTimer = nil;
    }
}

- (void)detectionVoice
{
    [self.m_recorder updateMeters];//刷新音量数据
    //获取音量的平均值  [recorder averagePowerForChannel:0];
    //音量的最大值  [recorder peakPowerForChannel:0];
    
    double lowPassResults = pow(10, (0.05 * [self.m_recorder peakPowerForChannel:0]));

    //最大50  0
    //图片 小-》大
    if (0<lowPassResults<=0.06) {
        [self.m_showVoiceImage setImage:[UIImage imageNamed:@"record_animate_01.png"]];
    }else if (0.06<lowPassResults<=0.13) {
        [self.m_showVoiceImage setImage:[UIImage imageNamed:@"record_animate_02.png"]];
    }else if (0.13<lowPassResults<=0.20) {
        [self.m_showVoiceImage setImage:[UIImage imageNamed:@"record_animate_03.png"]];
    }else if (0.20<lowPassResults<=0.27) {
        [self.m_showVoiceImage setImage:[UIImage imageNamed:@"record_animate_04.png"]];
    }else if (0.27<lowPassResults<=0.34) {
        [self.m_showVoiceImage setImage:[UIImage imageNamed:@"record_animate_05.png"]];
    }else if (0.34<lowPassResults<=0.41) {
        [self.m_showVoiceImage setImage:[UIImage imageNamed:@"record_animate_06.png"]];
    }else if (0.41<lowPassResults<=0.48) {
        [self.m_showVoiceImage setImage:[UIImage imageNamed:@"record_animate_07.png"]];
    }else if (0.48<lowPassResults<=0.55) {
        [self.m_showVoiceImage setImage:[UIImage imageNamed:@"record_animate_08.png"]];
    }else if (0.55<lowPassResults<=0.62) {
        [self.m_showVoiceImage setImage:[UIImage imageNamed:@"record_animate_09.png"]];
    }else if (0.62<lowPassResults<=0.69) {
        [self.m_showVoiceImage setImage:[UIImage imageNamed:@"record_animate_10.png"]];
    }else if (0.69<lowPassResults<=0.76) {
        [self.m_showVoiceImage setImage:[UIImage imageNamed:@"record_animate_11.png"]];
    }else if (0.76<lowPassResults<=0.83) {
        [self.m_showVoiceImage setImage:[UIImage imageNamed:@"record_animate_12.png"]];
    }else if (0.83<lowPassResults<=0.9) {
        [self.m_showVoiceImage setImage:[UIImage imageNamed:@"record_animate_13.png"]];
    }else {
        [self.m_showVoiceImage setImage:[UIImage imageNamed:@"record_animate_14.png"]];
    }
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
