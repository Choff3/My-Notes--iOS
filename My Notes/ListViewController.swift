//
//  ListViewController.swift
//  MyNotes
//
//  Created by Teddy Hoff on 4/19/19.
//  Copyright © 2019 TBA. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UITableViewController {

    @IBOutlet weak var sgmtSort: UISegmentedControl!
    var notes:[NSManagedObject] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func changeSort(_ sender: Any) {
        
        let settings = UserDefaults.standard
        
        if(sgmtSort.selectedSegmentIndex == 1){
            settings.set("importance", forKey: "sortField")
        }
        else{
            settings.set("date", forKey: "sortField")
        }
        
        settings.synchronize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //set the UI based on values in UserDefaults
        
        self.loadDataFromDatabase()
        tableView.reloadData()
        
    }
    
    func loadDataFromDatabase() {
        //Read settings to enable sorting
        let settings = UserDefaults.standard
        let sortField = settings.string(forKey: "sortField")
        if sortField == "importance"{
            sgmtSort.selectedSegmentIndex = 1
        }
        //Set up Core Data Context
        let context = appDelegate.persistentContainer.viewContext
        //Set up Request
        let request = NSFetchRequest<NSManagedObject>(entityName: "Note")
        //Specify sorting
    /*    let sortDescriptor = NSSortDescriptor(coder: sortField)
        let sortDescriptorArray = [sortDescriptor]
        //to sort by multiple fields, add more sort descriptors to the array
        request.sortDescriptors = sortDescriptorArray */
        //Execute request
        do {
            notes = try context.fetch(request)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotesCell", for: indexPath)
        
        // Configure the cell...
        let note = notes[indexPath.row] as? Note
        cell.textLabel?.text = note?.title
       // cell.detailTextLabel?.text = String(note?.date)
        cell.accessoryType = UITableViewCell.AccessoryType.detailDisclosureButton
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
