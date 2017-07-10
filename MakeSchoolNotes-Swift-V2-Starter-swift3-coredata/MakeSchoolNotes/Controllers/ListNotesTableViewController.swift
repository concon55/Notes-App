//
//  ListNotesTableViewController.swift
//  MakeSchoolNotes
//
//  Created by Chris Orcutt on 1/10/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit

class ListNotesTableViewController: UITableViewController {
    //data source, delegate: protocols 
    
    var notes = [Note](){
        didSet{ //property observer: whenever property's value changes, property observers like didSet respond (even if new value is the same as current value)
            //reload data whenever notes property is changed
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notes = CoreDataHelper.retrieveNotes()
    }
    
    // 1: enable table view to have additional editing modes (delete option)
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //1: delete note from CoreData using helper method
            //use indexPath.row to index into notes to delete the correct one
            CoreDataHelper.delete(note: notes[indexPath.row])
            //2: update notes
            notes = CoreDataHelper.retrieveNotes()
        }
    }
    
    // 1: how many cells to display (for now, hard coded value 10)
    // later, set dynamically
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    // 2: tells it what cell to display in particular row of the table
    // indexPath: which section and row the cell will belong to within the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "listNotesTableViewCell", for: indexPath) as! ListNotesTableViewCell
        
        // 1: access the row property to figure out which row the table view wants a cell for
        let row = indexPath.row
        
        // 2: use row to index into notes array to get note object
        let note = notes[row]
        
        // 3:  set text of label to be title of the note
        cell.noteTitleLabel.text = note.title
        
        // 4: convert Date to a String using method already included
        //set text property of the noteModificationTimeLabel to be the modification time of the note
        cell.noteModificationTimeLabel.text = note.modificationTime?.convertToString()
        //*******************************
        //*******************************
        //*******************************
        
        return cell    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // 1: storing identifier of segue that was triggered into a local variable called identifier
        if let identifier = segue.identifier {
            
            // 2: check if "displayNote" segue was triggered
            if identifier == "displayNote" {
                
                // 3: print message to console
                print("Table view cell tapped")
               
                // 1: every table view has a property called indexPathForSelectedRow
                //when a user has selected a cell from a table view, use this method to access that cells's index path
                let indexPath = tableView.indexPathForSelectedRow!
               
                // 2: use indexPath.row to retrieve the note from the notes array that corresponds to the touched cell
                let note = notes[indexPath.row]
                
                // 3: access display controller using the segue's destination property
                // downcast it: access properties of child controller (display controller is child of list controller)
                let displayNoteViewController = segue.destination as! DisplayNoteViewController
                
                // 4: set note property to the note corresponding to the cell that was tapped
                displayNoteViewController.note = note
                
            } else if identifier == "addNote" {
                print("+ button tapped")
            }
        }
    }
    
    @IBAction func unwindToListNotesViewController(_ segue: UIStoryboardSegue){
        self.notes = CoreDataHelper.retrieveNotes()
    }
}
