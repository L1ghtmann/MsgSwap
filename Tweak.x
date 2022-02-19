//
//	Tweak.x
//	MsgSwap
//
//	Created by Lightmann during COVID-19
//

#import "MsgSwapFooter.h"

%hook CKMessageEntryView
%property (nonatomic, retain) MsgSwapFooter *footer;
%property (nonatomic) BOOL caretState;
// initial footer setup
-(void)setInputButtonContainerView:(UIView *)inputButtonContainerView {
	%orig;

	self.footer = [[MsgSwapFooter alloc] initWithFrame:CGRectZero];
	[self.footer setDelegate:self];
	[self.footer setDataSource:self.appStrip.dataSource];
	[inputButtonContainerView addSubview:self.footer];

	// hey ma, look, I used constraints!
	[self.footer setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self.footer.heightAnchor constraintEqualToConstant:39.5].active = YES;
	[self.footer.widthAnchor constraintEqualToConstant:64.5].active = YES;
	[self.footer.leftAnchor constraintEqualToAnchor:inputButtonContainerView.leftAnchor].active = YES;
	[self.footer.bottomAnchor constraintEqualToAnchor:inputButtonContainerView.bottomAnchor constant:-4.5].active = YES;

	// add observer for notification from MsgSwapFooter that the cell was tapped a second time
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(secondTap) name:@"secondTap" object:nil];

	// add observer for notification from self about caret ">" being shown or hidden
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unleashTheRabbit) name:@"Gromit" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recollectTheRabbit) name:@"Wallace" object:nil];
}

// grab a reference to the photoButton
-(void)setPhotoButton:(CKEntryViewButton *)photoButton {
	%orig;

	[self.footer setCameraButton:photoButton];
}

// hide and unhide cell/photoButton at appStrip presentation/dismissal
-(void)setShowAppStrip:(BOOL)arg1 animated:(BOOL)arg2 completion:(/*^block*/id)arg3 {
	%orig;

	if(arg1){
		[UIView animateWithDuration:0.5 animations:^{
			[self.footer.cameraButton setHidden:NO];
			[self.footer.cell setAlpha:0];
		}];
	}
	else if(!arg1){
		[UIView animateWithDuration:0.5 animations:^{
			[self.footer.cameraButton setHidden:YES];
			[self.footer.cell setAlpha:1];
		}];
	}
}

// get state of caret and act accordingly
-(BOOL)shouldEntryViewBeExpandedLayout{
	BOOL orig = %orig;
	if(self.caretState != orig){
		if(orig) [[NSNotificationCenter defaultCenter] postNotificationName:@"Gromit" object:nil];
		else [[NSNotificationCenter defaultCenter] postNotificationName:@"Wallace" object:nil];
		[self setCaretState:orig];
	}
	return orig;
}

%new
// hide or show cell depending on presence (or lack thereof) of the caret
-(void)unleashTheRabbit{
	// no animation because we want this to be quick
	[self.footer.cell setAlpha:0];
}

%new
-(void)recollectTheRabbit{
	[UIView animateWithDuration:0.20 animations:^{
		[self.footer.cell setAlpha:1];
	}];
}

%new
// respond to plugin deactivation notification by 'tapping' the contentview to close the plugin extension window
-(void)secondTap{
	[self messageEntryContentViewWasTapped:self.contentView isLongPress:NO];
}
%end

// post notification to deselect cell when the plugin is deactivated
%hook CKBalloonPluginManager
-(void)updateSnapshotForBrowserViewController:(id)arg1 currentBounds:(CGRect)arg2 {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"deselect" object:nil];

	%orig;
}
%end
