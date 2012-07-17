//
//  ViewController.h
//  ZenPlayerDemo
//
//  Created by noradaiko on 7/17/12.
//  Copyright (c) 2012 noradaiko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZenPlayerButton.h"

@interface ViewController : UIViewController

@property (nonatomic, retain) ZenPlayerButton* zenPlayerButton;

- (IBAction) rewind:(id)sender;
- (IBAction) forward:(id)sender;
- (IBAction) changeState:(id)sender;
- (void) zenPlayerButtonDidTouchUpInside:(id)sender;


@end
