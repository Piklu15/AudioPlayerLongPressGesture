//
//  ViewController.m
//  AnimationAudio
//
//  Created by Divine IT on 9/18/17.
//  Copyright © 2017 Divine IT. All rights reserved.
//

#import "ViewController.h"
@import AVFoundation;
@interface ViewController ()<AVAudioRecorderDelegate, AVAudioPlayerDelegate>{
    
    CGRect originalFrame;
    CGPoint originalCenter;
    NSInteger recordSecond;
    NSInteger recordMinute;

    
}
@property (strong, nonatomic) IBOutlet UIImageView *deleteImageView;

@property (strong, nonatomic) AVAudioRecorder *audioRecorder;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) IBOutlet UIButton *recordButton;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UIButton *stopButton;

@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIButton *audioButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *trailingSpaceOfAudioButton;
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property(nonatomic,strong) NSTimer * timer;
@property (strong, nonatomic) IBOutlet UILabel *currentTime;
@property (strong, nonatomic) IBOutlet UILabel *countDownLabel;
@property (strong, nonatomic) IBOutlet UILabel *slideToCancelLabel;
@property(nonatomic,strong) NSTimer * recordTimer;
@property(nonatomic,strong) NSTimer *dotTimer;
@property (strong, nonatomic) IBOutlet UIView *TouchView;
@property (strong, nonatomic) IBOutlet UILabel *dotLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self prepareForeRecord];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
//    
//    originalFrame = CGRectMake(355,0,60,60);
//    
//    NSLog(@"original frame is : %@",NSStringFromCGRect(self.audioButton.frame));
//    
//    
    
}

-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    originalFrame = self.audioButton.frame;
    
    NSLog(@"original frame is : %@",NSStringFromCGRect(self.audioButton.frame));
    NSLog(@"containerView frame is : %@",NSStringFromCGRect(self.TouchView.frame));;



}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)userDidStopRecording{

    [self.recordTimer invalidate];
    self.recordTimer = nil;
    
    [self.dotTimer invalidate];
    self.dotTimer = nil;
    
    self.slideToCancelLabel.alpha = 0.0;
    self.countDownLabel.alpha = 0.0;
    self.deleteImageView.alpha = 0.0;
    self.dotLabel.alpha = 0;
    

    self.slideToCancelLabel.text = @"";
    self.countDownLabel.text = @"";
    recordSecond = 0;
    recordMinute = 0;
}




-(void)userDidBeginRecord{
  
    self.slideToCancelLabel.alpha = 1.0;
    self.countDownLabel.alpha = 1.0;
    self.deleteImageView.alpha = 1.0;
    self.dotLabel.alpha = 1.0;
    

    self.slideToCancelLabel.text = @"<Slide to cancle";
    self.countDownLabel.text = @"00:00";
    self.dotLabel.hidden = false;
    
    self.recordTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
    self.dotTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(dotToggle:) userInfo:nil repeats:YES];
    
    

    
}

-(void)dotToggle:(NSTimer *) dotTimer{

    self.dotLabel.hidden = !self.dotLabel.isHidden ;

}

-(void)countDown:(NSTimer *) sender{

    
    recordSecond ++;
    self.countDownLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",recordMinute,recordSecond];
    
    
    if(recordSecond == 60){
    
        recordMinute += 1;
        recordSecond = 0;
    }
    
    
}

#pragma mark - AudioRecord implementation with PressGesture
- (IBAction)longPressGestureActions:(UILongPressGestureRecognizer *)sender {
    
    UIButton * audioBUttono  = (UIButton *) sender.view;
    CGPoint location  = [sender locationInView:self.TouchView];
    
    
    
    if(sender.state == UIGestureRecognizerStateBegan){
        
        
    
        [self recordAudio:nil];
        
        [self userDidBeginRecord];
    
        audioBUttono.transform = CGAffineTransformMakeScale(2, 2);
        
        
    }else if(sender.state == UIGestureRecognizerStateChanged){
    
        
        if(location.x < self.TouchView.center.x){
            
            audioBUttono.alpha =   0.5;
            
        }else{
            
            audioBUttono.alpha = 1;
            

        
        }

        
        CGPoint center = audioBUttono.center;
       // center.y = location.y;
        center.x = location.x;
        audioBUttono.center = center;
        
        //audioBUttono.center = CGPointMake(self.view.center.x + location.x, self.view.center.y + location.y);
    }else{
        
        [self userDidStopRecording];
        [self stopAudio:nil];
        self.deleteImageView.alpha = 0;
    
        [UIView animateWithDuration:0.5
                              delay:0
             usingSpringWithDamping:0.3 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             NSLog(@"inside animation original frame is : %@",NSStringFromCGRect(originalFrame));
                             audioBUttono.transform = CGAffineTransformIdentity;
                             audioBUttono.frame = originalFrame;
                             audioBUttono.alpha = 1.0;
                             
                             
                             
                             

                         }
                         completion:^(BOOL finished){
                             
                         }];
        
    }
    
    
    
}

-(void)configureAudioSession{
    
  
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord
                        error:nil];


    
}

-(void)prepareForeRecord{
    
    [self configureAudioSession];

}


-(void)setUpRecorder{
    
    
    
    
    NSDictionary *recordSettings = [NSDictionary
                                    dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:AVAudioQualityMin],
                                    AVEncoderAudioQualityKey,
                                    [NSNumber numberWithInt:16],
                                    AVEncoderBitRateKey,
                                    [NSNumber numberWithInt: 2],
                                    AVNumberOfChannelsKey,
                                    [NSNumber numberWithFloat:44100.0],
                                    AVSampleRateKey,
                                    nil];
    
    NSError *error = nil;
    
    
    _audioRecorder = [[AVAudioRecorder alloc]
                      initWithURL:[self getFileUrl]
                      settings:recordSettings
                      error:&error];
    
    if (error)
    {
        NSLog(@"error: %@", [error localizedDescription]);
    } else {
        [_audioRecorder prepareToRecord];
    }
    
    

}

-(NSString*)getUniqueFileName{
    
    
    NSString * uuid = [[NSUUID UUID] UUIDString];
    
    return [NSString stringWithFormat:@"%@_sound.caf",uuid];

}

-(NSURL *)getFileUrl{
    
    
    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    
  NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:[self getUniqueFileName]];
    
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    return soundFileURL;
    



    
}






- (IBAction)recordAudio:(id)sender{
    
    [self setUpRecorder];
    
    if (!_audioRecorder.recording){
        [_audioRecorder record];
    }
    
}

- (IBAction)stopAudio:(id)sender{
    
    if(_audioRecorder!=nil){
        
        if (_audioRecorder.recording)
        {
            [_audioRecorder stop];
            
        }
        
    }
    
    
    [self prepareToPlay:nil];
    
}




#pragma mark -- Recorded Audio play with AVAudioPlayer...

- (IBAction)prepareToPlay:(id)sender{
    
    
    NSLog(@"url is : %@",_audioRecorder.url);
    
  NSError *error;
        
        _audioPlayer = [[AVAudioPlayer alloc]
                        initWithContentsOfURL:_audioRecorder.url
                        error:&error];
        
        _audioPlayer.delegate = self;
    
    [self.audioPlayer prepareToPlay];
    
    self.slider.minimumValue = 0.0f;
    self.slider.maximumValue = self.audioPlayer.duration;
    [self.slider setThumbImage:[UIImage imageNamed:@"thumimage.png"] forState:UIControlStateNormal];
    [self.slider setThumbImage:[UIImage imageNamed: @"thumbHighlighted"] forState:UIControlStateHighlighted];

    if (error)
            NSLog(@"Error: %@",
                  [error localizedDescription]);
    
}




#pragma mark - AVAudioPlayer Actions

- (IBAction)play:(id)sender {
    
    [self.audioPlayer play];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    
}

- (IBAction)pause:(id)sender {
    [self.audioPlayer pause];
    [self stopTimer];
    [self updateDisplay];
}

- (IBAction)stop:(id)sender {
    [self.audioPlayer stop];
    [self stopTimer];
    self.audioPlayer.currentTime = 0;
    [self.audioPlayer prepareToPlay];
    [self updateDisplay];
}


#pragma -mark Slider Value Changed & touchUPinside

- (IBAction)currentTimeSliderValueChanged:(id)sender
{
    if(self.timer)
        [self stopTimer];
    [self updateSliderLabels];
}

- (IBAction)currentTimeSliderTouchUpInside:(id)sender
{
    [self.audioPlayer stop];
    self.audioPlayer.currentTime = self.slider.value;
    [self.audioPlayer prepareToPlay];
    [self play:nil];
}

#pragma mark - Display Update
- (void)updateDisplay
{
    NSTimeInterval currentTime = self.audioPlayer.currentTime;
    self.slider.value = currentTime;
    [self updateSliderLabels];
    
}

- (void)updateSliderLabels
{
    NSTimeInterval currentTime = self.slider.value;
    NSString* currentTimeString = [NSString stringWithFormat:@"%.02f", currentTime];
    
    self.currentTime.text =  currentTimeString;
}

#pragma mark - Timer
- (void)timerFired:(NSTimer*)timer
{
    [self updateDisplay];
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
    [self updateDisplay];
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self stopTimer];
    [self updateDisplay];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"%s error=%@", __PRETTY_FUNCTION__, error);
    [self stopTimer];
    [self updateDisplay];
}

#pragma -mark AVAudioRecorderDelegate
-(void)audioRecorderDidFinishRecording:
(AVAudioRecorder *)recorder
                          successfully:(BOOL)flag{
    
    
}

-(void)audioRecorderEncodeErrorDidOccur:
(AVAudioRecorder *)recorder
                                  error:(NSError *)error{
    NSLog(@"Encode Error occurred");
}






@end
