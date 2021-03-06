import UIKit
import Firebase

class DetailsViewController: UIViewController {
    var selectedPost:Post?
    var selectedPostImage:UIImage?
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var descriptionLable: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var numberLable: UILabel!
    @IBOutlet weak var postDescriptionLabel: UITextView!
    
    @IBOutlet weak var mobileNumber: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionLable.text = "description".localized
        numberLable.text = "number1".localized
        titleLable.text = "title".localized
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "backButton".localized, style: .plain, target: nil, action: nil)
        if let selectedPost = selectedPost,
           let selectedImage = selectedPostImage {
            postTitleLabel.text = selectedPost.title
            postDescriptionLabel.text =
            selectedPost.description
            postImageView.image = selectedImage
            mobileNumber.text = selectedPost.user.number
        }
    }
}
