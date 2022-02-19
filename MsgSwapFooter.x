//
//	MsgSwapFooter.x
//	MsgSwap
//
//	Created by Lightmann during COVID-19
//

#import "MsgSwapFooter.h"

@implementation MsgSwapFooter

- (instancetype)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];

	if(self){
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
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deselectCell) name:@"deselect" object:nil];
	}

	return self;
}

// tells collectionview we only want 1 cell (for some reason returning 1 makes 2 cells, but returning 2 makes 1??)
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
	return 2;
}

// size of cell
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
	return CGSizeMake(52, 38);
}

// the cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (CKBrowserPluginCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
	[collectionView registerClass:%c(CKBrowserPluginCell) forCellWithReuseIdentifier:@"photosCell"];

	CKBrowserPluginCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photosCell" forIndexPath:indexPath];

	// set plugin (doesn't have a link to the browser img, so we'll have to find and set it manually . . .)
	NSDictionary *plugins = ((IMBalloonPluginManager *)[%c(IMBalloonPluginManager) sharedInstance]).pluginsMap;
	[cell setPlugin:[plugins objectForKey:@"com.apple.messages.MSMessageExtensionBalloonPlugin"]];

	// get possible cell icons
	NSString *path = @"/Applications/MobileSlideShow.app/PlugIns/PhotosMessagesApp.appex/";
	NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
	NSMutableArray *icons = [NSMutableArray new];
	[contents enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		NSString *filename = (NSString *)obj;
		NSString *extension = [[filename pathExtension] lowercaseString];
		if([extension isEqualToString:@"png"]){
			[icons addObject:[path stringByAppendingPathComponent:filename]];
		}
	}];

	// set highest quality cell icon as the browser img
	if(icons.count){
		UIImageView *browserImg = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:icons.lastObject]];
		[browserImg setImage:[UIImage imageWithContentsOfFile:icons.lastObject]];
		[browserImg.layer setMasksToBounds:YES];
		[browserImg.layer setCornerRadius:15];
		if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"13")){
			[browserImg.layer setBorderColor:[UIColor systemGray4Color].CGColor];
		}
		else{
			[browserImg.layer setBorderColor:[UIColor colorWithRed:0.227 green:0.227 blue:0.235 alpha:1.0].CGColor];
		}
		[browserImg.layer setBorderWidth:0.35];
		[cell addSubview:browserImg];
		[cell setBrowserImage:browserImg];
	}

	self.cell = cell;
	return cell;
}

// allows double tapping cell to close the photos plugin
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   if([collectionView.indexPathsForSelectedItems containsObject:indexPath]) {
		[collectionView deselectItemAtIndexPath:indexPath animated:NO]; // deselect cell
		[[CKBalloonPluginManager sharedInstance] prepareForSuspend]; // tell plugin manager to kill the plugin
		[[NSNotificationCenter defaultCenter] postNotificationName:@"secondTap" object:nil];
		return NO;
	}

	return YES;
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
