//
//  SlideVerifier.h
//  Schenley
//
//  Created by songshushan on 2018/5/11.
//  Copyright © 2018年 sqhtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SlideVerifier;

@protocol SlideVerifierResultDelegate <NSObject>

- (void)slideVerifier:(SlideVerifier *)verifier result:(BOOL)result;

@end

@interface SlideVerifier : UIView

@property (nonatomic, weak) id<SlideVerifierResultDelegate> delegate;

@end
