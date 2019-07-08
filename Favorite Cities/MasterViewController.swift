//
//  MasterViewController.swift
//  Favorite Cities
//
//  Created by Nicolas Yepes on 7/8/19.
//  Copyright © 2019 Nicolas Yepes. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var cities = [City]()
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        if let saveData = defaults.object(forKey: "data") as? Data {
            if let decoded = try? JSONDecoder().decode([City].self, from: saveData) {
                cities = decoded
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        tableView.reloadData()
        saveData()
    }
    func saveData () {
        if let encoded = try? JSONEncoder().encode(cities) {
            defaults.set(encoded, forKey: "data")
        }
    }

    @objc
    func insertNewObject(_ sender: Any) {
        let alert = UIAlertController (title: "Add city", message: nil, preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = "City"
        }
        alert.addTextField { (textfield) in
            textfield.placeholder = "State"
        }
        alert.addTextField { (textfield) in
            textfield.placeholder = "Population"
            textfield.keyboardType = .numberPad
        }
        let cancelAction = UIAlertAction (title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        let insertAction = UIAlertAction (title: "Add", style: .default) { (action) in
            let cityTextField = alert.textFields![0] as UITextField
            let stateTextField = alert.textFields![1] as UITextField
            let populationTextField = alert.textFields![2] as UITextField
            guard let image = UIImage(named: cityTextField.text!) else {
                print("Missing \(cityTextField.text!) image")
                    return
                }
                if let population = Int (populationTextField.text!) {
                    let city = City (name:cityTextField.text!, state: stateTextField.text!, population: population, flag: image.pngData()!)
                    self.cities.append(city)
                    self.tableView.reloadData()
                    self.saveData()
                }
            }
        alert.addAction (insertAction)
        present (alert, animated: true, completion: nil)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = cities[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let object = cities[indexPath.row] as! NSDate
        cell.textLabel!.text = object.description
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            cities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let objectToMove = cities.remove(at: sourceIndexPath.row)
        cities.insert(objectToMove, at: destinationIndexPath.row)
        saveData()
    }
}
