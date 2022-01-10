import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postDescriptionLabel: UILabel!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(with post:Post) ->UITableViewCell {
        postTitleLabel.text = post.title
        postDescriptionLabel.text = post.description
        userNameLabel.text = post.user.name
        postImageView.loadImageUsingCache(with: post.imageUrl)
        userImageView.loadImageUsingCache(with: post.user.imageUrl )
        return self
    }
    override func prepareForReuse() {
        userImageView.image = nil
        postImageView.image = nil
    }
}
