//
//  ArticleFeedParser.swift
//  ArticleList
//
//  Created by Artak Yepremyan on 05.08.22.
//

import Foundation

class ArticleFeedParser: NSObject {
    private var rssItems: [Article] = []
    private var currentElement = ""
    private var currentTitle: String = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentDescription: String = "" {
        didSet {
            currentDescription = currentDescription.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentPubDate: String = "" {
        didSet {
            currentPubDate = currentPubDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentArticleUrl: String = "" {
        didSet {
            currentArticleUrl = currentArticleUrl.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentArticleImageUrl: String = "" {
        didSet {
            currentArticleImageUrl = currentArticleImageUrl.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var parserComplitionHandler: ((Result<[Article], ALError>) -> ())?
    
    
    func parseFeed(data: Data, completionHandler: @escaping (Result<[Article], ALError>) -> ()) {
        self.rssItems = []
        self.parserComplitionHandler = completionHandler
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }
    
    
    
}

// MARK: - XML Parser Delegate -
extension ArticleFeedParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentElement = elementName
        
        if currentElement == "item" {
            currentTitle = ""
            currentDescription = ""
            currentPubDate = ""
            currentArticleImageUrl = ""
            currentArticleUrl = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        switch currentElement {
        case "title":
            currentTitle += string
        case "description":
            currentDescription += string
        case "pubDate":
            currentPubDate += string
        case "link":
            currentArticleUrl += string
        case "imageLink":
            currentArticleImageUrl += string
        default :
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "item" {
            let article = Article(title: currentTitle, description: currentDescription, date: currentPubDate, url: currentArticleUrl, imageUrl: currentArticleImageUrl)
            self.rssItems.append(article)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parserComplitionHandler?(.success(rssItems))
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        parserComplitionHandler?(.failure(.parsing(error: parseError)))
    }
}


