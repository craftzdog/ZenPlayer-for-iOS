//
//  ZenPlayerButton.h
//  zenplayer
//
//  Created by noradaiko on 2/4/12.
//  Copyright (c) 2012 noradaiko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@class ZenLayerBackground;
@class ZenLayerContainer;
@class ZenLayerCircle;
@class ZenLayerProgress;
@class ZenLayerPlayButton;
@class ZenLayerPauseButton;



#pragma mark - ZenPlayerButton definition

typedef enum {

    ZenPlayerButtonStateNormal,
    ZenPlayerButtonStateLoading,
    ZenPlayerButtonStatePlaying
    
} ZenPlayerButtonState;


@interface ZenPlayerButton : UIControl

/**
 * State of the button
 */
@property (nonatomic, assign) ZenPlayerButtonState state;
/**
 * Progress in range from 0.0f to 1.0f
 */
@property (nonatomic, assign) CGFloat progress;


@end



#pragma mark - ZenLayerBackground

/**
 * Background layer of the zen player button
 */
@interface ZenLayerBackground : CALayer

@property (nonatomic, retain) UIImage* imgBackground;

/**
 * Create and initialize layer.
 * @param   frame  The frame of the layer
 * @return  A newly initialized layer
 */
+ (ZenLayerBackground*) layerWithFrame: (CGRect) frame;

@end


#pragma mark - ZenLayerContainer

/**
 * Container and mask for sub layers
 */
@interface ZenLayerContainer : CALayer

@property (nonatomic, retain) ZenLayerCircle*      layerCircle;
@property (nonatomic, retain) ZenLayerProgress*    layerProgress;
@property (nonatomic, retain) ZenLayerPlayButton*  layerPlayButton;
@property (nonatomic, retain) ZenLayerPauseButton* layerPauseButton;

/**
 * Create and initialize layer.
 * @param   frame  The frame of the layer
 * @return  A newly initialized layer
 */
+ (ZenLayerContainer*) layerWithFrame: (CGRect) frame;

@end


#pragma mark - ZenLayerCircle

/**
 * Layer drawing the state of the player
 */
@interface ZenLayerCircle : CALayer

@property (nonatomic, retain) UIImage* imgCircle;
@property (nonatomic, assign) CGSize originalSize;
@property (nonatomic, retain) NSString* rotateBackKey;
@property (nonatomic, retain) NSString* rotateForwardKey;

/**
 * Create and initialize layer.
 * @param   frame  The frame of the layer
 * @return  A newly initialized layer
 */
+ (ZenLayerCircle*) layerWithFrame: (CGRect) frame;

/**
 * shrink the play button with animation
 */
- (void) shrink;

/**
 * Bulge the play button with animation
 */
- (void) bulge;


- (CABasicAnimation*) getRotateBackAnimationFromValue: (NSNumber*) fromValue;
- (CABasicAnimation*) getRotateForwardAnimationFromValue: (NSNumber*) fromValue;

/**
 * Rotate layer clockwise
 */
- (void) rotateBack;

/**
 * Rotate layer counterclockwise
 */
- (void) rotateForward;

/**
 * Stop rotation
 */
- (void) stopRotation;

@end


#pragma mark -ZenLayerProgress

/**
 * Layer drawing progress of the player
 */
@interface ZenLayerProgress : CALayer

@property (nonatomic, retain) UIImage* imgProgress;
@property (nonatomic, assign) CGFloat progress;

/**
 * Create and initialize layer.
 * @param   frame  The frame of the layer
 * @return  A newly initialized layer
 */
+ (ZenLayerProgress*) layerWithFrame: (CGRect) frame;

@end


#pragma mark - ZenLayerPlayButton

/**
 * Layer drawing play button
 */
@interface ZenLayerPlayButton : CALayer

@property (nonatomic, retain) UIImage* imgPlayButton;
@property (nonatomic, assign) CGSize originalSize;
@property (nonatomic, retain) UIColor* tintColor;

/**
 * Create and initialize layer.
 * @param   frame  The frame of the layer
 * @return  A newly initialized layer
 */
+ (ZenLayerPlayButton*) layerWithFrame: (CGRect) frame;

/**
 * shrink the play button with animation
 */
- (void) shrink;

/**
 * Bulge the play button with animation
 */
- (void) bulge;

/**
 * hide with animation
 */
- (void) fadeOut;

/**
 * show with animation
 */
- (void) fadeUp;


@end


#pragma mark -ZenLayerPauseButton

/**
 * Layer drawing pause button
 */
@interface ZenLayerPauseButton : CALayer

@property (nonatomic, retain) UIImage* imgPauseButton;
/**
 * Create and initialize layer.
 * @param   frame  The frame of the layer
 * @return  A newly initialized layer
 */
+ (ZenLayerPauseButton*) layerWithFrame: (CGRect) frame;

/**
 * hide with animation
 */
- (void) fadeOut;

/**
 * show with animation
 */
- (void) fadeUp;

@end


