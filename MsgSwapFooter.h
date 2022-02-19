#import "General.h"

// https://stackoverflow.com/a/5337804
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface MsgSwapFooter : CKBrowserSwitcherFooterView
@property (nonatomic,retain) UICollectionView * collectionView;
@property (nonatomic,retain) CKBrowserPluginCell * cell;
@property (nonatomic,retain) CKEntryViewButton * cameraButton;
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
-(CKBrowserPluginCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
-(void)deselectCell;
-(void)clickCameraButton:(UILongPressGestureRecognizer*)gesture;
@end

@interface CKMessageEntryView (MsgSwap)
@property (nonatomic, retain) MsgSwapFooter *footer; // MsgSwapFooter
-(void)messageEntryContentViewWasTapped:(id)arg1 isLongPress:(BOOL)arg2 ;
-(void)unleashTheRabbit;
-(void)recollectTheRabbit;
-(void)secondTap;
@end
