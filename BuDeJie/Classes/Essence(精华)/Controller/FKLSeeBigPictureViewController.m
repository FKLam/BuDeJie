//
//  FKLSeeBigPictureViewController.m
//  BuDeJie
//
//  Created by kun on 16/8/27.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLSeeBigPictureViewController.h"
#import "FKLTopic.h"
#import <UIImageView+WebCache.h>
#import <SVProgressHUD.h>
#import <Photos/Photos.h>

@interface FKLSeeBigPictureViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation FKLSeeBigPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // scrollView
    [self.view insertSubview:self.scrollView atIndex:0];
    // imageView
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.image1] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if ( !image ) return;
        self.saveButton.enabled = YES;
    }];
    imageView.fkl_width = self.scrollView.fkl_width;
    imageView.fkl_height = imageView.fkl_width * self.topic.height / self.topic.width;
    imageView.fkl_x = 0;
    if ( imageView.fkl_height >= FKLScreenH )
    {
        imageView.fkl_y = 0;
        [self.scrollView setContentSize:CGSizeMake(0, imageView.fkl_height)];
    }
    else
    {
        imageView.fkl_centerY = self.scrollView.fkl_height * 0.5;
    }
    [self.scrollView addSubview:imageView];
    self.imageView = imageView;
    
    // 处理图片缩放
    CGFloat maxScale = self.topic.width / imageView.fkl_width;
    if ( maxScale > 1 )
    {
        self.scrollView.maximumZoomScale = maxScale;
        self.scrollView.delegate = self;
    }
}
- (IBAction)backButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)saveButtonClick:(id)sender {
    // 保存图片到［相机胶卷］
    // 又有一个［自定义相册］
    // 添加刚才保存的图片到［自定义相册］
//    [self saveImageToPhotoAlbum];
    
    // 请求\检查访问权限
    /**  
     PHAuthorizationStatusNotDetermined = 0,
     PHAuthorizationStatusRestricted,
     PHAuthorizationStatusDenied,
     PHAuthorizationStatusAuthorized
     */
    PHAuthorizationStatus oldStatus = [PHPhotoLibrary authorizationStatus];
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
           if ( PHAuthorizationStatusDenied == status && 
               oldStatus != PHAuthorizationStatusDenied ) // 用户拒绝当前App访问相册
           {
               FKLLog(@"提醒用户打开应用授权");
           }
            else if ( PHAuthorizationStatusAuthorized == status ) // 用户允许当前App访问相册
            {
                [self saveImageWithPHSasset];
            }
            else if ( PHAuthorizationStatusRestricted == status ) // 无法访问相册
            {
                [SVProgressHUD showErrorWithStatus:@"因系统原因，无法访问相册"];
            }
        });
    }];
}
// Photos框架
/*
 1，PHAsset：一个PHAsset对象就代表相册中的一张图片或者一个视频
    1>查：[PHAsset fetchAssets...]
    2>增删改：PHAssetChangeRequest(包括所有跟图片\视频相关的改动操作)
 2，PHAssetCollection：一个PHAssetCollection对象就代表一个相册
     1>查：[PHAssetCollection fetchAssetCollection...]
     2>增删改：PHAssetCollectionChangeRequest(包括所有跟图片\视频相关的改动操作)
 3，对相册\相片的任何修改［增删改］操作，都必须放到以下方法的block中执行
    -[PHPhotoLibrary performChanges:]
    -[PHPhotoLibrary performChangesAndWait:] block.
 */
- (void)saveImageWithPHSasset
{
    PHFetchResult<PHAsset *> *creactedAssets = [self createAssets];
    if ( nil == creactedAssets )
    {
        [SVProgressHUD showErrorWithStatus:@"保存失败！"];
        return;
    }
    PHAssetCollection *createdCollection = [self createdCollection];
    if ( nil == createdCollection )
    {
        [SVProgressHUD showErrorWithStatus:@"创建或者获取相册失败！"];
        return;
    }
    // 添加刚才保存的图片到［自定义相册］
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdCollection];
        [request insertAssets:creactedAssets atIndexes:[NSIndexSet indexSetWithIndex:0]];
    } error:&error];
    if ( error )
    {
        [SVProgressHUD showErrorWithStatus:@"保存失败！"];
    }
    else
    {
        [SVProgressHUD showSuccessWithStatus:@"保存成功！"];
    }
}
#pragma mark - 获得当前App对应的自定义相册
- (PHAssetCollection *)createdCollection
{
    // 获得软件名字
    NSString *title = [NSBundle mainBundle].infoDictionary[(__bridge NSString *)kCFBundleNameKey];
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // 查找当前App对应的自定义相册
    for ( PHAssetCollection *collection in collections )
    {
        if ( [collection.localizedTitle isEqualToString:title] )
        {
            return collection;
            break;
        }
    }
    // 若从未创建过对应的相册
    NSError *error = nil;
    __block NSString *ID = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        // 创建一个［自定义相册］
        ID = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    if ( error )
    {
        [SVProgressHUD showErrorWithStatus:@"创建相册失败"];
        return nil;
    }
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[ID] options:nil].firstObject;
}
- (PHFetchResult<PHAsset *> *)createAssets
{
    // 同步执行修改
    NSError *error = nil;
    __block NSString *assetID = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        assetID = [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageView.image].placeholderForCreatedAsset.localIdentifier;
    } error:&error];
    if ( error )
    {
        return nil;
    }
    // 获取刚才保存的相片
    return [PHAsset fetchAssetsWithLocalIdentifiers:@[assetID] options:nil];
}
// 用C语言方法保存图片到相机胶卷
- (void)saveImageToPhotoAlbum
{
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if ( error )
    {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    }
    else
    {
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }
}
- (void)back
{
    [self backButtonClick:nil];
}
#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}
#pragma mark - getter methods
- (UIScrollView *)scrollView
{
    if ( nil == _scrollView )
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)]];
    }
    return _scrollView;
}
@end
