import UIKit
import Firebase

class LandingViewController: UIViewController {
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var perfumeLable: UILabel!
    @IBOutlet weak var emailLabel: UILabel!{
        didSet{
            emailLabel.text = "email".localized
        }
    }
    @IBOutlet weak var passwordLabel: UILabel!{
        didSet{
            passwordLabel.text = "password".localized
        }
    }
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var languageSegmentControk: UISegmentedControl!{
        didSet{
            if let lang = UserDefaults.standard.string(forKey: "currentLanguage") {
                switch lang {
                case "ar":
                    languageSegmentControk.selectedSegmentIndex = 0
                case "en":
                    languageSegmentControk.selectedSegmentIndex = 1
                default:
                    let localLang = Locale.current.languageCode
                    if localLang == "ar" {
                        languageSegmentControk.selectedSegmentIndex = 0
                    }else {
                        languageSegmentControk.selectedSegmentIndex = 1
                    }
                }
            }else {
                let localLang = Locale.current.languageCode
                if localLang == "ar" {
                    languageSegmentControk.selectedSegmentIndex = 0
                }else {
                    languageSegmentControk.selectedSegmentIndex = 1
                }
            }
        }
    }
    let activityIndicator = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "backButton".localized, style: .plain, target: nil, action: nil)
        perfumeLable.text = "perfume".localized
        loginButton.setTitle("login".localized, for: .normal)
        registerButton.setTitle("register".localized, for: .normal)
        
    }
    @IBAction func logInPressed(_ sender: Any) {
        if let email = emailTextField.text,
           let password = passwordTextField.text {
            Activity.showIndicator(parentView: self.view, childView: activityIndicator)
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let _ = authResult {
                    if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNavigationController") as? UINavigationController {
                        vc.modalPresentationStyle = .fullScreen
                        Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    @IBAction func languageChanged(_ sender: UISegmentedControl) {
        if let lang = sender.titleForSegment(at:sender.selectedSegmentIndex)?.lowercased() {
            UserDefaults.standard.set(lang, forKey: "currentLanguage")
            Bundle.setLanguage(lang)
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate {
                sceneDelegate.window?.rootViewController = storyboard.instantiateInitialViewController()
            }
        }
    }
}
