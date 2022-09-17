//
//  SREmojiKeyBoard.h
//  addcnos
//
//  Created by addcnos on 2019/12/11.
//  Copyright © 2019 addcnos All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SREmojiKeyBoardDelegate <NSObject>

@optional

- (void)appendEmoji:(NSString *)emoji;

- (void)deleteEmojiCharacter;

- (void)sendMessage;

@end

@interface SREmojiKeyBoard : UIView

@property (nonatomic, weak) id<SREmojiKeyBoardDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
