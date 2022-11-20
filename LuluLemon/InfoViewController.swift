//
//  InfoViewController.swift
//  LuluLemon
//
//  Created by Ronald Jones on 11/19/22.
//

import UIKit
import CoreData

class InfoViewController: UIViewController{
    
    @IBOutlet weak var txtField: UITextField!
    var newGarment = [Garment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtField.layer.borderWidth = 1.0
        txtField.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func save(_ sender: Any) {
        if let newTitle = txtField.text {
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
                let garment = Garment(context: managedContext)
                garment.setValue(Date(), forKey: #keyPath(Garment.dateCreated))
                garment.setValue(newTitle, forKey: #keyPath(Garment.title))
                self.newGarment.insert(garment, at: 0)
                AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "saved"), object: nil)
            self.dismiss(animated: true)
        }
        else {
            let alert = UIAlertController(title: "Oops", message: "You need to put a name", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .cancel)
            alert.addAction(ok)
            self.present(alert, animated: true)
        }
    }
}

extension NSNotification.Name {
    static let globalVariableChanged = NSNotification.Name(Bundle.main.bundleIdentifier! + ".saved")
}
