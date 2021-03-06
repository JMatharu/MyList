//
//  LoginViewController.swift
//  Grocery
//
//  Created by Jagdeep Matharu on 2017-07-09.
//  Copyright © 2017 Jagdeep Matharu. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import Firebase
import SwiftSpinner

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var logoLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fbLoginButton = FBSDKLoginButton()
        
        logoLabel.font = logoLabel.font.withSize(self.view.frame.height * 0.090)
        
        createSignInButton(loginButton: fbLoginButton)
    }
    
    // MARK: - Facebook Login
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }

        loginToFirebase()
        print("Successfully Login")
        // Spinner
        _ = SwiftSpinner.init(title: Constants.Spinner.TitleLogin)

    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did logout!!!")
        
        UserDefaults.standard.set(false, forKey: Constants.UserDefaults.IsUserLoggedIn)
    }
    
    // MARK: - Firebase Login
    func loginToFirebase() {
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else {
            return
        }
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if let e = error {
                print(e)
                return
            }
            if let user = user {
                UserDefaults.standard.set(true, forKey: Constants.UserDefaults.IsUserLoggedIn)
                UserDefaults.standard.set(user.uid, forKey: Constants.UserDefaults.UID)
            }
            // To push controller in Navigation Controller
            // let listViewController: ListViewController = self.storyboard?.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
            // self.navigationController?.pushViewController(listViewController, animated: true)
            
            // To push controller with segue
            self.performSegue(withIdentifier: "LoadingScreen", sender: nil)
        })
    }
    
    func createSignInButton(loginButton: Any)  {
        if let fbLoginButton = loginButton as? FBSDKLoginButton {
            self.view.addSubview(fbLoginButton)
            
            let topConstraint = NSLayoutConstraint(item: fbLoginButton, attribute: .top, relatedBy: .equal, toItem: logoLabel, attribute: .bottom, multiplier: 1, constant: Constants.UIDimentions.ButtonTopPadding)
            let leftConstraint = NSLayoutConstraint(item: fbLoginButton, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: Constants.UIDimentions.ButtonLeftPadding)
            let rightConstraint = NSLayoutConstraint(item: fbLoginButton, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: Constants.UIDimentions.ButtonRightPadding)
            let heightConstraint = NSLayoutConstraint(item: fbLoginButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: Constants.UIDimentions.ButtonHeight)
            
            self.view.addConstraints([topConstraint, leftConstraint, rightConstraint, heightConstraint])
            self.view.updateConstraints()
            fbLoginButton.translatesAutoresizingMaskIntoConstraints = false
            
            fbLoginButton.setAttributedTitle(NSAttributedString(string: Constants.Titles.FacebookButton), for: .normal)
            
            fbLoginButton.delegate = self
            fbLoginButton.readPermissions = [Constants.UserPermissions.Email, Constants.UserPermissions.PublicProfile]
        }

    }
}
