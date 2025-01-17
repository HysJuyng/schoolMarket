/*
 账户信息 单元格
 标题  内容  图片
 */

#import <UIKit/UIKit.h>

@interface PersonMsgCell : UITableViewCell


@property (nonatomic,weak) UILabel *lbTitle;
@property (nonatomic,weak) UILabel *lbContent;
@property (nonatomic,weak) UIImageView *nextImgv;


//初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andFrame:(CGRect)frame;

/**
 *  设置cell内容
 *
 *  @param title   标题
 *  @param content 内容
 */
- (void)setPersonMsgCell:(NSString*)title andContent:(NSString*)content;

@end
