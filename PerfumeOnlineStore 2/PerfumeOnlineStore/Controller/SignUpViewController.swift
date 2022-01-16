import UIKit
import Firebase

class SignUpViewController: UIViewController {
    let imagePickerController = UIImagePickerController()
    var activityIndicator = UIActivityIndicatorView()
    @IBOutlet weak var registerButton: UIButton!
    

    @IBOutlet weak var errorLable: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView! {
        didSet {
            userImageView.layer.borderColor = UIColor.systemGray.cgColor
            userImageView.layer.borderWidth = 3.0
            userImageView.layer.cornerRadius = userImageView.bounds.height / 2
            userImageView.layer.masksToBounds = true
            userImageView.isUserInteractionEnabled = true
            let tabGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
            userImageView.addGestureRecognizer(tabGesture)
        }
    }
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    //localition
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var mobileLable: UILabel!
    @IBOutlet weak var emailLable: UILabel!
    @IBOutlet weak var passowrdLable: UILabel!
    @IBOutlet weak var confirmPasswordLable: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "backButton".localized, style: .plain, target: nil, action: nil)
        registerButton.setTitle(NSLocalizedString("Register", comment: ""), for: .normal)
        nameLable.text = "name".localized
        mobileLable.text = "mobile".localized
        emailLable.text = "email".localized
        passowrdLable.text = "password".localized
        confirmPasswordLable.text = "confirmPassword".localized
        
        
        // Do any additional setup after loading the view.
        imagePickerController.delegate = self
    }
    
    @IBAction func handleRegister(_ sender: Any) {
        if let image = userImageView.image,
           let imageData = image.jpegData(compressionQuality: 0.75),
           let name = nameTextField.text,
           let mobile = mobileTextField.text,
           let email = emailTextField.text,
           let password = passwordTextField.text,
           let confirmPassword = confirmPasswordTextField.text,
           password == confirmPassword {
            Activity.showIndicator(parentView: self.view, childView: activityIndicator)
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                
                if let error = error{
                self.errorLable.text = error.localizedDescription
                Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                }
         //       if let error = error {
          //          print("Registration Auth Error",error.localizedDescription)
           //         Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
             //   }
                if let authResult = authResult {
                    let storageRef = Storage.storage().reference(withPath: "users/\(authResult.user.uid)")
                    let uploadMeta = StorageMetadata.init()
                    uploadMeta.contentType = "image/jpeg"
                    storageRef.putData(imageData, metadata: uploadMeta) { storageMeta, error in
                        if let error = error{
                            print("Registration Storage Error",error.localizedDescription)
                        }
                        storageRef.downloadURL { url, error in
                            if let error = error {
                                print("Registration Storage Download Url Error",error.localizedDescription)
                            }
                            if let url = url {
                                print("URL",url.absoluteString)
                                let db = Firestore.firestore()
                                let userData: [String:String] = [
                                    "id":authResult.user.uid,
                                    "name":name,
                                    "mobile":mobile,
                                    "email":email,
                                    "imageUrl":url.absoluteString
                                ]
                                db.collection("users").document(authResult.user.uid).setData(userData) { error in
                                    if let error = error {
                                        print("Registration Database error",error.localizedDescription)
                                    }else {
                                        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNavigationController") as? UINavigationController {
                                            vc.modalPresentationStyle = .fullScreen
                                            Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                                            self.present(vc, animated: true, completion: nil)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }else{
            if passwordTextField.text != confirmPasswordTextField.text!{
                errorLable.text = "Password Not Corecct".localized
            }else{
                errorLable.text = "Empty Information"
            }
        }
    }
}
extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @objc func selectImage() {
        showAlert()
    }
    func showAlert() {
        let alert = UIAlertController(title: "choose Profile Picture", message: "where do you want to pick your image from?", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { Action in
            self.getImage(from: .camera)
        }
        let galaryAction = UIAlertAction(title: "photo Album", style: .default) { Action in
            self.getImage(from: .photoLibrary)
        }
        let dismissAction = UIAlertAction(title: "Cancle", style: .destructive) { Action in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cameraAction)
        alert.addAction(galaryAction)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
    }
    func getImage( from sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return}
        userImageView.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
