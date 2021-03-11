import Foundation
struct InAppMessage: Codable{
    let id: String
    let data: InAppMessageData
    var nextDisplayTime: Double?
    
    enum CodingKeys: String, CodingKey {
        case id = "smsg_id", data = "message_json", nextDisplayTime = "nextDisplayTime"
    }
}

struct InAppMessageData: Codable{
        let messageId: Int
        let messageDetails: String?
        let expireDate: String
        let priority: Priority
        let dengageSendId: Int
        let dengageCampId: Int
        let content: Content
        let displayCondition: DisplayCondition
        let displayTiming: DisplayTiming
}

struct Content: Codable {
    let type: ContentType
    let props: ContentParams
}

extension InAppMessage: Equatable {
    static func == (lhs: InAppMessage, rhs: InAppMessage) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Array where Element == InAppMessage {
    var sorted:[InAppMessage]{
        return (self as NSArray).sortedArray(comparator: { first, second -> ComparisonResult in
            guard let first = first as? InAppMessage else {return .orderedSame}
            guard let second = second as? InAppMessage else {return .orderedSame}
            guard first.data.priority == second.data.priority else {
                return first.data.priority.rawValue < second.data.priority.rawValue ? .orderedAscending : .orderedDescending
            }
            guard let firstExpireDate = Utilities.convertDate(to: first.data.expireDate) else {return .orderedSame}
            guard let secondExpireDate = Utilities.convertDate(to: first.data.expireDate) else {return .orderedSame}
            return firstExpireDate.compare(secondExpireDate)

        }) as? [InAppMessage] ?? []
    }
}

