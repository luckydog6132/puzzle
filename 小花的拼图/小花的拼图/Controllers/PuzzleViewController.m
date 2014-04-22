//
//  PuzzleViewController.m
//  小花的拼图
//
//  Created by luckydog on 13-12-30.
//  Copyright (c) 2013年 Szdcec. All rights reserved.
//

#import "PuzzleViewController.h"
#import "OtherSolve.h"

@interface PuzzleViewController ()
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation PuzzleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self initData];
    
    [self initPuzzleImage];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark 初始化

// 初始化必要数据
-(void) initData
{
    self.title = @"拼图";
    
    self.string_ImageName = @"IMG_0002.JPG";
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = back;
    
    UIBarButtonItem *selectItem = [[UIBarButtonItem alloc]initWithTitle:@"选取" style:UIBarButtonItemStyleBordered target:self action:@selector(takePicture:)];
    
    NSMutableArray *arrayButtons = [NSMutableArray arrayWithObject:selectItem];
    
    if (self.lvl == 3)
    {
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"求解" style:UIBarButtonItemStyleBordered target:self action:@selector(findout:)];
        [arrayButtons addObject:item];
    }
    
    self.navigationItem.rightBarButtonItems = arrayButtons;
}
-(void)back:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
    if (self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}
-(void)takePicture:(UIBarButtonItem *)sender
{
    UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"选取图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"照相机", nil];
    
    [act showFromBarButtonItem:sender animated:YES];
}
-(void)findout:(UIBarButtonItem *)sender
{
    if (self.isResulting || !self.isStart)
    {
        return;
    }
    {
        self.isResulting = YES;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    
    // 获取现在排序
    for (NSInteger i = 0; i < self.array_ImageView.count; i++)
    {
        for (PuzzleImageView *pz in self.array_ImageView)
        {
            if (i == pz.nowIndex)
            {
                [array addObject:[NSString stringWithFormat:@"%i",pz.resultIndex]];
//                break;
            }
        }
    }
    // 得到结果路径
    self.array_Result = [NSMutableArray arrayWithArray:[OtherSolve solveFromArray:array]];
    
    // 开始执行路径
    [self alreadyFindResult];
}
-(void) alreadyFindResult
{
    if (self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
    else
    {
        
        self.nowStep = 0;
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(goToResult) userInfo:Nil repeats:YES];
    }
}
-(void)goToResult
{
    if (!self.isStart)
    {
        return;
    }
    
    // 数组越界检查
    if (self.nowStep > self.array_Result.count - 1)
    {
        for (PuzzleImageView *pz in self.array_ImageView)
        {
            if (pz.resultIndex != 0 && pz.nowIndex != pz.resultIndex)
            {
                [self exchangePuzzleFrameWithZero:[self.array_ImageView objectAtIndex:0] And:pz withAnimation:YES];
                return;
            }
        }
    }
    else
    {
        NSValue *value = [self.array_Result objectAtIndex:self.nowStep];
        self.nowStep ++;
        Node step ;
        [value getValue:&step];
        
        // 找到不同的一个
        for (int i = 0; i < ROW; i++)
        {
            for (int j = 0; j < COL; j++)
            {
                NSInteger index = i * ROW + j;
                
                for (PuzzleImageView *pz in self.array_ImageView)
                {
                    if (pz.nowIndex == index) {
                        NSInteger num = step.digit[i][j];
                        
                        if (num != 0 && num != pz.resultIndex)
                        {
                            [self exchangePuzzleFrameWithZero:[self.array_ImageView objectAtIndex:0] And:pz withAnimation:YES];
                            break;
                        }
                    }
                }
            }
        }
    }
}
// 初始化图片
-(void) initPuzzleImage
{
    [self resetPuzzleImageWithImage:[UIImage imageNamed:self.string_ImageName]];
}
// 重置图片
-(void) resetPuzzleImageWithImage:(UIImage *)image
{
    CGFloat scale = image.size.height / image.size.width;
    
    UIImage *resultImage = [self image:image ByScalingToSize:CGSizeMake(320, 320*scale)];
    self.isStart = NO;
    
    self.array_ImageView = [self separateImage:resultImage ByX:self.lvl andY:self.lvl];
    
    [self puzzleTheImage];
    
    if(self.view_PuzzleBoard)
    {
        [self.view_PuzzleBoard removeFromSuperview];
    }
    
    self.view_PuzzleBoard = [self createPuzzleBoardViewWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-64)];
    
    [self.view addSubview:self.view_PuzzleBoard];
}
-(void)delayImage
{
    
}
#pragma mark -
#pragma mark 生成拼图

- (UIImage *)image:(UIImage *)sourceImage ByScalingToSize:(CGSize)targetSize
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor < heightFactor) {
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    // this is actually the interesting part:
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    return newImage ;
}

// 分解图片
-(NSMutableArray *) separateImage:(UIImage *)image ByX:(int)x andY:(int)y
{
	// 数据监测
	if (x < 1 || y < 1 || ![image isKindOfClass:[UIImage class]])
    {
		return Nil;
	}
	
    CGFloat sWidth = self.view.frame.size.width;
    CGFloat sHeight = self.view.frame.size.height-64;
    CGFloat iWidth = image.size.width;
    CGFloat iHeight = image.size.height;
    // 图片大小适配
    if (iHeight > sHeight || iWidth > sWidth)
    {
        CGFloat scala = MIN(sHeight/iHeight, sWidth/iWidth);
        
        iWidth = iWidth * scala;
        iHeight = iHeight * scala;
    }
    
    NSMutableArray *array = [NSMutableArray array];
	//attributes of element
	float xStep = image.size.width * 1.0 / y;
	float yStep = image.size.height * 1.0 / x;
    
    float resultX = iWidth * 1.0 / y;
	float resultY = iHeight * 1.0 / x;
    
    float xShift = (sWidth - iWidth) / 2;
    float yShift = (sHeight - 70 - iHeight) / 2;
    
	//snap in context and create element image view
	for (int i = 0; i < x; i++)
	{
		for (int j = 0; j < y; j++)
		{
			CGRect rect = CGRectMake(xStep*j, yStep*i, xStep, yStep);
			CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage],rect);
			UIImage* elementImage = [UIImage imageWithCGImage:imageRef];
            
            // 空白位
            if (i == 0 && j == 0)
            {
                elementImage = nil;
            }
			PuzzleImageView *puzzleImageView=[[PuzzleImageView alloc] initWithImage:elementImage];
            puzzleImageView.resultIndex = i * x + j;
            puzzleImageView.nowIndex = i * x + j;
            puzzleImageView.delegate = self;
			puzzleImageView.frame = CGRectMake(xShift + resultX * j, 44 + yShift + resultY * i, resultX, resultY);
            [puzzleImageView showIndex];
            [array addObject:puzzleImageView];
		}
	}
    
    return array;
}

-(UIView *) createPuzzleBoardViewWithFrame:(CGRect)rect
{
    UIView *view = [[UIView alloc]initWithFrame:rect];
    view.backgroundColor = [UIColor grayColor];
    
    for (PuzzleImageView *pzView in self.array_ImageView)
    {
        [view addSubview: pzView];
    }
    return view;
}

// 打乱顺序
-(void)puzzleTheImage
{
    // 保持0位不动,否则奇偶性检查无效
    NSInteger aIndex = arc4random()%(self.array_ImageView.count - 1) + 1;
    PuzzleImageView *aView = [self.array_ImageView objectAtIndex:aIndex];
    
    NSInteger bIndex = arc4random()%(self.array_ImageView.count - 1) + 1;
    PuzzleImageView *bView = [self.array_ImageView objectAtIndex:bIndex];
    
    [self exchangePuzzleFrameWithZero:aView And:bView withAnimation:NO];
    
    // 检查打乱是否完成,否则递归
    if (![self makePuzzleCanBeSolved] || ![self makePuzzleFinished])
    {
        [self puzzleTheImage];
    }
    else
    {
        // 游戏正式开始
        self.isStart = YES;
    }
}
// 检查无解
-(BOOL) makePuzzleCanBeSolved
{
    // 奇偶性总值
    NSInteger sum = 0;
    
    // 循环遍历
    for (NSInteger i = 0; i < self.array_ImageView.count; i++)
    {
        PuzzleImageView *aView = [self.array_ImageView objectAtIndex:i];
        
        for (NSInteger j = i + 1; j < self.array_ImageView.count; j++)
        {
            PuzzleImageView *bView = [self.array_ImageView objectAtIndex:j];
            
            // 逆序数检查
            if (aView.nowIndex > bView.nowIndex)
            {
                sum ++;
            }
        }
    }
    
    // 根据逆序数奇偶性判断是否有解
    if ((sum % 2) == 0)
    {
        return YES;
    }
    else
    {
        printf("无解\n");
        return NO;
    }
}
// 全部无序
-(BOOL) makePuzzleFinished
{
    BOOL flag = YES;
    for (PuzzleImageView *pzView in self.array_ImageView)
    {
        if (pzView.resultIndex != 0 && pzView.resultIndex == pzView.nowIndex)
        {
            printf("未全打乱\n");
            flag = NO;
            break;
        }
    }
    return flag;
}
#pragma mark -
#pragma mark 拼图移动委托

-(void) puzzleImageViewShouldMove:(PuzzleImageView *)imageview
{
    PuzzleImageView *zeroPZ = [self.array_ImageView objectAtIndex:0];
    
    // 是否允许移动
    if ([imageview canMoveToPoint:zeroPZ.frame.origin]) {
        [self exchangePuzzleFrameWithZero:zeroPZ And:imageview withAnimation:YES];
    }
}

#pragma mark -
#pragma mark 选图片委托

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            // 相册
            [self takeImageFromLibrary];
            break;
        }
        case 1:
        {
            // 相机
            [self takeImageFromCamera];
            break;
        }
        case 2:
        {
            // 取消
            break;
        }
        default:
            break;
    }
}
// 相册选取
-(void) takeImageFromLibrary
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *imagePicker=[[UIImagePickerController alloc]init];
        imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate=self;
        
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    }
}
// 相册选取
-(void) takeImageFromCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *cameraPicker=[[UIImagePickerController alloc]init];
        cameraPicker.sourceType=UIImagePickerControllerSourceTypeCamera;
        cameraPicker.delegate=self;
        
        [self presentViewController:cameraPicker animated:YES completion:nil];
        
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    if (image)
    {
        NSData* imageData = UIImageJPEGRepresentation(image, 0.2);
        
        self.string_ImageName = @"cacheImage";
        
        NSString *file = [[self savedPath]stringByAppendingPathComponent:self.string_ImageName];
        
        if ([imageData writeToFile:file atomically:YES])
        {
            NSData *data = [NSData dataWithContentsOfFile:[[self savedPath]stringByAppendingPathComponent:self.string_ImageName]];
            UIImage *gameImage = [UIImage imageWithData:data];
            
            [self resetPuzzleImageWithImage:gameImage];
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(NSString *)savedPath
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *file = [path stringByAppendingPathComponent:@"imageCache"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:file isDirectory:nil]) {
		[fileManager createDirectoryAtPath:file withIntermediateDirectories:NO attributes:nil error:nil];
	}
    return file;
}
#pragma mark -
#pragma mark 交换2个视图位置

// 交换视图
-(void)exchangePuzzleFrameWithZero:(PuzzleImageView *)zeroView And:(PuzzleImageView *)bView withAnimation:(BOOL)animation
{
    CGRect aRect = zeroView.frame;
    NSInteger aIndex = zeroView.nowIndex;
    
    [zeroView setFrame:bView.frame];
    [zeroView setNowIndex:bView.nowIndex];
    
    [bView setNowIndex:aIndex];
    if (animation) {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [bView setFrame:aRect];
        } completion:Nil];
    }else
    {
        [bView setFrame:aRect];
    }
    
    if (self.isStart && [self gameComplete])
    {
        self.isStart = NO;
        
        if (self.timer)
        {
            [self.timer invalidate];
            self.timer = nil;
        }
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"恭喜" message:@"游戏完成!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:Nil, nil];
        [alert show];
    }
}
// 完成退出
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}
// 判断游戏完成
-(BOOL) gameComplete
{
    BOOL flag = YES;
    for (PuzzleImageView *pzView in self.array_ImageView)
    {
        if (pzView.resultIndex != pzView.nowIndex)
        {
            flag = NO;
            break;
        }
    }
    return flag;
}
@end
