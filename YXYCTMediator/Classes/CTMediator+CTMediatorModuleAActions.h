//
//  CTMediator+CTMediatorModuleAActions.h
//  CTMediator
//
//  Created by casa on 16/3/13.
//  Copyright © 2016年 casa. All rights reserved.
//

#import "CTMediator.h"
#import <UIKit/UIKit.h>

@interface CTMediator (CTMediatorModuleAActions)

@property (nonatomic, copy) NSString *target;// 类名
@property (nonatomic, copy) NSString *actionName;// 方法名

- (UIViewController *)CTMediator_viewControllerForDetail:(NSDictionary *)params;

- (void)CTMediator_showAlertWithMessage:(NSString *)message cancelAction:(void(^)(NSDictionary *info))cancelAction confirmAction:(void(^)(NSDictionary *info))confirmAction;

- (void)CTMediator_presentImage:(UIImage *)image;

- (UITableViewCell *)CTMediator_tableViewCellWithIdentifier:(NSString *)identifier tableView:(UITableView *)tableView;

- (void)CTMediator_configTableViewCell:(UITableViewCell *)cell withTitle:(NSString *)title atIndexPath:(NSIndexPath *)indexPath;

- (void)CTMediator_cleanTableViewCellTarget;

@end
