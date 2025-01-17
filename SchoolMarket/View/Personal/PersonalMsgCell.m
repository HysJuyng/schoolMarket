/*
 个人主页 头部信息
 头像  用户名  手机号码
 */

#import "PersonalMsgCell.h"
#import "SDWebImage-umbrella.h"
#import "User.h"

@implementation PersonalMsgCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andFrame:(CGRect)frame
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.frame = frame;
        self.backgroundColor = [UIColor colorWithRed:10.0/255.0 green:200.0/255.0 blue:150.0/255.0 alpha:1.0];
        
        
        //头像
        UIImageView *tempimgv = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width / 6, self.frame.size.height / 4, self.frame.size.height / 2, self.frame.size.height / 2)];
        self.userImgv = tempimgv;
        self.userImgv.layer.masksToBounds = YES; //设置圆角
        self.userImgv.layer.cornerRadius = 36;
        self.userImgv.image = [UIImage imageNamed:@"personal_default_head.png"];
        [self addSubview:self.userImgv];
        
        //用户名
        UILabel *tempname = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 6 + self.frame.size.height / 2 + 5, self.frame.size.height / 4, self.frame.size.width / 3 * 2 - self.frame.size.height / 2 - 5 , self.frame.size.height / 5)];
        self.lbName = tempname;
        self.lbName.textAlignment = NSTextAlignmentLeft;
        self.lbName.text = @"请输入您的昵称";
        [self addSubview:self.lbName];
        
        //手机图标
        UIImageView *tempphoneimgv = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width / 6 + self.frame.size.height / 2 + 5, self.frame.size.height / 2, self.frame.size.height / 12, self.frame.size.height / 8)];
        self.phoneImgv = tempphoneimgv;
        self.phoneImgv.image = [UIImage imageNamed:@"personal_mobile"];
        [self addSubview:self.phoneImgv];
        
        //手机号码
        UILabel *tempphone = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 6 + self.frame.size.height / 2 + self.frame.size.height / 12 + 10, self.frame.size.height / 2, self.frame.size.width / 3 * 2 - self.frame.size.height / 2  - self.frame.size.height / 8 - 10, self.frame.size.height / 8)];
        self.lbPhone = tempphone;
        self.lbPhone.textAlignment = NSTextAlignmentLeft;
        //字体
        self.lbPhone.font = [UIFont systemFontOfSize:self.frame.size.height / 12];
        [self addSubview:self.lbPhone];
        
        
        
    }
    return self;
}

/**
 *  设置内容
 *
 *  @param user 用户model
 */
- (void)setPersonalCell:(User*)user {
    if ([user.portrait.class isEqual:[NSNull class]]) {
        self.userImgv.image = [UIImage imageNamed:@"personal_default_head"];
    } else {
        [self.userImgv sd_setImageWithURL:[NSURL URLWithString:user.portrait] placeholderImage:[UIImage imageNamed:@"personal_default_head"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (error) {
                
            }
        }];
    }
    
    self.lbName.text = user.userName;
    self.lbPhone.text = user.userPhone;
}

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
