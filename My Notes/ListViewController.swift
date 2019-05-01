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
    @IBOutlet weak var checkedOff: UITableViewCell!
    
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
            
            let df = DateFormatter()
            df.dateFormat = "MM/dd/yy hh:mm"
            let strDate = df.string(from: note?.date ?? Date())
            
            var strImp : String
            
            if(note?.importance == 3){
                strImp = "High"
            }
            else if(note?.importance == 2){
                strImp = "Medium"
            }
            else{
                strImp = "Low"
            }
            
            cell.detailTextLabel?.text = "Created: \(strDate) Importance: \(strImp)" //String(note?.date)
            cell.accessoryType = UITableViewCell.AccessoryType.none
            return cell
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Uncomment the following line to preserve selection between presentations
            // self.clearsSelectionOnViewWillAppear = false
            // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
            // self.navigationItem.rightBarButtonItem = self.editButtonItem
        }
        
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                // Delete the row from the data source
                let note = notes[indexPath.row] as? Note
                let context = appDelegate.persistentContainer.viewContext
                context.delete(note!)
                do {
                    try context.save()
                }
                catch {
                    fatalError("Error saving context: \(error)")
                }
                loadDataFromDatabase()
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else if editingStyle == .insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            }
        }
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "EditNote" {
                let noteController = segue.destination as? NoteViewController
                //         let selectedRow = self.tableView.indexPathForSelectedRow?.row
                let selectedRow = self.tableView.indexPath(for: sender as! UITableViewCell)?.row
                
                let selectedNote = notes[selectedRow!] as? Note
                noteController?.currentNote = selectedNote!
            }
        }
        
}
