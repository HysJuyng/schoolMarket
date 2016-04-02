//
//  CategoriesCell.h
//  SchoolMarket
//
//  Created by tb on 16/4/2.
//  Copyright © 2016年 linjy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Categories;

@interface CategoriesCell : UITableViewCell

/**  分类的数据模型 */
@property (nonatomic, strong) Categories *mainCategories;

/**  提供一个类方法快速创建Cell */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
