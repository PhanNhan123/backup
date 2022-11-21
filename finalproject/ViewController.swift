
import Foundation
import UIKit
import Alamofire
import SDWebImage
import MBProgressHUD
import SwiftyJSON
import CoreData
//test
class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    var users:  [NSManagedObject] = []
    @IBOutlet weak var userTableView: UITableView!
    //    struct User {
    //        let login: String
    //        let avatar_url: String
    //        let url: String
    //    }
    struct User : Codable{
        let login: String
        let avatar_url: String
        let html_url: String
        //        let id : Int
        //        let node_id:  String
        //        let gravatar_id: String
        //        let followers_url: String
        //        let following_url: String
        //        let gists_url : String
        //        let starred_url : String
        //        let subscriptions_url: String
        //        let organizations_url: String
        //        let repos_url : String
        //        let events_url : String
        //        let received_events_url: String
        //        let type : String
        //        let site_admin : String
        
    }
    //    let data:[User] = [
    //        User(login: "mojombo",avatar_url: "https://avatars.githubusercontent.com/u/1?v=4",url:"https://github.com/wayneeseguin"),
    //        User(login: "defunkt",avatar_url: "https://avatars.githubusercontent.com/u/2?v=4",url:"https://github.com/defunkt"),
    //        User(login: "pjhyett",avatar_url: "https://avatars.githubusercontent.com/u/3?v=4",url:"https://github.com/pjhyett"),
    //        User(login: "wycats",avatar_url: "https://avatars.githubusercontent.com/u/4?v=4",url:"https://github.com/wycats"),
    //
    //    ]
    
    override func viewDidLoad() {
        
        self.title = "Switters"
        getURL() {(users) in
            //            print(users)
        }
        fetchData()
        userTableView.dataSource = self
        userTableView.delegate = self
        
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section:Int) -> String?
    {
        return "Switters"
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->  Int{
        //        return data.count
        return 10
    }
    func  tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = userTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserTableViewCell
        let user = users[indexPath.row]
        cell.loginLabel.text = user.value(forKey: "login") as! String
        cell.loginLabel.font = UIFont.boldSystemFont(ofSize: 18)
        cell.urlLabel.text  =  user.value(forKey: "html_url") as! String
        cell.urlLabel.textColor = .blue
        cell.urlLabel.isUserInteractionEnabled = true
        cell.infoView.bringSubviewToFront(cell.urlLabel);
        cell.mainView.bringSubviewToFront(cell.urlLabel);
        let tap = MyTapGesture(target: self, action: #selector(self.tapFunction(sender:)))
        cell.urlLabel.addGestureRecognizer(tap)
        tap.url =  user.value(forKey: "html_url") as! String
        
        let data = user.value(forKey: "avatar_url") as! Data
        cell.userImageView.image  = UIImage(data: data)
        
        //        cell.userImageView.sd_setImage(with: URL(string:  user.value(forKey: "avatar_url") as! String), placeholderImage: UIImage(named: "placeholder.png"))
        cell.userImageView.layer.cornerRadius = 20
        cell.userImageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        cell.userImageView.frame = CGRect(x: 10, y: 10, width: 370, height: 250)
        return cell
    }
    
    
    
    // tap function
    
    func tableView(_ tableView:UITableView, heightForRowAt indexPath: IndexPath) ->CGFloat{return 400
        
    }
    
    // navigtion
    
    func tableView(_ tableView:UITableView,didSelectRowAt indexPath: IndexPath){
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        var user = users[indexPath.row]
        vc?.login =  user.value(forKey: "login") as! String
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func save(login: String,html_url:String,avatar_url:String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
        let user = NSManagedObject(entity: entity, insertInto: managedContext)
        user.setValue(login, forKeyPath: "login")
        user.setValue(html_url, forKeyPath: "html_url")
        let urlImage = URL(string: avatar_url)!
        if let data  = try? Data(contentsOf: urlImage){
            user.setValue(data, forKeyPath: "avatar_url")
        }
        do{
            try managedContext.save()
            users.append(user)
        }catch let error as NSError{
            print("Could not save, \(error), \(error.userInfo)")
        }
    }
    
    func fetchData() {
        print("fetchdata")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return }
        let managedConText = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        do{
            users  = try managedConText.fetch(fetchRequest)
            for data in users as! [NSManagedObject]{
                //                print(data.value(forKey: "avatar_url") as! Data)
                
            }
        }catch let error as NSError{
            print("Could not fetch , \(error),\(error.userInfo)")
            print (0)
        }
    }
    func removeCoreData() {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "User") // Find this name in your .xcdatamodeld file
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedContext.execute(deleteRequest)
        } catch let error as NSError {
            // TODO: handle the error
            print(error.localizedDescription)
        }
    }
    func getURL(completion: @escaping ([User]) -> Void) {
        let url = "https://api.github.com/users"
        AF.request(url).responseJSON {response in
            switch (response.result) {
            case .success( _):
                do {
                    let users = try JSONDecoder().decode([User].self, from: response.data!)
                    self.removeCoreData()
                    for item in users {
                        
                        self.save(login:item.login,html_url: item.html_url,avatar_url: item.avatar_url)
                    }
                    completion(users)
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("Request error: \(error.localizedDescription)")
            }
            
        }
    }
    
    @IBAction func tapFunction(sender: MyTapGesture){
        if let url = URL(string: sender.url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)}
    }
    
    
}
class MyTapGesture: UITapGestureRecognizer {
    var url = String()
}


