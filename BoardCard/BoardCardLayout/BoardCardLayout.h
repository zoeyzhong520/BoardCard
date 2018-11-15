//
//  BoardCardLayout.h
//  BoardCard
//
//  Created by zhifu360 on 2018/11/14.
//  Copyright © 2018 ZZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - 自定制UICollectionViewLayout

NS_ASSUME_NONNULL_BEGIN

@protocol BoardCardLayoutDelegate <NSObject>

@optional
- (void)scrollToItemWithPageNum:(NSInteger)pageNum;

@end

@interface BoardCardLayout : UICollectionViewFlowLayout

///两个cell的间距
@property (nonatomic, assign) CGFloat kLineSpace;
///cell的宽度
@property (nonatomic, assign) CGFloat kPageCardWidth;
///cell的高度
@property (nonatomic, assign) CGFloat kPageCardHeight;
///delegate
@property (nonatomic, weak) id<BoardCardLayoutDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
