//
//  SRChatToolView.m
//  HKHouse591
//
//  Created by Addcnhk591 on 2019/11/7.
//  Copyright © 2019 com.addcn.hk591. All rights reserved.
//

#import "SRChatToolView.h"
#import "SRChatToolCell.h"
#import "SRIMUtility.h"
#import "SRIMImageExtension.h"
#import "SRIMConfigure.h"
@interface SRChatToolView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) NSArray *images;

@property (nonatomic, strong) SRIMConfigure *configure;

@end

@implementation SRChatToolView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titles = @[@"照片", @"拍攝"];
        SRIMConfigure *configure = [SRIMConfigure shareConfigure];
        self.images = @[configure.chat_take_pic ? configure.chat_take_pic : @"chat_camera_photo",
                        configure.chat_take_photo ? configure.chat_take_photo : @"chat_camera"];
        [self setupView];
    }
    return self;
}

- (SRIMConfigure *)configure{
    if (!_configure) {
        _configure = [SRIMConfigure shareConfigure];
    }
    return _configure;
}

- (void)setupView {
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemW = 90;
        CGFloat itemH = 100;
        layout.itemSize = CGSizeMake(itemW, itemH);
        layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 15;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = self.configure.chat_detail_chatToolView_bg_color ? self.configure.chat_detail_chatToolView_bg_color : SRIMColorFromRGB(0xf5f5f5);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[SRChatToolCell class] forCellWithReuseIdentifier:NSStringFromClass([SRChatToolCell class])];
    }
    return _collectionView;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SRChatToolCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SRChatToolCell class]) forIndexPath:indexPath];
    cell.toolImageView.image = [SRIMImageExtension imageWithName:self.images[indexPath.item]];
    cell.toolTitleLabel.text = self.titles[indexPath.item];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titles.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectImagePickerType:)]) {
        [self.delegate didSelectImagePickerType:indexPath.item];
    }
}

@end
