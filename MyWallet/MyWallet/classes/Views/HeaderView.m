//
//  HeaderView.m
//  tabelHeader
//
//  Created by morplcp on 15/12/19.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "HeaderView.h"

@interface HeaderView ()

@property (nonatomic, strong) UIScrollView *imageScrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *bluredImageView;

@end

#define kCurrentPageFrame CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)

static CGFloat PARALLAX = 0.5f;

@implementation HeaderView

+ (id)headerViewWithImage:(UIImage *)image forSize:(CGSize)headerSize forEffectStyle:(UIBlurEffectStyle)effectStyle{
    HeaderView *headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, headerSize.width, headerSize.height)];
    headerView.headerImage = image;
    headerView.effectStyle = effectStyle;
    [headerView initSubView];
    return headerView;
}
+ (id)headerViewWithCGSize:(CGSize)headerSize{
    HeaderView *headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, headerSize.width, headerSize.height)];
    [headerView initSubView];
    return headerView;
}

- (void)setHeaderImage:(UIImage *)headerImage{
    if (_headerImage) {
        _headerImage = nil;
    }
    _headerImage = headerImage;
    self.imageView.image = headerImage;
}

- (void)layoutHeaderViewWithScrollViewOffset:(CGPoint)offset{
    CGRect frame = self.imageScrollView.frame;
    if (offset.y > 0) {
        frame.origin.y = MAX(offset.y * PARALLAX, 0);
        self.imageScrollView.frame = frame;
        self.bluredImageView.alpha = 1 / kCurrentPageFrame.size.height * offset.y * 2;
        self.clipsToBounds = YES;
    }else{
        CGFloat delta = 0.0f;
        CGRect rect = kCurrentPageFrame;
        delta = fabs(MIN(0.0f, offset.y));
        rect.origin.y -= delta;
        rect.size.height += delta;
        self.imageScrollView.frame = rect;
        self.bluredImageView.alpha = 1 / kCurrentPageFrame.size.height * offset.y * 2;
        self.clipsToBounds = NO;
    }
}

- (void)initSubView{
    self.imageScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.imageView = [[UIImageView alloc] initWithFrame:_imageScrollView.bounds];
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.image = self.headerImage;
    [self.imageScrollView addSubview:_imageView];
    self.bluredImageView = [[UIImageView alloc] initWithFrame:self.imageView.frame];
    _bluredImageView.autoresizingMask = _imageView.autoresizingMask;
    _bluredImageView.alpha = 0.0f;
    UIBlurEffect *eff = [UIBlurEffect effectWithStyle:self.effectStyle];
    UIVisualEffectView *visView = [[UIVisualEffectView alloc] initWithEffect:eff];
    visView.frame = _bluredImageView.bounds;
    [_bluredImageView addSubview:visView];
    [self.imageScrollView addSubview:_bluredImageView];
    [self addSubview:_imageScrollView];
}


@end
