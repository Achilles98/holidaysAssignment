

import Foundation

//Created Delegate protocols to show results from the REST API to the viewController
protocol HolidaysLoaderDelegate{
    func didLoadHolidays(_ holidaysLoader: HolidaysLoader, _ holidays: [HolidaysData])
    func didFailWithError(_ error: Error)
}

struct HolidaysLoader{
    
    func fetchHolidays(_ year: String) {
        let urlString = "https://date.nager.at/api/v3/PublicHolidays/\(year)/GR"
        performRequest(urlString) //Calling a function to make a request for the holidays information
    }
    
    var delegate: HolidaysLoaderDelegate?
    
    func performRequest(_ urlString: String){
        if let url = URL(string: urlString){
            var request = URLRequest(url: url) //Requesting appi connection
            request.httpMethod = "GET"
            let session = URLSession(configuration: .default) //Creating session
            let task = session.dataTask(with: request) { data, response, error in //Creating task to get the data from the session created from the request
                if error != nil{
                    delegate?.didFailWithError(error!) //If there is an error with the connection the delegate sends it to the viewController
                    return
                }
                if let safeData = data{
                    //Parsing the json data received from the api
                    if let holiday = self.parseJSON(safeData){
                        self.delegate?.didLoadHolidays(self, holiday) //Sending the results to the viewController via the delegate
                    }
                }
            }
            task.resume() // Starting the task
        }
    }
    
    //Simple decoding the received json information
    func parseJSON(_ holidayData: Data) -> [HolidaysData]? {
        let decoder = JSONDecoder()
        var holiday:[HolidaysData] = []
        do{
            let decodedData = try decoder.decode([HolidaysData].self, from: holidayData) //Using the json decoder we are getting the information from the api and putting it in an appropriate decodable model we created.
            for i in 0...decodedData.count - 1{
                holiday.append(decodedData[i]) //Appending the decoded data to an array where we will have the final results
            }
            return holiday
            
        }catch let e{
            self.delegate?.didFailWithError(e)
            return nil
        }
    }
    
}
