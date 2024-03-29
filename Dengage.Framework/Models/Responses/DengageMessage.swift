import Foundation

@objc public class DengageMessage: NSObject, Codable {

    public let id: String
    public let title: String?
    public let message: String?
    public let mediaURL: String?
    public let targetURL: String?
    public let receiveDate: Date?
    public var isClicked: Bool
    public let carouselItems: [CarouselItem]?
    
    required public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        isClicked = try container.decode(Bool.self, forKey: .isClicked)
        carouselItems = try? container.decode([CarouselItem].self, forKey: .carouselItems)
        let messageJson = try container.decode(String.self, forKey: .message)
        let data = Data(messageJson.utf8)
        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        self.title = json["title"] as? String
        self.message = json["message"] as? String
        let iosMediaUrl = json["iosMediaUrl"] as? String
        self.mediaURL = iosMediaUrl ?? json["mediaUrl"] as? String
        let iosTargetUrl = json["iosTargetUrl"] as? String
        self.targetURL = iosTargetUrl ?? json["targetUrl"] as? String
        let receiveDateString = json["receiveDate"] as! String
        self.receiveDate = Utilities.convertDate(to: receiveDateString)
        
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "smsg_id", isClicked = "is_clicked", message = "message_json", carouselItems = "iosCarouselContent"
    }
}


