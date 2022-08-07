//
//  FileManager + documents.swift
//  ArticleList
//
//  Created by Artak Yepremyan on 07.08.22.
//

import Foundation

extension FileManager {
    func documentsDirectory() -> URL? {
        let urls = self.urls(for: .documentDirectory, in: .userDomainMask)
        return urls.first
    }
}
