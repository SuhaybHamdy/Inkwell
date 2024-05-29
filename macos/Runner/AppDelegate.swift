import Cocoa
import FlutterMacOS
import FirebaseCore

@NSApplicationMain
class AppDelegate: FlutterAppDelegate {

  override func applicationDidFinishLaunching(_ notification: Notification) {
    FirebaseApp.configure()
    super.applicationDidFinishLaunching(notification)
  }
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }
}
