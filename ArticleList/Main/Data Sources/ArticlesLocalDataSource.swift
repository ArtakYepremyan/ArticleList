//
//  ArticlesLocalDataSource.swift
//  ArticleList
//
//  Created by Artak Yepremyan on 07.08.22.
//

import Foundation
import AEXML

struct ArticlesLocalDataSource: ArticlesLocalDataSourceProtocol {
        
    func save(items: [Article], format: DataFormat) {
        switch format {
        case .xml:
            UserDefaults.standard.set(true, forKey: Constants.kArticlesSavedXml)
            saveItemsToXml(articles: items)
        case .json:
            UserDefaults.standard.set(false, forKey: Constants.kArticlesSavedXml)
            saveItemsToJson(articles: items)
        }
    }
    
    func get(completionHandler: @escaping CompletionHandler) {
        let manager = FileManager.default
        guard let documentDirectoryUrl = manager.documentsDirectory() else {return}
        let xmlFileUrl = documentDirectoryUrl.appendingPathComponent("Articles.xml")
        let jsonFileUrl = documentDirectoryUrl.appendingPathComponent("Articles.json")
        
        if UserDefaults.standard.bool(forKey: Constants.kArticlesSavedXml) {
            getSavedXmlItems(url: xmlFileUrl) { result in
                completionHandler(result)
            }
        } else {
            getSavedJsonItems(url: jsonFileUrl) { result in
                completionHandler(result)
            }
        }
    }
    
    
    private func getSavedXmlItems(url: URL, completion: @escaping CompletionHandler) {
        do {
            let data = try Data(contentsOf: url)
            let parser = ArticleFeedParser()
            parser.parseFeed(data: data) { result in
                completion(result)
            }
        }
        catch {
            print(error)
            completion(.failure(.unknown))
        }
    }
    
    private func getSavedJsonItems(url: URL, completion: @escaping CompletionHandler) {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let articles = try decoder.decode([Article].self, from: data)
            completion(.success(articles))
        }
        catch {
            print(error)
            completion(.failure(.unknown))
        }
    }
    
    private func saveItemsToXml(articles: [Article]) {
        let document = AEXMLDocument()
        let items = document.addChild(name: "items")
        
        for article in articles {
            let xmlItem = items.addChild(name: "item")
            xmlItem.addChild(name: "title", value: article.title)
            xmlItem.addChild(name: "description", value: article.description)
            xmlItem.addChild(name: "link", value: article.url?.absoluteString ?? "")
            xmlItem.addChild(name: "imageLink", value: article.imageURL?.absoluteString ?? "")
            xmlItem.addChild(name: "pubDate", value: article.publishedDate.toStringLongFormat())
        }
        let manager = FileManager.default
        guard let documentsUrl = manager.documentsDirectory() else {return}
        let fileURL = documentsUrl.appendingPathComponent("Articles.xml")
        let data = document.xmlCompact.data(using: .utf8)
        if manager.fileExists(atPath: fileURL.path) {
            try? manager.removeItem(atPath: fileURL.path)
        }
        manager.createFile(atPath: fileURL.path, contents: data)
    }
    
    private func saveItemsToJson(articles: [Article]) {
        
        let encoder = JSONEncoder()
        let data = try? encoder.encode(articles)
        let manager = FileManager.default
        guard let documentsUrl = manager.documentsDirectory() else {return}
        let fileURL = documentsUrl.appendingPathComponent("Articles.json")
        if manager.fileExists(atPath: fileURL.path) {
            try? manager.removeItem(atPath: fileURL.path)
        }
        manager.createFile(atPath: fileURL.path, contents: data)
    }
}
