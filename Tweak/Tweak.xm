#import "MsgSwapFooter.h"

// Lightmann
// Made during COVID-19
// MsgSwap

%hook CKMessageEntryView
%property (nonatomic, retain) MsgSwapFooter *footer;
// initial footer setup
-(void)setInputButtonContainerView:(UIView *)inputButtonContainerView {
	%orig;

	self.footer = [[MsgSwapFooter alloc] initWithFrame:CGRectMake(0,0,64.5,39.5)];
	[self.footer setDelegate:self];
	[self.footer setDataSource:self.appStrip.dataSource];
	[inputButtonContainerView addSubview:self.footer];

	// add observer for notification from MsgSwapFooter that the cell was tapped a second time
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(secondTap) name:@"MsgSwapCell_SecondTap" object:nil];
}

// grab a reference to the photoButton then hide it 
-(void)setPhotoButton:(CKEntryViewButton *)photoButton {
	%orig;

	[self.footer setCameraButton:photoButton];  
	[photoButton setHidden:YES]; 
}

// prevent photos cell from moving up when entryview expands/shrinks (after a newline is created/deleted)
-(void)layoutSubviews{
	%orig;

	CGRect frame = self.footer.frame;
	frame.origin.y = self.contentView.frame.size.height-35;
	[self.footer setFrame:frame];
}

// hides photos cell when caret ">" is visible
-(void)setAnimatingLayoutChange:(BOOL)arg1 {
  	%orig;

	if(arg1){
		if(!self.footer.hidden){ 
			[self.footer setHidden:YES];
		}
		else{
			[self.footer setHidden:NO];
		}
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
					[cell setHidden:YES];
					[cell removeFromSuperview];
				}
			}
		}
	}
}
 
%new
// respond to plugin deactivation notification by 'tapping' the contentview to close the plugin extension window
-(void)secondTap{
	[self messageEntryContentViewWasTapped:self.contentView isLongPress:NO];
}
%end

// adjust appbar collectionview frame for now-removed cell ^
%hook CKBrowserSwitcherFooterView
-(void)layoutSubviews{
	%orig;

	if([self.superview isMemberOfClass:%c(CKMessageEntryView)]){
		CGRect frame = [self collectionView].frame;
		frame.origin.x = frame.origin.x-54;
		frame.size.width = frame.size.width+54;
		[[self collectionView] setFrame:frame];
	}
}
%end

// post notification to deselect cell when the plugin is deactivated
%hook CKBalloonPluginManager
-(void)updateSnapshotForBrowserViewController:(id)arg1 currentBounds:(CGRect)arg2 {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"MsgSwapCell_Deselect" object:nil];	 

	%orig;
}
%end
