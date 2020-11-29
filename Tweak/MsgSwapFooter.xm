#import "MsgSwapFooter.h"

@implementation MsgSwapFooter

//Tells collectionview we only want 1 cell (for some reason returning 1 makes 2 cells, but returning 2 makes 1??)
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(52, 38);
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (CKBrowserPluginCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{    
    [collectionView registerClass:%c(CKBrowserPluginCell) forCellWithReuseIdentifier:@"photosCell"];
    CKBrowserPluginCell *cell = (CKBrowserPluginCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"photosCell" forIndexPath:indexPath];

	//Check if device is running a version below iOS 13 since other method (_updateTraitsIfNecessary) doesn't set plugin image for those versions  
	if(kCFCoreFoundationVersionNumber < 1600) { 
	  [cell setPlugin:((CKBalloonPluginManager*)[%c(CKBalloonPluginManager) sharedInstance]).visibleDrawerPlugins[0]]; 
	}

	self.cell = cell;
    return cell;
}

-(void)didMoveToWindow{
	if(!self.collectionView){
		//make collectionview
		UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(3,3.5,58,38.5) collectionViewLayout:layout];
		self.collectionView.backgroundColor = nil;
		[self.collectionView setDataSource:self];
		[self.collectionView setDelegate:self];
		self.collectionView.scrollEnabled = NO;
		[self addSubview:self.collectionView];

		//footer setup
		MSHookIvar<UICollectionView *>(self, "_collectionView") = self.collectionView;
		MSHookIvar<UIView *>(self, "_visibleView") = self.collectionView;
        self.clipsToBounds = YES;
		self.hideShinyStatus = YES;
		self.showBorders = YES;
		self.minifiesOnSelection = YES;
		self.snapshotVerticalOffset = -0.5;

		UILongPressGestureRecognizer *newLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(appsLongPressed:)];
		UILongPressGestureRecognizer *newTouchTracker = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(touchTrackerTrackedTouches:)];
		[newLongPress setView:self.collectionView];
		newLongPress.delegate = self;
		[newTouchTracker setView:self.collectionView];
		newTouchTracker.delegate = self;
		MSHookIvar<UILongPressGestureRecognizer *>(self, "_longPressRecognizer") = newLongPress;
		MSHookIvar<UILongPressGestureRecognizer *>(self, "_touchTracker") = newTouchTracker;
	}
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
