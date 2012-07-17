//
//  ZenPlayerButton.m
//  zenplayer
//
//  Created by noradaiko on 2/4/12.
//  Copyright (c) 2012 noradaiko. All rights reserved.
//

#import "ZenPlayerButton.h"
#import "debug.h"

@interface ZenPlayerButton ()
{
@private
    BOOL initialized;
}

@property (nonatomic, retain) ZenLayerBackground* layerBackground;
@property (nonatomic, retain) ZenLayerContainer* layerContainer;

/**
 * Initialize layers
 */
- (void) initLayers;

#pragma mark customized tap event

/**
 * Invoked when the tap began in the view
 */
- (void) tapBegan;

/**
 * Invoked when the view was tapped
 */
- (void) tapDone;

/**
 * Invoked when the view was cancelled to tap
 */
- (void) tapCancelled;

@end



@implementation ZenPlayerButton

@synthesize layerBackground=_layerBackground;
@synthesize layerContainer=_layerContainer;
@synthesize state=_state;
@synthesize progress=_progress;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        initialized = NO;
        self.progress = 0.0f;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        initialized = NO;
        self.progress = 0.0f;
    }
    return self;
}

-(void)dealloc
{
    LOG_CURRENT_METHOD;

    self.layerBackground = nil;
    self.layerContainer = nil;
}

/**
 * Initialize layers
 */
- (void) initLayers
{
    LOG_CURRENT_METHOD;
    if(!initialized)
    {
        self.layer.sublayers = nil;
        self.backgroundColor = [UIColor clearColor];

        self.layerBackground = [ZenLayerBackground layerWithFrame:self.bounds];
        self.layerBackground.position=CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);

        CGFloat scale = 140.0f / 208.0f;
        CGRect frameContainer = CGRectMake(0.0, 0.0, self.bounds.size.width * scale, self.bounds.size.height * scale);
        self.layerContainer = [ZenLayerContainer layerWithFrame:frameContainer];
        self.layerContainer.position=CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);

        [self.layer addSublayer:self.layerBackground];
        [self.layer addSublayer:self.layerContainer];

        [self.layerBackground setNeedsDisplay];
        [self.layerContainer setNeedsDisplay];

        self.state = ZenPlayerButtonStateNormal;
        initialized = YES;
    }
}

- (void)layoutSubviews
{
    [self initLayers];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{    
    if(touches.count==1)
        for (UITouch *touch in touches)
        {
            CGPoint pos = [touch locationInView:self];
            if(pos.x>=0 && 
               pos.y>=0 &&
               pos.x<self.bounds.size.width && 
               pos.y<self.bounds.size.height)
                [self tapBegan];
        }
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(touches.count==1)
        for (UITouch *touch in touches)
        {
            CGPoint pos = [touch locationInView:self];
            if(pos.x>=0 &&
               pos.y>=0 &&
               pos.x<self.bounds.size.width &&
               pos.y<self.bounds.size.height)
                [self tapDone];
            else
                [self tapCancelled];
        }
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
}

#pragma mark customized tap event

/**
 * Invoked when the tap began in the view
 */
- (void) tapBegan
{
    switch (self.state)
    {
        case ZenPlayerButtonStateNormal:
            [self.layerContainer.layerPlayButton shrink];
            break;
            
        case ZenPlayerButtonStatePlaying:
            break;
            
        default:
            break;
    }
}

/**
 * Invoked when the view was tapped
 */
- (void) tapDone
{
    switch (self.state)
    {
        case ZenPlayerButtonStateNormal:
            self.state = ZenPlayerButtonStateLoading;
            break;
            
        case ZenPlayerButtonStateLoading:
            self.state = ZenPlayerButtonStateNormal;
            break;
            
        case ZenPlayerButtonStatePlaying:
            self.state = ZenPlayerButtonStateNormal;
            break;
            
        default:
            break;
    }    
}

/**
 * Invoked when the view was cancelled to tap
 */
- (void) tapCancelled
{
    [self.layerContainer.layerPlayButton bulge];
}

- (void)setState:(ZenPlayerButtonState)state
{
    switch (state)
    {
        case ZenPlayerButtonStatePlaying:
            [self.layerContainer.layerPlayButton fadeOut];
            [self.layerContainer.layerPauseButton fadeUp];
            [self.layerContainer.layerCircle rotateForward];
            [self.layerContainer.layerCircle bulge];

            {
                CABasicAnimation* a = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
                a.toValue = (id)[UIColor cyanColor].CGColor;
                a.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                a.fillMode = kCAFillModeForwards;
                a.removedOnCompletion = NO;
                [self.layerContainer.layerCircle addAnimation:a forKey:@"backgroundColor"];
            }

            self->_state = state;
            break;
            
        case ZenPlayerButtonStateLoading:
            [self.layerContainer.layerPlayButton fadeOut];
            [self.layerContainer.layerPauseButton fadeUp];
            [self.layerContainer.layerCircle rotateBack];
            [self.layerContainer.layerCircle bulge];
            self.layerContainer.layerCircle.backgroundColor = [UIColor greenColor].CGColor;
            
            self->_state = state;
            break;

        case ZenPlayerButtonStateNormal:
            [self.layerContainer.layerPlayButton fadeUp];
            [self.layerContainer.layerPlayButton bulge];
            [self.layerContainer.layerPauseButton fadeOut];
            [self.layerContainer.layerCircle shrink];
            [self.layerContainer.layerCircle stopRotation];
            self.layerContainer.layerCircle.backgroundColor = [UIColor greenColor].CGColor;
            
            self->_state = state;
            break;

        default:
            break;
    }    
}


- (void)setProgress:(CGFloat)progress
{
    if(progress!=self->_progress)
    {
        while(progress>1.01f) progress-=1.0f;
        self.layerContainer.layerProgress.progress = progress;
        self->_progress = progress;
    }
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];

    if(!enabled)
        self.layerContainer.layerPlayButton.tintColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    else
        self.layerContainer.layerPlayButton.tintColor = [UIColor clearColor];
}

@end





#pragma mark - ZenLayerBackground

/**
 * Background layer of the zen player button
 */
@implementation ZenLayerBackground

@synthesize imgBackground=_imgBackground;

/**
 * Create and initialize layer.
 * @param   frame  The frame of the layer
 * @return  A newly initialized layer
 */
+ (ZenLayerBackground*) layerWithFrame: (CGRect) frame
{
    LOG_CURRENT_METHOD;
    ZenLayerBackground* instance = [super layer];
    if(instance)
    {
        instance.imgBackground = [UIImage imageNamed:@"zenpb_bg.png"];
        instance.needsDisplayOnBoundsChange = YES;
        instance.frame = frame;
    }
    return instance;
}

- (void)dealloc
{
    LOG_CURRENT_METHOD;
    self.imgBackground = nil;
}

- (void)display
{
    [super display];

    self.contents = (id)self.imgBackground.CGImage;
    self.cornerRadius = self.bounds.size.width / 2;
    self.masksToBounds = YES;
}

@end




#pragma mark - ZenLayerContainer

/**
 * Layer for containing button layers and masking them
 */
@implementation ZenLayerContainer

@synthesize layerCircle=_layerCircle;
@synthesize layerProgress=_layerProgress;
@synthesize layerPlayButton=_layerPlayButton;
@synthesize layerPauseButton=_layerPauseButton;


/**
 * Create and initialize layer.
 * @param   frame  The frame of the layer
 * @return  A newly initialized layer
 */
+ (ZenLayerContainer*) layerWithFrame: (CGRect) frame
{
    LOG_CURRENT_METHOD;
    ZenLayerContainer* instance = [super layer];
    if(instance)
    {
        instance.frame = frame;
        instance.needsDisplayOnBoundsChange = YES;
        instance.layerCircle      = [ZenLayerCircle layerWithFrame:instance.bounds];
        instance.layerProgress    = [ZenLayerProgress layerWithFrame:instance.bounds];
        instance.layerPlayButton  = [ZenLayerPlayButton layerWithFrame:instance.bounds];
        instance.layerPauseButton = [ZenLayerPauseButton layerWithFrame:instance.bounds];

        instance.cornerRadius = instance.bounds.size.width / 2;
        instance.masksToBounds = YES;

        instance.layerPauseButton.hidden = YES;

        [instance addSublayer:instance.layerCircle];
        [instance addSublayer:instance.layerProgress];
        [instance addSublayer:instance.layerPlayButton];
        [instance addSublayer:instance.layerPauseButton];


        [instance setNeedsDisplay];
    }
    return instance;
}

- (void)dealloc
{
    LOG_CURRENT_METHOD;
    self.layerCircle = nil;
    self.layerPauseButton = nil;
    self.layerPlayButton = nil;
    self.layerProgress = nil;
}

- (void)display
{
    [super display];

    self.cornerRadius = self.bounds.size.width / 2;
    
    self.layerCircle.frame = self.bounds;
    self.layerProgress.frame = self.bounds;
    self.layerPlayButton.frame = self.bounds;
    self.layerPauseButton.frame = self.bounds;
    
    [self.layerCircle setNeedsDisplay];
    [self.layerProgress setNeedsDisplay];
    [self.layerPlayButton setNeedsDisplay];
    [self.layerPauseButton setNeedsDisplay];
}


@end





#pragma mark - ZenLayerCircle

@implementation ZenLayerCircle

@synthesize imgCircle=_imgCircle;
@synthesize originalSize=_originalSize;
@synthesize rotateBackKey=_rotateBackKey;
@synthesize rotateForwardKey=_rotateForwardKey;

/**
 * Create and initialize layer.
 * @param   frame  The frame of the layer
 * @return  A newly initialized layer
 */
+ (ZenLayerCircle*) layerWithFrame: (CGRect) frame
{
    LOG_CURRENT_METHOD;
    ZenLayerCircle* instance = [super layer];
    if(instance)
    {
        instance.frame = frame;
        instance.originalSize = frame.size;
        instance.needsDisplayOnBoundsChange = YES;
        instance.imgCircle = [UIImage imageNamed:@"zenpb_circle.png"];
        instance.backgroundColor = [UIColor greenColor].CGColor;
        instance.contents = (id)instance.imgCircle.CGImage;
        instance.contentsScale = [[UIScreen mainScreen] scale];

        instance.rotateBackKey    = @"rotateBack";
        instance.rotateForwardKey = @"rotateForward";
//        instance.imgCircle = [UIImage imageNamed:@"zenpb_progress.png"];
        
        instance.cornerRadius  = frame.size.width / 2;
        instance.masksToBounds = YES;

    }
    return instance;
}

- (void)dealloc
{
    LOG_CURRENT_METHOD;
    self.contents = nil;
    self.imgCircle = nil;
    self.rotateBackKey = nil;
    self.rotateForwardKey = nil;
}
/*
- (void)display
{
    [super display];

    self.cornerRadius = self.bounds.size.width / 2;
    self.masksToBounds = YES;
}
*/
/*
- (void)layoutSublayers
{
    [super layoutSublayers];
    LOG_CURRENT_METHOD;

}
*/
- (void)drawInContext:(CGContextRef)ctx
{
    LOG_CURRENT_METHOD;
    [super drawInContext:ctx];

    CGRect r = CGContextGetClipBoundingBox(ctx);
    LOG(@"%f, %f", r.size.width, r.size.height);

    // draw image
    CGContextSaveGState(ctx);
    CGContextTranslateCTM(ctx, 0.0f, r.size.height);
    CGContextScaleCTM(ctx, 1.0f, -1.0f);

    CGContextClearRect(ctx, r);
    CGContextDrawImage(ctx, r, self.imgCircle.CGImage);
    
    CGContextRestoreGState(ctx);
    
    if(r.size.width<self.bounds.size.width ||
       r.size.height<self.bounds.size.height)
    {
        [self setNeedsDisplayInRect:self.bounds];
    }
}

/**
 * shrink the play button with animation
 */
- (void) shrink
{
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:0.2f]
                     forKey:kCATransactionAnimationDuration];
    
    CGRect newBounds = self.bounds;
    newBounds.size.width  *= 0.8f;
    newBounds.size.height *= 0.8f;
    self.cornerRadius = newBounds.size.width / 2;
    self.bounds = newBounds;

    [CATransaction commit];
}

/**
 * Bulge the play button with animation
 */
- (void) bulge
{
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:0.2f]
                     forKey:kCATransactionAnimationDuration];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];

//    self.backgroundColor = [UIColor cyanColor].CGColor;
    CGRect newBounds = self.bounds;
    newBounds.size = self.originalSize;
    self.bounds = newBounds;
    self.cornerRadius = newBounds.size.width / 2;
//    [self setNeedsDisplay];

    [CATransaction commit];
}


- (CABasicAnimation*) getRotateBackAnimationFromValue: (NSNumber*) fromValue
{
//    NSNumber* currentTransform = (NSNumber*)[(CALayer*)self.presentationLayer valueForKeyPath:@"transform.rotation"];
    // create an animation to hold "zRotation" transform
    CABasicAnimation *animateZRotation;
    animateZRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    // Assign "zRotation" to animation
    animateZRotation.fromValue = fromValue;
    animateZRotation.toValue   = [NSNumber numberWithFloat:fromValue.floatValue + ((90*M_PI)/180)];
    // Duration, repeat count, etc
    animateZRotation.duration = 0.5f;//change this depending on your animation needs
    // Here set cumulative, repeatCount, kCAFillMode, and others found in
    // the CABasicAnimation Class Reference.
    animateZRotation.repeatCount = HUGE_VALF;
    //    animateZRotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animateZRotation.fillMode = kCAFillModeForwards;
    animateZRotation.removedOnCompletion = NO;
    animateZRotation.cumulative = YES;

    return animateZRotation;
}


- (CABasicAnimation*) getRotateForwardAnimationFromValue: (NSNumber*) fromValue
{
    // create an animation to hold "zRotation" transform
    CABasicAnimation *animateZRotation;
    animateZRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    // Assign "zRotation" to animation
//    animateZRotation.fromValue = currentTransform;
    animateZRotation.fromValue = fromValue;
    animateZRotation.toValue   = [NSNumber numberWithFloat:fromValue.floatValue + ((-90*M_PI)/180)];
//    animateZRotation.toValue   = [NSNumber numberWithFloat:((-90*M_PI)/180)];
    // Duration, repeat count, etc
    animateZRotation.duration = 3.0f;//change this depending on your animation needs
    // Here set cumulative, repeatCount, kCAFillMode, and others found in
    // the CABasicAnimation Class Reference.
    animateZRotation.repeatCount = HUGE_VALF;
    animateZRotation.fillMode = kCAFillModeForwards;
    animateZRotation.removedOnCompletion = NO;
    animateZRotation.cumulative = YES;

    return animateZRotation;
}


/**
 * Rotate layer clockwise
 */
- (void) rotateBack
{
    [self stopRotation];

    // create an animation to hold "zRotation" transform
    CABasicAnimation *animateZRotation = [self getRotateBackAnimationFromValue:[NSNumber numberWithFloat:0]];

    [self addAnimation:animateZRotation forKey:self.rotateBackKey];
}

/**
 * Rotate layer counterclockwise
 */
- (void) rotateForward
{
    CABasicAnimation *animationRotateBack = (CABasicAnimation *)[self animationForKey:self.rotateBackKey];
    if(animationRotateBack)
    {
        [self stopRotation];
        
        // get current rotation radian
        NSNumber* currentRotation = (NSNumber*)[(CALayer*)self.presentationLayer valueForKeyPath:@"transform.rotation"];

        // stop slowly
        animationRotateBack = [self getRotateBackAnimationFromValue:currentRotation];
        animationRotateBack.repeatCount = 1;
        animationRotateBack.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        animationRotateBack.duration *= 1.5;

        CABasicAnimation *animationRotateForward1, *animationRotateForward2, *animationRotateForward3;

        // begin rotating forward
        // step 1: accel rotating
        animationRotateForward1 = [self getRotateForwardAnimationFromValue:animationRotateBack.toValue];
        animationRotateForward1.repeatCount = 1;
        animationRotateForward1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        animationRotateForward1.beginTime = animationRotateBack.duration;
        animationRotateForward1.removedOnCompletion = YES;

        // step 2: rotate to radian=0
        CGFloat toValue = [(NSNumber*)animationRotateForward1.toValue floatValue];
        toValue = (M_PI*2 * (floor(toValue / (M_PI*2))));
        CGFloat fromValue = [(NSNumber*)animationRotateForward1.toValue floatValue];
        animationRotateForward2 = [self getRotateForwardAnimationFromValue:animationRotateForward1.toValue];
        animationRotateForward2.beginTime = animationRotateForward1.beginTime + animationRotateForward1.duration;
        animationRotateForward2.toValue = [NSNumber numberWithDouble:toValue];
        animationRotateForward2.duration = animationRotateForward1.duration * 3.0 * ((fromValue - toValue) / M_PI / 2);
        animationRotateForward2.repeatCount = 1;
        animationRotateForward2.removedOnCompletion = YES;
//        LOG(@"(fromValue - toValue) / M_PI / 2 = %f", (fromValue - toValue) / M_PI / 2);

        // step 3: keep rotating
        animationRotateForward3 = [self getRotateForwardAnimationFromValue:animationRotateForward2.toValue];
        animationRotateForward3.beginTime = animationRotateForward2.beginTime + animationRotateForward2.duration;
//        LOG(@"animationRotateForward2.beginTime + animationRotateForward2.duration = %f", animationRotateForward2.beginTime + animationRotateForward2.duration);

        CAAnimationGroup* group = [CAAnimationGroup animation];
        group.animations = [NSArray arrayWithObjects:animationRotateBack, 
                                                     animationRotateForward1, 
                                                     animationRotateForward2, 
                                                     animationRotateForward3,
                                                     nil];
        group.duration = UINT_MAX;
        group.fillMode = kCAFillModeForwards;
        [self addAnimation:group forKey:self.rotateForwardKey];
    }
    else
    if(![self animationForKey:self.rotateForwardKey])
    {
        [self stopRotation];
        // create an animation to hold "zRotation" transform
        CABasicAnimation *animateZRotation = [self getRotateForwardAnimationFromValue:[NSNumber numberWithFloat:0]];
        [self addAnimation:animateZRotation forKey:self.rotateForwardKey];
    }
    
}

/**
 * Stop rotation
 */
- (void) stopRotation
{
    [self removeAllAnimations];
}

@end


#pragma mark -ZenLayerProgress

@implementation ZenLayerProgress

@synthesize imgProgress=_imgProgress;
@synthesize progress=_progress;

/**
 * Create and initialize layer.
 * @param   frame  The frame of the layer
 * @return  A newly initialized layer
 */
+ (ZenLayerProgress*) layerWithFrame: (CGRect) frame
{
    LOG_CURRENT_METHOD;
    ZenLayerProgress* instance = [super layer];
    if(instance)
    {
        instance.frame = frame;
        instance.imgProgress = [UIImage imageNamed:@"zenpb_progress.png"];
        instance.progress = 0.0f;
    }
    return instance;
}

- (void)dealloc
{
    LOG_CURRENT_METHOD;
    self.contents = nil;
    self.imgProgress = nil;
}
/*
- (void)display
{
    [super display];
    self.contents = (id)self.imgProgress.CGImage;
}
*/

- (void)drawInContext:(CGContextRef)ctx
{
    LOG_CURRENT_METHOD;
    [super drawInContext:ctx];
    
    CGRect r = CGContextGetClipBoundingBox(ctx);
    LOG(@"%f, %f", r.size.width, r.size.height);
    
    // draw image
    CGContextSaveGState(ctx);
    CGContextTranslateCTM(ctx, 0.0f, r.size.height);
    CGContextScaleCTM(ctx, 1.0f, -1.0f);
    
    CGContextClearRect(ctx, r);
    CGContextDrawImage(ctx, r, self.imgProgress.CGImage);
    
    CGContextRestoreGState(ctx);
}


- (void)setProgress:(CGFloat)progress
{
    if(progress!=self->_progress)
    {
//        LOG(@"progress = %f", progress);        

        CGFloat f_to_angle = (progress * 2.0f * M_PI);
        CGFloat f_from_angle = (self->_progress * 2.0f * M_PI);
        if(f_from_angle>M_PI)
        {
            if(f_to_angle<M_PI)
                f_to_angle += 2.0f * M_PI;
        }

//        LOG(@"#### %f --> %f", f_from_angle, f_to_angle);
        NSNumber* to_angle = [NSNumber numberWithFloat:f_to_angle];
//        LOG(@"to_angle = %@", to_angle);

        NSNumber* from_angle = [NSNumber numberWithFloat:f_from_angle];
    //    NSNumber* from_angle = (NSNumber*)[(CALayer*)self valueForKeyPath:@"transform.rotation"];
//        LOG(@"from_angle = %@", from_angle);
        if(from_angle.floatValue<0)
            from_angle = [NSNumber numberWithFloat:from_angle.floatValue + M_PI * 2.0f];

        // create an animation to hold "zRotation" transform
        CABasicAnimation *animateZRotation;
        animateZRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        // Assign "zRotation" to animation
        animateZRotation.fromValue = from_angle;
        animateZRotation.toValue   = to_angle;

//        LOG(@"%@ => %@", animateZRotation.fromValue, animateZRotation.toValue);

        // Duration, repeat count, etc
        if(progress!=0.0f)
            animateZRotation.duration = 0.8f;
        else
        {
            animateZRotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            animateZRotation.duration = 0.8f;
        }
        animateZRotation.fillMode = kCAFillModeForwards;
        animateZRotation.removedOnCompletion = NO;
        animateZRotation.delegate = self;

        [self addAnimation:animateZRotation forKey:nil];

        self->_progress = progress;
    }
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
//    LOG_CURRENT_METHOD;
    CABasicAnimation* ani = (CABasicAnimation*)theAnimation;
    NSNumber* angle = (NSNumber*)ani.toValue;
    if(angle.floatValue>2.0f * M_PI)
        angle = [NSNumber numberWithFloat:angle.floatValue - 2.0f * M_PI];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];

    [self setValue:angle forKeyPath:@"transform.rotation"];

    [CATransaction commit];
}


@end


#pragma mark - ZenLayerPlayButton

@implementation ZenLayerPlayButton

@synthesize imgPlayButton=_imgPlayButton;
@synthesize originalSize=_originalSize;
@synthesize tintColor=_tintColor;

/**
 * Create and initialize layer.
 * @param   frame  The frame of the layer
 * @return  A newly initialized layer
 */
+ (ZenLayerPlayButton*) layerWithFrame: (CGRect) frame
{
    LOG_CURRENT_METHOD;
    ZenLayerPlayButton* instance = [super layer];
    if(instance)
    {
        instance.frame = frame;
        instance.originalSize = frame.size;
        instance.needsDisplayOnBoundsChange = YES;
        instance.imgPlayButton = [UIImage imageNamed:@"zenpb_playbutton.png"];
        instance.tintColor = [UIColor clearColor];
        instance.contentsScale = [[UIScreen mainScreen] scale];
    }
    return instance;
}

- (void)dealloc
{
    LOG_CURRENT_METHOD;
    self.contents = nil;
    self.imgPlayButton = nil;
}

/*
- (void)display
{
    [super display];
    
    self.contents = (id)self.imgPlayButton.CGImage;
}
*/

- (void)drawInContext:(CGContextRef)ctx
{
    [super drawInContext:ctx];
    
    // draw image
    CGContextSaveGState(ctx);
    CGContextTranslateCTM(ctx, 0.0f, self.bounds.size.height);
    CGContextScaleCTM(ctx, 1.0f, -1.0f);

    CGContextClearRect(ctx, self.bounds);
    CGContextDrawImage(ctx, self.bounds, self.imgPlayButton.CGImage);
    
    CGContextRestoreGState(ctx);

    // tint
    CGContextSetBlendMode(ctx,kCGBlendModeMultiply);
    CGContextSetFillColorWithColor(ctx, self.tintColor.CGColor);
    CGContextFillEllipseInRect(ctx, self.bounds);
}

/**
 * shrink the play button with animation
 */
- (void) shrink
{
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:0.2f]
                     forKey:kCATransactionAnimationDuration];

    CGRect newBounds = self.bounds;
    newBounds.size.width  *= 0.6f;
    newBounds.size.height *= 0.6f;
    self.bounds = newBounds;
    self.opacity = 0.5f;

    [CATransaction commit];
}

/**
 * Bulge the play button with animation
 */
- (void) bulge
{
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:0.2f]
                     forKey:kCATransactionAnimationDuration];
    
    CGRect newBounds = self.bounds;
    newBounds.size = self.originalSize;
    self.bounds = newBounds;
    self.opacity = 1.0f;
    
    [CATransaction commit];
}

/**
 * hide with animation
 */
- (void) fadeOut
{
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:0.5f]
                     forKey:kCATransactionAnimationDuration];
    
    self.hidden = YES;
    
    [CATransaction commit];
}

/**
 * show with animation
 */
- (void) fadeUp
{
    self.hidden = NO;
}


- (void)setTintColor:(UIColor *)tintColor
{
    self->_tintColor = tintColor;

    [self setNeedsDisplay];
}


@end


#pragma mark -ZenLayerPauseButton

@implementation ZenLayerPauseButton

@synthesize imgPauseButton=_imgPauseButton;

/**
 * Create and initialize layer.
 * @param   frame  The frame of the layer
 * @return  A newly initialized layer
 */
+ (ZenLayerPauseButton*) layerWithFrame: (CGRect) frame
{
    LOG_CURRENT_METHOD;
    ZenLayerPauseButton* instance = [super layer];
    if(instance)
    {
        instance.frame = frame;
        instance.needsDisplayOnBoundsChange = YES;
        instance.imgPauseButton = [UIImage imageNamed:@"zenpb_pausebutton.png"];
    }
    return instance;
}

- (void)dealloc
{
    LOG_CURRENT_METHOD;
    self.contents = nil;
    self.imgPauseButton = nil;
}

- (void)display
{
    [super display];
    
    self.contents = (id)self.imgPauseButton.CGImage;
}


/**
 * hide with animation
 */
- (void) fadeOut
{
    self.hidden = YES;
}

/**
 * show with animation
 */
- (void) fadeUp
{
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:0.5f]
                     forKey:kCATransactionAnimationDuration];
    
    self.hidden = NO;
    
    [CATransaction commit];
}


@end



