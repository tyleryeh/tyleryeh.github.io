//
//  LogInViewController.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2020/12/18.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST
import GTMSessionFetcher
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import AuthenticationServices

//let clientID = "183366530677-6pg0g8496n2027g3dkd38ij2vplpk284.apps.googleusercontent.com"
//let clientID = "488237529686-mfvarsr47dfjkskllsjfc6u1982imml2.apps.googleusercontent.com"
let clientID = "433968265446-vrr65td107hqh9224bl80n0jj68e6llo.apps.googleusercontent.com"

protocol LogInViewControllerDelegate: class {
    func fbDidLogIn(email: String)
    func appleDidLonIn(name: String, email: String)
}

class LogInViewController: UIViewController {
    
    let googleSignIn = GIDSignIn.sharedInstance()
    var fbuserID: String = ""
    var fbname: String?
    var fbmail: String = ""
    var fbBD: String = ""
    
    var delegate: LogInViewControllerDelegate?

    @IBOutlet weak var facebookSignIn: FBLoginButton!
    @IBOutlet weak var googleLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "077ColdEvening"))
        //Prepare for Google SignIn
        googleSignIn?.delegate = self
        //kGTLRAuthScopeDriveFile: 只有app上傳的才看得到
        googleSignIn?.scopes = [kGTLRAuthScopeDriveFile]//登入條件權限
        googleSignIn?.clientID = clientID
        
        //恢復之前登入狀態
        googleSignIn?.restorePreviousSignIn()
        
        self.facebookSignIn.permissions = ["public_profile","email"]
        self.facebookSignIn.delegate = self

        Profile.enableUpdatesOnAccessTokenChange(true)
        NotificationCenter.default.addObserver(self, selector: #selector(updataProfile), name: .ProfileDidChange, object: nil)
        
        self.updataProfile()
        
        
    }
    @objc func updataProfile() {
        if let profile = Profile.current{
//            self.profileView.profileID = profile.userID
//            self.textLabel.text = profile.name
            fbuserID = profile.userID
            fbname = profile.name ?? "N/A"
        }
        requestOtherInfo()
    }
    //email,birthday
    func requestOtherInfo() {
        if AccessToken.current != nil {
            let request = GraphRequest(graphPath: "me",
                                       parameters: ["fields":"birthday,email"])
            request.start { (connect, result, error) in
                let info = result as! Dictionary<String,AnyObject>
                if let email = info["email"] {
                    self.fbmail = String(describing: email)
                    SubFunctions.shared.userEmail = String(describing: email)
                    self.delegate?.fbDidLogIn(email: self.fbmail)
                }
                if let birthday = info["birthday"] {
                    print("\(birthday)")
                    self.fbBD = String(describing:birthday)
                }
            }
        }
    }
    //Apple Sing In
    @IBAction func appleSingIn(_ sender: Any) {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
        
    }
    
    
    @IBAction func googleSignBtn(_ sender: Any) {
        guard let canAuthorize = googleSignIn?.currentUser?.authentication?.fetcherAuthorizer()?.canAuthorize else {
            launchSignIn()
            return
        }
        if canAuthorize{
            //Start to use GDrive functions.
            
        }else{
            //Launch SignIn.
            launchSignIn()
        }
    }
    @IBAction func googleLogOutBtn(_ sender: Any) {
        googleSignIn?.signOut()
    }
    func launchSignIn(){
        googleSignIn?.presentingViewController = self
        googleSignIn?.signIn()
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension LogInViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("failed!")
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let credentials as ASAuthorizationAppleIDCredential:
            if let firstName = credentials.fullName?.givenName,
               let lastName = credentials.fullName?.familyName,
               let userEmail = credentials.email {
                let name = lastName + firstName
                self.delegate?.appleDidLonIn(name: name, email: String(describing: userEmail))
            } else {
                print("TrainsError!")
            }
            break
        default:
            break
        }
    }
}
extension LogInViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
    
    
}

extension LogInViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        fbname = ""
        fbBD = ""
        fbmail = ""
        fbuserID = ""
    }
    



}

extension LogInViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error{
            print("\(error)")
            return
        }
        let userID = user.userID ?? "n/a"
        let name = user.profile.name ?? "n/a"
        let email = user.profile.email ?? "n/a"
        //profile hasImage = 大頭貼
        print(userID)
        print(name)
        print(email)
    }
    
    
}
