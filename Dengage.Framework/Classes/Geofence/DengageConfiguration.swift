import Foundation
import AdSupport
import CoreTelephony
import UIKit

final class DengageConfiguration:Encodable {
    
    let subscriptionURL: URL
    let eventURL: URL
    let deviceCountryCode: String
    let deviceLanguage: String
    let deviceTimeZone: String
    let appVersion: String
    var applicationIdentifier: String
    let advertisingIdentifier: String
    let getCarrierIdentifier: String
    let sdkVersion: String
    let integrationKey: String
    let options: DengageOptions
    var deviceToken: String?
    let userAgent: String
    var permission: Bool
    let geofenceURL: URL

    var inboxLastFetchedDate: Date?
    
    init(integrationKey: String, options: DengageOptions) {
        subscriptionURL = URL.init(string: Settings.shared.getSubscriptionApi())!
        eventURL = URL.init(string: Settings.shared.getEventApiUrl())!
        deviceCountryCode = Settings.shared.getDeviceCountry()
        deviceLanguage = Locale.current.languageCode ?? "Null"
        deviceTimeZone = TimeZone.current.abbreviation() ?? "Null"
        appVersion = Settings.shared.getAppversion() ?? ""
        applicationIdentifier = Settings.shared.getApplicationIdentifier()
        advertisingIdentifier = Settings.shared.getAdvertisinId() ?? ""
        getCarrierIdentifier = Settings.shared.getCarrierId()
        sdkVersion = SDK_VERSION
        self.integrationKey = Settings.shared.getDengageIntegrationKey()
        self.options = options
        self.userAgent = UserAgentUtils.userAgent
        self.permission = Settings.shared.getPermission() ?? false
        self.deviceToken = Settings.shared.getToken()
        geofenceURL = URL.init(string: Settings.shared.getGeoFenceApi())!

    }
    
    
    
    
   
    
   
}


extension DengageConfiguration: CustomStringConvertible{
    public var description: String{
        var desc = "Dengage Configrations\n"
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            if let label = child.label {
                desc.append("\(label): \(child.value)\n")
            }
        }
        return desc
    }
}

private extension UUID{
    var isNotEmpty: Bool{
        let emptyUUID = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
        return self.uuidString.elementsEqual(emptyUUID.uuidString)
    }
}

final class UserAgentUtils { // todo dusun
    
    //eg. Darwin/16.3.0
    class var darwinVersion: String {
        var sysinfo = utsname()
        uname(&sysinfo)
        let bytes = Data(bytes: &sysinfo.release, count: Int(_SYS_NAMELEN))
        guard let darwinString = String(bytes: bytes, encoding: .ascii) else { return "Null"}
        return "Darwin/\(darwinString.trimmingCharacters(in: .controlCharacters))"
    }
    
    //eg. CFNetwork/808.3
    class var CFNetworkVersion: String {
        guard let dictionary = Bundle(identifier: "com.apple.CFNetwork")?.infoDictionary else { return "Null" }
        let version = dictionary["CFBundleShortVersionString"] as! String
        return "CFNetwork/\(version)"
    }

    //eg. iOS/10_1
    class var deviceVersion: String {
        let currentDevice = UIDevice.current
        return "\(currentDevice.systemName)/\(currentDevice.systemVersion)"
    }
    
    //eg. iPhone 13 Pro
    class var deviceName: String {
        return UIDevice.modelName
    }
    
    //eg. MyApp/1
    class var appNameAndVersion:String {
        guard let dictionary = Bundle.main.infoDictionary else {return "Null"}
        let version = dictionary["CFBundleShortVersionString"] as? String ?? "1.0"
        let name = dictionary["CFBundleName"] as! String
        return "\(name)/\(version)"
    }

    class var userAgent: String {
        return "\(appNameAndVersion) \(deviceName) \(deviceVersion) \(CFNetworkVersion) \(darwinVersion)"
    }
}
