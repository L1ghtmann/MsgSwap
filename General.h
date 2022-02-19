#import <UIKit/UIKit.h>

@interface IMBalloonPlugin : NSObject
@end

@interface IMBalloonPluginManager : NSObject
@property (nonatomic,retain) NSMutableDictionary * pluginsMap;
+(instancetype)sharedInstance;
@end

@interface CKBalloonPluginManager : NSObject
+(instancetype)sharedInstance;
-(void)prepareForSuspend;
@end

@interface CKBrowserPluginCell : UICollectionViewCell
@property (nonatomic,retain) IMBalloonPlugin * plugin;
-(void)setPlugin:(IMBalloonPlugin *)arg1;
@property (nonatomic,retain) UIImageView * browserImage;
-(void)setBrowserImage:(UIImageView *)arg1 ;
@end

@interface CKAppStripLayout : UICollectionViewLayout
@end

@interface CKMessageEntryContentView : UIView
@end

@interface CKBrowserSwitcherFooterView : UIView <UICollectionViewDelegate, UICollectionViewDataSource>
@property (assign,nonatomic) id delegate;
@property (assign,nonatomic) id dataSource;
@property (assign,nonatomic) BOOL isMagnified;
@property (assign,nonatomic) BOOL hideShinyStatus;
@property (assign,nonatomic) BOOL showBorders;
@property (nonatomic,retain) CKAppStripLayout * appStripLayout;
@property (assign,nonatomic) BOOL minifiesOnSelection;
@property (assign,nonatomic) BOOL isMinifyingOnTranscriptScroll;
@property (assign,nonatomic) double snapshotVerticalOffset;
@property (nonatomic,retain) CKMessageEntryContentView * contentView;
-(UICollectionView*)collectionView;
@end

@interface CKEntryViewButton : UIButton // UIView (iOS 13) || UIButton (iOS 12)
@property (nonatomic,retain) UIButton * button; // iOS 13
@end

@interface CKMessageEntryView : UIView
@property (nonatomic,retain) CKEntryViewButton * photoButton;  // camera
@property (nonatomic,retain) CKEntryViewButton * browserButton; // toggles appstrip
@property (nonatomic,retain) CKEntryViewButton * arrowButton;   // caret
@property (nonatomic,retain) CKBrowserSwitcherFooterView * appStrip;
@property (nonatomic,retain) UIView * inputButtonContainerView;
@property (nonatomic,retain) CKMessageEntryContentView * contentView;
@property (nonatomic) BOOL caretState;
@end
