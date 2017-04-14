//
//  CFlowViewController.m
//  flowWindow
//
//  Created by mincj on 2017/4/13.
//  Copyright © 2017年 mincj. All rights reserved.
//

#import "CFlowViewController.h"
#import "WBFloatWindow.h"

@interface CFlowViewController ()<WBFloatWindowProtcol>
@property(nonatomic, strong)UIView* flowWindow;
@end

@implementation CFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(50, 50, 50, 50)];
    [btn setTitle:@"悬浮" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(flowWindow:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [self.view addSubview:self.flowWindow];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView*)flowWindow{
    if(_flowWindow) return _flowWindow;
    
    UIView* back = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 100, 200)];
    back.backgroundColor = [UIColor yellowColor];
    _flowWindow  = back;
    return back;
}
-(void)flowWindow:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
    
    [[WBFloatWindow floatWindow]showView:[self flowWindow] delegate:self fromViewController:self];
}

-(void)recoverViewController:(UIViewController*)vc BaseViewController:(UIViewController*)baseViewController FloatWindow:(WBFloatWindow*)floatWindow{
    if([vc isKindOfClass:[self class]]){
        floatWindow.showView.frame = CGRectMake(100, 100, 100, 200);
        [vc.view addSubview:floatWindow.showView];
    }
    if(baseViewController.navigationController){
        [baseViewController.navigationController pushViewController:vc animated:YES];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
