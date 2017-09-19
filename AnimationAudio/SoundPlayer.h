//
//  SoundPlayer.h
//  AnimationAudio
//
//  Created by Divine IT on 9/19/17.
//  Copyright © 2017 Divine IT. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AVFoundation;
@protocol soundPlayer <NSObject>

-(void)stopTimer;
-(void)updateDisplay;

@end


@interface SoundPlayer : AVAudioPlayer
-(instancetype)initWthFileUrl:(NSURL *) fileUrl;
@property(nonatomic,weak) id<soundPlayer>  Sounddelegate;
@end
