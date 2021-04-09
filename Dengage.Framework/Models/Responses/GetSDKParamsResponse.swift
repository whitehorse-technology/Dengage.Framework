import Foundation
struct GetSDKParamsResponse: Codable {
    let accountId: Int?
    let accountName: String?
    let eventsEnabled: Bool
    let inboxEnabled: Bool
    let inAppEnabled: Bool
    let subscriptionEnabled: Bool
    private let inAppFetchIntervalInMin: Int?
    let inAppMinSecBetweenMessages:Int?
    
    var fetchIntervalInMin:Double{
        Double((inAppFetchIntervalInMin ?? 0) * 60000)
    }
}
