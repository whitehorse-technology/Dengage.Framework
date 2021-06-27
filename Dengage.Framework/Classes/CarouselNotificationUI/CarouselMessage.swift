//
//  CarouselMessage.swift
//  Dengage.Framework
//
//  Created by Nahit Rustu Heper on 27.06.2021.
//

import Foundation
struct CarouselMessage: Decodable{
    let image: String?
    let title: String?
    let description: String?
    
    init?(with dictionary:NSDictionary){
        image = dictionary["mediaUrl"] as? String
        title = dictionary["title"] as? String
        description = dictionary["desc"] as? String
        guard image != nil && title != nil else { return nil }
    }
}
