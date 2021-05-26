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
        
        contentTextView.text = note!.content
    }
    
    
    @IBAction func categoryPicker(_ sender: Any) {
        let viewController = UIViewController()
        viewController.preferredContentSize = CGSize(width: screenWidth, height: <#T##CGFloat#>)
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
    


