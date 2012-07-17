//
//  ViewController.m
//  ZenPlayerDemo
//
//  Created by noradaiko on 7/17/12.
//  Copyright (c) 2012 noradaiko. All rights reserved.
//

#import "ViewController.h"
#import "debug.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize zenPlayerButton=_zenPlayerButton;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // create new zen player button
    self.zenPlayerButton = [[ZenPlayerButton alloc] initWithFrame:CGRectMake(108, 178, 104, 104)];
    // listening to tap event on the button
    [self.zenPlayerButton addTarget:self
                             action:@selector(zenPlayerButtonDidTouchUpInside:) 
                   forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.zenPlayerButton];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction) rewind:(id)sender;
{
    self.zenPlayerButton.progress = 0.0f;
}

- (IBAction) forward:(id)sender;
{
    self.zenPlayerButton.progress += 0.1f;
}

- (IBAction) changeState:(id)sender;
{
    self.zenPlayerButton.state = ZenPlayerButtonStatePlaying;
}

- (void) zenPlayerButtonDidTouchUpInside:(id)sender;
{
    LOG_CURRENT_METHOD;
}

@end
