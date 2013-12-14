//
//  JoyStickControl.m
//  Control
//
//  Created by Imthiaz Rafiq on 12/14/13.
//  Copyright (c) 2013 Imthi.com. All rights reserved.
//

#import "JoyStickControl.h"
#import "PadView.h"

@interface JoyStickControl ()

@property (nonatomic, strong) UIImageView * crossHair;

@property (nonatomic, strong) PadView * lfView;
@property (nonatomic, strong) PadView * ffView;
@property (nonatomic, strong) PadView * frView;
@property (nonatomic, strong) PadView * llView;
@property (nonatomic, strong) PadView * saView;
@property (nonatomic, strong) PadView * rrView;
@property (nonatomic, strong) PadView * lbView;
@property (nonatomic, strong) PadView * bbView;
@property (nonatomic, strong) PadView * brView;

@property (nonatomic, strong) NSString * lastSentCommand;

@end


@implementation JoyStickControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.lfView];
        [self addSubview:self.ffView];
        [self addSubview:self.frView];
        [self addSubview:self.llView];
        [self addSubview:self.saView];
        [self addSubview:self.rrView];
        [self addSubview:self.lbView];
        [self addSubview:self.bbView];
        [self addSubview:self.brView];
        
        self.lastSentCommand = nil;
        
        [self addSubview:self.crossHair];
        [self setMultipleTouchEnabled:NO];
        [self setBackgroundColor:[UIColor blackColor]];
        
    }
    return self;
}

#pragma mark - touch handle

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self placeCrossHairWithTouches:touches withEvent:event];
    [self processControlWithTouches:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [self placeCrossHairWithTouches:touches withEvent:event];
    [self processControlWithTouches:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self placeCrossHairWithTouches:touches withEvent:event];
    [self processControlWithTouches:touches withEvent:event];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(sendStopCommand:)
                                               object:nil];
    [self performSelector:@selector(sendStopCommand:)
               withObject:nil
               afterDelay:0.5];
}

- (void)sendStopCommand:(id)sender{
    self.lastSentCommand = @"SS00";
    [self.delegate receivedCommand:self.lastSentCommand];
    
    CGRect crossHairRect = self.crossHair.frame;
    crossHairRect.origin.x = (320 - 20) / 2;
    crossHairRect.origin.y = (320 - 20) / 2;
    self.crossHair.frame = crossHairRect;
}

- (void)processControlWithTouches:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView: self];
    
    if (![self pointInside:location withEvent:event]) {
        return;
    }

    PadView * touchView = (PadView *)[self hitTest:location withEvent:event];
    if (![touchView isKindOfClass:[PadView class]]) {
        return;
    }
    CGPoint touchPoint = [touch locationInView:touchView];
    
    int xPercentage = 1 + round( ( touchPoint.x / touchView.bounds.size.width ) * 8 );
    int yPercentage = 1 + round( ( touchPoint.y / touchView.bounds.size.height ) * 8);
    
    NSString * commandToSend;
    if ([touchView.command isEqualToString:@"LF"]) {
        commandToSend = [NSString stringWithFormat:@"FF%d%d",xPercentage,yPercentage];
    }
    if ([touchView.command isEqualToString:@"FF"]) {
        xPercentage = 10 - yPercentage;
        yPercentage = 10 - yPercentage;
        commandToSend = [NSString stringWithFormat:@"FF%d%d",xPercentage,yPercentage];
    }
    if ([touchView.command isEqualToString:@"FR"]) {
        xPercentage = 9 - xPercentage;
        yPercentage = 9;
        commandToSend = [NSString stringWithFormat:@"FF%d%d",yPercentage,xPercentage];
    }
    if ([touchView.command isEqualToString:@"LL"]) {
        xPercentage = 10 - xPercentage;
        yPercentage = xPercentage;
        commandToSend = [NSString stringWithFormat:@"BF%d%d",xPercentage,yPercentage];
    }
    if ([touchView.command isEqualToString:@"SA"]) {
        xPercentage = 0;
        yPercentage = 0;
        commandToSend = [NSString stringWithFormat:@"SS%d%d",xPercentage,yPercentage];
    }
    if ([touchView.command isEqualToString:@"RR"]) {
        xPercentage = xPercentage;
        yPercentage = xPercentage;
        commandToSend = [NSString stringWithFormat:@"FB%d%d",xPercentage,yPercentage];
    }
    if ([touchView.command isEqualToString:@"BB"]) {
        xPercentage = yPercentage;
        yPercentage = yPercentage;
        commandToSend = [NSString stringWithFormat:@"BB%d%d",xPercentage,yPercentage];
    }
    if ([touchView.command isEqualToString:@"LB"]) {
        xPercentage = xPercentage;
        yPercentage = 9;
        commandToSend = [NSString stringWithFormat:@"BB%d%d",xPercentage,yPercentage];
    }
    if ([touchView.command isEqualToString:@"BR"]) {
        xPercentage = 10 - xPercentage;
        yPercentage = 9;
        commandToSend = [NSString stringWithFormat:@"BB%d%d",yPercentage,xPercentage];
    }
    
    if (![self.lastSentCommand isEqualToString:commandToSend]) {
        self.lastSentCommand = commandToSend;
        [self.delegate receivedCommand:self.lastSentCommand];
    }
    
}

- (void)placeCrossHairWithTouches:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView: self];
    
    if (![self pointInside:location withEvent:event]) {
        return;
    }
    
    PadView * touchView = (PadView *)[self hitTest:location withEvent:event];
    if (![touchView isKindOfClass:[PadView class]]) {
        return;
    }

    CGRect crossHairRect = self.crossHair.frame;
    crossHairRect.origin.x = location.x - 10;
    crossHairRect.origin.y = location.y - 10;
    self.crossHair.frame = crossHairRect;
}

#pragma mark - getters

- (UIImageView *)crossHair{
    if (_crossHair==nil) {
        _crossHair = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CrossHair"]];
        [_crossHair setFrame:CGRectMake(150, 150, 20, 20)];
    }
    return _crossHair;
}

- (PadView *)lfView{
    if (_lfView==nil) {
        _lfView = [[PadView alloc] initWithFrame:CGRectMake(0, 0, 140, 40)];
        [_lfView setBackgroundColor:[UIColor colorWithRed:0.33 green:0.33 blue:0.33 alpha:1.0]];
        [_lfView setCommand:@"LF"];
    }
    return _lfView;
}

- (PadView *)ffView{
    if (_ffView==nil) {
        _ffView = [[PadView alloc] initWithFrame:CGRectMake(140, 0, 40, 140)];
        [_ffView setBackgroundColor:[UIColor colorWithRed:0.77 green:0.77 blue:0.77 alpha:1.0]];
        [_ffView setCommand:@"FF"];
    }
    return _ffView;
}

- (PadView *)frView{
    if (_frView==nil) {
        _frView = [[PadView alloc] initWithFrame:CGRectMake(180, 0, 140, 40)];
        [_frView setBackgroundColor:[UIColor colorWithRed:0.33 green:0.33 blue:0.33 alpha:1.0]];
        [_frView setCommand:@"FR"];
    }
    return _frView;
}

- (PadView *)llView{
    if (_llView==nil) {
        _llView = [[PadView alloc] initWithFrame:CGRectMake(0, 140, 140, 40)];
        [_llView setBackgroundColor:[UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:1.0]];
        [_llView setCommand:@"LL"];
    }
    return _llView;
}

- (PadView *)saView{
    if (_saView==nil) {
        _saView = [[PadView alloc] initWithFrame:CGRectMake(140, 140, 40, 40)];
        [_saView setBackgroundColor:[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0]];
        [_saView setCommand:@"SA"];
    }
    return _saView;
}

- (PadView *)rrView{
    if (_rrView==nil) {
        _rrView = [[PadView alloc] initWithFrame:CGRectMake(180, 140, 140, 40)];
        [_rrView setBackgroundColor:[UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:1.0]];
        [_rrView setCommand:@"RR"];
    }
    return _rrView;
}

- (PadView *)lbView{
    if (_lbView==nil) {
        _lbView = [[PadView alloc] initWithFrame:CGRectMake(0, 280, 140, 40)];
        [_lbView setBackgroundColor:[UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:1.0]];
        [_lbView setCommand:@"LB"];
    }
    return _lbView;
}

- (PadView *)bbView{
    if (_bbView==nil) {
        _bbView = [[PadView alloc] initWithFrame:CGRectMake(140, 180, 40, 140)];
        [_bbView setBackgroundColor:[UIColor colorWithRed:0.77 green:0.77 blue:0.77 alpha:1.0]];
        [_bbView setCommand:@"BB"];
    }
    return _bbView;
}

- (UIView *)brView{
    if (_brView==nil) {
        _brView = [[PadView alloc] initWithFrame:CGRectMake(180, 280, 140, 40)];
        [_brView setBackgroundColor:[UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:1.0]];
        [_brView setCommand:@"BR"];
    }
    return _brView;
}

@end
