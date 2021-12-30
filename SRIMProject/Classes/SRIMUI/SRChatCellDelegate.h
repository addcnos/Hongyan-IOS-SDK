//
//  SRChatCellDelegate.h
//  HKHouse591
//
//  Created by Addcnhk591 on 2019/12/2.
//  Copyright © 2019 com.addcn.hk591. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SRChatCellDelegate <NSObject>

- (void)errorBtnEventForIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
