import UIKit
import CoreData
class ViewController: UIViewController ,UIApplicationDelegate , UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = taskArray[indexPath.row]
        //        cell.textLabel?.text = String(priorityArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTask = taskArray[indexPath.row]
        //        selectedPriority = priorityArray[indexPath.row]
        selectedid = idArray[indexPath.row]
        performSegue(withIdentifier: "ToDoViewSague", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            
            self.taskArray.remove(at: indexPath.row)
            let indexPath = IndexPath(item: indexPath.row, section: 0)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    var selectedTask = ""
    //    var selectedPriority = 0
    var taskArray = [String]()
    //    var priorityArray = [Int]()
    var idArray = [UUID]()
    var selectedid : UUID?
    @IBOutlet weak var tblToDo: UITableView!
    
    @objc func getData(){
        //clear the array
        taskArray.removeAll(keepingCapacity: false)
        //        priorityArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        //retrieve data from core data from the Tasks Entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
        fetchRequest.returnsObjectsAsFaults = false
        
        
        do{
            //if any occurred while fetching data it'll catch and show the error.
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    //fetch all data and save it into array
                    if let task = result.value(forKey: "show") as? String {
                        taskArray.append(task)
                        
                    }
                    //                    if let priority = result.value(forKey: "priority") as? Int {
                    //                        priorityArray.append(priority)
                    //
                    //                    }
                    if let id = result.value(forKey: "id") as? UUID{
                        idArray.append(id)
                    }
                    self.tblToDo.reloadData()
                    
                }
            }
        }
        catch{
            
            print("error uccurred \(error)")
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        getData()
        // Do any additional setup after loading the view.
        tblToDo.dataSource = self
        tblToDo.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name:
            NSNotification.Name(rawValue: "NewTasks"), object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToDoViewSague"{
            let des = segue.destination as! ToDOViewContoller
            //            des.choosePriority = Int(selectedPriority)
            des.chooseTask = selectedTask
            des.chooseid = selectedid
            
        }
    }
}


