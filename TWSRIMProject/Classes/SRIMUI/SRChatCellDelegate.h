//
//  SRChatCellDelegate.h
//  addcnos
//
//  Created by addcnos on 2019/12/2.
//  Copyright © 2019 addcnos All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SRChatCellDelegate <NSObject>

- (void)errorBtnEventForIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
