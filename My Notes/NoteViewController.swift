//
//  NoteViewController.swift
//  MyNotes
//
//  Created by Teddy Hoff on 4/19/19.
//  Copyright © 2019 TBA. All rights reserved.
//

import UIKit
import CoreData

class NoteViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate{

    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtContent: UITextView!
    @IBOutlet weak var pckImportance: UIPickerView!
    @IBOutlet weak var btnSave: UIBarButtonItem!
    
    var content = "content"
    
    var currentNote: Note?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtContent.delegate = self
        if(currentNote != nil) {
            txtTitle.text = currentNote!.title
            txtContent.text = currentNote!.content
            //TODO: make the importance picker set to importance
        }
        
        txtTitle.addTarget(self,
                                action: #selector(UITextFieldDelegate.textFieldShouldEndEditing(_:)),
                                for: UIControl.Event.editingDidEnd)
        
       /* txtContent.addTarget(self,
                           action: #selector(UITextViewDelegate.textViewShouldEndEditing(_:)),
                           for: UIControl.Event.editingDidEnd) */
        
        // Do any additional setup after loading the view. 
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        saveContact()
    }
    
    func textViewDidChange(_ textView: UITextView){
        print("entered text:\(textView.text)")
        content = textView.text
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        currentNote?.title = txtTitle.text
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        currentNote?.content = txtContent.text
        return true
    }
    
    func saveContact() {
        if currentNote == nil {
            let context = appDelegate.persistentContainer.viewContext
            currentNote = Note(context: context)
        }
        appDelegate.saveContext()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
