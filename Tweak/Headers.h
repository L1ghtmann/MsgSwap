#import <UIKit/UIKit.h>

//https://stackoverflow.com/a/5337804
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface UICollectionView (Private) 
@property (assign,nonatomic) id dataSource;    
@property (assign,nonatomic) id delegate;      
@end

@interface UILongPressGestureRecognizer (Private)
-(void)setView:(UIView *)arg1;
@end

@interface PKHostPlugIn : NSObject
@property (readonly) BOOL active; 
@end

@interface IMBalloonPlugin : NSObject 
@property (nonatomic,retain) PKHostPlugIn* plugin;   
@end

@interface IMBalloonAppExtension : NSObject
@property (nonatomic,retain) NSString* containingBundleIdentifier;   
-(NSString *)containingBundleIdentifier;
@end

@interface CKBalloonPluginManager : NSObject
+(id)sharedInstance;
@property (nonatomic,readonly) NSArray * visibleDrawerPlugins;      
@end

@interface CKTranscriptCollectionViewController : UIViewController
@end

@interface CKBrowserPluginCell : UICollectionViewCell
-(void)setSelected:(BOOL)arg1 ;
@property (nonatomic,retain) IMBalloonPlugin * plugin;    
-(void)setPlugin:(IMBalloonPlugin *)arg1 ;
@property (nonatomic,retain) UIImageView * browserImage;     
@end

@interface CKAppStripLayout : UICollectionViewLayout
@end

@interface CKBrowserSwitcherFooterView : UIView{
	UIView* _visibleView;
	id _animator;
	UILongPressGestureRecognizer* _longPressRecognizer;
	UILongPressGestureRecognizer* _touchTracker;
}
@property (assign,nonatomic) id delegate;        
@property (assign,nonatomic) id dataSource;     
@property (assign,nonatomic) BOOL isMagnified;                                         
@property (assign,nonatomic) BOOL hideShinyStatus;                                     
@property (assign,nonatomic) BOOL showBorders;                 
@property (nonatomic,retain) CKAppStripLayout * appStripLayout;                     
@property (assign,nonatomic) BOOL minifiesOnSelection;                
@property (assign,nonatomic) BOOL isMinifyingOnTranscriptScroll;                 
@property (assign,nonatomic) double snapshotVerticalOffset;        
-(UICollectionView*)collectionView;   
-(void)resetScrollPosition;
@end

@interface CKEntryViewButton : UIButton //: UIView (iOS13) -- : UIButton (iOS12)
@property (nonatomic,retain) UIButton * button; //iOS13
@end

@interface CKMessageEntryContentView : UIView
@end

@interface CKMessageEntryView : UIView
@property (nonatomic,retain) CKEntryViewButton * photoButton;  //camera
@property (nonatomic,retain) CKEntryViewButton * browserButton; //opens up appstrip
@property (nonatomic,retain) CKEntryViewButton * arrowButton;   //caret
@property (nonatomic,retain) CKBrowserSwitcherFooterView * appStrip;
@property (nonatomic,retain) UIView * buttonAndTextAreaContainerView; 
@property (nonatomic,retain) UIView * inputButtonContainerView; 
@property (nonatomic,retain) CKMessageEntryContentView * contentView; 
@end
