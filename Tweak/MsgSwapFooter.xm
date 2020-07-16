
#import "MsgSwapFooter.h"

@implementation MsgSwapFooter

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (CKBrowserPluginCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{    
    [collectionView registerClass:%c(CKBrowserPluginCell) forCellWithReuseIdentifier:@"photosCell"];
    CKBrowserPluginCell *cell = (CKBrowserPluginCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"photosCell" forIndexPath:indexPath];
    self.cell = cell;
    [cell setPlugin:((CKBalloonPluginManager*)[%c(CKBalloonPluginManager) sharedInstance]).visibleDrawerPlugins[0]]; 
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(52, 38);
}

//sets what happens during long press 
-(void)clickCameraButton:(UILongPressGestureRecognizer*)gesture {
	if(kCFCoreFoundationVersionNumber < 1600) { //Check if device is running a version below iOS 13 since ckentryviewbutton is different 
        if (gesture.state == UIGestureRecognizerStateBegan) {
            [self.cameraButton sendActionsForControlEvents:UIControlEventTouchUpInside]; 
        }
    }
    else{
        if (gesture.state == UIGestureRecognizerStateBegan) {
            [self.cameraButton.button sendActionsForControlEvents:UIControlEventTouchUpInside]; 
        }
    }
}

@end
