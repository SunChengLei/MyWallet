//
//  HeaderView.h
//  tabelHeader
//
//  Created by morplcp on 15/12/19.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UIView

@property (nonatomic, strong) UILabel *headerTitleLabel;
@property (nonatomic, strong) UIImage *headerImage;
@property (nonatomic, assign) UIBlurEffectStyle effectStyle;

+ (id)headerViewWithImage:(UIImage *)image forSize:(CGSize)headerSize forEffectStyle:(UIBlurEffectStyle)effectStyle;
+ (id)headerViewWithCGSize:(CGSize)headerSize;
- (void)layoutHeaderViewWithScrollViewOffset:(CGPoint)offset;

@end
