//
//  LKOthersCell.m
//  Luckeys
//
//  Created by lishaowei on 15/10/17.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKShareOthersCell.h"
#import "UIView+additions.h"

#define kImageWith BoundsOfScale(70)

@interface LKShareOthersCell ()
{
    UIImageView *_headView;
    UILabel *_nameLabel;
    UILabel *_contentLabel; //用户输入内容（没有默认系统填充一句话）
    UIView *_commodityView; //商品uiview
    UIImageView *_commodityImageView;
    UILabel *_commodityTitleLabel;
    UILabel *_timeLabel;
    UIButton *_likeButton;
    UIButton *_commentButton;
    
    UILabel *_codeLabel;
    
    UIView *_lineView;
    
    UIView *_iamgeViess;
    
    UIView *_commentViews;//评论view
    
    LKFriendsData *_data;
    
    NSMutableArray *_imageViewArray;
}

@end

@implementation LKShareOthersCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imageViewArray = [[NSMutableArray alloc] initWithCapacity:0];
        [self addView];
    }
    return self;
}

- (void)addView
{
    _headView = [[UIImageView alloc] initWithFrame:CGRectMake(BoundsOfScale(10), BoundsOfScale(15), BoundsOfScale(45), BoundsOfScale(45))];
    _headView.layer.cornerRadius = CGRectGetMidX(_headView.bounds);
    _headView.layer.masksToBounds = YES;
    [_headView setContentMode:UIViewContentModeScaleAspectFill];
    _headView.clipsToBounds = YES;
    [self.contentView addSubview:_headView];
    _headView.userInteractionEnabled = YES;

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headTapGestureHeadInside)];
    [_headView addGestureRecognizer:tapGesture];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headView.maxX+BoundsOfScale(10), BoundsOfScale(15), UI_IOS_WINDOW_WIDTH-_headView.maxX-BoundsOfScale(20), BoundsOfScale(20))];
    _nameLabel.textColor = UIColorRGB(0x576b95);
    _nameLabel.font = [UIFont systemFontOfSize:FontOfScale(14)];
    _nameLabel.text = @"你若安好";
    [self.contentView addSubview:_nameLabel];
    
    NSString *str = @"用户输入内容（没有默认系统填充一句话）";
    CGSize contentSize = [str sizeWithFont:[UIFont systemFontOfSize:FontOfScale(14)] constrainedToSize:CGSizeMake(UI_IOS_WINDOW_WIDTH-(_headView.maxX+BoundsOfScale(20)), 100000) lineBreakMode:NSLineBreakByCharWrapping];
    
    //用户输入内容（没有默认系统填充一句话）
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headView.maxX+BoundsOfScale(10), _nameLabel.maxY+BoundsOfScale(10), UI_IOS_WINDOW_WIDTH-(_headView.maxX+BoundsOfScale(20)), contentSize.height)];
    _contentLabel.textColor = UIColorRGB(0x333333);
    _contentLabel.font = [UIFont systemFontOfSize:FontOfScale(14)];
    _contentLabel.numberOfLines = 0;
    _contentLabel.text = str;
    [self.contentView addSubview:_contentLabel];

    _iamgeViess = [[UIImageView alloc] initWithFrame:CGRectMake(_headView.maxX+BoundsOfScale(10),  _contentLabel.maxY+BoundsOfScale(10), UI_IOS_WINDOW_WIDTH-(_headView.maxX+BoundsOfScale(20)), 0)];
    _iamgeViess.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_iamgeViess];
    
    //商品uiview
    _commodityView = [[UIView alloc] initWithFrame:CGRectMake(_headView.maxX+BoundsOfScale(10), _iamgeViess.maxY+BoundsOfScale(10), UI_IOS_WINDOW_WIDTH-(_headView.maxX+BoundsOfScale(20)), BoundsOfScale(50))];
    _commodityView.backgroundColor = UIColorRGB(0xf3f3f5);
    [self.contentView addSubview:_commodityView];
    _commodityView.userInteractionEnabled = YES;

    UITapGestureRecognizer *dityTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dityTapGestureHeadInside)];
    [_commodityView addGestureRecognizer:dityTapGesture];
    
    _commodityImageView = [[UIImageView alloc] initWithFrame:CGRectMake(BoundsOfScale(5), BoundsOfScale(5), BoundsOfScale(51), BoundsOfScale(40))];
    _commodityImageView.image = [UIImage imageNamed:@"moren"];
    [_commodityImageView setContentMode:UIViewContentModeScaleAspectFill];
    _commodityImageView.clipsToBounds = YES;
    [_commodityView addSubview:_commodityImageView];
    
    _commodityTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_commodityImageView.maxX+BoundsOfScale(10), BoundsOfScale(5), _commodityView.width-(_commodityImageView.maxX+BoundsOfScale(20)), BoundsOfScale(20))];
    _commodityTitleLabel.textColor = UIColorRGB(0x333333);
    _commodityTitleLabel.font = [UIFont systemFontOfSize:FontOfScale(12)];
    _commodityTitleLabel.text = @"［电影票］你若安好";
    [_commodityView addSubview:_commodityTitleLabel];
    
    _codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_commodityImageView.maxX+BoundsOfScale(10), _commodityTitleLabel.maxY, _commodityView.width-(_commodityImageView.maxX+BoundsOfScale(20)), BoundsOfScale(15))];
    _codeLabel.textColor = UIColorRGB(0x333333);
    _codeLabel.font = [UIFont systemFontOfSize:FontOfScale(11)];
    _codeLabel.text = @"中奖码";
    [_commodityView addSubview:_codeLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_commodityView.x, _commodityView.maxY+BoundsOfScale(10), BoundsOfScale(100), 20)];
    _timeLabel.textColor = UIColorRGB(0x999999);
    _timeLabel.font = [UIFont systemFontOfSize:FontOfScale(12)];
    _timeLabel.text = @"40分钟前";
    [self.contentView addSubview:_timeLabel];
    
    _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _likeButton.frame = CGRectMake(UI_IOS_WINDOW_WIDTH-BoundsOfScale(90), _timeLabel.y, BoundsOfScale(20), BoundsOfScale(20));
    [_likeButton setImage:[UIImage imageNamed:@"ic_share_thumb"] forState:UIControlStateNormal];
    [self.contentView addSubview:_likeButton];
    [_likeButton addTarget:self action:@selector(likeBtnInside:) forControlEvents:UIControlEventTouchUpInside];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(_likeButton.maxX+BoundsOfScale(20)-SINGLE_LINE_ADJUST_OFFSET, _likeButton.y, SINGLE_LINE_BOUNDS, BoundsOfScale(20))];
    _lineView.backgroundColor = UIColorRGB(0xf3f3f5);
    [self.contentView addSubview:_lineView];
    
    _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _commentButton.frame = CGRectMake(UI_IOS_WINDOW_WIDTH-BoundsOfScale(45), _timeLabel.y, BoundsOfScale(20), BoundsOfScale(20));
    [_commentButton setImage:[UIImage imageNamed:@"ic_share_replr"] forState:UIControlStateNormal];
    [self.contentView addSubview:_commentButton];
    [_commentButton addTarget:self action:@selector(commentBtnInside:) forControlEvents:UIControlEventTouchUpInside];
    
    _commentViews = [[UIView alloc] initWithFrame:CGRectMake(_headView.maxX+BoundsOfScale(10), _commentButton.maxY+BoundsOfScale(5), UI_IOS_WINDOW_WIDTH-(_headView.maxX+BoundsOfScale(20)), 0)];
    _commentViews.backgroundColor = UIColorRGB(0xf3f3f5);
    [self.contentView addSubview:_commentViews];
    
}

- (void)dityTapGestureHeadInside
{
    if ([self.delegate respondsToSelector:@selector(changeShareCellWithBtn:withData:)]) {
        [self.delegate changeShareCellWithBtn:SHARE_DITY withData:_data];
    }
}

- (void)headTapGestureHeadInside
{
    if ([self.delegate respondsToSelector:@selector(changeShareCellWithBtn:withData:)]) {
        [self.delegate changeShareCellWithBtn:SHARE_HEADIMAGE withData:_data];
    }
}

- (void)likeBtnInside:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(changeShareCellWithBtn:withData:)]) {
        [self.delegate changeShareCellWithBtn:SHARE_LIKEBTN withData:_data];
    }
}

- (void)commentBtnInside:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(changeShareCellWithBtn:withData:)]) {
        [self.delegate changeShareCellWithBtn:SHARE_COMMENTBTN withData:_data];
    }
}

- (void)updateCell:(LKFriendsData *)data
{
    
    _data = data;
    
    [_imageViewArray removeAllObjects];
    
    _headView.frame = CGRectMake(BoundsOfScale(10), BoundsOfScale(15), BoundsOfScale(45), BoundsOfScale(45));    
    NSString *headUrl = [NSString stringWithFormat:@"http://%@%@",SeverHost,data.userHead];
    [_headView sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"defaulthead"]];
    
    _nameLabel.frame = CGRectMake(_headView.maxX+BoundsOfScale(10), BoundsOfScale(15), UI_IOS_WINDOW_WIDTH-_headView.maxX-BoundsOfScale(20), BoundsOfScale(20));
    _nameLabel.text = data.nickName;
    
    NSString *str = data.comment;
    CGSize contentSize = [str sizeWithFont:[UIFont systemFontOfSize:FontOfScale(14)] constrainedToSize:CGSizeMake(UI_IOS_WINDOW_WIDTH-(_headView.maxX+BoundsOfScale(20)), 100000) lineBreakMode:NSLineBreakByCharWrapping];
    //用户输入内容（没有默认系统填充一句话）
    _contentLabel.frame = CGRectMake(_headView.maxX+BoundsOfScale(10), _nameLabel.maxY+BoundsOfScale(10), UI_IOS_WINDOW_WIDTH-(_headView.maxX+BoundsOfScale(20)), contentSize.height);
    _contentLabel.text = str;
    
    if (_iamgeViess) {
        [_iamgeViess removeFromSuperview];
    }
    
    NSMutableArray *imageArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    if (![data.imageUrl isKindOfClass:[NSNull class]] && data.imageUrl.length > 0) {
        for (NSString *str in [data.imageUrl componentsSeparatedByString:@","]) {
            [imageArray addObject:str];
        }
    }
    
    NSInteger row = 0;
    NSInteger count = [imageArray count];
    CGFloat height = 0;
    CGFloat iamgeViessY = _contentLabel.maxY;
    
    if (count > 0){
        if (count%3) {
            row = count/3+1;
        }else{
            row = count/3;
        }
        height = row*kImageWith+(row-1)*10;
        
        iamgeViessY = _contentLabel.maxY+BoundsOfScale(10);
    }
    
    _iamgeViess = [[UIImageView alloc] initWithFrame:CGRectMake(_headView.maxX+BoundsOfScale(10),  iamgeViessY, UI_IOS_WINDOW_WIDTH-(_headView.maxX+BoundsOfScale(20)), height)];
    _iamgeViess.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_iamgeViess];
    _iamgeViess.userInteractionEnabled = YES;
    for (int i = 0; i < row; i++) {
        for (int j = 0; j < 3; j++) {
            if (i*3+j >= count) {
                break;
            }
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(j*(10+kImageWith), i*(10+kImageWith), kImageWith, kImageWith)];
            [imageView setContentMode:UIViewContentModeScaleAspectFill];
            imageView.clipsToBounds = YES;
            NSString *headImageUrl = [NSString stringWithFormat:@"http://%@%@",SeverHost,[imageArray objectAtIndex:i*3+j]];
            [imageView sd_setImageWithURL:[NSURL URLWithString:headImageUrl] placeholderImage:[UIImage imageNamed:@"moren"]];
            [_iamgeViess addSubview:imageView];
            imageView.userInteractionEnabled = YES;
            
            [_imageViewArray addObject:headImageUrl];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = imageView.bounds;
            button.backgroundColor = [UIColor clearColor];
            button.tag = i*3+j+1000;
            [imageView addSubview:button];
            [button addTarget:self action:@selector(chageImageView:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    //商品uiview
    _commodityView.frame = CGRectMake(_headView.maxX+BoundsOfScale(10), _iamgeViess.maxY+BoundsOfScale(10), UI_IOS_WINDOW_WIDTH-(_headView.maxX+BoundsOfScale(20)), BoundsOfScale(50));
    
    _commodityImageView.frame = CGRectMake(BoundsOfScale(5), BoundsOfScale(5), BoundsOfScale(51), BoundsOfScale(40));
    NSArray *imageActitvtyArray = [data.activityImageUrl componentsSeparatedByString:@","];
    if (imageActitvtyArray.count > 0) {
        NSString *dityImageStr = [NSString stringWithFormat:@"http://%@%@",SeverHost,[imageActitvtyArray objectAtIndex:0]];
        
        [_commodityImageView sd_setImageWithURL:[NSURL URLWithString:dityImageStr] placeholderImage:[UIImage imageNamed:@"moren"]];
    }else{
        NSString *dityImageStr = [NSString stringWithFormat:@"http://%@%@",SeverHost,@""];
        [_commodityImageView sd_setImageWithURL:[NSURL URLWithString:dityImageStr] placeholderImage:[UIImage imageNamed:@"moren"]];
    }
    
    _commodityTitleLabel.frame = CGRectMake(_commodityImageView.maxX+BoundsOfScale(10), BoundsOfScale(7), _commodityView.width-(_commodityImageView.maxX+BoundsOfScale(20)), BoundsOfScale(20));
    _commodityTitleLabel.text = data.activityName;
    
    _codeLabel.frame = CGRectMake(_commodityImageView.maxX+BoundsOfScale(10), _commodityTitleLabel.maxY, _commodityView.width-(_commodityImageView.maxX+BoundsOfScale(20)), BoundsOfScale(15));
    _codeLabel.text = data.code;
    
    _timeLabel.frame = CGRectMake(_commodityView.x, _commodityView.maxY+BoundsOfScale(10), BoundsOfScale(150), 20);
    _timeLabel.text = [NSString transTime:[NSString stringWithFormat:@"%@", data.shareTime] Format:@"yyyy-MM-dd HH:mm"];
    
    _likeButton.frame = CGRectMake(UI_IOS_WINDOW_WIDTH-BoundsOfScale(90), _timeLabel.y, BoundsOfScale(20), BoundsOfScale(20));
    if ([data.isWin isEqualToString:@"1"]) {
        _likeButton.userInteractionEnabled = NO;
        [_likeButton setImage:[UIImage imageNamed:@"ic_share_thumb_pressed"] forState:UIControlStateNormal];
    }else{
        _likeButton.userInteractionEnabled = YES;
        [_likeButton setImage:[UIImage imageNamed:@"ic_share_thumb"] forState:UIControlStateNormal];
    }
    
    _lineView.frame = CGRectMake(_likeButton.maxX+BoundsOfScale(20)-SINGLE_LINE_ADJUST_OFFSET, _likeButton.y+BoundsOfScale(2), 1, BoundsOfScale(16));
    
    _commentButton.frame = CGRectMake(UI_IOS_WINDOW_WIDTH-BoundsOfScale(35), _timeLabel.y, BoundsOfScale(20), BoundsOfScale(20));
    [_commentButton setImage:[UIImage imageNamed:@"ic_share_replr"] forState:UIControlStateNormal];

    if (_commentViews) {
        [_commentViews removeFromSuperview];
    }
    _commentViews = [[UIView alloc] initWithFrame:CGRectMake(_headView.maxX+BoundsOfScale(10), _commentButton.maxY+BoundsOfScale(5), UI_IOS_WINDOW_WIDTH-(_headView.maxX+BoundsOfScale(20)), 0)];
    _commentViews.backgroundColor = UIColorRGB(0xf3f3f5);
    [self.contentView addSubview:_commentViews];
    
    CGFloat y = BoundsOfScale(5);
    for (int i = 0; i < data.listComment.count; i++) {
        NSDictionary *dic = [data.listComment objectAtIndex:i];
        NSString *string = [NSString stringWithFormat:@"%@：%@", [dic objectForKey:@"nickName"], [dic objectForKey:@"descri"]];
        CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:FontOfScale(13)] constrainedToSize:CGSizeMake(UI_IOS_WINDOW_WIDTH-(_headView.maxX+BoundsOfScale(20)+BoundsOfScale(10)), 100000) lineBreakMode:NSLineBreakByCharWrapping];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(BoundsOfScale(5), y, size.width, size.height)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:FontOfScale(13)];
        label.text = string;
        [_commentViews addSubview:label];
        y = label.maxY;
    }
    
    if (data.listComment.count > 0) {
        _commentViews.height = y+BoundsOfScale(5);
    }else{
        _commentViews.height = 0;
    }
}

/**
 *  点击图片响应
 *
 *  @param button
 */
- (void)chageImageView:(UIButton *)button
{
    NSInteger tagIntTeger = button.tag-1000;
    if ([self.delegate respondsToSelector:@selector(changeArrayImageViewWith:selectWith:)]) {
        [self.delegate changeArrayImageViewWith:_imageViewArray selectWith:tagIntTeger];
    }
}

+ (CGFloat)getCellHeight:(LKFriendsData *)data
{
    UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(BoundsOfScale(10), BoundsOfScale(15), BoundsOfScale(45), BoundsOfScale(45))];
    headView.layer.cornerRadius = CGRectGetMidX(headView.bounds);
    headView.layer.masksToBounds = YES;
    headView.image = [UIImage imageNamed:@"defaulthead"];
    [headView setContentMode:UIViewContentModeScaleAspectFill];
    headView.clipsToBounds = YES;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(headView.maxX+BoundsOfScale(10), BoundsOfScale(15), UI_IOS_WINDOW_WIDTH-headView.maxX-BoundsOfScale(20), BoundsOfScale(20))];
    nameLabel.textColor = UIColorRGB(0x576b95);
    nameLabel.font = [UIFont systemFontOfSize:FontOfScale(14)];
    nameLabel.text = data.nickName;
    
    NSString *str = data.comment;
    CGSize contentSize = [str sizeWithFont:[UIFont systemFontOfSize:FontOfScale(14)] constrainedToSize:CGSizeMake(UI_IOS_WINDOW_WIDTH-(headView.maxX+BoundsOfScale(20)), 100000) lineBreakMode:NSLineBreakByCharWrapping];
    
    //用户输入内容（没有默认系统填充一句话）
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(headView.maxX+BoundsOfScale(10), nameLabel.maxY+BoundsOfScale(10), UI_IOS_WINDOW_WIDTH-(headView.maxX+BoundsOfScale(20)), contentSize.height)];
    contentLabel.textColor = UIColorRGB(0x333333);
    contentLabel.font = [UIFont systemFontOfSize:FontOfScale(14)];
    contentLabel.numberOfLines = 0;
    contentLabel.text = str;
    
    NSMutableArray *imageArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    if (![data.imageUrl isKindOfClass:[NSNull class]] && data.imageUrl.length > 0) {
        for (NSString *str in [data.imageUrl componentsSeparatedByString:@","]) {
            [imageArray addObject:str];
        }
    }
    
    NSInteger row = 0;
    NSInteger count = imageArray.count;
    CGFloat height = 0;
    CGFloat iamgeViessY = contentLabel.maxY;
    
    if (count > 0){
        if (count%3) {
            row = count/3+1;
        }else{
            row = count/3;
        }
        height = row*kImageWith+(row-1)*10;
        
        iamgeViessY = contentLabel.maxY+BoundsOfScale(10);

    }
    
    UIImageView *iamgeViess = [[UIImageView alloc] initWithFrame:CGRectMake(headView.maxX+BoundsOfScale(10),  iamgeViessY, UI_IOS_WINDOW_WIDTH-(headView.maxX+BoundsOfScale(20)), height)];
    
    //商品uiview
    UIView *commodityView = [[UIView alloc] initWithFrame:CGRectMake(headView.maxX+BoundsOfScale(10), iamgeViess.maxY+BoundsOfScale(10), UI_IOS_WINDOW_WIDTH-(headView.maxX+BoundsOfScale(20)), BoundsOfScale(50))];
    commodityView.backgroundColor = UIColorRGB(0xf3f3f5);
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(commodityView.x, commodityView.maxY+BoundsOfScale(10), BoundsOfScale(100), 20)];
    timeLabel.textColor = UIColorRGB(0x999999);
    timeLabel.font = [UIFont systemFontOfSize:FontOfScale(12)];
    timeLabel.text = @"40分钟前";
    
    UIButton *likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    likeButton.frame = CGRectMake(UI_IOS_WINDOW_WIDTH-BoundsOfScale(90), timeLabel.y, BoundsOfScale(20), BoundsOfScale(20));
    [likeButton setImage:[UIImage imageNamed:@"ic_share_thumb"] forState:UIControlStateNormal];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(likeButton.maxX+BoundsOfScale(20), likeButton.y, 1, BoundsOfScale(20))];
    lineView.backgroundColor = UIColorRGB(0xf3f3f5);
    
    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commentButton.frame = CGRectMake(UI_IOS_WINDOW_WIDTH-BoundsOfScale(30), timeLabel.y, BoundsOfScale(20), BoundsOfScale(20));
    [commentButton setImage:[UIImage imageNamed:@"ic_share_replr"] forState:UIControlStateNormal];
 
    UIView *commentViews = [[UIView alloc] initWithFrame:CGRectMake(headView.maxX+BoundsOfScale(10), commentButton.maxY+BoundsOfScale(5), UI_IOS_WINDOW_WIDTH-(headView.maxX+BoundsOfScale(20)), 10)];
    commentViews.backgroundColor = UIColorRGB(0xf3f3f5);
    
    CGFloat y = BoundsOfScale(5);
    for (int i = 0; i < data.listComment.count; i++) {
        NSDictionary *dic = [data.listComment objectAtIndex:i];
        NSString *string = [NSString stringWithFormat:@"%@：%@", [dic objectForKey:@"nickName"], [dic objectForKey:@"descri"]];
        CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:FontOfScale(13)] constrainedToSize:CGSizeMake(UI_IOS_WINDOW_WIDTH-(headView.maxX+BoundsOfScale(20)+BoundsOfScale(10)), 100000) lineBreakMode:NSLineBreakByCharWrapping];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(BoundsOfScale(5), y, size.width, size.height)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:FontOfScale(13)];
        label.text = string;
        y = label.maxY;
    }
    if (data.listComment.count > 0) {
        commentViews.height = y+BoundsOfScale(5);
    }else{
        commentViews.height = 0;
    }
    
    return commentViews.maxY+BoundsOfScale(10);
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
