//
//  ArticleTableViewCell.swift
//  ArticleList
//
//  Created by Artak Yepremyan on 05.08.22.
//

import UIKit
import Nuke

class ArticleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(article: Article) {
        self.titleLabel.text = article.title
        self.descriptionLabel.text = article.description
    }
    
}
