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

#import "MEViewController.h"
#import "METoast.h"

@interface MEViewController ()

@end

@implementation MEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleTopEvent:(id)sender {
    METoastAttribute *attri = [[METoastAttribute alloc] init];
    attri.location = METoastLocationTop;
    [METoast setToastAttribute:attri];
    [METoast toastWithMessage:@"On the top of the screen!"];
    [attri release];
}

- (IBAction)handleMiddleEvent:(id)sender {
    METoastAttribute *attri = [[METoastAttribute alloc] init];
    attri.location = METoastLocationMiddle;
    [METoast setToastAttribute:attri];
    [METoast toastWithMessage:@"On the middle of the screen!"];
    [attri release];
}

- (IBAction)handleBottomEvent:(id)sender {
    [METoast resetToastAttribute];
    [METoast toastWithMessage:@"On the bottom of the screen!"];
}

- (IBAction)handleCompleteBlockEvent:(id)sender {
    [METoast toastWithMessage:@"Geographically speaking, Boracay is part of the municipality of Malay in the province of Aklan, which is located in Panay, one of a cluster of islands that constitute the central section of the Philippine archipelago."
             andCompleteBlock:^{
                 self.view.backgroundColor = [UIColor redColor];
             }];
    
    [self.view performSelector:@selector(setBackgroundColor:)
                    withObject:[UIColor lightGrayColor]
                    afterDelay:4];
}

- (IBAction)handleQueueEvent:(id)sender {
    NSString *msg = nil;
    for (int i = 0; i < 5; i++) {
        msg = [NSString stringWithFormat:@"Message %d.", i];
        [METoast toastWithMessage:msg];
    }
}

@end
