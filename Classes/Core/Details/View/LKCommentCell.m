//
//  LKCommentCell.m
//  nstest
//
//  Created by lishaowei on 15/10/12.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKCommentCell.h"
#import "UIImage+Extra.h"

@interface LKCommentCell ()
{
    UIImageView *_faceImageView;
    UILabel *_nameLabel;
    UILabel *_timeLabel;
    UILabel *_contentLable;
    
    UIView *_lineView;
    UIButton *_likeBtn;
    
    UILabel *_likeLabel;
    UIImageView *_heatImageView;
    
    LKCommentData *_commentData;
}

@end

@implementation LKCommentCell

- (void)dealloc
{
    self.delegate = nil;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addView];
    }
    return self;
}

- (void)addView
{
    _faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(BoundsOfScale(15), BoundsOfScale(15), BoundsOfScale(42), BoundsOfScale(42))];
    _faceImageView.image = [UIImage imageNamed:@"defaulthead"];
    [_faceImageView setContentMode:UIViewContentModeScaleAspectFill];
    _faceImageView.clipsToBounds = YES;
    _faceImageView.layer.cornerRadius = CGRectGetMidX(_faceImageView.bounds);
    _faceImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_faceImageView];
    _faceImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHeadInside)];
    [_faceImageView addGestureRecognizer:tapGesture];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_faceImageView.frame)+BoundsOfScale(11), BoundsOfScale(15), UI_IOS_WINDOW_WIDTH-(CGRectGetMaxX(_faceImageView.frame)+BoundsOfScale(11)+BoundsOfScale(80)), BoundsOfScale(25))];
    _nameLabel.font = [UIFont systemFontOfSize:15];
    _nameLabel.textColor = UIColorRGB(0x596c96);
    [self.contentView addSubview:_nameLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_faceImageView.frame)+BoundsOfScale(11), CGRectGetMaxY(_nameLabel.frame), UI_IOS_WINDOW_WIDTH-(CGRectGetMaxX(_faceImageView.frame)+BoundsOfScale(11)+BoundsOfScale(80)), BoundsOfScale(20))];
    _timeLabel.font = [UIFont systemFontOfSize:FontOfScale(11)];
    _timeLabel.textColor = UIColorRGB(0x999999);
    [self.contentView addSubview:_timeLabel];
    
    _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _likeBtn.frame = CGRectMake(UI_IOS_WINDOW_WIDTH-BoundsOfScale(70), BoundsOfScale(15), BoundsOfScale(60), BoundsOfScale(22));
    [_likeBtn setBackgroundImage:[UIImage imageScaleNamed:@"detalis_btn_helpful"] forState:UIControlStateNormal];
    [self.contentView addSubview:_likeBtn];
    
    _likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(BoundsOfScale(25), BoundsOfScale(2), CGRectGetWidth(_likeBtn.frame)-(BoundsOfScale(25)+BoundsOfScale(8)), BoundsOfScale(18))];
    _likeLabel.font = [UIFont systemFontOfSize:FontOfScale(12)];
    _likeLabel.textColor = [UIColor grayColor];
    _likeLabel.text = @"有用";
    [_likeBtn addSubview:_likeLabel];
    [_likeBtn addTarget:self action:@selector(likeBtnTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *contentStr = @"深圳地铁附属资源由资源开发分公司进行统一经营管理,现已形成商业经营、广告传媒、通信信息、文化拓展等4大核心业务,为地铁乘客提供全方位的商业服务。 商业经营 广告";
    NSMutableAttributedString *attrib = [self attributedStringWithString:contentStr withFont:[UIFont systemFontOfSize:FontOfScale(15)] withColor:UIColorRGB(0x666666) withLineSpacing:4];
     CGRect rect = [LKCommentCell getRectWithSize:UI_IOS_WINDOW_WIDTH-(BoundsOfScale(15)+BoundsOfScale(42)+BoundsOfScale(11)+BoundsOfScale(15)) withAttributedString:attrib];
    
    _contentLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_faceImageView.frame)+BoundsOfScale(11), CGRectGetMaxY(_timeLabel.frame)+BoundsOfScale(5), UI_IOS_WINDOW_WIDTH-(CGRectGetMaxX(_faceImageView.frame)+BoundsOfScale(11)+BoundsOfScale(15)), rect.size.height)];
    _contentLable.numberOfLines = 0;
    _contentLable.attributedText = attrib;
    [self.contentView addSubview:_contentLable];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(BoundsOfScale(15), CGRectGetMaxY(_contentLable.frame)+BoundsOfScale(9), UI_IOS_WINDOW_WIDTH-BoundsOfScale(15)*2 -SINGLE_LINE_ADJUST_OFFSET, SINGLE_LINE_BOUNDS)];
    _lineView.backgroundColor = UIColorMakeRGB(233.0, 233.0, 233.0);
    [self.contentView addSubview:_lineView];
    
}

- (void)updateWithData:(LKCommentData *)commentData
{
    
    _commentData = commentData;
    
    [_faceImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@",SeverHost,commentData.userHead]] placeholderImage:[UIImage imageWithName:@"defaulthead"]];
    
    if (commentData.nickName.length <= 0) {
        _nameLabel.text = @"匿名";
    }
    else{
        _nameLabel.text = commentData.nickName;
    }
    
    
    if (![commentData.used isEqualToString:@"0"]) {
        [self setHeartState:YES];
    }else{
        [self setHeartState:NO];
    }
    
    NSString *strDate = [NSString transTime:STR_IS_NULL(commentData.createDate) Format:@"yyyy-MM-dd HH:mm:ss"];
    _timeLabel.text = strDate;
    
    NSMutableAttributedString *attrib = [self attributedStringWithString:commentData.descri withFont:[UIFont systemFontOfSize:FontOfScale(15)] withColor:UIColorRGB(0x666666) withLineSpacing:4];
    CGRect rect = [LKCommentCell getRectWithSize:UI_IOS_WINDOW_WIDTH-(BoundsOfScale(15)+BoundsOfScale(42)+BoundsOfScale(11)+BoundsOfScale(15)) withAttributedString:attrib];
    _contentLable.attributedText = attrib;
    _contentLable.frame = CGRectMake(CGRectGetMaxX(_faceImageView.frame)+BoundsOfScale(11), CGRectGetMaxY(_timeLabel.frame)+BoundsOfScale(5), UI_IOS_WINDOW_WIDTH-(CGRectGetMaxX(_faceImageView.frame)+BoundsOfScale(11)+BoundsOfScale(15)), rect.size.height);
    
    _lineView.frame = CGRectMake(BoundsOfScale(15), CGRectGetMaxY(_contentLable.frame)+BoundsOfScale(9)-SINGLE_LINE_ADJUST_OFFSET, UI_IOS_WINDOW_WIDTH-BoundsOfScale(15)*2, SINGLE_LINE_BOUNDS);
}

- (void)setHeartState:(BOOL)isUsed
{
    if (isUsed) {
        [_likeBtn setUserInteractionEnabled:NO];
        [_likeBtn setBackgroundImage:[UIImage imageScaleNamed:@"detalis_btn_helpful_on"] forState:UIControlStateNormal];
        _likeLabel.textColor = [UIColor redColor];
    }else{
        [_likeBtn setUserInteractionEnabled:YES];
        [_likeBtn setBackgroundImage:[UIImage imageScaleNamed:@"detalis_btn_helpful"] forState:UIControlStateNormal];
        _likeLabel.textColor = [UIColor grayColor];
    }
}

- (void)likeBtnTouchUpInside
{
    if ([self.delegate respondsToSelector:@selector(changeLikeBtn:)]) {
        [self.delegate changeLikeBtn:_commentData];
    }
}

- (void)tapGestureHeadInside
{
    if ([self.delegate respondsToSelector:@selector(changeHeadBtn:)]) {
        [self.delegate changeHeadBtn:_commentData];
    }
}

+ (CGFloat)getCellHeight:(LKCommentData *)commentData
{
    CGFloat height = BoundsOfScale(15)+BoundsOfScale(25)+BoundsOfScale(20)+BoundsOfScale(5);
    
    NSMutableAttributedString *attrib = [self attributedStringWithString:commentData.descri withFont:[UIFont systemFontOfSize:FontOfScale(15)] withColor:UIColorRGB(0x666666) withLineSpacing:4];
    
    CGRect rect = [LKCommentCell getRectWithSize:UI_IOS_WINDOW_WIDTH-(BoundsOfScale(15)+BoundsOfScale(42)+BoundsOfScale(11)+BoundsOfScale(15)) withAttributedString:attrib];
    
    return height+rect.size.height+BoundsOfScale(9);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGRect)getRectWithSize:(CGFloat)width withAttributedString:(NSMutableAttributedString*)attrt
{
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attrt boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:options context:nil];
    return rect;
}

+ (CGRect)getRectWithSize:(CGFloat)width withAttributedString:(NSMutableAttributedString*)attrt
{
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attrt boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:options context:nil];
    return rect;
}

- (NSMutableAttributedString *)attributedStringWithString:(NSString *)string withFont:(UIFont *)font withColor:(UIColor *)color withLineSpacing:(CGFloat)lineSpacing
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    
    [attributedStr addAttribute:NSParagraphStyleAttributeName
                          value:paragraphStyle
                          range:NSMakeRange(0, [string length])];
    return attributedStr;
}

+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string withFont:(UIFont *)font withColor:(UIColor *)color withLineSpacing:(CGFloat)lineSpacing
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    
    [attributedStr addAttribute:NSParagraphStyleAttributeName
                          value:paragraphStyle
                          range:NSMakeRange(0, [string length])];
    return attributedStr;
}

@end
