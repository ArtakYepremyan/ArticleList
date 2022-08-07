//
//  Article.swift
//  ArticleList
//
//  Created by Artak Yepremyan on 05.08.22.
//

import Foundation

struct Article: Codable {
    let title: String
    let description: String
    let publishedDate: Date
    let url: URL?
    let imageURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case description = "description"
        
        case publishedDate = "publishedAt"
        case imageURL = "urlToImage"
        case url = "url"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let urlStr = try values.decode(String.self, forKey: .url)
        url = URL(string: urlStr)
        let imageUrlStr = try values.decode(String.self, forKey: .imageURL)
        imageURL = URL(string: imageUrlStr)
        title = try values.decode(String.self, forKey: .title)
        description = try values.decode(String.self, forKey: .description)
        let dateString = try values.decode(String.self, forKey: .publishedDate)
        publishedDate = dateString.toDateShortFormat() ?? Date()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(publishedDate.toStringShortFormat(), forKey: .publishedDate)
        try container.encodeIfPresent(imageURL?.absoluteString, forKey: .imageURL)
        try container.encodeIfPresent(url?.absoluteString, forKey: .url)
    }
    
    init(title: String, description: String, date: String, url: String, imageUrl: String) {
        //I use this initializer for creating objects from xml
        self.title = title
        self.description = description
        self.publishedDate = date.toDateLongFormat() ?? Date()
        self.imageURL = URL(string: imageUrl)
        self.url = URL(string: url)
    }
}
