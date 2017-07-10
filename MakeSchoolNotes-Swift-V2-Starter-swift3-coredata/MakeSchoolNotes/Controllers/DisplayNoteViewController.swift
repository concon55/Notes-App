//
//  DisplayNoteViewController.swift
//  MakeSchoolNotes
//
//  Created by Chris Orcutt on 1/10/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit

class DisplayNoteViewController: UIViewController {
    
    var note: Note?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "save" {
            //if note exists, update title and content
            let note = self.note ?? CoreDataHelper.newNote()
            note.title = noteTitleTextField.text ?? ""
            note.content = noteContentTextView.text ?? ""
            note.modificationTime = Date() as NSDate
            CoreDataHelper.saveNote()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var noteContentTextView: UITextView!
    
    @IBOutlet weak var noteTitleTextField: UITextField!
    
    
    //every time a view controller is about to be displayed on screen, viewWillAppear() will be called
    //use this to remove placeholder text
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //check if note property is nil (create new note) or contains value (modify existing note)
        // 1: optional binding technique: unwrap value in note property and store actual value (if it exists) in local variable named note
        if let note = note {
            // 2: if note property is not nil, set text field and view properties to note's title and content
            noteTitleTextField.text = note.title
            noteContentTextView.text = note.content
        } else {
            // 3: if nil, set text field and view to empty strings
            noteTitleTextField.text = ""
            noteContentTextView.text = ""
        }
    }
}
