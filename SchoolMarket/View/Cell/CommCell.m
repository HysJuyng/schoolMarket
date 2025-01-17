/*
 商品Cell
 */

#import "CommCell.h"
#import "SDWebImage-umbrella.h"

#import "Commodity.h"


@implementation CommCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        //商品图片imageView
        UIImageView *tempimgv = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width - 10, self.frame.size.height / 5 * 3 - 10)];
        self.commImgv = tempimgv;
        [self addSubview:self.commImgv];
        
        //商品名称
        UILabel *tempName = [[UILabel alloc] initWithFrame:CGRectMake(5, self.frame.size.height / 5 * 3, self.frame.size.width, self.frame.size.height / 20 * 2)];
        self.lbName = tempName;
        self.lbName.font = [UIFont systemFontOfSize:self.lbName.frame.size.height];
        [self addSubview:self.lbName];
        
        //商品规格
        UILabel *tempSpecification = [[UILabel alloc] initWithFrame:CGRectMake(5, self.frame.size.height / 10 * 7, self.frame.size.width, self.frame.size.height / 20 * 2)];
        self.lbSpecification = tempSpecification;
        self.lbSpecification.font = [UIFont systemFontOfSize:self.lbSpecification.frame.size.height - 3];
        [self addSubview:self.lbSpecification];
        
        //加按钮
        self.btnAdd = [UIButton buttonWithType:(UIButtonTypeSystem)];
        self.btnAdd.frame = CGRectMake(self.frame.size.width / 4 * 3, self.frame.size.height / 20 * 17, self.frame.size.width / 4, self.frame.size.width / 4);
        [self.btnAdd setTitle:@"+" forState:(UIControlStateNormal)];
        self.btnAdd.titleLabel.font = [UIFont systemFontOfSize:self.btnAdd.frame.size.width * 1.2];
        [self.btnAdd setTitleColor:[UIColor colorWithRed:10.0/255.0 green:200.0/255.0 blue:150.0/255.0 alpha:1.0] forState:(UIControlStateNormal)];
        [self addSubview:self.btnAdd];
        
        [self.btnAdd addTarget:self.delegate action:@selector(commCellClickAdd:) forControlEvents:(UIControlEventTouchUpInside)];
        
        //减按钮
        self.btnMinus = [UIButton buttonWithType:(UIButtonTypeSystem)];
        self.btnMinus.frame = CGRectMake(0, self.frame.size.height / 20 * 17, self.frame.size.width / 4, self.frame.size.width / 4);
        [self.btnMinus setTitle:@"-" forState:(UIControlStateNormal)];
        self.btnMinus.titleLabel.font = [UIFont systemFontOfSize:self.btnMinus.frame.size.width * 1.5];
        [self.btnMinus setTitleColor:[UIColor colorWithRed:0.840 green:0.816 blue:1.000 alpha:1.000] forState:(UIControlStateNormal)];
        [self addSubview:self.btnMinus];
        
        [self.btnMinus addTarget:self.delegate action:@selector(commCellClickMinus:) forControlEvents:(UIControlEventTouchUpInside)];
        
        //价格lable
        UILabel *tempPrice = [[UILabel alloc]initWithFrame:CGRectMake(5, self.frame.size.height / 20 * 17, self.frame.size.width / 3 * 2, self.frame.size.width / 4)];
        self.lbPrice = tempPrice;
        self.lbPrice.font = [UIFont systemFontOfSize:self.lbPrice.frame.size.height / 3 * 2];
        [self addSubview:self.lbPrice];
        
        //数量lable
        UILabel *tempNum = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width / 4, self.frame.size.height / 20 * 17, self.frame.size.width / 2, self.frame.size.width / 4)];
        self.lbNum = tempNum;
        self.lbNum.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.lbNum];
    }
    return self;
}


//设置选择的商品数量
- (void)setSelectedNum:(NSString*)num {
    self.lbNum.text = num;
}

/** 通过model设置cell内容*/
- (void)setCommCell:(Commodity*)commodity {
    self.lbName.text = commodity.commName;
    self.lbSpecification.text = commodity.specification;
    self.lbPrice.text = [NSString stringWithFormat:@"￥%@",commodity.price];
    NSLog(@"%@",commodity.picture);
    if ([commodity.picture isEqual:[NSNull null]]) {
        [self.commImgv setImage:[UIImage imageNamed:@"default_img_failed"]];
    } else {
        [self.commImgv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://schoolserver.nat123.net/SchoolMarketServer/uploadDir/%@",commodity.picture]]
                         placeholderImage:[UIImage imageNamed:@"default_img"]
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    if (error) {
                                        self.commImgv.image = [UIImage imageNamed:@"default_img_failed"];
                                    }
                                }];
        
        //如果数量不为0 设置选择数量 并显示
        if (commodity.selectedNum != 0) {
            self.lbNum.text = [NSString stringWithFormat:@"%d",commodity.selectedNum];
            //隐藏价格 显示减按钮 数量文本
            self.lbNum.hidden = false;
            self.btnMinus.hidden = false;
            self.lbPrice.hidden = true;
        } else {
            //设置文本
            self.lbNum.text = @"";
            //显示价格  隐藏减按钮 数量文本
            self.lbNum.hidden = true;
            self.btnMinus.hidden = true;
            self.lbPrice.hidden = false;
        }
        
        //显示加按钮
        self.btnAdd.hidden = false;
    }
}
/** 设置cell的数量*/
- (void)setCommcellOfSelectedNum:(NSString*)selectedNum {
    //如果数量为0
    if ([selectedNum isEqualToString:@"0"]) {
        //设置文本
        self.lbNum.text = @"";
        //显示价格  隐藏减按钮 数量文本
        self.lbNum.hidden = true;
        self.btnMinus.hidden = true;
        self.lbPrice.hidden = false;
    } else {  //如果数量不为0
        self.lbNum.text = selectedNum;
        //隐藏价格 显示减按钮 数量文本
        self.lbNum.hidden = false;
        self.btnMinus.hidden = false;
        self.lbPrice.hidden = true;
    }
}

@end
