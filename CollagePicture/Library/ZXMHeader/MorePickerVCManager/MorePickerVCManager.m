//
//  MorePickerVCManager.m
//  Baby
//
//  Created by simon on 16/4/19.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "MorePickerVCManager.h"
#import "OrientationNaController.h"
#include <MobileCoreServices/UTCoreTypes.h>


static char pickerControllerActionKey;

@implementation MorePickerVCManager

- (void)zxPresentActionSheetToMoreUIImagePickerControllerFromSourceController:(UIViewController *)sourceController
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"选择", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"拍照", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (![self isFrontCameraAvailable] && ![self isRearCameraAvailable])
            {
                NSLog(@"前置后置摄像头都不能用");
                return;
            }
            [self presentMoreImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera sourceController:sourceController];
        }];
        [alertController addAction:cameraAction];
    }
    else
    {
        alertController.title = nil;
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];

    
    UIAlertAction *doAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"从相册选择", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
          [self presentMoreImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum sourceController:sourceController];
    }];
    [alertController addAction:doAction];
    
    [sourceController presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - actionsheet delegate


- (void)presentMoreImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType sourceController:(UIViewController *)sourceController
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    //跳转到相机或相册页面
    imagePicker.sourceType = sourceType;
    //如果是camera,不需要allowsEditing
    if (sourceType ==UIImagePickerControllerSourceTypeCamera)
    {
        imagePicker.allowsEditing = NO;
    }
    else
    {
        imagePicker.allowsEditing = YES;
        if (self.morePickerAlbumType ==PhotosAlbumListType_custom)
        {
//        [self pushToImagePickerToController:sourceController];
          return;
        }
    }
    [sourceController presentViewController:imagePicker animated:YES completion:^{}];

}

/*
- (void)pushToImagePickerToController:(UIViewController*)vc
{
    ImagePickerViewController *pickerVC =[[ImagePickerViewController alloc] init];
    OrientationNaController *navi =[[OrientationNaController alloc] initWithRootViewController:pickerVC];
    pickerVC.minNumberOfSelection =self.minNumberOfSelection;
    pickerVC.maxNumberOfSelection =self.maxNumberOfSelection;
    pickerVC.isNeedUpdate = self.isNeedUpdate;
    pickerVC.group =nil;
    pickerVC.delegate =self;
    pickerVC.displayCutBtn =self.displayCutBtn;
  
    [vc presentViewController:navi animated:YES completion:nil];
}
*/

// 前面的摄像头是否可用
- (BOOL) isFrontCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

// 后面的摄像头是否可用
- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

#pragma mark-imagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // 如果想之后立刻调用UIVideoEditor,animated不能是YES。最好的还是dismiss结束后在调用editor。
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *type =[info objectForKey:UIImagePickerControllerMediaType ];
    //如果返回回来的是照片
    if ([type isEqualToString:(NSString *)kUTTypeImage])
    {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        //如果是camera的照片,save original photos到photosAlbum
        if (picker.sourceType ==UIImagePickerControllerSourceTypeCamera)
        {
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
        else
        {
            if (picker.allowsEditing)
            {
                image = [info objectForKey:UIImagePickerControllerEditedImage];
            }
        }
        
        if ([self.morePickerActionDelegate respondsToSelector:@selector(zxImagePickerController:didFinishPickingMediaWithInfo:withEditedImage:)])
        {
            [self.morePickerActionDelegate zxImagePickerController:picker didFinishPickingMediaWithInfo:info withEditedImage:image];
        }
    }
//    //保存视频,这里不对，如果已经有视频了，就不能再保存了
//    if ([type isEqualToString:(NSString *)kUTTypeMovie])
//    {
//        NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
//        NSString *path =url.path;
//        UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
//    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/*
//多选相册回调代理－有uploadId的时候
- (void)imagePickerController:(ImagePickerViewController *)imagePicker didSelectAssets:(NSArray *)assets isOriginal:(BOOL)original requestData:(id)data
{
    
    if ([self.morePickerActionDelegate respondsToSelector:@selector(zxImagePickerController:didSelectAssets:isOriginal:requestData:)])
    {
        [self.morePickerActionDelegate zxImagePickerController:imagePicker didSelectAssets:assets isOriginal:original requestData:data];
    }

}

//多选相册回调代理
- (void)imagePickerController:(ImagePickerViewController *)imagePicker didSelectAssets:(NSArray *)assets isOriginal:(BOOL)original
{
    if ([self.morePickerActionDelegate respondsToSelector:@selector(zxImagePickerController:didSelectAssets:isOriginal:)])
    {
        [self.morePickerActionDelegate zxImagePickerController:imagePicker didSelectAssets:assets isOriginal:original];
    }
//    NSLog(@"%@ ---%d",assets,original);
}

*/

- (void)setMorePickerActionDelegate:(id<UIImagePickerControllerDelegate>)morePickerActionDelegate
{
    [self willChangeValueForKey:@"key"];
    objc_setAssociatedObject(self, &pickerControllerActionKey, morePickerActionDelegate, OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"key"];
}



- (id<UIImagePickerControllerDelegate>)morePickerActionDelegate
{
    return objc_getAssociatedObject(self, &pickerControllerActionKey);
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(id)info
{
    NSLog(@"D＝%@,%@",[NSThread currentThread], [NSThread currentThread].name);
    
    if(error)
    {
        NSLog(@"savefailed:%@",error.localizedDescription);
    }
    else
    {
        NSLog(@"savesuccess");
    }
}


- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(error)
    {
        NSLog(@"savefailed:%@",error.localizedDescription);
    }
    else
    {
        NSLog(@"savesuccess");
    }
    NSLog(@"%@",videoPath);
}
@end