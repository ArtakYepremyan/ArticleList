//
//  ArticleImageTableViewCell.swift
//  ArticleList
//
//  Created by Artak Yepremyan on 05.08.22.
//

import UIKit
import Nuke

class ArticleImageTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(article: Article) {
        self.titleLabel.text = article.title
        self.descriptionLabel.text = article.description
        Nuke.loadImage(with: article.imageURL, into: articleImageView)
    }
}
