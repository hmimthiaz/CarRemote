//
//  ViewController.m
//  CarRemote
//
//  Created by Imthiaz Rafiq on 12/10/13.
//  Copyright (c) 2013 www.imthi.com. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) JoyStickControl * control;

@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    bleShield = [[BLE alloc] init];
    [bleShield controlSetup];
    bleShield.delegate = self;
    
    [self.view addSubview:self.control];
}

-(void) connectionTimer:(NSTimer *)timer{
    if(bleShield.peripherals.count > 0){
        [bleShield connectPeripheral:[bleShield.peripherals objectAtIndex:0]];
    }else{
        [self.spinner stopAnimating];
    }
}

-(void) bleDidReceiveData:(unsigned char *)data length:(int)length{
    NSData *d = [NSData dataWithBytes:data length:length];
    NSString *s = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    NSLog(@"Received: %@",s);
}


- (void) bleDidDisconnect{
    [self.buttonConnect setImage:[UIImage imageNamed:@"disconnect"] forState:UIControlStateNormal];
}

-(void) bleDidConnect{
    [self.spinner stopAnimating];
    [self.buttonConnect setImage:[UIImage imageNamed:@"connect"] forState:UIControlStateNormal];
}

- (void)receivedCommand:(NSString *)commandString{
    NSLog(@"Received Command: %@",commandString);
    [self BLEShieldSendCommand:commandString];
    
}


- (void)BLEShieldSendCommand:(NSString *)commandText{
    if (bleShield.activePeripheral.state==CBPeripheralStateConnected) {
        NSString * commandString = [NSString stringWithFormat:@"%@\r\n", commandText];
        NSData * commandDataToSend = [commandString dataUsingEncoding:NSUTF8StringEncoding];
        [bleShield write:commandDataToSend];
    }
}

- (IBAction)BLEShieldScan:(id)sender{
    if (bleShield.activePeripheral)
        if(bleShield.activePeripheral.state==CBPeripheralStateConnected){
            [[bleShield CM] cancelPeripheralConnection:[bleShield activePeripheral]];
            return;
        }
    
    if (bleShield.peripherals)
        bleShield.peripherals = nil;
    
    [bleShield findBLEPeripherals:3];
    
    [NSTimer scheduledTimerWithTimeInterval:(float)3.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
    
    [self.spinner startAnimating];
}

- (JoyStickControl *)control{
    if (_control==nil) {
        _control = [[JoyStickControl alloc] initWithFrame:CGRectMake(0, 200, 320, 320)];
        [_control setDelegate:self];
    }
    return _control;
}

@end
