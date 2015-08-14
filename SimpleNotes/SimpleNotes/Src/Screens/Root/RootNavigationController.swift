//
// Created by Maxim Pervushin on 14/08/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class RootNavigationController: UINavigationController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {

    // MARK: - RootNavigationController

    private func showError(description: String) {
        println(description)
    }

    // MARK: - UIViewController

    func logIn() {
        if Parse.authenticated {
            return
        }

        let logInController = PFLogInViewController()
        logInController.delegate = self
        logInController.signUpController?.emailAsUsername = true
        logInController.signUpController?.delegate = self
        presentViewController(logInController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Parse.checkEnabled()

        var dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.01 * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            () -> Void in
            self.logIn()
        })
    }

    // MARK: - PFLogInViewControllerDelegate

    func logInViewControllerDidCancelLogIn(logInController: PFLogInViewController) {
        logInController.dismissViewControllerAnimated(true, completion: nil)
    }

    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        logInController.dismissViewControllerAnimated(true, completion: nil)

    }

    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        var localizedDescription = "Unknown error"
        if let error = error {
            localizedDescription = error.localizedDescription
        }
        showError(localizedDescription)
    }

    // MARK: - PFSignUpViewControllerDelegate

    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        signUpController.dismissViewControllerAnimated(true, completion: nil)
    }

    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        var localizedDescription = "Unknown error"
        if let error = error {
            localizedDescription = error.localizedDescription
        }
        showError(localizedDescription)
    }

    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        signUpController.dismissViewControllerAnimated(true, completion: nil)
    }
}
