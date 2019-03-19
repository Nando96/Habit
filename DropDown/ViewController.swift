import UIKit
import EventKit


class ViewController: UIViewController {
    
    
    @IBOutlet var cityButtons: [UIButton]!
    
    @IBOutlet var Select: UIButton!
    
    @IBOutlet var weeks: UIStackView!
    
    
    
    @IBOutlet var entry: UIStackView!
    
    
    @IBOutlet var namefield: UIStackView!

    @IBOutlet weak var ENTRYNAME: UITextField!
    
    @IBOutlet var Entrydis: UITextField!
    
    @IBOutlet weak var startHr: UITextField!
    
    @IBOutlet weak var StartMin: UITextField!
    
    @IBOutlet weak var endHr: UITextField!
    
    @IBOutlet weak var EndMin: UITextField!
    
    @IBOutlet weak var timefield: UIStackView!
    
    var name: String = ""
    var type: String = ""
    var mon: Bool = false
    var tue: Bool = false
    var wen: Bool = false
    var thur: Bool = false
    var fri: Bool = false
    var sat: Bool = false
    var sun: Bool = false
    var des: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func handleSelection(_ sender: UIButton) {
        cityButtons.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func handletime(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            self.weeks.isHidden = !self.weeks.isHidden
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func handledis(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            self.entry.isHidden = !self.entry.isHidden
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func htime(_ sender: Any) {
        UIView.animate(withDuration: 0.1, animations: {
            self.timefield.isHidden = !self.timefield.isHidden
            self.view.layoutIfNeeded()
        })
    }
    
    
    enum buttons: String {
        case Ph = "Physical"
        case Nu = "Nutritional"
        case Ed = "Educational"
        case Mi = "Misc"
        
    }
    
    @IBAction func cityTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle, let button = buttons(rawValue: title) else {
            return
        }
        
        switch button {
        case .Ph:
            print("Physical")
            type = "Physical"
            
            cityButtons.forEach { (button) in
                UIView.animate(withDuration: 0.3, animations: {
                    button.backgroundColor = UIColor.red
                })}
            sender.backgroundColor = UIColor.green
        case .Nu:
            print("Nutritional")
            type = "Nutritional"
            cityButtons.forEach { (button) in
                UIView.animate(withDuration: 0.3, animations: {
                    button.backgroundColor = UIColor.red
                })}
            sender.backgroundColor = UIColor.green
        case .Ed:
            print("Educational")
            type = "Educational"
            cityButtons.forEach { (button) in
                UIView.animate(withDuration: 0.3, animations: {
                    button.backgroundColor = UIColor.red
                })}
            sender.backgroundColor = UIColor.green
            
        default:
            print("Misc")
            cityButtons.forEach { (button) in
                UIView.animate(withDuration: 0.3, animations: {
                    button.backgroundColor = UIColor.red
                })}
            sender.backgroundColor = UIColor.green
        }
        
    }
    @IBAction func checkBoxTapped(_ sender: UIButton) {
        chang(temp: sender)
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (success) in
            sender.isSelected = !sender.isSelected

            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear,
                
                           animations: {
                sender.transform = .identity
            }, completion: nil)
        }
        
        
}
    @IBAction func allowname(_ sender: UIButton) {
    UIView.animate(withDuration: 0.1, animations: {
    self.namefield.isHidden = !self.namefield.isHidden
    self.view.layoutIfNeeded()
    })
    }
    
    @IBAction func OUTPUT(_ sender: Any) {
        dowork()
        name = ENTRYNAME.text!
        des = Entrydis.text!
        //if !checkevents(){
        
        //}
        //else{
        
        if mon{
            outmanager(temp: .monday)
        }
        if tue{
            outmanager(temp: .tuesday)
        }
        if wen{
            outmanager(temp: .wednesday)
        }
        if thur{
            outmanager(temp: .thursday)
        }
        if fri{
            outmanager(temp: .friday)
        }
        if sat{
            outmanager(temp: .saturday)
        }
        if sun{
            outmanager(temp: .sunday)
        }
            //makeevent(day: .monday)
            
            //UIApplication.shared.openURL(NSURL(string: "calshow://")! as URL)
        //}
        
    }
   
    func outmanager(temp: Date.Weekday){
        let date1 = Calendar.current.date(bySettingHour: Int((startHr?.text)!)!, minute: Int((StartMin?.text)!)!, second: 0, of: Date.today().next(temp))!
        let date2 = Calendar.current.date(bySettingHour: Int((endHr?.text)!)!, minute: Int((EndMin?.text)!)!, second: 0, of: Date.today().next(temp))!
        

        
        addEventToCalendar(title: name, description: des, startDate: date1, endDate: date2 )
        
        
    }
    
    
    func addEventToCalendar(title: String, description: String?, startDate: Date, endDate: Date, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
                event.notes = description
                event.addAlarm(EKAlarm(relativeOffset: -60*5))
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let e as NSError {
                    completion?(false, e)
                    return
                }
                completion?(true, nil)
            } else {
                completion?(false, error as NSError?)
            }
        })
    }
    
    
    

    
    func chang(temp: UIButton){
        
        if temp.currentTitle == "Off"{
            temp.setTitle("On", for: .normal)
            print("ON")
            }
        else{
            temp.setTitle("Off", for: .normal)
            print("OFF")
        }
        }
    func printall(){
        name = ENTRYNAME.text!
        des = Entrydis.text!
        print(name+type+des)
        
        }
    
  
    func checkevents() -> Bool{
        if (name != "") && (type != "") && (des != ""){
            return true
        }
        else{
            return false
        }
    }
    
    
    @IBAction func monbutton(_ sender: Any) {
        mon.toggle()
    }
    
    @IBAction func tuebutton(_ sender: Any) {
        tue.toggle()
    }
    @IBAction func wenbutton(_ sender: Any) {
        wen.toggle()
    }
    
    @IBAction func thurbutton(_ sender: Any) {
        thur.toggle()
    }
    @IBAction func fributton(_ sender: Any) {
        fri.toggle()
    }
    
    @IBAction func satbutton(_ sender: Any) {
        sat.toggle()
    }
    @IBAction func sunbutton(_ sender: Any) {
        sun.toggle()
    }
    
    func dowork(){
        var titles : [String] = []
        var startDates : [NSDate] = []
        var endDates : [NSDate] = []
        
        let eventStore = EKEventStore()
        let calendars = eventStore.calendars(for: .event)
        
        for calendar in calendars {
            if calendar.title == "Calendar" {
                
                let oneMonthAgo = NSDate(timeIntervalSinceNow: -30*24*3600)
                let oneMonthAfter = NSDate(timeIntervalSinceNow: +30*24*3600)
                
                let predicate = eventStore.predicateForEvents(withStart: oneMonthAgo as Date, end: oneMonthAfter as Date, calendars: [calendar])
                
                let events = eventStore.events(matching: predicate)
                
                for event in events {
                    titles.append(event.title)
                    startDates.append(event.startDate! as NSDate)
                    endDates.append(event.endDate! as NSDate)
                }
            }
        }
        print(titles)
    }
}






extension Date {
    
    static func today() -> Date {
        return Date()
    }
    
    func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.Next,
                   weekday,
                   considerToday: considerToday)
    }
    
    func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.Previous,
                   weekday,
                   considerToday: considerToday)
    }
    
    func get(_ direction: SearchDirection,
             _ weekDay: Weekday,
             considerToday consider: Bool = false) -> Date {
        
        let dayName = weekDay.rawValue
        
        let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }
        
        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
        
        let searchWeekdayIndex = weekdaysName.index(of: dayName)! + 1
        
        let calendar = Calendar(identifier: .gregorian)
        
        if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
            return self
        }
        
        var nextDateComponent = DateComponents()
        nextDateComponent.weekday = searchWeekdayIndex
        
        
        let date = calendar.nextDate(after: self,
                                     matching: nextDateComponent,
                                     matchingPolicy: .nextTime,
                                     direction: direction.calendarSearchDirection)
        
        return date!
    }
    
}
extension Date {
    func getWeekDaysInEnglish() -> [String] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.weekdaySymbols
    }
    
    enum Weekday: String {
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    }
    
    enum SearchDirection {
        case Next
        case Previous
        
        var calendarSearchDirection: Calendar.SearchDirection {
            switch self {
            case .Next:
                return .forward
            case .Previous:
                return .backward
            }
        }
}
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

