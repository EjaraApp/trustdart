#import "TrustdartPlugin.h"
#if __has_include(<trustdart/trustdart-Swift.h>)
#import <trustdart/trustdart-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "trustdart-Swift.h"
#endif

@implementation TrustdartPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTrustdartPlugin registerWithRegistrar:registrar];
}
@end
