
import Foundation
import UIKit

class resultsViewController: UIViewController, UITableViewDataSource{
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var holidaysArray: [HolidaysData] = []
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Printing the results on the table view
        let name = holidaysArray[indexPath.row].name
        let date = holidaysArray[indexPath.row].date
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = date
        activityIndicator.stopAnimating() //Stoping the spinning loader after the tableView has some data
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return holidaysArray.count
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    var year = ""
    var holidaysLoader = HolidaysLoader()
    var dbManager = DatabaseManager() //Creating the database
    
    override func viewDidLoad() {
        activityIndicator.startAnimating()      //Activating spining loader
        activityIndicator.hidesWhenStopped = true
        dbManager.createTable()     //Create the table for the holidays to be saved if there isn't one
        if dbManager.read(year).isEmpty { //Checking if this year's holidays have been already saved on the database
            holidaysLoader.delegate = self
            holidaysLoader.fetchHolidays(year) //Beginnig the process of accessing the api's data
        }else{
            holidaysArray = dbManager.read(year) //Accessing the holidays from the sqlite database
        }
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension resultsViewController: HolidaysLoaderDelegate{
    func didLoadHolidays(_ holidaysLoader: HolidaysLoader, _ holidays: [HolidaysData]) {
        holidaysArray = holidays
        for i in 0...holidaysArray.count - 1{
            dbManager.insert(year, holidaysArray[i].name, holidaysArray[i].date) // Saving the holidays for this year on the database so they can be accessed offline
        }
        DispatchQueue.main.async {
            self.tableView.reloadData() //Reloading tableView on the main thread
        }
    }
    
    func didFailWithError(_ error: Error) {
        print("error")
    }
    
}
