//Lightmann
//Made during COVID-19
//MsgSwap

#import "Headers.h"
#import "MsgSwapController.h"

BOOL collectionViewMade = NO;


//initalize my controller
%hook SpringBoard
- (void)applicationDidFinishLaunching:(UIApplication *)application {
    %orig;
	[MsgSwapController sharedInstance]; 
}
%end


//initalize plugin manager
%hook CKBalloonPluginManager
+ (instancetype)sharedInstance
{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        _sharedInstance = [[self alloc] init];
    });

    return _sharedInstance;
}
%end


//where the magic happens
%hook MsgSwapFooter
-(void)didMoveToWindow{
	%orig;

	if(!collectionViewMade){
		//make collectionview
		UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
		UICollectionView *_collectionView =[[UICollectionView alloc] initWithFrame:CGRectMake(3,3.5,58,38.5) collectionViewLayout:layout];
		_collectionView.backgroundColor = nil;
		[_collectionView setDataSource:self];
		[_collectionView setDelegate:self];
		self.collectionView = _collectionView;
		[_collectionView registerClass:%c(CKBrowserPluginCell) forCellWithReuseIdentifier:@"cellIdentifier"];
		_collectionView.scrollEnabled = NO;
		[self addSubview:_collectionView];
		collectionViewMade = YES;

		//footer setup
		MSHookIvar<UICollectionView *>(self, "_collectionView") = _collectionView;
		MSHookIvar<UIView *>(self, "_visibleView") = _collectionView;
		self.clipsToBounds = YES;
		self.hideShinyStatus = YES;
		self.showBorders = YES;
		self.toggleBordersOnInterfaceStyle = YES;
		self.minifiesOnSelection = YES;
		self.snapshotVerticalOffset = -0.5;
		
		UILongPressGestureRecognizer *newLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(appsLongPressed:)];
		UILongPressGestureRecognizer *newTouchTracker = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(touchTrackerTrackedTouches:)];
		[newLongPress setView:_collectionView];
		newLongPress.delegate = self;
		[newTouchTracker setView:_collectionView];
		newTouchTracker.delegate = self;
		MSHookIvar<UILongPressGestureRecognizer *>(self, "_longPressRecognizer") = newLongPress;
		MSHookIvar<UILongPressGestureRecognizer *>(self, "_touchTracker") = newTouchTracker;
	}
}
%end


%hook CKMessageEntryView
-(void)setPhotoButton:(CKEntryViewButton *)arg1 {
	%orig;

	//hide camera button since that's what's being replaced
	[arg1 setHidden:YES];
}

-(void)didMoveToWindow{
	%orig;

	MsgSwapFooter *footer = [((MsgSwapController*)[%c(MsgSwapController) sharedInstance]) footer];

	//Additional footer setup
	footer.appStripLayout = self.appStrip.appStripLayout;
	footer.delegate = self;
	footer.dataSource = self.appStrip.dataSource;
	footer.cameraButton = self.photoButton;//for easier access w gesture below V

	//adds longpress gesture to activate cameraButton (that was replaced w photos cell)
	UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:footer action:@selector(clickCameraButton:)];
	longPress.minimumPressDuration = 0.35f;
	[footer addGestureRecognizer:longPress];

	//Delays method below so visibleDrawerPlugins has time to populate fully
	[self performSelector:@selector(populateArrays) withObject:nil afterDelay:0.2];
}

//hides my cell when caret ">" is visible
-(void)updateTextViewsForShouldHideCaret:(BOOL)arg1 {
	%orig;

	if(self.arrowButton.alpha == 1){
		[((MsgSwapController*)[%c(MsgSwapController) sharedInstance]) footer].hidden = YES;
	}
	if(self.arrowButton.alpha == 0){
		[((MsgSwapController*)[%c(MsgSwapController) sharedInstance]) footer].hidden = NO;
	}
}

%new
-(void)populateArrays{	
	//add footer (containing collectionview and cell )to entry view
	[self.inputButtonContainerView addSubview:[((MsgSwapController*)[%c(MsgSwapController) sharedInstance]) footer]];
}
%end


//prevents cell from moving up when entry view expands/shrinks (after newline creation/deletion)
%hook CKMessageEntryContentView
-(void)layoutSubviews{
	%orig;
	
	CGRect frame = [((MsgSwapController*)[%c(MsgSwapController) sharedInstance]) footer].frame;
	[((MsgSwapController*)[%c(MsgSwapController) sharedInstance]) footer].frame = CGRectMake(frame.origin.x, (self.frame.size.height-35), frame.size.width, frame.size.height);
}
%end


//janky fix for selectionOutline bug on my cell (selectionOutline isn't hidden because BOOL selected doesn't change to NO automatically after de-selection)
%hook CKBrowserPluginCell
-(void)setSelected:(BOOL)arg1 {
	%orig;

	if([self.superview.superview isMemberOfClass:%c(MsgSwapFooter)]){
		if(self.selected == YES){
			[MSHookIvar<UIImageView *>(self, "_selectionOutline") setHidden:NO];

			double delayInSeconds = 2.0;
			dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
			dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
				[self setSelected:NO];
			});
		}

		if(self.selected == NO){
			[MSHookIvar<UIImageView *>(self, "_selectionOutline") setHidden:YES];
		}
	}
}
%end
