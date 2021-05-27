import UIKit

class NoteViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    @IBOutlet var contentTextView: UITextView!
    @IBOutlet weak var categoryButton: UIButton!
    
    var note: Note? = nil
    var categoryList = ["All", "Work", "School", "Personal"]
    let screenWidth = UIScreen.main.bounds.width - 10
    let screenHeight = UIScreen.main.bounds.height / 2
    var selectedRow = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(note!.noteCategory)
        
        contentTextView.text = note!.content
    }
    
    
    @IBAction func categoryPicker(_ sender: Any) {
        let viewController = UIViewController()
        viewController.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        pickerView.dataSource = self
        pickerView.delegate = self
        
        pickerView.selectRow(selectedRow, inComponent: 0, animated: false)
        viewController.view.addSubview(pickerView)
        pickerView.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor).isActive = true
        
        let alert = UIAlertController(title: "Select category", message: "", preferredStyle: .actionSheet)
        
        alert.popoverPresentationController?.sourceView = categoryButton
        alert.popoverPresentationController?.sourceRect = categoryButton.bounds
        
        alert.setValue(viewController, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction)
            in
        }))
        
        print("test")
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { (UIAlertAction) in
            self.selectedRow = pickerView.selectedRow(inComponent: 0)
            let selected = self.categoryList[self.selectedRow]
            let category = selected
            self.note!.noteCategory = category
            self.note!.content = self.contentTextView.text
            self.categoryButton.setTitle(self.note?.noteCategory, for: .normal)
            print(self.note!.noteCategory)
            
            print("does this work?\(String(describing: self.note?.noteCategory))")

            
            NoteManager.shared.saveNote(note: self.note!)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 30))
        label.text = categoryList[row]
        label.sizeToFit()
        return label
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        categoryList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        note!.content = contentTextView.text
        NoteManager.shared.saveNote(note: note!)
    }
}
    


