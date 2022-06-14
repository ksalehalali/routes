import UIKit
import Flutter
import GoogleMaps
import CoreLocation
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate ,CLLocationManagerDelegate {
    private var locManager:CLLocationManager?
    var locationDataD = ["a":0.0]

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      FirebaseApp.configure()

      if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
          }
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      
      let METHOD_CHANNEL_NAME = "location"
           let Channel = FlutterMethodChannel(
             name: METHOD_CHANNEL_NAME,
             binaryMessenger: controller.binaryMessenger)
      
      Channel.setMethodCallHandler({
           (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
           switch call.method {
           case "getCurrentLocation":
               guard let args = call.arguments as? [String: Any] else {return}
               let name = args["name"]!
               
               result(self.locationDataD)
               
           default:
               result(FlutterMethodNotImplemented)
               
           }
       })
           
    GMSServices.provideAPIKey("AIzaSyBZCipU5Ocjy9Abhqa_9gPe39JjTqTVOCE")
    GeneratedPluginRegistrant.register(with: self)
      getCurrent()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    func getCurrent(){
        if CLLocationManager.locationServicesEnabled(){
            print(" enabled")
            locManager = CLLocationManager()
            
            locManager?.delegate = self
            locManager?.desiredAccuracy = kCLLocationAccuracyBest
            locManager?.requestAlwaysAuthorization()
            locManager?.startUpdatingLocation()
            
        }else{
            print("not enabled")
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("lat **************** \(location.coordinate.latitude)")
            locationDataD = ["lat":location.coordinate.latitude,"lng":location.coordinate.longitude]
        }
       
        
    }
}
