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
    
    init(title: String, description: String, date: String, url: String) {
        //I use this initializer for creating objects from xml
        self.title = title
        self.description = description
        self.publishedDate = date.toDateLongFormat() ?? Date()
        self.imageURL = nil //here imageUrl is nil because given api doesn't provide that data
        self.url = URL(string: url)
    }
}
