//
//  SlideVerifier.m
//  Schenley
//
//  Created by songshushan on 2018/5/11.
//  Copyright © 2018年 sqhtech. All rights reserved.
//

#import "SlideVerifier.h"

@interface SlideVerifier()
{
    CGPoint _startPoint;
    CGRect _frame;
}
@property (nonatomic, strong) UIView * centerView;
@property (nonatomic, strong) UIImageView * iconView;
@property (nonatomic, strong) UILabel * centerLabel;

@end

@implementation SlideVerifier


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _frame = frame;
        self.layer.masksToBounds = YES;
//        self.layer.borderColor = UIColor.blackColor.CGColor;
//        self.layer.borderWidth = 1;
        self.centerView = [[UIView alloc] init];
        self.centerView.backgroundColor = [UIColor colorWithRed:221/255.0f green:221/255.0f blue:221/255.0f alpha:1.0f];
        self.centerView.layer.masksToBounds = YES;
        self.centerView.frame = CGRectMake(0, 0, 33, frame.size.height);
        [self addSubview:self.centerView];
        
        self.iconView = [[UIImageView alloc] init];
        self.iconView.userInteractionEnabled = YES;
        self.iconView.frame = self.centerView.bounds;
        self.iconView.image = [UIImage imageNamed:@"slide_verifier"];
        self.iconView.layer.masksToBounds = YES;
        self.iconView.tag = 1001;
        [self addSubview:self.iconView];
        
        self.centerLabel = [[UILabel alloc] init];
        self.centerLabel.frame = CGRectMake(33, 0, frame.size.width - 20, frame.size.height);
        self.centerLabel.backgroundColor = [UIColor colorWithRed:221/255.0f green:221/255.0f blue:221/255.0f alpha:1.0f];
        self.centerLabel.textAlignment = NSTextAlignmentCenter;
        self.centerLabel.textColor = [UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0f];
        self.centerLabel.text = @"向右滑动验证";
        [self addSubview:self.centerLabel];
        
        [self bringSubviewToFront:self.iconView];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch * touch = [touches anyObject];
    if (touch.view.tag == 1001) {
        CGPoint point = [touch locationInView:self.centerView];
        _startPoint = point;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if (touch.view.tag == 1001) {
        CGPoint point = [touch locationInView:self.centerView];
        CGFloat offsetX = point.x - _startPoint.x;
        if (offsetX < 0) offsetX = 0;
        CGFloat maxSlideDistance = _frame.size.width - self.iconView.frame.size.width;
        CGRect frame = self.iconView.frame;
        frame.origin = CGPointMake(frame.origin.x + offsetX, frame.origin.y);
        if (frame.origin.x > maxSlideDistance) {
            frame.origin = CGPointMake(maxSlideDistance, frame.origin.y);
        }
        self.iconView.frame = frame;
        _startPoint = point;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if (touch.view.tag == 1001) {
        CGPoint point = [touch locationInView:self.centerView];
        CGFloat offsetX = point.x - _startPoint.x;
        CGRect frame = self.iconView.frame;
        CGFloat iconX = frame.origin.x + offsetX;
        if (iconX >= _frame.size.width * 0.75) {
            CGFloat x = _frame.size.width - self.iconView.frame.size.width;
            CGFloat y = 0;
            CGFloat w = self.iconView.frame.size.width;
            CGFloat h = self.iconView.frame.size.height;
            
            [UIView animateWithDuration:0.1f animations:^{
                self.iconView.frame = CGRectMake(x, y, w, h);
            } completion:^(BOOL finished) {
                if ([self.delegate respondsToSelector:(@selector(slideVerifier:result:))]) {
                    [self.delegate slideVerifier:self result:YES];
                }
                self.iconView.frame = self.centerView.bounds;
            }];
        }else{
            self.iconView.frame = self.centerView.bounds;
            if (iconX > 0){
                if ([self.delegate respondsToSelector:(@selector(slideVerifier:result:))]) {
                    [self.delegate slideVerifier:self result:NO];
                }
            }
        }
    }
}

@end
