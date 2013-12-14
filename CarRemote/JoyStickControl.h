//
//  JoyStickControl.h
//  Control
//
//  Created by Imthiaz Rafiq on 12/14/13.
//  Copyright (c) 2013 Imthi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JoyStickControlDelegate <NSObject>

- (void)receivedCommand:(NSString *)commandString;

@end

@interface JoyStickControl : UIView

@property (nonatomic, assign) id <JoyStickControlDelegate> delegate;

@end
