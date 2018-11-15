//
//  ViewController.m
//  BoardCard
//
//  Created by zhifu360 on 2018/11/14.
//  Copyright © 2018 ZZJ. All rights reserved.
//

#import "ViewController.h"
#import "BoardCardLayout.h"

static NSString * const CELLID = @"cellID";

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, BoardCardLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.collectionView];
}

#pragma mark - BoardCardLayoutDelegate
- (void)scrollToItemWithPageNum:(NSInteger)pageNum {
    
    NSLog(@"当前滚动到第%ld个item",pageNum);
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:(arc4random()%256)/255.0f green:(arc4random()%256)/255.0f blue:(arc4random()%256)/255.0f alpha:1];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}


#pragma mark - lazy
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        BoardCardLayout *layout = [[BoardCardLayout alloc] init];
        layout.kLineSpace = 10;
        layout.kPageCardWidth = 280;
        layout.kPageCardHeight = 160;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 200) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CELLID];
        _collectionView.decelerationRate = 0;
    }
    return _collectionView;
}

@end
