
struct MarkAsInAppMessageClickedRequest: APIRequest{
    
    typealias Response = EmptyResponse

    let method: HTTPMethod = .get
    let baseURL: String = SUBSCRIPTION_SERVICE_URL
    let path: String = "/api/inapp/setAsClicked"

    let httpBody: Data? = nil
    
    var queryParameters: [URLQueryItem] {
        var parameters = [
            URLQueryItem(name: "acc", value: accountName),
            URLQueryItem(name: "cdkey", value: contactKey),
            URLQueryItem(name: "message_details", value: id),
            URLQueryItem(name: "did", value: deviceID),
            URLQueryItem(name: "type", value: type)
        ]
        if let buttonId = buttonId {
            parameters.append(URLQueryItem(name: "button_id", value: buttonId))
        }
        return parameters
    }
    
    let id: String
    let contactKey: String
    let accountName: String
    let type: String
    let deviceID:String
    let buttonId:String?
    
    init(type: String,
         deviceID:String,
         accountName:String,
         contactKey: String,
         id: String,
         buttonId:String?) {
        self.accountName = accountName
        self.contactKey = contactKey
        self.id = id
        self.type = type
        self.deviceID = deviceID
        self.buttonId = buttonId
    }
}
