//
//  ArticleTableViewCell.swift
//  ArticleList
//
//  Created by Artak Yepremyan on 05.08.22.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(article: Article) {
        self.titleLabel.text = article.title
        self.descriptionLabel.text = article.description
        if article.imageURL == nil {
            articleImage.isHidden = true
        } else {
            articleImage.isHidden = false
        }
    }
    
}
