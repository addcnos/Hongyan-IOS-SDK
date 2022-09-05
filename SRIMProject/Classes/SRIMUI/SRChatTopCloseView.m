//
//  SRChatTopCloseView.m
//  AFNetworking
//
//  Created by addcnos on 2019/12/30.
//

#import "SRChatTopCloseView.h"
#import "SRIMUtility.h"
#import "SRIMImageExtension.h"
@interface SRChatTopCloseView()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeBtn;
@end

@implementation SRChatTopCloseView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    self.backgroundColor = SRIMColorFromRGB(0xf5f5f5);
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.titleLabel.textColor = SRIMColorFromRGB(0x222222);
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeBtn setImage:[SRIMImageExtension imageWithName:@"chat_close_icon"] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.height.equalTo(self);
        make.width.mas_equalTo(30);
    }];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectZero];
    line.backgroundColor = SRIMColorFromRGB(0xcccccc);
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(9, 9)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)closeBtnAction {
    if (self.closeActionBlock) {
        self.closeActionBlock();
    }
}
@end
