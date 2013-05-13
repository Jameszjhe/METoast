/*
 * Copyright (c) 2013, James Lee<jamesqianlee@gmail.com>
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of James Lee nor the names of its contributors may
 *       be used to endorse or promote products derived from this software
 *       without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY JAMES LEE "AS IS" AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL JAMES LEE AND CONTRIBUTORS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "METoast.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation METoastAttribute

@synthesize backgroundColor = backgroundColor_;
@synthesize borderColor = borderColor_;
@synthesize textColor = textColor_;
@synthesize textFont = textFont_;
@synthesize location = location_;
@synthesize borderWidth = borderWidth_;

- (id)init {
    self = [super init];
    
    if (self) {
        backgroundColor_ = [[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0]
                            retain];
        borderColor_ = [[UIColor colorWithRed:.3 green:.3 blue:.3 alpha:1.0]
                        retain];
        textColor_ = [[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]
                      retain];
        textFont_ = [[UIFont systemFontOfSize:14.0f] retain];
        location_ = METoastLocationBottom;
        borderWidth_ = 2.0f;
    }
    
    return self;
}

- (void)dealloc {
    [backgroundColor_ release];
    [borderColor_ release];
    [textColor_ release];
    [textFont_ release];
    [super dealloc];
}

@end
//******************************************************************************

#define METoastViewMargin 10.0f
#define METoastViewCornerRadius 4.0f

@interface METoastView : UIView {
    NSString *message_;
}

@property (nonatomic, retain) NSString *message;

- (id)initWithMessage:(NSString *)msg;

@end

@implementation METoastView

@synthesize message = message_;

- (id)initWithMessage:(NSString *)msg {
    METoastAttribute *attri = [METoast toastAttribute];
    
    CGFloat maxWidth = floorf(0.8*CGRectGetWidth([UIScreen mainScreen].bounds));
    CGSize cSize = [@"#" sizeWithFont:attri.textFont];
    maxWidth = maxWidth - 2 * METoastViewMargin;
    CGFloat maxHeight = 3 * cSize.height + 2 * METoastViewMargin;
    CGSize textSize = [msg sizeWithFont:attri.textFont
                      constrainedToSize:CGSizeMake(maxWidth, maxHeight)
                          lineBreakMode:NSLineBreakByWordWrapping];
    CGRect bounds = CGRectMake(0,
                               0,
                               textSize.width + 2 * METoastViewMargin,
                               textSize.height + 2 * METoastViewMargin);
    
    self = [super initWithFrame:bounds];
    if (self) {
        self.message = msg;
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    METoastAttribute *attri = [METoast toastAttribute];
    CGFloat o = attri.borderWidth / 2.0f;
    CGFloat r = METoastViewCornerRadius;
    CGFloat m = METoastViewMargin;
    
    CGContextRef ctxt = UIGraphicsGetCurrentContext();
    
    CGContextClearRect(ctxt, rect);
    
    CGFloat minX = CGRectGetMinX(rect);
    CGFloat minY = CGRectGetMinY(rect);
    CGFloat midX = CGRectGetMidX(rect);
    CGFloat midY = CGRectGetMidY(rect);
    CGFloat maxX = CGRectGetMaxX(rect);
    CGFloat maxY = CGRectGetMaxY(rect);
    
    CGContextSaveGState(ctxt);
    CGContextSetLineWidth(ctxt, attri.borderWidth);
    CGContextSetFillColorWithColor(ctxt, attri.backgroundColor.CGColor);
    CGContextSetStrokeColorWithColor(ctxt, attri.backgroundColor.CGColor);
    CGContextMoveToPoint(ctxt, minX + o, midY);
    CGContextAddArcToPoint(ctxt, minX + o, minY + o, midX, minY + o, r);
    CGContextAddArcToPoint(ctxt, maxX - o, minY + o, maxX - o, midY, r);
    CGContextAddArcToPoint(ctxt, maxX - o, maxY - o, midX, maxY - o, r);
    CGContextAddArcToPoint(ctxt, minX + o, maxY - o, minX + o, midY, r);
    CGContextClosePath(ctxt);
    CGContextFillPath(ctxt);
    CGContextRestoreGState(ctxt);
    
    CGContextSaveGState(ctxt);
    CGContextSetLineWidth(ctxt, attri.borderWidth);
    CGContextSetStrokeColorWithColor(ctxt, attri.borderColor.CGColor);
    CGContextMoveToPoint(ctxt, minX + o, midY);
    CGContextAddArcToPoint(ctxt, minX + o, minY + o, midX, minY + o, r);
    CGContextAddArcToPoint(ctxt, maxX - o, minY + o, maxX - o, midY, r);
    CGContextAddArcToPoint(ctxt, maxX - o, maxY - o, midX, maxY - o, r);
    CGContextAddArcToPoint(ctxt, minX + o, maxY - o, minX + o, midY, r);
    CGContextClosePath(ctxt);
    CGContextStrokePath(ctxt);
    CGContextRestoreGState(ctxt);
    
    CGContextSaveGState(ctxt);
    CGContextSetFillColorWithColor(ctxt, attri.textColor.CGColor);
    CGRect textRect = CGRectInset(rect, m, m);
    [self.message drawInRect:textRect withFont:attri.textFont];
    CGContextRestoreGState(ctxt);
}

- (void)dealloc {
    [message_ release];
    [super dealloc];
}

@end

//******************************************************************************
@interface METoastItem : NSObject {
    METoastView *view_;
    NSString *message_;
    CGFloat duration_;
    void (^completeBlock_) (void);
}

@property (nonatomic, readonly) METoastView *view;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, copy) void (^completeBlock) (void);

@end

@implementation METoastItem

@synthesize view = view_;
@synthesize message = message_;
@synthesize duration = duration_;
@synthesize completeBlock = completeBlock_;

- (METoastView *)view {
    if (!view_) {
        view_ = [[METoastView alloc] initWithMessage:message_];
    }
    
    return view_;
}

- (void)dealloc {
    [view_ release];
    [message_ release];
    
    if (completeBlock_) {
        Block_release(completeBlock_);
    }
    
    [super dealloc];
}

@end
//******************************************************************************

static METoast *sharedToast = nil;
static METoastAttribute *sharedAttribute = nil;

@interface METoast () {
    NSMutableArray *queue_;
    METoastItem *currentToastItem_;
    UIWindow *toastWindow_;
}

@property (nonatomic, readonly) NSMutableArray *queue;
@property (nonatomic, retain) METoastItem *currentToastItem;
@property (nonatomic, readonly) UIWindow *toastWindow;

+ (id)sharedInstance;

- (void)hideCurrentToastItem;

- (void)showNextToastItem;

- (void)showToastWithMessage:(NSString *)message
                    duration:(CGFloat)duration
            andCompleteBlock:(void (^)(void))completeBlock;

- (void)layoutToastView;

@end

@implementation METoast

@synthesize queue = queue_;
@synthesize currentToastItem = currentToastItem_;
@synthesize toastWindow = toastWindow_;

+ (id)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedToast = [[METoast alloc] init];
    });
    
    return sharedToast;
}

- (void)hideCurrentToastItem {
    if (!self.currentToastItem) {
        return;
    }
    
    [self.queue removeObject:self.currentToastItem];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.currentToastItem.view.alpha = 0;
                     }
                     completion:^(BOOL completed) {
                         [self.currentToastItem.view removeFromSuperview];
                         
                         if (self.currentToastItem.completeBlock) {
                             self.currentToastItem.completeBlock();
                         }
                         
                         if (![[self queue] count]) {
                             self.toastWindow.hidden = YES;
                         }
                         
                         self.currentToastItem = nil;
                         
                         [self showNextToastItem];
                     }];
}

- (void)showNextToastItem {
    if (currentToastItem_ || ![[self queue] count]) {
        return;
    }
    
    self.currentToastItem = [[self queue] objectAtIndex:0];
    
    if (self.toastWindow.hidden) {
        self.toastWindow.hidden = NO;
    }
    
    self.currentToastItem.view.alpha = 0;
    
    [self.toastWindow addSubview:self.currentToastItem.view];
    [self layoutToastView];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.currentToastItem.view.alpha = 1.0;
    }];
    
    [self performSelector:@selector(hideCurrentToastItem)
               withObject:nil
               afterDelay:self.currentToastItem.duration];
}

- (void)showToastWithMessage:(NSString *)message
                    duration:(CGFloat)duration
            andCompleteBlock:(void (^)(void))completeBlock {
    METoastItem *item = [[METoastItem alloc] init];
    item.message = message;
    item.duration = duration;
    item.completeBlock = completeBlock;
    [[self queue] addObject:item];
    [item release];
    
    [self showNextToastItem];
}

- (void)layoutToastView {
    CGRect toastWindowBounds = self.toastWindow.bounds;
    CGFloat w = CGRectGetWidth(toastWindowBounds);
    CGFloat h = CGRectGetHeight(toastWindowBounds);
    METoastLocation loc = [[METoast toastAttribute] location];
    CGPoint center = CGPointZero;
    
    CGFloat coefficient = 0.168;
    
    switch (loc) {
        case METoastLocationBottom:
            center.x = floorf(w / 2.0);
            center.y = floorf(h * (1 - coefficient));
            break;
        case METoastLocationMiddle:
            center.x = floorf(w / 2.0);
            center.y = floorf(h / 2.0);
            break;
        case METoastLocationTop:
            center.x = floorf(w / 2.0);
            center.y = floorf(h * coefficient);
            break;
    }
    
    self.currentToastItem.view.center = center;
}

- (id)init {
    self = [super init];
    
    if (self) {
        queue_ = [[NSMutableArray alloc] init];
        
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        toastWindow_ = [[UIWindow alloc] initWithFrame:screenBounds];
        toastWindow_.windowLevel = UIWindowLevelAlert + 1;
        toastWindow_.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)dealloc {
    [queue_ release];
    [toastWindow_ release];
    [super dealloc];
}

+ (void)toastWithMessage:(NSString *)message {
    [self toastWithMessage:message andCompleteBlock:NULL];
}

+ (void)toastWithMessage:(NSString *)message
        andCompleteBlock:(void (^)(void)) completeBlock {
    [self toastWithMessage:message
                  duration:METoastDurationDefault
          andCompleteBlock:completeBlock];
}

+ (void)toastWithMessage:(NSString *)message
                duration:(CGFloat)duration
        andCompleteBlock:(void (^)(void))completeBlock {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[METoast sharedInstance] showToastWithMessage:message
                                              duration:duration
                                      andCompleteBlock:completeBlock];
    });
}

+ (void)hide {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[METoast sharedInstance] hideCurrentToastItem];
    });
}

+ (METoastAttribute *)toastAttribute {
    if (!sharedAttribute) {
        sharedAttribute = [[METoastAttribute alloc] init];
    }
    
    return sharedAttribute;
}

+ (void)setToastAttribute:(METoastAttribute *)attribute {
    if (sharedAttribute) {
        [sharedAttribute release];
        sharedAttribute = nil;
    }
    
    sharedAttribute = [attribute retain];
}

+ (void)resetToastAttribute {
    [METoast setToastAttribute:nil];
}

@end
