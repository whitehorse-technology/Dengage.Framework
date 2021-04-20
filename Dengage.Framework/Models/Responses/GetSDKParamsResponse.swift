import Foundation
struct GetSDKParamsResponse: Codable {
    let accountId: Int?
    let accountName: String?
    let eventsEnabled: Bool
    let inboxEnabled: Bool
    let inAppEnabled: Bool
    let subscriptionEnabled: Bool
    private let inAppFetchIntervalInMin: Int?
    private let inAppMinSecBetweenMessages:Int?
    
    var fetchIntervalInMin:Double{
        Double((inAppFetchIntervalInMin ?? 0) * 60000)
    }
    
    var minSecBetweenMessages:Double{
        Double((inAppMinSecBetweenMessages ?? 0) * 1000)
    }
}
