//
//  WBDraggalbeView.h
//  WBLiveKit
//
//  Created by mincj on 2017/3/29.
//  Copyright © 2017年 Sina. All rights reserved.
//

#import <UIKit/UIKit.h>


@class WBDraggalbeView;

@protocol WBDraggalbeDelegate <NSObject>

-(void)closeView:(WBDraggalbeView*)view;
-(void)tapView:(WBDraggalbeView*)view;

@end

@interface WBDraggalbeView : UIView
@property(weak, nonatomic)id <WBDraggalbeDelegate> delegate;
@property(assign, nonatomic)CGRect moveScreenArea;

@end
