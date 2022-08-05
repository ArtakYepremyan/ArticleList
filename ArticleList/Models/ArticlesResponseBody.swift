//
//  ArticlesResponseBody.swift
//  ArticleList
//
//  Created by Artak Yepremyan on 05.08.22.
//

import Foundation

struct ArticlesResponseBody: Codable {
    let articles: [Article]
}
