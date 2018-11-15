//
//  BoardCardLayout.m
//  BoardCard
//
//  Created by zhifu360 on 2018/11/14.
//  Copyright © 2018 ZZJ. All rights reserved.
//

#import "BoardCardLayout.h"

@interface BoardCardLayout ()

@property (nonatomic, assign) CGFloat previousOffsetX;
@property (nonatomic, assign) NSInteger pageNum;

@end

@implementation BoardCardLayout

- (void)prepareLayout {
    
    //滑动方向
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //两个cell的间距
    self.minimumLineSpacing = self.kLineSpace;
    //计算cell超出显示的宽度
    CGFloat width = (self.collectionView.frame.size.width - self.kPageCardWidth - self.kLineSpace*2)/2;
    //第一个cell和最后一个cell相对于屏幕的偏移
    self.sectionInset = UIEdgeInsetsMake(0, self.kLineSpace+width, 0, self.kLineSpace+width);
    //每个cell的实际大小
    self.itemSize = CGSizeMake(self.kPageCardWidth, self.kPageCardHeight);
    
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    // 分页以1/3处
    if (proposedContentOffset.x > self.previousOffsetX + self.itemSize.width / 3.0) {
        self.previousOffsetX += self.kPageCardWidth + self.kLineSpace;
        self.pageNum = self.previousOffsetX/(self.kPageCardWidth + self.kLineSpace);
        
        //代理
        if (self.delegate && [self.delegate respondsToSelector:@selector(scrollToItemWithPageNum:)]) {
            [self.delegate scrollToItemWithPageNum:self.pageNum];
        }
        
    } else if (proposedContentOffset.x < self.previousOffsetX - self.itemSize.width / 3.0) {
        self.previousOffsetX -= self.kPageCardWidth + self.kLineSpace;
        self.pageNum = self.previousOffsetX/(self.kPageCardWidth + self.kLineSpace);
        
        //代理
        if (self.delegate && [self.delegate respondsToSelector:@selector(scrollToItemWithPageNum:)]) {
            [self.delegate scrollToItemWithPageNum:self.pageNum];
        }
    }
    
    //将当前cell移动到屏幕中间位置
    proposedContentOffset.x = self.previousOffsetX;
    
    return proposedContentOffset;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSArray *superAttributes = [super layoutAttributesForElementsInRect:rect];
    NSArray *attributes = [[NSArray alloc] initWithArray:superAttributes copyItems:YES];
    
    CGRect visibleRect = CGRectMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y, self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    CGFloat offset = CGRectGetMidX(visibleRect);
    
    [attributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        CGFloat distance = offset - obj.center.x;
        // 越往中心移动，值越小，那么缩放就越小，从而显示就越大
        // 同样，超过中心后，越往左、右走，缩放就越大，显示就越小
        CGFloat scaleForDistance = distance/self.itemSize.width;
        // 0.1可调整，值越大，显示就越大
        CGFloat scaleForCell = 1 + 0.1*(1 - fabs(scaleForDistance));
        
        //只在Y轴方向做缩放
        obj.transform3D = CATransform3DMakeScale(1, scaleForCell, 1);
        obj.zIndex = 1;
        
        //渐变
        CGFloat scaleForAlpha = 1 - fabs(scaleForDistance)*0.4;
        obj.alpha = scaleForAlpha;
        
    }];
    
    return attributes;
}

//YES if the collection view requires a layout update or NO if the layout does not need to change.
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

@end
