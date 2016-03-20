//
//  YPShowShotViewController.m
//  iDesign
//
//  Created by 千锋 on 16/3/7.
//  Copyright © 2016年 yinpans. All rights reserved.
//

#import "YPShowShotViewController.h"
#import <YLImageView.h>
#import <YLGIFImage.h>
#import "YPDrawView.h"
#import <SDWebImageDownloader.h>

@interface YPShowShotViewController ()

@property (nonatomic, strong) YLImageView *shotImageView;
@property (nonatomic, strong) YPDrawView *drawView;

@end

@implementation YPShowShotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI
{
    if (_url) {
        [self showAttachment];
    }else{
        [self showImage];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shotTap:)];
    [self.view addGestureRecognizer:tap];
    self.view.userInteractionEnabled = YES;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(25, HEIGHT - 50, 25, 25)];
    [button setImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(saveShot) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
- (void)saveShot
{
    UIImageWriteToSavedPhotosAlbum(_shotImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    if (!error) {
        [SVProgressHUD showSuccessWithStatus:@"Save success!"];
    }else{
        [SVProgressHUD showErrorWithStatus:@"Error"];
    }
}

- (void)showImage
{
    self.view.backgroundColor = [[UIColor themeBlack] colorWithAlphaComponent:0.8];
    _shotImageView = [[YLImageView alloc] initWithFrame:*(_originRect)];
    _shotImageView.image = [YLGIFImage imageWithData:_shotData];
    _shotImageView.userInteractionEnabled = YES;
    [self addGestureRecognizerForShotImage:_shotImageView];
    
    [self.view addSubview:_shotImageView];
}

- (void)showAttachment
{
    self.view.backgroundColor = [[UIColor themeBackgroundBlack] colorWithAlphaComponent:0.8];
    _shotImageView = [[YLImageView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_shotImageView];
    _shotImageView.userInteractionEnabled = YES;
    [self addGestureRecognizerForShotImage:_shotImageView];
    __weak typeof(self) weakSelf = self;
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:_url ] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        weakSelf.drawView.value = (CGFloat)receivedSize/(CGFloat)expectedSize;
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        if (image && finished) {
            _shotImageView.frame = CGRectMake(0, 0, WIDTH, image.size.height * WIDTH /image.size.width);
            _shotImageView.center = self.view.center;
            _shotImageView.image = [YLGIFImage imageWithData:data];
        }
    }];
}

- (YPDrawView *)drawView
{
    if (!_drawView) {
        _drawView = [[YPDrawView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _drawView.backgroundColor = [UIColor clearColor];
        _drawView.center = self.view.center;
        [self.view addSubview:_drawView];
    }
    return _drawView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _shotImageView.center = self.view.center;
    } completion:nil];
}

- (void)addGestureRecognizerForShotImage:(UIImageView *)imageView;
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shotTap:)];
    [imageView addGestureRecognizer:tap];
    
    
    UIPinchGestureRecognizer *pin = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(shotPin:)];
    [imageView addGestureRecognizer:pin];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self back];
}

- (void)shotRotation:(UIRotationGestureRecognizer *)rotation
{
    static CGFloat offFloat;
    //rotation 旋转的角度 + 记录的角度 offFloat
    _shotImageView.transform =  CGAffineTransformMakeRotation(rotation.rotation + offFloat);
    //rotation.state 手势状态
    //UIGestureRecognizerStateEnded 手势结束
    if (rotation.state == UIGestureRecognizerStateEnded) {
        //在手势结束时 记录一下旋转角度 以便下次旋转时用
        offFloat = offFloat + rotation.rotation;
    }
}



- (void)shotTap:(UITapGestureRecognizer *)sender
{
    [self back];
}

- (void)shotPan:(UIPanGestureRecognizer *)pan
{
    
    CGPoint point = [pan locationInView:_shotImageView];
    
    _shotImageView.center = point;
}

- (void)shotPin:(UIPinchGestureRecognizer *)pinch
{

    //捏合手势触发此方法
    static CGFloat offFloct = 1;
    
    if (pinch.scale < 0.8) {
        pinch.scale = 0.8;
    }
    //CGAffineTransformMakeScale 直接形变
    _shotImageView.transform = CGAffineTransformMakeScale(pinch.scale * offFloct, pinch.scale * offFloct);
    
    if (pinch.state == UIGestureRecognizerStateEnded) {
        offFloct = pinch.scale * offFloct;
    }
    
    if (pinch.scale < 1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.2 animations:^{
                _shotImageView.transform = CGAffineTransformIdentity;
            }];
        });
    }
}


- (void)back
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
