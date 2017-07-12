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

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var logoLabel: UILabel!
    override func viewDidLoad() {
        let fbLoginButton = FBSDKLoginButton()
        self.view.addSubview(fbLoginButton)

        let topConstraint = NSLayoutConstraint(item: fbLoginButton, attribute: .top, relatedBy: .equal, toItem: logoLabel, attribute: .bottom, multiplier: 1, constant: 30)
        let leftConstraint = NSLayoutConstraint(item: fbLoginButton, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 20)
        let rightConstraint = NSLayoutConstraint(item: fbLoginButton, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -20)
        let heightConstraint = NSLayoutConstraint(item: fbLoginButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 40)
        
        self.view.addConstraints([topConstraint, leftConstraint, rightConstraint, heightConstraint])
        self.view.updateConstraints()
        fbLoginButton.translatesAutoresizingMaskIntoConstraints = false
        
        fbLoginButton.delegate = self
        fbLoginButton.readPermissions = ["email", "public_profile"]

    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }

        loginToFirebase()
        print("Successfully Login")
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did logout!!!")
    }
    
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
                print("User is : ", user)
            }
            let listViewController: ListViewController = self.storyboard?.instantiateViewController(withIdentifier: "GroceryListViewController") as! ListViewController
            self.navigationController?.pushViewController(listViewController, animated: true)
        })
    }
}
