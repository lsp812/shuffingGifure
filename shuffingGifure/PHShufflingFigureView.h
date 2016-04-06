//
//  PHShufflingFigureView.h
//  shuffingGifure
//
//  Created by 大麦 on 16/4/2.
//  Copyright © 2016年 lsp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PHShufflingFigureDataSourceDelegate <NSObject>

#pragma mark -- 返回下标从0开始.
-(void)clickimageViewIndex:(int)index;

@end

@interface PHShufflingFigureView : UIView
@property (nonatomic, assign) id<PHShufflingFigureDataSourceDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;


#pragma mark 设置图片、代理和设置时间间隔
-(void)dataSourceWithImageArray:(NSArray *)imageArray andDelegate:(id)delegate andTimeInterval:(float)timeInterval;


@end
