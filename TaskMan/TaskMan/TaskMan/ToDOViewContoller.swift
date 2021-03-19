import UIKit
import CoreData

class ToDOViewContoller: UIViewController, UINavigationControllerDelegate , UIApplicationDelegate  {
    
    var chooseTask = ""
    //    var choosePriority = 0
    var chooseid : UUID?
    
    @IBOutlet weak var txtTask: UITextField!
    @IBOutlet weak var txtPrior: UITextField!
    
    
    @IBAction func btnAdd(_ sender: UIButton) {
        let task: String = txtTask.text!
        let priority: Int = Int(txtPrior.text!) ?? -1
//        print("Your task \(task) and prior is\(priority)")
        let Printable: String = task+"=>"+String(priority)
        if task == ""
        {
            let alert = UIAlertController(title: "Validation Error Found", message: "Please fill in your Task!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else if (priority > 5 || priority < 0)
        {
            let alert = UIAlertController(title: "Validation Error Found", message: "Please Add your Priority between 0 to 5 Range!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            
        }else{
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            
            let newTask = NSEntityDescription.insertNewObject(forEntityName: "Tasks" , into: context)
            
            newTask.setValue(task, forKey: "task")
            newTask.setValue(String(priority), forKey: "priority")
            newTask.setValue(Printable, forKey: "show")
            newTask.setValue(UUID(), forKey: "id")
            
            do{
                try context.save()
                print("success")
            }
            catch{
                print("error Occurred \(error)")
            }
        }
        navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name("NewTask"), object: nil)
        txtTask.endEditing(true)
        txtPrior.endEditing(true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPrior.keyboardType = .numberPad
        getTasksById()
        
    }
    func getTasksById(){
        
        if chooseTask != ""{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
            let idString = chooseid?.uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
            fetchRequest.returnsObjectsAsFaults = false
            
            do{
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject]{
                        if let tasks = result.value(forKey: "task") as? String {
                            txtTask.text = tasks
                        }
                        if let priority = result.value(forKey: "priority") as? String{
                            txtPrior.text = priority
                        }
                        txtTask.isEnabled = false;
                        txtPrior.isEnabled = false;
                    }
                }
            }
            catch{
                print("error Occurred \(error)")
            }
        }
        else{
            txtPrior.text = ""
            txtTask.text = ""
            
        }
    }
}
