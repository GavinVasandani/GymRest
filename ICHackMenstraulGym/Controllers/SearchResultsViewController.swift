//
//  SearchResultsViewController.swift
//  ICHackMenstraulGym
//
//  Created by Gavin Vasandani on 04/02/2023.
//

import UIKit
//Protocol that is created for a class that
protocol SearchResultsViewControllerDelegate: AnyObject {
    //Passing result output to watchlist
    func SearchResultsViewControllerDidSelect(resultOut:SearchResult) //SearchResult is an element (stock) of SearchResponse array //a member function that takes in input param resultOut which is when value from result table is clicked
}
//UIViewController is a protocol, it has certain properties (like super/base function) and a class conforms to the protocol by inheriting all its properties
class SearchResultsViewController: UIViewController {
    
    weak var delegate: SearchResultsViewControllerDelegate? //so weak var so it must have optional type so default type?
    
    private var results: [SearchResult] = [] //so results variable which is type String array and is initialized as empty array []
    
    //Creating table object:
    private let tableView: UITableView = {
        let table = UITableView() //registers table values from table view cell (not sure what it does)
        table.register(SearchResultTableViewCell.self, forCellReuseIdentifier: "SearchResultTableViewCell")
        return table
    }()

    override func viewDidLoad() { //functions in this scope, are all outputted on page
        super.viewDidLoad()
        //Creating table that search results are outputted on
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
        setUpTable()
    }
    
    private func setUpTable() {
        //Title object that is Rectangular and has the aforementioned dimensions and position
        view.addSubview(tableView) //calls tableView func which has output UITableView and that's input param to add subview which is added to view object. Then view object is outputted on the page
        tableView.delegate = self
        tableView.dataSource = self //so data and interactions are handled within this file
    }
    
    public func update(with results: [SearchResult]) { //func which has input param as array of string which is used as the rows of the search results
        self.results = results //so object currently being considered has member variable results which is assigned to the input param results
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() { //overrride overwrites a standard func definition
        super.viewDidLayoutSubviews() //super keyword calls the inheriting class/base class
        //Layout of object in subviews: table, title etc.
        tableView.frame = view.bounds
    }
    
}
//extension/extra codespace thats in scope of SearchResultsViewController class, the stuff after : are protocols that the class follows so if it alters a certain member variable of the protocol then class must conform to protocol
extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource{
    func SearchResultsViewControllerDidSelect(resultOut: String) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of items in your data source
        return results.count //so count value from the input data which is the number of results from the query
    }
    
    //func that creates a dequeue to represent a cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier, for: indexPath)
        // Configure the cell's contents
        
        let model = results[indexPath.row] //so choose the specific stock based on the indexPath.row so current row we're on
        //Output that specific stocks symbol
        cell.textLabel?.text = model.displaySymbol //"Row \(indexPath.row)" //outputs current row number as cell text
        //forward slash in string literal (const char*) ends string literal and allows outputting of a variable
        cell.detailTextLabel?.text = model.description //"This is: Row \(indexPath.row)" //outputs current row number as cell text
        return cell
    }
    //func to see if cell was clicked:
    //overload of tableView func, so input args is the table object and indexPath is object representing what row was selected
    //so func called when a row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //Now when a certain stock is selected it inputted as input param into delegate
        let model = results[indexPath.row]
        delegate?.SearchResultsViewControllerDidSelect(resultOut: model)
    }
    
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
