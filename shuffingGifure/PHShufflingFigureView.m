//
//  PHShufflingFigureView.m
//  shuffingGifure
//
//  Created by 大麦 on 16/4/2.
//  Copyright © 2016年 lsp. All rights reserved.
//  参考 http://www.cocoachina.com/ios/20160331/15808.html

#import "PHShufflingFigureView.h"
typedef enum{
    PHDirecNone,
    PHDirecLeft,
    PHDirecRight
} PHDirection;


@interface PHShufflingFigureView ()<UIScrollViewDelegate>

#define WIDTH_shuF    self.frame.size.width
#define HEIGHT_shuF   self.frame.size.height

@property (strong, nonatomic) IBOutlet UIView *contentView;

//轮播的图片数组
@property (nonatomic, strong) NSMutableArray *images;
//滚动方向
@property (nonatomic, assign) PHDirection direction;
//显示的imageView
@property (nonatomic, strong) UIImageView *currImageView;
//辅助滚动的imageView
@property (nonatomic, strong) UIImageView *otherImageView;
//当前显示图片的索引
@property (nonatomic, assign) NSInteger currIndex;
//将要显示图片的索引
@property (nonatomic, assign) NSInteger nextIndex;
//定时器
@property (nonatomic, strong) NSTimer *timer;
//每一页停留时间
@property (nonatomic, assign) NSTimeInterval time;

@end

@implementation PHShufflingFigureView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib {
    [[NSBundle mainBundle] loadNibNamed:@"PHShufflingFigureView" owner:self options:nil];
    self.contentView.frame = self.frame;
    [self addSubview: self.contentView];
    self.pageControl.hidden = YES;
//    [self setPageImage:[UIImage imageNamed:@"other.png"] andCurrentImage:[UIImage imageNamed:@"current.png"]];
}

#pragma mark -- 设置图片和设置时间间隔
-(void)dataSourceWithImageArray:(NSArray *)imageArray andDelegate:(id)delegate andTimeInterval:(float)timeInterval
{
    if([imageArray count]!=0)
    {
        //设置scrollview
        self.time = timeInterval;
        self.delegate = delegate;
        [self.images removeAllObjects];
        self.images = [NSMutableArray arrayWithArray:imageArray];
        self.pageControl.numberOfPages = [self.images count];
        [self fillScrollViewWithImageArray:imageArray];
        if([self.images count]>1)
        {
            //启用计时器
            [self startTimer];
        }
    }
}
#pragma mark -- 填充scrollview
-(void)fillScrollViewWithImageArray:(NSArray *)imageArray
{
    [self addObserver:self forKeyPath:@"direction" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    //
    //>3的情况
    self.scrollView.contentSize = CGSizeMake(3*WIDTH_shuF, HEIGHT_shuF);
    self.scrollView.contentOffset = CGPointMake(WIDTH_shuF, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    //
    _currImageView = [[UIImageView alloc] init];
    _currImageView.userInteractionEnabled = YES;
    [_currImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick)]];
    [_scrollView addSubview:_currImageView];
    //
    _otherImageView = [[UIImageView alloc] init];
    [_scrollView addSubview:_otherImageView];
    //
    self.currImageView.image = self.images.firstObject;
    //
    _scrollView.contentOffset = CGPointMake(WIDTH_shuF, 0);
    _currImageView.frame = CGRectMake(WIDTH_shuF, 0, WIDTH_shuF, WIDTH_shuF);
    [self setScrollViewContentSize];
}
#pragma mark 设置scrollView的contentSize
- (void)setScrollViewContentSize {
    if (_images.count > 1) {
        self.scrollView.contentSize = CGSizeMake(self.frame.size.width * 3, 0);
    } else {
        self.scrollView.contentSize = CGSizeZero;
    }
}
#pragma mark 图片点击事件
- (void)imageClick {
    if(self.delegate&&[self.delegate respondsToSelector:@selector(clickimageViewIndex:)])
    {
        [self.delegate clickimageViewIndex:self.currIndex];
    }
}
#pragma mark 设置pageControl的图片
- (void)setPageImage:(UIImage *)pageImage andCurrentImage:(UIImage *)currentImage {
    if (!pageImage || !currentImage) return;
    //此处要求系统时是7.0 以上
    [_pageControl setValue:currentImage forKey:@"_currentPageImage"];
    [_pageControl setValue:pageImage forKey:@"_pageImage"];
}
#pragma mark- --------定时器相关方法--------
- (void)startTimer {
    //如果self.time＝0的话则不需要定时器
    if(self.time==0)  return;
    //如果只有一张图片，则直接返回，不开启定时器
    if (_images.count <= 1) return;
    //如果定时器已开启，先停止再重新开启
    if (self.timer) [self stopTimer];
    self.timer = [NSTimer timerWithTimeInterval:self.time target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)nextPage {
    [self.scrollView setContentOffset:CGPointMake(WIDTH_shuF * 2, 0) animated:YES];
}

#pragma mark KVO监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {

    if(change[NSKeyValueChangeNewKey] == change[NSKeyValueChangeOldKey]) return;
    if ([change[NSKeyValueChangeNewKey] intValue] == PHDirecRight) {
        self.otherImageView.frame = CGRectMake(0, 0, WIDTH_shuF, HEIGHT_shuF);
        self.nextIndex = self.currIndex - 1;
        if (self.nextIndex < 0) self.nextIndex = _images.count - 1;
    } else if ([change[NSKeyValueChangeNewKey] intValue] == PHDirecLeft){
        self.otherImageView.frame = CGRectMake(CGRectGetMaxX(_currImageView.frame), 0, WIDTH_shuF, HEIGHT_shuF);
        self.nextIndex = (self.currIndex + 1) % _images.count;
    }
    self.otherImageView.image = self.images[self.nextIndex];
    if([self.images count]==1)//加此行代码是当图片数组是1的时候otherImageView的frame会覆盖住currImageView
    {
        self.currImageView.frame = CGRectMake(0, 0, WIDTH_shuF, HEIGHT_shuF);
    }
}
#pragma mark- --------UIScrollViewDelegate--------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.direction = scrollView.contentOffset.x > self.frame.size.width? PHDirecLeft : PHDirecRight;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self startTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self pauseScroll];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self pauseScroll];
}
- (void)pauseScroll {

    self.direction = PHDirecNone;
    int index = self.scrollView.contentOffset.x / WIDTH_shuF;
    if (index == 1) return;
    self.currIndex = self.nextIndex;
    self.pageControl.currentPage = self.currIndex;
    self.currImageView.frame = CGRectMake(WIDTH_shuF, 0, WIDTH_shuF, HEIGHT_shuF);
    self.currImageView.image = self.otherImageView.image;
    self.scrollView.contentOffset = CGPointMake(WIDTH_shuF, 0);
}
- (void)dealloc {
    [self removeObserver:self forKeyPath:@"direction"];
}
@end
