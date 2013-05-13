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

#import <UIKit/UIKit.h>

#define METoastDuration2s 2.0
#define METoastDuration3s 3.0
#define METoastDurationDefault METoastDuration2s

typedef enum {
    METoastLocationBottom,
    METoastLocationMiddle,
    METoastLocationTop
}METoastLocation;

@interface METoastAttribute : NSObject {
    UIColor *backgroundColor_;
    UIColor *borderColor_;
    UIColor *textColor_;
    UIFont *textFont_;
    METoastLocation location_;
    CGFloat borderWidth_;
}

@property (nonatomic, retain) UIColor *backgroundColor;
@property (nonatomic, retain) UIColor *borderColor;
@property (nonatomic, retain) UIColor *textColor;
@property (nonatomic, retain) UIFont *textFont;
@property (nonatomic, assign) METoastLocation location;
@property (nonatomic, assign) CGFloat borderWidth;

@end

@interface METoast : NSObject

+ (void)toastWithMessage:(NSString *)message;

+ (void)toastWithMessage:(NSString *)message
        andCompleteBlock:(void (^)(void))completeBlock;

+ (void)toastWithMessage:(NSString *)message
                duration:(CGFloat)duration
        andCompleteBlock:(void (^)(void))completeBlock;

+ (void)hide;

+ (METoastAttribute *)toastAttribute;

+ (void)setToastAttribute:(METoastAttribute *)attribute;

+ (void)resetToastAttribute;

@end
