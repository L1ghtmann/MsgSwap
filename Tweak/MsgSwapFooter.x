#import "MsgSwapFooter.h"

@implementation MsgSwapFooter

- (void)didMoveToWindow{
	if(!self.collectionView){
		// collectionview setup
		UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
		self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(3,3.5,58,38.5) collectionViewLayout:layout];
		[self.collectionView setBackgroundColor:nil];
		[self.collectionView setDataSource:self];
		[self.collectionView setDelegate:self];
		[self.collectionView setScrollEnabled:NO];
		[self addSubview:self.collectionView];

		// more footer setup
		[self setClipsToBounds:YES];
		[self setHideShinyStatus:YES];
		[self setShowBorders:YES];
		[self setMinifiesOnSelection:YES];
		[self setSnapshotVerticalOffset:-0.5];
			
		// add longpress gesture to activate cameraButton (that we replaced w photos cell)
		UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(clickCameraButton:)];
		longPress.minimumPressDuration = 0.35f;
		[self addGestureRecognizer:longPress];

		// add observer for plugin manager's plugin deactivation notification
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deselectCell) name:@"MsgSwapCell_Deselect" object:nil];
	}
}

// tells collectionview we only want 1 cell (for some reason returning 1 makes 2 cells, but returning 2 makes 1??)
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}

// size of cell
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(52, 38);
}

// allows double tapping cell to close the photos plugin
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   if([collectionView.indexPathsForSelectedItems containsObject:indexPath]) {
        [collectionView deselectItemAtIndexPath:indexPath animated:NO]; // deselect cell
		[[CKBalloonPluginManager sharedInstance] prepareForSuspend]; // tell plugin manager to kill plugin
		[[NSNotificationCenter defaultCenter] postNotificationName:@"MsgSwapCell_SecondTap" object:nil]; // post notification that all is ready	 
        return NO;
    }

    return YES;
}

// the cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (CKBrowserPluginCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{    
    [collectionView registerClass:%c(CKBrowserPluginCell) forCellWithReuseIdentifier:@"photosCell"];
   
    CKBrowserPluginCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photosCell" forIndexPath:indexPath];

	// ensure that the plugin manager's array has time to populate 
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.001 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		[cell setPlugin:[CKBalloonPluginManager sharedInstance].visibleDrawerPlugins[0]]; 
	});

	self.cell = cell;
    return cell;
}

// deselect cell on notification from plugin manager that the cell was deactivated 
- (void)deselectCell{
	for(NSIndexPath *indexPath in [self.collectionView indexPathsForSelectedItems]) {
		[self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
	}
}

// respond to longpress 
- (void)clickCameraButton:(UILongPressGestureRecognizer*)gesture {
	// check if device is running a version below iOS 13 since ckentryviewbutton is different 
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
