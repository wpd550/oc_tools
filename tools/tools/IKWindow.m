
#import "IKWindow.h"



#pragma mark - WAYWindow
@interface IKWindow ()<NSWindowDelegate>

@property (strong) NSArray* standardButtons;
@property (strong) NSTextField *titleLabel;

@end

static float kWAYWindowDefaultTrafficLightButtonsLeftMargin = 0;
static float kWAYWindowDefaultTrafficLightButtonsTopMargin = 0;

@implementation IKWindow

+ (BOOL) supportsVibrantAppearances {
	return (NSClassFromString(@"NSVisualEffectView")!=nil);
}

+ (float) defaultTitleBarHeight {
	NSRect frame = NSMakeRect(0, 0, 800, 600);
	NSRect contentRect = [NSWindow contentRectForFrameRect:frame styleMask: NSTitledWindowMask];
	
   CGFloat h =  NSHeight(frame) - NSHeight(contentRect);
    return h;
    
    
}

#pragma mark - NSWindow Overwritings

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag {
	if ((self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag])) {
		[self _setUp];
	}
	return self;
}

- (void)setAppearance:(NSAppearance *)appearance{
    [super setAppearance:appearance];
}

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag screen:(NSScreen *)screen {
	if ((self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag screen:screen])) {
		[self _setUp];
	}
	return self;
}



- (void) setFrame:(NSRect)frameRect display:(BOOL)flag {
	[super setFrame:frameRect display:flag];
	[self _setNeedsLayout];
}

- (void) restoreStateWithCoder:(NSCoder *)coder {
	[super restoreStateWithCoder:coder];
	[self _setNeedsLayout];
}

- (void) orderFront:(id)sender {
	[super orderFront:sender];
	[self _setNeedsLayout];
}

- (void)awakeFromNib{
   
//    self.backgroundColor = [NSColor orangeColor];
    NSLog(@"title = %@",self.title);
    
    if(self.titleView){
        NSRect rect = NSMakeRect(0, self.contentView.bounds.size.height - _titleBarHeight, self.contentView.bounds.size.width, _titleBarHeight);
        [self.titleBarContainView setFrame:rect];
        self.titleView.frame = self.titleBarContainView.bounds;
        [self.titleBarView addSubview:self.titleView];

        if(!_hidesTitle){
            CGFloat frameMidX = NSMidX(self.titleView.frame);
            CGFloat frameHalfWidth = (NSWidth(_titleLabel.frame)/2);
            CGFloat diff = frameMidX - frameHalfWidth;
            
            CGFloat frameMidy = (NSHeight(self.titleView.frame) - NSHeight(_titleLabel.frame))/2 ;
            _titleLabel.frame = NSMakeRect(diff,
                                           frameMidy,
                                           NSWidth(_titleLabel.frame),
                                           NSHeight(_titleLabel.frame));
            NSLog(@"label = %@",NSStringFromRect(_titleLabel.frame));
        }
        
    }
    
}

- (void)display{
    [super display];
}


#pragma mark - Public

- (NSView *) titleBarView {
	return [_standardButtons[0] superview];
}

- (NSView* )titleBarContainView{
    return [[_standardButtons[0] superview] superview];
}

- (void) setCenterTrafficLightButtons:(BOOL)centerTrafficLightButtons {
	_centerTrafficLightButtons = centerTrafficLightButtons;
	[self _setNeedsLayout];
}


- (void) setTitleBarHeight:(CGFloat)titleBarHeight {

	titleBarHeight = MAX(titleBarHeight,[[self class] defaultTitleBarHeight]);
	_titleBarHeight = titleBarHeight;
	
	
    NSRect frame = self.frame;
    
  
  
	[self _setNeedsLayout];
	[self setFrame:frame display:NO]; // NO is important.
}

- (void) setHidesTitle:(BOOL)hidesTitle {
	_hidesTitle = hidesTitle;
    if(self.title && !_hidesTitle)
    {
        self.titleLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 200, 20)];
        self.titleLabel.stringValue = self.title;
        [self.titleLabel setEditable:NO];
        [self.titleLabel setSelectable:NO];
        [self.titleLabel setFont:[NSFont systemFontOfSize:16]];
        [self.titleLabel sizeToFit];
        self.titleLabel.backgroundColor = [NSColor clearColor];
        self.titleLabel.bordered = NO;
        self.titleLabel.drawsBackground = NO;
        
        [self.titleView addSubview:_titleLabel];
    }else{
        if(_titleLabel)
        {
            [_titleLabel removeFromSuperview];
        }
    }
}

- (void) setContentViewAppearanceVibrantDark {
	[self setContentViewAppearance:NSVisualEffectMaterialDark];
}

- (void) setContentViewAppearanceVibrantLight {
	[self setContentViewAppearance:NSVisualEffectMaterialLight];
}

- (void) setContentViewAppearance: (int) material {
	if (![IKWindow supportsVibrantAppearances])
		return;
	
	NSVisualEffectView *newContentView = (NSVisualEffectView *)[self replaceSubview:self.contentView withViewOfClass:[NSVisualEffectView class]];
	[newContentView setMaterial:material];
	[self setContentView:newContentView];
}

- (void) setVibrantDarkAppearance {
	[self setAppearance:[NSAppearance appearanceNamed:NSAppearanceNameVibrantDark]];
}

- (void) setVibrantLightAppearance {
	[self setAppearance:[NSAppearance appearanceNamed:NSAppearanceNameVibrantLight]];
}

- (void) setAquaAppearance {
	[super setAppearance:[NSAppearance appearanceNamed:NSAppearanceNameAqua]];
}

- (BOOL) isFullScreen {
	return (([self styleMask] & NSFullScreenWindowMask) == NSFullScreenWindowMask);
}

- (void) replaceSubview: (NSView *) aView withView: (NSView *) newView resizing:(BOOL)flag {
	if (flag) {
		[newView setFrame:aView.frame];
	}
	
	[newView setAutoresizesSubviews:aView.autoresizesSubviews];
	[aView.subviews.copy enumerateObjectsUsingBlock:^(NSView *subview, NSUInteger idx, BOOL *stop) {
		NSRect frame = subview.frame;
		if (subview.constraints.count>0) {
			// Note: so far, constraint based contentView subviews are not supported yet
			NSLog(@"WARNING: [%@ %@] does not work yet with NSView instances, that use auto-layout.",
				  NSStringFromClass([self class]),
				  NSStringFromSelector(_cmd));
		}
		[subview removeFromSuperview];
		[newView addSubview:subview];
		[subview setFrame:frame];
	}];
	
	if (aView==self.contentView) {
		[self setContentView: newView];
	} else {
		[aView.superview replaceSubview:aView with:newView];
	}
	[self _setNeedsLayout];
}

- (NSView *) replaceSubview:(NSView *)aView withViewOfClass:(Class)newViewClass {
	NSView *view = [[newViewClass alloc] initWithFrame:aView.frame];
	[self replaceSubview:aView withView:view resizing:YES];
	return view;
}

#pragma mark - Private

- (void) _setUp {
  
    [self setMovableByWindowBackground:YES];
	_standardButtons = @[[self standardWindowButton:NSWindowCloseButton],
						 [self standardWindowButton:NSWindowMiniaturizeButton],
						 [self standardWindowButton:NSWindowZoomButton]];
	_centerTrafficLightButtons = YES;
    self.titlebarAppearsTransparent = YES;
	NSButton *closeButton = [self standardWindowButton:NSWindowCloseButton];
	kWAYWindowDefaultTrafficLightButtonsLeftMargin = NSMinX(closeButton.frame);
	kWAYWindowDefaultTrafficLightButtonsTopMargin = NSHeight(closeButton.superview.frame)-NSMaxY(closeButton.frame);
	
	self.styleMask |= NSFullSizeContentViewWindowMask;
	_trafficLightButtonsLeftMargin = kWAYWindowDefaultTrafficLightButtonsLeftMargin;
	_trafficLightButtonsTopMargin = kWAYWindowDefaultTrafficLightButtonsTopMargin;
	_hidesTitle = YES;
	[self _setNeedsLayout];
}

//- (NSView *)titleView{
//    if(!_titleView){
//        _titleView = [[NSView alloc] init];
//        _titleView.wantsLayer = YES;
//        _titleView.layer.backgroundColor = [NSColor whiteColor].CGColor;
//        if(self.title && !_hidesTitle)
//        {
//            self.titleLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 200, 20)];
//            self.titleLabel.stringValue = self.title;
//            [self.titleLabel setEditable:NO];
//            [self.titleLabel setSelectable:NO];
//            [self.titleLabel setFont:[NSFont systemFontOfSize:16]];
//            [self.titleLabel sizeToFit];
//            self.titleLabel.backgroundColor = [NSColor clearColor];
//            self.titleLabel.bordered = NO;
//            self.titleLabel.drawsBackground = NO;
//            [_titleView  addSubview:self.titleLabel];
//        }
//        
//    }
//    return _titleView;
//}


- (void)updateConstraintsIfNeeded{
    NSLog(@"updateConstraintsIfNeeded");
    NSRect rect = NSMakeRect(0, self.contentView.bounds.size.height - _titleBarHeight, self.contentView.bounds.size.width, _titleBarHeight);
    [self.titleBarContainView setFrame:rect];
    
//    [self _setNeedsLayout];
}

- (void) _setNeedsLayout {
    
    NSLog(@"_setNeedsLayout");
	[_standardButtons enumerateObjectsUsingBlock:^(NSButton *standardButton, NSUInteger idx, BOOL *stop) {
		NSRect frame = standardButton.frame;
		if (_centerTrafficLightButtons)
			frame.origin.y = NSHeight(standardButton.superview.frame)/2-NSHeight(standardButton.frame)/2;
		else
			frame.origin.y = NSHeight(standardButton.superview.frame)-NSHeight(standardButton.frame)-_trafficLightButtonsTopMargin;
		
		frame.origin.x = _trafficLightButtonsLeftMargin +idx*(NSWidth(frame) + 6);
		[standardButton setFrame:frame];
	}];
   
  
  
//    h = _titleBarHeight - h;
//    rect =NSOffsetRect(rect, 0, -h);
//    rect.size.height =  _titleBarHeight;

}


#pragma mark - NSWindow Delegate

- (void) windowDidResize:(NSNotification *)notification {
	[self _setNeedsLayout];
}

- (void)windowDidChangeBackingProperties:(NSNotification *)notification{
    NSLog(@"windowDidChangeBackingProperties");
}

@end
