#import "MsgSwapFooter.h"

@implementation MsgSwapFooter

// tells collectionview we only want 1 cell (for some reason returning 1 makes 2 cells, but returning 2 makes 1??)
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(52, 38);
}

// the cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (CKBrowserPluginCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{    
    [collectionView registerClass:%c(CKBrowserPluginCell) forCellWithReuseIdentifier:@"photosCell"];
    CKBrowserPluginCell *cell = (CKBrowserPluginCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"photosCell" forIndexPath:indexPath];

	// check if device is running a version below iOS 13 since other method (_updateTraitsIfNecessary) doesn't set plugin image for those versions  
	if(!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"13")) { 
	  [cell setPlugin:((CKBalloonPluginManager*)[%c(CKBalloonPluginManager) sharedInstance]).visibleDrawerPlugins[0]]; 
	}

	self.cell = cell;
    return cell;
}

-(void)didMoveToWindow{
	if(!self.collectionView){
		// collectionview setup
		UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(3,3.5,58,38.5) collectionViewLayout:layout];
		[self.collectionView setBackgroundColor:nil];
		[self.collectionView setDataSource:self];
		[self.collectionView setDelegate:self];
		[self.collectionView setScrollEnabled:NO];
		[self addSubview:self.collectionView];

		// footer setup
        [self setClipsToBounds:YES];
		[self setHideShinyStatus:YES];
		[self setShowBorders:YES];
		[self setMinifiesOnSelection:YES];
		[self setSnapshotVerticalOffset:-0.5];
	}
}

// respond to longpress 
-(void)clickCameraButton:(UILongPressGestureRecognizer*)gesture {
	//Check if device is running a version below iOS 13 since ckentryviewbutton is different 
	if(!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"13")) { 
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
