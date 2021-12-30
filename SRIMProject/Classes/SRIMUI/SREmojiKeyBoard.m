//
//  SREmojiKeyBoard.m
//  HKHouse591
//
//  Created by Addcnhk591 on 2019/12/11.
//  Copyright © 2019 com.addcn.hk591. All rights reserved.
//

#import "SREmojiKeyBoard.h"
#import "SRIMEmojiCell.h"
#import "SRIMImageExtension.h"
#import "SRIMUtility.h"
#import "SRIMConfigure.h"
@interface SREmojiKeyBoard()<UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIScrollView *emojiScrollView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSArray *emojiArr;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic, strong) SRIMConfigure *configure;

@end

@implementation SREmojiKeyBoard

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (SRIMConfigure *)configure{
    if (!_configure) {
        _configure = [SRIMConfigure shareConfigure];
    }
    return _configure;
}

- (void)reloadScrollViewDataSource {
    CGFloat width = self.frame.size.width;
    NSInteger emojiCount = self.emojiArr.count;
    NSInteger emojiPerRow = 7;
    NSInteger line = 3;
    NSInteger emojiPerPage = emojiPerRow * line - 1;
    self.pageSize = emojiPerPage;
    self.page = (emojiCount % emojiPerPage == 0) ? (emojiCount / emojiPerPage) : (emojiCount / emojiPerPage + 1);
    self.emojiScrollView.contentSize = CGSizeMake(width * self.page, self.frame.size.height);
    for (NSInteger i = 0; i < self.page; i ++) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(self.frame.size.width / 7, 50);
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(i * self.frame.size.width, 0, width, 150) collectionViewLayout:layout];
        collectionView.backgroundColor = self.configure.chat_detail_emojiKeyBoard_bg_color ? self.configure.chat_detail_emojiKeyBoard_bg_color : [UIColor colorWithRed:244 / 255.0 green:244 / 255.0 blue:244 / 255.0 alpha:1.0];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.tag = i;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[SRIMEmojiCell class] forCellWithReuseIdentifier:NSStringFromClass([SRIMEmojiCell class])];
        [self.emojiScrollView addSubview:collectionView];
        
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteButton.frame = CGRectMake(self.frame.size.width - self.frame.size.width / 7, 2 * 50, self.frame.size.width / 7, 50);
        //@"chat_emoji_delete"
        [deleteButton setImage:[SRIMImageExtension imageWithName:self.configure.chat_emoji_delete ? self.configure.chat_emoji_delete : @"chat_emoji_delete_1"] forState:UIControlStateNormal];
        deleteButton.tag = i;
        [deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        [collectionView addSubview:deleteButton];
    }
    
    [self addSubview:self.pageControl];
    
}

- (void)sendAction {
    //發送消息
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendMessage)]) {
        [self.delegate sendMessage];
    }
}

- (void)deleteAction:(UIButton *)sender {
    //删除文字or表情
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendMessage)]) {
        [self.delegate deleteEmojiCharacter];
    }
}

#pragma mark - Action

- (void)pageControlValueChanged:(UIPageControl *)pageControl {
    
}

#pragma mark - UI

- (void)setupUI {
    
    [self addSubview:self.emojiScrollView];
    [self addSubview:self.sendButton];
    [self reloadScrollViewDataSource];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    NSInteger page = contentOffsetX / scrollView.frame.size.width;
    self.pageControl.currentPage = page;
}

#pragma mark - DataSource

- (NSInteger)numberOfEmojisAtPage:(NSInteger )page {
    if (page >= self.page) {
        return 0;
    }
    return (self.emojiArr.count >= (page + 1)* self.pageSize) ? self.pageSize : (self.emojiArr.count % self.pageSize);
}

- (NSString *)emojiAtPage:(NSInteger )page IndexPath:(NSIndexPath *)indexPath {
    NSInteger index  = page * self.pageSize + indexPath.item;
    if (index >= self.emojiArr.count) {
        return nil;
    }
    return [self.emojiArr objectAtIndex:index];
}

#pragma mark - UICollectionViewDataSource

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSInteger page = collectionView.tag;
    SRIMEmojiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SRIMEmojiCell class]) forIndexPath:indexPath];
    cell.emoji = [self emojiAtPage:page IndexPath:indexPath];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger nums = [self numberOfEmojisAtPage:collectionView.tag];
    NSLog(@"page:%zi nums:%zi", collectionView.tag, nums);
    return [self numberOfEmojisAtPage:collectionView.tag];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.frame.size.width / 7.0, 50);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger )section {
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *emoji = [self emojiAtPage:collectionView.tag IndexPath:indexPath];
    NSLog(@"touch emoji:%@", emoji);
    if (self.delegate && [self.delegate respondsToSelector:@selector(appendEmoji:)]) {
        [self.delegate appendEmoji:emoji];
    }
}

#pragma mark - Getter

- (NSArray *)emojiArr {
    if (!_emojiArr) {
        _emojiArr = [SRIMImageExtension emojiArrWithName:@"SRIMEmoji"];
    }
    return _emojiArr;
}

- (UIScrollView *)emojiScrollView {
    if (!_emojiScrollView) {
        _emojiScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _emojiScrollView.backgroundColor = self.configure.chat_detail_emojiKeyBoard_bg_color ? self.configure.chat_detail_emojiKeyBoard_bg_color : SRIMRGB(244, 244, 244);
        _emojiScrollView.pagingEnabled = YES;
        _emojiScrollView.delegate = self;
        _emojiScrollView.showsVerticalScrollIndicator = NO;
        _emojiScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _emojiScrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 40, self.frame.size.width, 20)];
        if (@available(iOS 14.0, *)) { // iOS14新增了样式，不设置的话会不显示
            _pageControl.backgroundStyle = UIPageControlBackgroundStyleMinimal;
            _pageControl.allowsContinuousInteraction = NO; // 關掉拖曳模式
        }
        _pageControl.userInteractionEnabled =  NO;
        _pageControl.numberOfPages = self.page;
        _pageControl.currentPage = 0;
        
        _pageControl.pageIndicatorTintColor = self.configure.chat_emoji_unsel_color ? self.configure.chat_emoji_unsel_color : SRIMColorFromRGB(0x999999);
        _pageControl.currentPageIndicatorTintColor = self.configure.chat_emoji_sel_color ? self.configure.chat_emoji_sel_color : SRIMColorFromRGB(0x222222);
        [_pageControl addTarget:self action:@selector(pageControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.frame = CGRectMake(self.frame.size.width - 80, self.frame.size.height - 40, 60, 40);
        [_sendButton setTitle:@"發送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:SRIMColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
        _sendButton.backgroundColor = self.configure.chat_send_emoji_color ? self.configure.chat_send_emoji_color : SRIMColorFromRGB(0xff8000);
        _sendButton.clipsToBounds = YES;
        _sendButton.layer.cornerRadius = 2;
    }
    return _sendButton;
}

@end
