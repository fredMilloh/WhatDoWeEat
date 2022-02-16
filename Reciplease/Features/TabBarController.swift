//
//  ViewController.swift
//  Reciplease
//
//  Created by fred on 05/02/2022.
//

import UIKit

class TabBarController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension TabBarController : AlertDelegate {


    func presentAlert(message alertError: RecipeError) {

        let alert = UIAlertController(
            title: "",
            message: "\(alertError.localizedDescription)",
            preferredStyle: .alert
        )
        let errorAction = UIAlertAction(
            title: "ok",
            style: .cancel
        )
        alert.addAction(errorAction)
        present(alert, animated: true)
    }

    func AskConfirmation (completion:@escaping (_ result:Bool) -> Void) {
        let alert = UIAlertController(
            title: "Are you sure ?",
            message: "Delete this element",
            preferredStyle: .actionSheet)
        self.present(alert, animated: true, completion: nil)

        alert.addAction(UIAlertAction(
            title: "delete",
            style: .destructive,
            handler: { action in
            completion(true)
        }))

        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: { action in
            completion(false)
        }))
      }

    func presentInfo(message alertInfo: String) {

        let alert = UIAlertController(
            title: "",
            message: "",
            preferredStyle: .alert
        )
        let errorAction = UIAlertAction(
            title: "ok",
            style: .cancel
        )
        alert.addAction(errorAction)
        present(alert, animated: true)
    }
}
