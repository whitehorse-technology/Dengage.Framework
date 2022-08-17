import Foundation
import UserNotifications
import UIKit
import CoreLocation

public class DengageManager {

    var config: DengageConfiguration
    var application: UIApplication?
    var launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    var options: DengageOptions?
    var apiClient: DengageNetworking
    var sessionManager: DengageSessionManagerInterface
    var geofenceManager: DengageGeofenceManagerInterface

    var testPageWindow: UIWindow?
    
    init(with apiKey: String,
         application: UIApplication,
         launchOptions: [UIApplication.LaunchOptionsKey: Any]?,
         dengageOptions options: DengageOptions) {
        
        config = DengageConfiguration(integrationKey: apiKey, options: options)
        
        // keychain ve userdefaults da daha once kayit edilenler confige eklenmiyor
        self.application = application
        self.launchOptions = launchOptions
        self.options = options
        self.apiClient = DengageNetworking(config: config)
        self.sessionManager = DengageSessionManager()
       
        self.geofenceManager = DengageGeofenceManager(config: config,
                                                      service: apiClient)
    }
}


//MARK: - Private

@objc public class DengageOptions: NSObject,Codable {
    public let disableOpenURL: Bool
    public let badgeCountReset: Bool
    public let disableRegisterForRemoteNotifications: Bool
    public let enableGeofence: Bool
    public init(disableOpenURL: Bool = false,
                badgeCountReset: Bool = false,
                disableRegisterForRemoteNotifications: Bool = false,
                enableGeofence: Bool = false) {
        self.disableOpenURL = disableOpenURL
        self.badgeCountReset = badgeCountReset
        self.disableRegisterForRemoteNotifications = disableRegisterForRemoteNotifications
        self.enableGeofence = enableGeofence
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        disableOpenURL = try container.decode(Bool.self, forKey: .disableOpenURL)
        badgeCountReset = try container.decode(Bool.self, forKey: .badgeCountReset)
        disableRegisterForRemoteNotifications = try container.decode(Bool.self, forKey: .disableRegisterForRemoteNotifications)
        enableGeofence = try container.decode(Bool.self, forKey: .enableGeofence)
    }
    
    enum CodingKeys: String, CodingKey {
        case disableOpenURL, badgeCountReset, disableRegisterForRemoteNotifications, enableGeofence
    }
}


//MARK: - Geofence
extension DengageManager {
    
    func requestLocationPermissions() {
        geofenceManager.requestLocationPermissions()
    }
    
    func stopGeofence() {
        geofenceManager.stopGeofence()
    }
    
}

