//
//  WBFloatWindow.m
//  WBLiveKit
//
//  Created by mincj on 2017/3/29.
//  Copyright © 2017年 Sina. All rights reserved.
//

#import "WBFloatWindow.h"
#import "WBDraggalbeView.h"

@interface WBWindow11 : UIWindow
@property(weak, nonatomic)UIView* gradView;
@end
@implementation WBWindow11
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    return [self.gradView hitTest:[self convertPoint:point toView:self.gradView] withEvent:event];
}

- (void)sendEvent:(UIEvent *)event{
    [super sendEvent:event];
}
@end

@interface WBFloatWindow()<WBDraggalbeDelegate>
@property(strong, nonatomic)WBWindow11* windows;
@property(strong, nonatomic)WBDraggalbeView* dragView;
@property(strong, nonatomic)UIView* moveArea;
@property(assign, nonatomic)CGRect screenArea;
@end


@implementation WBFloatWindow

@synthesize windows = _windows;
@synthesize showView = _showView;
@synthesize moveInRect = _moveInRect;

+(instancetype)floatWindow{
    static WBFloatWindow* global = nil;
    static dispatch_once_t token ;
    
    if(!global){
        dispatch_once(&token, ^{
            if(!global){
                global = [[[self class]alloc]init];
            }
        });
    }
    
    return global;
}

-(instancetype)init{
    self = [super init];
    self.screenArea = [UIScreen mainScreen].bounds;
    return self;
}
-(void)dealloc{
    NSLog(@"----%s---WBFloatWindow::::delloc------", __func__);
}

-(void)showView:(UIView*)view delegate:(id<WBFloatWindowProtcol>) delegate fromViewController:(UIViewController*)vc{
    self.showView = view;
    self.delegate = delegate;
    self.fromViewController = vc;
    
    _hasFloatWindow = YES;
    //>
    [self.dragView insertSubview:self.showView atIndex:0];
    
    [self resetWindowPos];
    self.windows.hidden  = NO;
    
    [self.windows makeKeyAndVisible];
}
-(void)close{
    _hasFloatWindow = NO;
    self.windows.hidden = YES;
    for (UIView* sub in self.dragView.subviews) {
        if(sub == self.showView){
            [sub removeFromSuperview];
        }
    }
    self.showView = nil;
    self.fromViewController = nil;
}

-(WBDraggalbeView*)dragView{
    if(!_dragView){
        _dragView = [[WBDraggalbeView alloc]initWithFrame:CGRectZero];
        _dragView.delegate = self;
        
        [self.moveArea addSubview:_dragView];
        self.windows.gradView = _dragView;
    }
    return _dragView;
}

-(WBWindow11*)windows{
    if(!_windows){
        _windows = [[WBWindow11 alloc]initWithFrame:CGRectZero];
        _windows.windowLevel = UIWindowLevelAlert + 1;

        CGRect screen = [UIScreen mainScreen].bounds;
        _windows.center = CGPointMake(CGRectGetMidX(screen), CGRectGetMidY(screen));
        _windows.bounds = screen;
        _windows.backgroundColor = [UIColor clearColor];
    }
    return _windows;
}

-(UIView*)moveArea{
    if(!_moveArea){
        _moveArea = [[UIView alloc]initWithFrame:CGRectZero];
//        _moveArea.layer.borderWidth = 1;
        
        [self.windows addSubview:_moveArea];
        _moveArea.frame = CGRectMake(10, 10, CGRectGetWidth(self.screenArea) - 20, CGRectGetHeight(self.screenArea) - 20);
    }
    return _moveArea;
}



-(void)resetWindowPos{
    CGRect screen = [UIScreen mainScreen].bounds;
    self.dragView.center = CGPointMake(CGRectGetMidX(screen), CGRectGetMidY(screen));
    self.dragView.bounds = CGRectMake(0, 0, 100, 150);
    self.showView.frame = CGRectMake(0, 0, 100, 150);
}

#pragma mark -- delegate for drag view
-(void)closeView:(WBDraggalbeView*)view{
    [self close];
    
    if([self.delegate respondsToSelector:@selector(closeFloatView:)]){
        [self.delegate closeFloatView:self];
    }
}
-(void)tapView:(WBDraggalbeView*)view{
    UIViewController* root = [self topMostViewController];
    if([self.delegate respondsToSelector:@selector(recoverViewController:BaseViewController:FloatWindow:)]){
        [self.delegate recoverViewController:self.fromViewController BaseViewController:root FloatWindow:self];
    }
    [self close];
}

- (UIViewController*)topMostViewController {
    UIWindow* normal = nil;
    for (UIWindow* item in [UIApplication sharedApplication].windows) {
        if(item.windowLevel == UIWindowLevelNormal){
            normal = item;
            break;
        }
    }
    return [self topViewControllerWithRootViewController:normal.rootViewController];
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    // Handling UITabBarController
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarCtrl = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarCtrl.selectedViewController];
    }
    // Handling UINavigationController
    else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    }
    // Handling Modal views
    else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    }
    // Handling UIViewController's added as subviews to some other views.
    else {
        for (UIView *view in [rootViewController.view subviews])
        {
            id subViewController = [view nextResponder];    // Key property which most of us are unaware of / rarely use.
            if ( subViewController && [subViewController isKindOfClass:[UIViewController class]])
            {
                return [self topViewControllerWithRootViewController:subViewController];
            }
        }
        return rootViewController;
    }
}
@end
