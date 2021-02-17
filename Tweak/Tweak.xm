#import "MsgSwapController.h"

// Lightmann
// Made during COVID-19
// MsgSwap

// set cell plugin  
%hook CKTranscriptCollectionViewController
-(void)_updateTraitsIfNecessary{
	%orig;

	[[[%c(MsgSwapController) sharedInstance] footer].cell setPlugin:((CKBalloonPluginManager*)[%c(CKBalloonPluginManager) sharedInstance]).visibleDrawerPlugins[0]];
}
%end


%hook CKMessageEntryView
// hide camera button since that's what's being replaced
-(void)setPhotoButton:(CKEntryViewButton *)arg1 {
	%orig;

	[arg1 setHidden:YES];
}

// additional footer setup
-(void)setFrame:(CGRect)frame{
	%orig;

	MsgSwapFooter *footer = [[%c(MsgSwapController) sharedInstance] footer];
	[footer setAppStripLayout:self.appStrip.appStripLayout];
	[footer setDelegate:self];
	[footer setDataSource:self.appStrip.dataSource];
	footer.cameraButton = self.photoButton; //for easier access w gesture below 

	// add longpress gesture to activate cameraButton (that we replaced w photos cell)
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:footer action:@selector(clickCameraButton:)];
	longPress.minimumPressDuration = 0.35f;
	[footer addGestureRecognizer:longPress];

	[self.inputButtonContainerView addSubview:[[%c(MsgSwapController) sharedInstance] footer]];
}

// hides photos cell when caret ">" is visible
-(void)updateTextViewsForShouldHideCaret:(BOOL)arg1 {
	%orig;

	MsgSwapFooter* footer = [[%c(MsgSwapController) sharedInstance] footer];

	if(self.arrowButton.alpha == 1){
		[footer setHidden:YES];
	}
	else if(self.arrowButton.alpha == 0){
		[footer setHidden:NO];	
	}
}

// remove stock photo cell from appbar
-(void)updateAppStripFrame{
	%orig;

	for(UIView *view in [self.appStrip collectionView].subviews){
		if([view isMemberOfClass:%c(CKBrowserPluginCell)]){
			CKBrowserPluginCell *cell = (CKBrowserPluginCell*)view;
			if([cell.plugin respondsToSelector:@selector(containingBundleIdentifier)]){
				IMBalloonAppExtension *plugin = (IMBalloonAppExtension*)cell.plugin; 
				if([[plugin containingBundleIdentifier] isEqualToString:@"com.apple.mobileslideshow"]){
					[cell removeFromSuperview];
				}
			}
		}
	}
}
%end


// adjust appbar collectionview frame for now-removed cell ^
%hook CKBrowserSwitcherFooterView
-(void)layoutSubviews{
	%orig;

	if([self.superview isMemberOfClass:%c(CKMessageEntryView)]){
		CGRect frame = [self collectionView].frame;
		[[self collectionView] setFrame:CGRectMake(frame.origin.x-54, frame.origin.y, frame.size.width+54, frame.size.height)];
	}
}
%end


// prevent photos cell from moving up when entryview expands/shrinks (after a newline is created/deleted)
%hook CKMessageEntryContentView
-(void)layoutSubviews{
	%orig;

	MsgSwapFooter* footer = [[%c(MsgSwapController) sharedInstance] footer];
	[footer setFrame:CGRectMake(footer.frame.origin.x, (self.frame.size.height-35), footer.frame.size.width, footer.frame.size.height)];
}
%end
