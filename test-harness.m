#import <Cocoa/Cocoa.h>
#import <ScreenSaver/ScreenSaver.h>

int main(int argc, const char * argv[]) {
	@autoreleasepool {
		[NSApplication sharedApplication];
		[NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];

		// Load the .saver bundle
		NSString *saverPath = @"/tmp/forever-stars-build/Forever Stars.saver";
		NSBundle *saverBundle = [NSBundle bundleWithPath:saverPath];
		if (!saverBundle) {
			NSLog(@"Failed to load bundle at %@", saverPath);
			return 1;
		}

		Class saverClass = [saverBundle principalClass];
		if (!saverClass) {
			NSLog(@"Failed to get principal class from bundle");
			return 1;
		}

		// Create a window
		NSRect frame = NSMakeRect(100, 100, 800, 600);
		NSWindow *window = [[NSWindow alloc]
			initWithContentRect:frame
			styleMask:NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskResizable
			backing:NSBackingStoreBuffered
			defer:NO];
		[window setTitle:@"Forever Stars - Test"];

		// Create the screensaver view
		ScreenSaverView *view = [[saverClass alloc] initWithFrame:frame isPreview:NO];
		[window setContentView:view];
		[window makeKeyAndOrderFront:nil];
		[view startAnimation];

		[NSApp activateIgnoringOtherApps:YES];
		[NSApp run];
	}
	return 0;
}
