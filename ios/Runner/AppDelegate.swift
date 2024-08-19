import UIKit
import Flutter
import GoogleMaps


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Initialize Google Maps with API Key
    GMSServices.provideAPIKey("AIzaSyA8pIqHO4If7tMvIYIl60rFXI365Bfl3-I")
    
    // Register generated plugins
    GeneratedPluginRegistrant.register(with: self)

    // Return the result of the super call
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}