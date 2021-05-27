import UIKit

class NotesListViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {

    
    var notes: [Note] = []
    
    let searchController = UISearchController()
    @IBAction func createNote() {
        let _ = NoteManager.shared.create()
        reload()
    }
    
    var categoryList = ["All", "Work", "School", "Personal"]
    var filteredCategories = [Note]()
    
    func reload() {
        notes = NoteManager.shared.getNotes()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSearchController()
    }
    
    func initSearchController() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.scopeButtonTitles = categoryList
        searchController.searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchController.isActive) {
            return filteredCategories.count
        }
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            NoteManager.shared.deleteNote(note: notes[indexPath.row])
            reload()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].content
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NoteSegue",
                let destination = segue.destination as? NoteViewController,
                let index = tableView.indexPathForSelectedRow?.row {
            destination.note = notes[index]
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        let searchText = searchBar.text!
        
        filterText(searchText: searchText, scopeButton: scopeButton)
    }
    
    func filterText (searchText: String, scopeButton: String = "All") {
        filteredCategories = notes.filter
        {
            notes in
            let scopeMatch = (scopeButton == "All" || notes.noteCategory.contains(scopeButton.lowercased()))
            if(searchController.searchBar.text != "") {
                let searchTextMatch = notes.content.lowercased().contains(searchText.lowercased())
                
                return scopeMatch && searchTextMatch
            }
            else
            {
                return scopeMatch
            }
        }
        reload()
    }
}
