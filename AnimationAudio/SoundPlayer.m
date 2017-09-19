//
//  SoundPlayer.m
//  AnimationAudio
//
//  Created by Divine IT on 9/19/17.
//  Copyright © 2017 Divine IT. All rights reserved.
//

#import "SoundPlayer.h"
@interface SoundPlayer ()<AVAudioPlayerDelegate>{

    
}
@end

@implementation SoundPlayer


-(instancetype)initWthFileUrl:(NSURL *) fileUrl{

    NSError *error;
    self = [super initWithContentsOfURL:fileUrl error:&error];
    if(!self)
        return nil;
    
    self.delegate = self;
    
    return self;
    
    
}


#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.Sounddelegate stopTimer];
    [self.Sounddelegate updateDisplay];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"%s error=%@", __PRETTY_FUNCTION__, error);
    [self.Sounddelegate stopTimer];
    [self.Sounddelegate updateDisplay];
}


@end
