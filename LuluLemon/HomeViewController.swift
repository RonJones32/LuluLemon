//
//  HomeViewController.swift
//  LuluLemon
//
//  Created by Ronald Jones on 11/19/22.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var items = [Garment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: "item")
        segmentedControl.addTarget(self, action: #selector(self.segmentChanged(_:)), for: .valueChanged)
        let refreshControls = UIRefreshControl()
        refreshControls.addTarget(self, action: #selector(refr), for: .valueChanged)
        self.tableView.refreshControl = refreshControls
        getGarments()
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: NSNotification.Name("saved"), object: nil)
    }
    
    func getGarments() {
        let fetch: NSFetchRequest<Garment> = Garment.fetchRequest()
            do {
                let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
                let results = try managedContext.fetch(fetch)
                items = results
            } catch let error as NSError {
                print("Fetch error: \(error) description: \(error.userInfo)")
            }
    }

    @IBAction func add(_ sender: Any) {
        let info = InfoViewController()
        self.present(info, animated: true)
    }
    @objc func update() {
        getGarments()
        items.sort { item1, item2 in
            item1.title ?? "" < item2.title ?? ""
        }
        self.tableView.reloadData()
    }
    
    @objc func refr(refreshControl: UIRefreshControl) {
        getGarments()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        if segmentedControl.selectedSegmentIndex == 0 {
            items.sort { item1, item2 in
                item1.title ?? "" < item2.title ?? ""
            }
        } else if segmentedControl.selectedSegmentIndex == 1 {
            items.sort { item1, item2 in
                item1.dateCreated ?? Date() > item2.dateCreated ?? Date()
            }
        }
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "item") as? ItemTableViewCell
        if items.isEmpty {
            cell?.title.text = "Try adding some garments"
        }
        else {
            cell?.title.text = items[indexPath.row].title
        }
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var num = items.count
        if items.isEmpty {
            num = 1
        }
        return num
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       if editingStyle == .delete {
           //delete from coredata
               AppDelegate.sharedAppDelegate.coreDataStack.managedContext.delete(self.items[indexPath.row])
               // Save Changes
            AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
           items.remove(at: indexPath.row)
           tableView.reloadData()
       }
   }

}
