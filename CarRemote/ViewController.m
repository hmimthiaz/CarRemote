//
//  ViewController.m
//  CarRemote
//
//  Created by Imthiaz Rafiq on 12/10/13.
//  Copyright (c) 2013 www.imthi.com. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    bleShield = [[BLE alloc] init];
    [bleShield controlSetup];
    bleShield.delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

// Called when scan period is over to connect to the first found peripheral
-(void) connectionTimer:(NSTimer *)timer
{
    if(bleShield.peripherals.count > 0)
    {
        [bleShield connectPeripheral:[bleShield.peripherals objectAtIndex:0]];
    }
    else
    {
        [self.spinner stopAnimating];
    }
}

-(void) bleDidReceiveData:(unsigned char *)data length:(int)length
{
    NSData *d = [NSData dataWithBytes:data length:length];
    NSString *s = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    NSLog(@"Received: %@",s);
}


- (void) bleDidDisconnect
{

    [self.buttonForward setEnabled:NO];
    [self.buttonReverse setEnabled:NO];
    [self.buttonRight setEnabled:NO];
    [self.buttonLeft setEnabled:NO];

    
    [self.buttonConnect setImage:[UIImage imageNamed:@"disconnect"] forState:UIControlStateNormal];
}

-(void) bleDidConnect
{
    [self.spinner stopAnimating];
    [self.buttonConnect setImage:[UIImage imageNamed:@"connect"] forState:UIControlStateNormal];
    
    [self.buttonForward setEnabled:YES];
    [self.buttonReverse setEnabled:YES];
    [self.buttonRight setEnabled:YES];
    [self.buttonLeft setEnabled:YES];
    
}


- (IBAction)buttonNavigationTouched:(UIButton *)button{
    if (button.tag==1) {
        NSLog(@"Command: Forward");
        [self BLEShieldSendCommand:@"MF"];
    }else if (button.tag==2) {
        NSLog(@"Command: Reverse");
        [self BLEShieldSendCommand:@"MR"];
    }else if (button.tag==3) {
        NSLog(@"Command: Right");
        [self BLEShieldSendCommand:@"TR"];
    }else if (button.tag==4) {
        NSLog(@"Command: Left");
        [self BLEShieldSendCommand:@"TL"];
    }
    
    
}

- (IBAction)buttonNavigationReleased:(UIButton *)button{
    NSLog(@"Command: Stop");
    [self BLEShieldSendCommand:@"SA"];
}

- (void)BLEShieldSendCommand:(NSString *)commandText{
    NSString * commandString = [NSString stringWithFormat:@"%@\r\n", commandText];
    NSData * commandDataToSend = [commandString dataUsingEncoding:NSUTF8StringEncoding];
    [bleShield write:commandDataToSend];
}

- (IBAction)BLEShieldScan:(id)sender
{
    if (bleShield.activePeripheral)
        if(bleShield.activePeripheral.isConnected)
        {
            [[bleShield CM] cancelPeripheralConnection:[bleShield activePeripheral]];
            return;
        }
    
    if (bleShield.peripherals)
        bleShield.peripherals = nil;
    
    [bleShield findBLEPeripherals:3];
    
    [NSTimer scheduledTimerWithTimeInterval:(float)3.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
    
    [self.spinner startAnimating];
}

@end
