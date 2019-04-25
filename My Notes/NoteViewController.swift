//
//  NoteViewController.swift
//  MyNotes
//
//  Created by Teddy Hoff on 4/19/19.
//  Copyright © 2019 TBA. All rights reserved.
//

import UIKit
import CoreData

class NoteViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource{

    var currentNote: Note?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let importanceItems: Array<String> = ["Low", "Medium", "High"]
    var importance: Int = 1
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtContent: UITextView!
    @IBOutlet weak var pckImportance: UIPickerView!
    @IBOutlet weak var btnSave: UIBarButtonItem!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pckImportance.dataSource = self
        pckImportance.delegate = self
        self.txtContent.delegate = self
        if(currentNote != nil) {
            txtTitle.text = currentNote!.title
            txtContent.text = currentNote!.content
            appDelegate.saveContext()
            //TODO: make the importance picker set to importance
        }
        else{
            currentNote?.title = "Title"
            txtContent.text = "Content"
            txtContent.textColor = UIColor.lightGray
            currentNote?.importance = 1
            currentNote?.date = Date()
        }
        
        txtTitle.addTarget(self,
                                action: #selector(UITextFieldDelegate.textFieldShouldEndEditing(_:)),
                                for: UIControl.Event.editingDidEnd)
        // Do any additional setup after loading the view. 
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        currentNote?.title = txtTitle.text
        //currentNote?.importance = 1
        currentNote?.date = Date()
        appDelegate.saveContext()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        if currentNote == nil {
            let context = appDelegate.persistentContainer.viewContext
            currentNote = Note(context: context)
        }
        currentNote?.title = txtTitle.text
        currentNote?.content = txtContent.text
        currentNote?.importance = Int64(importance)
        appDelegate.saveContext()
        
        let alert = UIAlertController(title: "Success",
                                      message: "Your note has been saved.",
                                      preferredStyle: UIAlertController.Style.alert)
            
            let cancelAction = UIAlertAction(title: "OK",
                                             style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            UIApplication.shared.keyWindow?.rootViewController!.present(alert, animated: true,
                                                                                                   completion: nil)
        
    }

    // Returns the number of 'columns' to display.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Returns the # of rows in the picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return importanceItems.count
    }
    
    //Sets the value that is shown for each row in the picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int)
        -> String? {
            return importanceItems[row]
    }
    
    //If the user chooses from the pickerview, it calls this function;
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      //  let impField = importanceItems[row]
        currentNote?.importance = Int64(row) + 1
        importance = row + 1
      //  print("Imp: \(currentNote!.importance)")
    }
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector:
            #selector(NoteViewController.keyboardDidShow(notification:)), name:
            UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:
            #selector(NoteViewController.keyboardWillHide(notification:)), name:
            UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardDidShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        
        // Get the existing contentInset for the scrollView and set the bottom property to be the height of the keyboard
        var contentInset = self.scrollView.contentInset
        contentInset.bottom = keyboardSize.height
        
        self.scrollView.contentInset = contentInset
        self.scrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        var contentInset = self.scrollView.contentInset
        contentInset.bottom = 0
        
        self.scrollView.contentInset = contentInset
        self.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }

}
