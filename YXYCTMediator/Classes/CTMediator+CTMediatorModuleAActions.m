//
//  CTMediator+CTMediatorModuleAActions.m
//  CTMediator
//
//  Created by casa on 16/3/13.
//  Copyright © 2016年 casa. All rights reserved.
//

#import "CTMediator+CTMediatorModuleAActions.h"
#import <objc/runtime.h> /*或者 #import <objc/message.h>*/

static NSString *targetKey = @"targetKey";
static NSString *actionKey = @"actionKey";


NSString * const kCTMediatorActionNativePresentImage = @"nativePresentImage";
NSString * const kCTMediatorActionNativeNoImage = @"nativeNoImage";
NSString * const kCTMediatorActionShowAlert = @"showAlert";
NSString * const kCTMediatorActionCell = @"cell";
NSString * const kCTMediatorActionConfigCell = @"configCell";

@implementation CTMediator (CTMediatorModuleAActions)
- (UIViewController *)CTMediator_viewControllerForDetail
{
    UIViewController *viewController = [self performTarget:self.target
                                                    action:self.actionName
                                                    params:@{@"key":@"value"}
                                         shouldCacheTarget:NO
                                        ];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        // view controller 交付出去之后，可以由外界选择是push还是present
        return viewController;
    } else {
        // 这里处理异常场景，具体如何处理取决于产品
        return [[UIViewController alloc] init];
    }
}

- (void)CTMediator_presentImage:(UIImage *)image
{
    if (image) {
        [self performTarget:self.target
                     action:kCTMediatorActionNativePresentImage
                     params:@{@"image":image}
          shouldCacheTarget:NO];
    } else {
        // 这里处理image为nil的场景，如何处理取决于产品
        [self performTarget:self.target
                     action:kCTMediatorActionNativeNoImage
                     params:@{@"image":[UIImage imageNamed:@"noImage"]}
          shouldCacheTarget:NO];
    }
}

- (void)CTMediator_showAlertWithMessage:(NSString *)message cancelAction:(void(^)(NSDictionary *info))cancelAction confirmAction:(void(^)(NSDictionary *info))confirmAction
{
    NSMutableDictionary *paramsToSend = [[NSMutableDictionary alloc] init];
    if (message) {
        paramsToSend[@"message"] = message;
    }
    if (cancelAction) {
        paramsToSend[@"cancelAction"] = cancelAction;
    }
    if (confirmAction) {
        paramsToSend[@"confirmAction"] = confirmAction;
    }
    [self performTarget:self.target
                 action:kCTMediatorActionShowAlert
                 params:paramsToSend
      shouldCacheTarget:NO];
}

- (UITableViewCell *)CTMediator_tableViewCellWithIdentifier:(NSString *)identifier tableView:(UITableView *)tableView
{
    return [self performTarget:self.target
                        action:kCTMediatorActionCell
                        params:@{
                                 @"identifier":identifier,
                                 @"tableView":tableView
                                 }
             shouldCacheTarget:YES];
}

- (void)CTMediator_configTableViewCell:(UITableViewCell *)cell withTitle:(NSString *)title atIndexPath:(NSIndexPath *)indexPath
{
    [self performTarget:self.target
                 action:kCTMediatorActionConfigCell
                 params:@{
                          @"cell":cell,
                          @"title":title,
                          @"indexPath":indexPath
                          }
      shouldCacheTarget:YES];
}

- (void)CTMediator_cleanTableViewCellTarget
{
    [self releaseCachedTargetWithTargetName:self.target];
}

#pragma mark - 添加的属性
- (void)setTarget:(NSString *)target {
    objc_setAssociatedObject(self, &targetKey, target, OBJC_ASSOCIATION_COPY);
}
- (NSString *)target {
    return objc_getAssociatedObject(self, &targetKey);
}


- (void)setActionName:(NSString *)actionName{
    objc_setAssociatedObject(self, &actionKey, actionName, OBJC_ASSOCIATION_COPY);
}
- (NSString *)actionName{
    return objc_getAssociatedObject(self, &actionKey);
}

@end
