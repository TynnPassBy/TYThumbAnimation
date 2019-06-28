//
//  ViewController.m
//  TYThumbAnimation
//
//  Created by 刘庆贺 on 2019/5/5.
//  Copyright © 2019 Tynn丶. All rights reserved.
//

#import "ViewController.h"
#import "RBCLikeButton.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"点赞动画";
    
    
    RBCLikeButton *likeBtn = [[RBCLikeButton alloc] initWithFrame:CGRectMake(130, 200, 100, 100)];
    [likeBtn setImage:[UIImage imageNamed:@"day_like"] forState:UIControlStateNormal];
    [likeBtn setImage:[UIImage imageNamed:@"day_like_red"] forState:UIControlStateSelected];
    likeBtn.layer.cornerRadius = 5;
    likeBtn.layer.borderColor = [UIColor grayColor].CGColor;
    likeBtn.layer.borderWidth = 1;
    
    likeBtn.thumpNum = 0;
    [likeBtn addTarget:self action:@selector(likeBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:likeBtn];
    
    //设置点赞
//    [likeBtn setThumbWithSelected:NO thumbNum:0 animation:NO];
}
//点赞/取消点赞操作
- (void)likeBtnClickAction:(RBCLikeButton *)btn {
    
    //1.记录是否是点赞操作
    BOOL isThump = !btn.isSelected;
    
    //2.点赞量,正式运用中可自定义(从服务器获取当前的点赞量)
    NSInteger num = btn.thumpNum;
    
    //3.计算点赞后数值
    if (isThump) {
        //点赞后的点赞数
        num = num + 1;
    }else{
        //取消点赞后的点赞数
        num = num - 1;
    }
    
    //4.调用点赞动画,设置点赞button的点赞数值
    [btn setThumbWithSelected:isThump thumbNum:num animation:YES];
    
    //5.网络请求
    if (isThump) {//如果是点赞操作
        
        //发起网络请求,告知服务器APP进行了点赞操作,服务器返回是否成功的结果为isRequestSuccess
        //服务器返回的点赞按钮状态为status
        RBCLikeButtonStatus status = RBCLikeButtonStatusNoneThumbs;
        //如果status不是"正在取消点赞"和"正在点赞"和"已点赞"的状态时,再执行点赞网络请求
        if (status != RBCLikeButtonStatusCancelThumbsing
            && status != RBCLikeButtonStatusThumbsing
            && status != RBCLikeButtonStatusHadThumbs   )
        {
            //改变本地点赞按钮model的点赞状态
            status = RBCLikeButtonStatusThumbsing;
            //开始点赞网络请求
            BOOL isRequestSuccess = YES;//请求成功
            if (!isRequestSuccess) {//如果操作失败(没有网络或接口异常)
                //取消刚才的点赞操作导致的数值变换和点赞按钮的状态变化
                [btn cancelLike];
            }
        }
        
        
    }else{//如果是取消点赞操作
        
        //发起网络请求,告知服务器APP进行了取消点赞操作,服务器的返回结果为isRequestSuccess
        //服务器返回的点赞按钮状态为status
        RBCLikeButtonStatus status = RBCLikeButtonStatusNoneThumbs;
        //如果status不是"正在取消点赞"和"正在点赞"和"已点赞"的状态时,再执行点赞网络请求
        if (status != RBCLikeButtonStatusCancelThumbsing
            && status != RBCLikeButtonStatusThumbsing
            && status != RBCLikeButtonStatusHadThumbs   )
        {
            BOOL isRequestSuccess = YES;//请求成功
//            BOOL isRequestSuccess = NO;//请求失败
            status = RBCLikeButtonStatusCancelThumbsing;
            if (!isRequestSuccess) {//如果操作失败(没有网络或接口异常)
                //恢复到点赞之前的点赞数值和点赞按钮的状态变化
                [btn recoverLike];
            }
        }
    }
    
}

@end
