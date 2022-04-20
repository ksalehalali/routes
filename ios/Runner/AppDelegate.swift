import UIKit
import Flutter
import GoogleMaps
import CoreLocation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate ,CLLocationManagerDelegate {
    private var locManager:CLLocationManager?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
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
        }
       
        
    }
}
