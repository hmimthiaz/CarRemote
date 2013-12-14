//
//  ViewController.h
//  CarRemote
//
//  Created by Imthiaz Rafiq on 12/10/13.
//  Copyright (c) 2013 www.imthi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLE.h"
#import "JoyStickControl.h"


@interface ViewController : UIViewController <BLEDelegate,JoyStickControlDelegate,UIAccelerometerDelegate> {
    BLE *bleShield;
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIButton *buttonConnect;



@end
