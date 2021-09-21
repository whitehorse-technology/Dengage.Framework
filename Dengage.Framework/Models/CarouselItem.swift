//
//  CarouselItem.swift
//  Dengage.Framework
//
//  Created by Nahit Rustu Heper on 23.06.2021.
//

import Foundation
public struct CarouselItem: Decodable{
    public let id: String
    public let title: String
    public let descriptionText: String
    public let mediaUrl: String
    public let targetUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, descriptionText = "desc", mediaUrl, targetUrl
    }
}
