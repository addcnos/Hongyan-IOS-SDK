//
//  SRChatToolView.h
//  HKHouse591
//
//  Created by Addcnhk591 on 2019/11/7.
//  Copyright © 2019 com.addcn.hk591. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SRChatToolViewDelegate <NSObject>

- (void)didSelectImagePickerType:(NSInteger )pickerType;

@end

@interface SRChatToolView : UIView

@property (nonatomic, weak) id <SRChatToolViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
