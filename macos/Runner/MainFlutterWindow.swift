import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController.init()

    // Load window size and position from UserDefaults, or use default size
    let userDefaults = UserDefaults.standard
    let width = userDefaults.float(forKey: "WindowWidth") > 0 ? CGFloat(userDefaults.float(forKey: "WindowWidth")) : 800
    let height = userDefaults.float(forKey: "WindowHeight") > 0 ? CGFloat(userDefaults.float(forKey: "WindowHeight")) : 600
    let xPos = userDefaults.float(forKey: "WindowXPos") > 0 ? CGFloat(userDefaults.float(forKey: "WindowXPos")) : 0
    let yPos = userDefaults.float(forKey: "WindowYPos") > 0 ? CGFloat(userDefaults.float(forKey: "WindowYPos")) : 0

    let windowFrame = NSRect(x: xPos, y: yPos, width: width, height: height)

    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    self.titlebarAppearsTransparent = true
    self.titleVisibility = .hidden
    self.styleMask.insert(.fullSizeContentView)
    self.isMovableByWindowBackground = true

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }

  // Override close method to save window size and position
  override func close() {
    let userDefaults = UserDefaults.standard
    userDefaults.set(Float(self.frame.width), forKey: "WindowWidth")
    userDefaults.set(Float(self.frame.height), forKey: "WindowHeight")
    userDefaults.set(Float(self.frame.origin.x), forKey: "WindowXPos")
    userDefaults.set(Float(self.frame.origin.y), forKey: "WindowYPos")

    super.close()
  }
}
