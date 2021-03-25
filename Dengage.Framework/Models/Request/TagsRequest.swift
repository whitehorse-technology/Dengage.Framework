import Foundation
struct TagsRequest: APIRequest {

    typealias Response = EmptyResponse

    let method: HTTPMethod = .post
    let baseURL: String = SUBSCRIPTION_SERVICE_URL
    let path: String = "/api/setTags"
    let queryParameters: [URLQueryItem] = []
    
    var httpBody: Data? {
        let parameters = ["accountName": accountName,
                                  "key": key,
                                  "tags": tags] as [String : Any]
        return parameters.json
    }

    let accountName: String
    let key:String
    let tags:[[String:String]]
}


