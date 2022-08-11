
import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var years = [String]()
    var pickerViewValue = "1970"
    @IBOutlet weak var pickerView: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //Making an array of the desired years to fill the pickerView
        for i in 1970...2050{
            years.append(String(i))
        }
        //Initializing the pickerView
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    //MARK: -Filling the pickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {return 1}
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return years.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return years[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerViewValue = years[row]
    }

    @IBAction func buttonPressed(_ sender: Any) {
        performSegue(withIdentifier: "mainToResults", sender: self) //Moving to the storyboard with the results
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? resultsViewController{
            vc.year = pickerViewValue //Getting the year's value to the next viewController to load the results
        }
    }
}

