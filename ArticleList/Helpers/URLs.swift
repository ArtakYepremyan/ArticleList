//
//  URLs.swift
//  ArticleList
//
//  Created by Artak Yepremyan on 05.08.22.
//

import Foundation

struct URLs {
    static let articlesFeedUrl = URL(string: "http://feeds.bbci.co.uk/news/video_and_audio/technology/rss.xml")!
    static let articlesUrl = URL(string: "https://newsapi.org/v2/top- headlines?sources=techcrunch&apiKey=97ba815035ae4381b223377b2df975ab")!
}
