import UIKit

class NoteViewController: UIViewController {
    @IBOutlet var contentTextView: UITextView!
    
    var note: Note? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
//      source for tap to dismiss keyboard: https://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift by Esqarrouth
        let tap = UITapGestureRecognizer(target: contentTextView, action: #selector(self.dismissKeyboard (_:)))
        contentTextView.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        print("tab recognition works")
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentTextView.text = note!.content
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        note!.content = contentTextView.text
        NoteManager.shared.saveNote(note: note!)
    }
    
}
