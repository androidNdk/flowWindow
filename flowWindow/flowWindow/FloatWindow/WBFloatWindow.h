//
//  WBFloatWindow.h
//  WBLiveKit
//
//  Created by mincj on 2017/3/29.
//  Copyright © 2017年 Sina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class WBFloatWindow;

@protocol WBFloatWindowProtcol <NSObject>

@required
-(void)recoverViewController:(UIViewController*)vc BaseViewController:(UIViewController*)baseViewController FloatWindow:(WBFloatWindow*)floatWindow;

@optional
-(void)closeFloatView:(WBFloatWindow*)window;
@end


@interface WBFloatWindow : NSObject{
    @protected
    UIView* _showView;
    CGRect _moveInRect;
}

+(instancetype)floatWindow;

-(void)showView:(UIView*)view delegate:(id<WBFloatWindowProtcol>) delegate fromViewController:(UIViewController*)vc;
-(void)close;

@property(strong, nonatomic)UIViewController* fromViewController;

@property(assign, nonatomic)CGRect moveInRect;
@property(readonly, assign, nonatomic)BOOL hasFloatWindow;

@property(weak, nonatomic)id<WBFloatWindowProtcol> delegate;
@property(strong, nonatomic)UIView* showView;
@end


