//
//  SRIMEmojiCell.h
//  addcnos
//
//  Created by addcnos on 2019/12/12.
//  Copyright © 2019 addcnos All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRIMEmojiCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *emojiLabel;

@property (nonatomic, copy) NSString *emoji;

@end

NS_ASSUME_NONNULL_END
