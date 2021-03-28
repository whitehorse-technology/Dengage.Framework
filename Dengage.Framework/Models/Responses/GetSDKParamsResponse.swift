import Foundation
struct GetSDKParamsResponse: Codable {
    let accountId: Int?
    let accountName: String?
    let eventsEnabled: Bool
    let inboxEnabled: Bool
    let inAppEnabled: Bool
    let subscriptionEnabled: Bool
    let inAppFetchIntervalInMin: Int?
    let inAppMinSecBetweenMessages:Int?
}
