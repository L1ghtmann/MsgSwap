#import "Headers.h"

@interface MsgSwapFooter : CKBrowserSwitcherFooterView <UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate>
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
-(CKBrowserPluginCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
-(void)clickCameraButton:(UILongPressGestureRecognizer*)gesture; //custom method to run cameraButton code when my cell is longpressed 
@property (nonatomic,retain) UICollectionView * collectionView; 
@property (nonatomic,retain) CKEntryViewButton * cameraButton; 
@property (nonatomic,retain) CKBrowserPluginCell * cell; 
@end
