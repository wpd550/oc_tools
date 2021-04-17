
#import <Cocoa/Cocoa.h>


@interface IKWindow : NSWindow

/// Returns YES, if the class supports vibrant appearances. Can be used to determine if running on OS X 10.10+
+ (BOOL) supportsVibrantAppearances;

/// Defines the window's titlebar height. Defaut: OS X default value.
@property (nonatomic) IBInspectable CGFloat titleBarHeight;

//// Returns the titlebar view of the window, which you can add arbitrary subviews to.
@property (strong,readonly) NSView *titleBarView;

@property (strong,readonly) NSView *titleBarContainView;

/// If set to YES, the standard window button will be vertically centered. Default: YES.
@property (nonatomic) IBInspectable BOOL centerTrafficLightButtons;

/// Defines the left margin of the standard window buttons. Defaut: OS X default value.
@property (nonatomic) IBInspectable CGFloat trafficLightButtonsLeftMargin;

/// Defines the top margin of the standard window buttons. Used if not centered. Defaut: OS X default value.
@property (nonatomic) IBInspectable CGFloat trafficLightButtonsTopMargin;

/// If set to YES, the title of the window will be hidden. Default: YES.
@property (nonatomic) IBInspectable BOOL hidesTitle;


@property (nonatomic,strong) IBOutlet NSView *titleView;

/// Replaces the window's content view with an instance of NSVisualEffectView and applies the Vibrant Dark look. Transfers all subviews to the new content view.
- (void) setContentViewAppearanceVibrantDark;

/// Replaces the window's content view with an instance of NSVisualEffectView and applies the Vibrant Light look. Transfers all subviews to the new content view.
- (void) setContentViewAppearanceVibrantLight;

/// Convenient method to set the NSAppearance of the window to NSAppearanceNameVibrantDark
- (void) setVibrantDarkAppearance;

/// Convenient method to set the NSAppearance of the window to NSAppearanceNameVibrantLight
- (void) setVibrantLightAppearance;

/// Convenient method to set the NSAppearance of the window to NSAppearanceNameVibrantAqua
- (void) setAquaAppearance;

/// Replaces a view of the window subview hierarchy with the specified view, and transfers all current subviews to the new one. The frame of the new view will be set to the frame of the old view, if flag is YES.
- (void) replaceSubview: (NSView *) aView withView: (NSView *) newView resizing: (BOOL) flag;

/// Replaces a view of the window subview hierarchy with a new view of the specified NSView class, and transfers all current subviews to the new one.
- (NSView *) replaceSubview: (NSView *) aView withViewOfClass: (Class) newViewClass;

/// Returns YES if the window is currently in full-screen.
- (BOOL) isFullScreen;

@end
