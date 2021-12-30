//
//  SRChatPrivateCellViewModel.m
//  HKHouse591
//
//  Created by addcn591 on 2019/9/23.
//  Copyright © 2019 com.addcn.hk591. All rights reserved.
//

#import "SRChatPrivateCellViewModel.h"
#import "SRChatContent.h"

@interface SRChatPrivateCellViewModel ()

@property (nonatomic, assign) CGSize contentSize;

@end

@implementation SRChatPrivateCellViewModel

- (instancetype)initWithChatModel:(SRChatModel *)chatModel {
    if (self = [super init]) {
        self.chatModel = chatModel;
        [self calculateCellHeight];
    }
    return self;
}

- (void)calculateCellHeight {
    NSString *contentStr = [self contentString];
    CGRect contentRect = [contentStr boundingRectWithSize:CGSizeMake(SRIMScreenWidth - 110 - 20, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil];
    CGSize size = contentRect.size;
    self.contentSize = size;
}

- (CGFloat)contentWidth {
    CGFloat width = (self.contentSize.width >= (SRIMScreenWidth - 130 - 22)) ? SRIMScreenWidth - 130 : self.contentSize.width + 22;
    return width;
}

- (CGFloat )cellHeight {
    CGFloat height = self.contentSize.height + 22 + 30;
    return height > 65 ? height : 65;
}

- (CGRect )contentBGFrame {
    NSInteger message_direction = self.chatModel.message_direction;
    if (message_direction == 1) {
        CGFloat contentW = [self contentWidth];
        CGFloat contentX = SRIMScreenWidth - 60 - [self contentWidth];
        CGFloat contentY = 20;
        CGFloat contentH = [self cellHeight] - 30;
        return CGRectMake(contentX, contentY, contentW, contentH);
    }
    else if (message_direction == 2) {
        CGFloat contentX = 60;
        CGFloat contentY = 20;
        CGFloat contentW = [self contentWidth];
        CGFloat contentH = [self cellHeight] - 30;
        return CGRectMake(contentX, contentY, contentW, contentH);
    }
    return CGRectZero;
}

- (NSString *)contentString {
    SRChatContent *chatContent = (SRChatContent *)self.chatModel.content;
    NSString *content = SRIMNullClass(chatContent.content);
    return content;
}

- (NSString *)createTime {
    return self.chatModel.created_at;
}

- (NSString *)from_uid {
    return self.chatModel.from_uid;
}

- (NSString *)msg_id {
    return self.chatModel.msg_id;
}

- (NSString *)sendTime {
    return self.chatModel.send_time;
}

- (NSInteger )message_direction {
    return self.chatModel.message_direction;
}

- (NSString *)targetUid {
    return self.chatModel.target_uid;
}

- (NSString *)messageType {
    return self.chatModel.type;
}

- (NSInteger )status {
    return self.chatModel.sendStatus;
}

@end
