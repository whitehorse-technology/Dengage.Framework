//
//  Dengage.swift
//  dengage.ios.sdk
//
//  Created by Developer on 20.09.2019.
//  Copyright © 2019 Dengage. All rights reserved.
//

import Foundation
import UserNotifications
import AdSupport
import StoreKit

@objc public class Dengage: NSObject {

    static var center = UNUserNotificationCenter.current()

    static var notificationDelegate = DengageNotificationDelegate()
    static var openEventService: OpenEventService = OpenEventService()
    static var eventCollectionService: EventCollectionService = EventCollectionService()
    static var baseService = BaseService()
    static var sessionManager: SessionManager = .shared

    static var utilities: Utilities = .shared
    static var settings: Settings = .shared
    static var logger: SDKLogger = .shared
    static var localStorage: DengageLocalStorage = .shared
    static var inboxManager: InboxManager = .shared
    static var inAppMessageManager = InAppMessageManager(settings: settings, service: baseService)
    static var dengageRFMManager = DengageRFMManager()
    
    static var manager: DengageManager?
    
    static var dengage: DengageManager? {
        get{
            if self.manager == nil {
                Logger.log(message: "Dengage not started correctly", argument: "")
            }
            return self.manager
        }
        set{
            manager = newValue
        }
    }
    

    // MARK: - Initialize Methods
    /// Initiliazes SDK requiered parameters.
    ///
    /// -  Usage:
    ///
    ///      Dengage.initWithLaunchOptions(categories: [], withLaunchOptions: launchOptions, badgeCountReset: true)
    ///
    /// - Parameter categories: *categories* custom action buttons
    /// - Parameter withLaunchOptions: *withLaunchOptions*
    /// - Parameter badgeCountReset: *badgeCountReset* clears badge count icon on notification enable
    @available(iOS 10.0, *)
    // will support rich notifications with categories
    public static func initWithLaunchOptions(categories: Set<UNNotificationCategory>? = nil,
                                             withLaunchOptions: [UIApplication.LaunchOptionsKey: Any]?,
                                             badgeCountReset: Bool? = nil, appGroupName: String? = nil,dengageOptions options: DengageOptions = DengageOptions()) {
        let currentNotificationCenter = center.delegate
        notificationDelegate.delegate = currentNotificationCenter
        center.delegate = notificationDelegate
        settings.setBadgeCountReset(badgeCountReset: badgeCountReset)
        settings.removeTokenIfNeeded()
        configureSettings()
        Dengage.syncSubscription()
        Dengage.getSDKParams()
        
        dengage = .init(with: settings.integrationKey,
                        application: UIApplication.shared,
                        launchOptions:withLaunchOptions,
                        dengageOptions: options)
        
        guard let pushCategories = categories else {return}
        center.setNotificationCategories(pushCategories)
    }
    
    @objc public static func start(apiKey: String,
                                   application: UIApplication,
                                   launchOptions: [UIApplication.LaunchOptionsKey: Any]?,
                                   dengageOptions options: DengageOptions = DengageOptions()) {
        dengage = .init(with: apiKey,
                        application: application,
                        launchOptions:launchOptions,
                        dengageOptions: options)
    }

    // MARK: - Rich Notification İnitiliaze
    @available(iOSApplicationExtension 10.0, *)
    public static func didReceiveNotificationExtentionRequest(receivedRequest: UNNotificationRequest,
                                                              withNotificationContent: UNMutableNotificationContent) {

        if #available(iOS 15.0, *) {
            withNotificationContent.interruptionLevel = .timeSensitive
        } else {
            // Fallback on earlier versions
        }
        DengageNotificationExtension.shared.didReceiveNotificationExtentionRequest(receivedRequest: receivedRequest,
                                                                                   withNotificationContent: withNotificationContent)
    }

    // MARK: - Private Methods
    static func configureSettings() {

        settings.setCarrierId(carrierId: utilities.identifierForCarrier())
        settings.setAdvertisingId(advertisingId: utilities.identifierForAdvertising())
        settings.setApplicationIdentifier(applicationIndentifier: utilities.identifierForApplication())
        settings.setAppVersion(appVersion: utilities.indentifierForCFBundleShortVersionString())
    }
}

extension Dengage {
    public static func saveRFM(scores: [RFMScore]) {
        dengageRFMManager.saveRFM(scores: scores)
    }
    
    public static func categoryView(id: String){
        dengageRFMManager.categoryView(id: id)
    }
    
    public static func sortRFMItems(gender: RFMGender, items: [RFMItemProtocol]) -> [RFMItemProtocol] {
        dengageRFMManager.sortRFMItems(gender: gender,
                                       items: items)
    }
}


// MARK: - Inbox
extension Dengage {
    public static func getInboxMessages(offset: Int,
                                        limit: Int = 20,
                                        completion: @escaping (Result<[DengageMessage], Error>) -> Void) {
        guard (settings.configuration?.inboxEnabled ?? false) else {
            completion(.success([]))
            return}
        let accountName = settings.configuration?.accountName ?? ""
        let request = GetMessagesRequest(accountName: accountName,
                                         contactKey: settings.contactKey.0,
                                         type: settings.contactKey.type,
                                         offset: offset,
                                         limit: limit,
                                         deviceId: settings.getApplicationIdentifier())
        inboxManager.getInboxMessages(request: request) { result in
            switch result {
            case .success(let messages):
                completion(.success(messages))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    public static func deleteInboxMessage(with id: String,
                                          completion: @escaping (Result<Void, Error>) -> Void) {

        guard (settings.configuration?.inboxEnabled ?? false) else {
            completion(.success(()))
            return}
        
        let accountName = settings.configuration?.accountName ?? ""
        let request = DeleteMessagesRequest(type: settings.contactKey.type,
                                            deviceID: settings.getApplicationIdentifier(),
                                            accountName: accountName,
                                            contactKey: settings.contactKey.0,
                                            id: id)
        inboxManager.deleteInboxMessage(with: request) { result in
            switch result {
            case .success(_):
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    public static func setInboxMessageAsClicked(with id: String,
                                              completion: @escaping (Result<Void, Error>) -> Void) {
        guard (settings.configuration?.inboxEnabled ?? false) else {
            completion(.success(()))
            return}
        let accountName = settings.configuration?.accountName ?? ""
        let request = MarkAsReadRequest(type: settings.contactKey.type,
                                        deviceID: settings.getApplicationIdentifier(),
                                        accountName: accountName,
                                        contactKey: settings.contactKey.0,
                                        id: id)
        inboxManager.markInboxMessageAsRead(with: request) { result in
            switch result {
            case .success(_):
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public static func setNavigation(screenName:String? = nil ){
        inAppMessageManager.setNavigation(screenName:screenName)
    }
    
    public static func setTags(_ tags: [TagItem]){
        let request = TagsRequest(accountName: settings.configuration?.accountName ?? "",
                                  key: settings.getApplicationIdentifier(),
                                  tags: tags)
        baseService.send(request: request) { result in
            switch result {
            case .success(_):
                break
            case .failure:
                logger.Log(message: "[DENGAGE] SDK SetTags Method Error", logtype: .error)
            }
        }
    }
    
    public static func getPermission() -> Bool {
        return settings.getPermission() ?? true
    }
    

    static func getSDKParams() {
        if let date = (localStorage.getValue(for: .lastFetchedConfigTime) as? Date), let diff = Calendar.current.dateComponents([.hour], from: date, to: Date()).hour, diff > 24 {
            Dengage.fetchSDK()
        }else if (localStorage.getValue(for: .lastFetchedConfigTime) as? Date) == nil {
            Dengage.fetchSDK()
        }else{
            inAppMessageManager.fetchInAppMessages()
        }
    }
    
    private static func fetchSDK(){
        let request = GetSDKParamsRequest(integrationKey: settings.getDengageIntegrationKey(),
                                          deviceId: settings.getApplicationIdentifier())
        baseService.send(request: request) { result in
            switch result {
            case .success(let response):
                localStorage.saveConfig(with: response)
                localStorage.set(value: Date(), for: .lastFetchedConfigTime)
                inAppMessageManager.fetchInAppMessages()
            case .failure:
                logger.Log(message: "SDK PARAMS Config Error", logtype: .error)
            }
        }
    }
    
    public static func sendOpenEvent(messageId: Int,
                                     messageDetails: String,
                                     buttonId: String?) {
        
        var openEventHttpRequest = OpenEventHttpRequest()
        openEventHttpRequest.messageId = messageId
        openEventHttpRequest.messageDetails = messageDetails
        openEventHttpRequest.integrationKey = settings.getDengageIntegrationKey()
        openEventHttpRequest.buttonId = buttonId ?? ""
        
        openEventService.postOpenEvent(openEventHttpRequest: openEventHttpRequest)
        if settings.getBadgeCountReset() == true {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
    
    public static func showRatingView() {
        if #available( iOS 10.3,*){
            SKStoreReviewController.requestReview()
        }
    }
}

//MARK: - Geofence
extension Dengage{

    @objc public static func requestLocationPermissions() {
        dengage?.requestLocationPermissions()
    }
    
    @objc public static func stopGeofence() {
        dengage?.stopGeofence()
    }
    
    
}
