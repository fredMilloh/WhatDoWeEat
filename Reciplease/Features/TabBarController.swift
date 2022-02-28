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

extension TabBarController: AlertDelegate {

    func presentAlert(message: String) {
        let alert = UIAlertController(
            title: "",
            message: message,
            preferredStyle: .alert
        )
        let errorAction = UIAlertAction(
            title: "Ok",
            style: .cancel
        )
        alert.addAction(errorAction)
        present(alert, animated: true)
    }

    func presentDeletePopUp(deleteAction completion: @escaping () -> Void) {
        let alert = UIAlertController(
            title: "Are you sure ?",
            message: "Delete this element",
            preferredStyle: .actionSheet
        )

        alert.addAction(UIAlertAction(
            title: "Delete",
            style: .destructive,
            handler: { _ in completion() }
        ))

        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: { _ in self.dismiss(animated: true) }
        ))

        self.present(alert, animated: true, completion: nil)
      }

    func presentInfo(message alertInfo: String) {
        let alert = UIAlertController(
            title: "",
            message: alertInfo,
            preferredStyle: .alert
        )
        self.present(alert, animated: true)

        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
