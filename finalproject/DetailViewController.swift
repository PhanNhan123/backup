
import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import CoreData

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    var infoUsers: [NSManagedObject] = []
    struct User{
        var login : String
        var id : Int
        var node_id : String
        var avatar_url : String
        var gravatar_id : String
        var url : String
        var html_url : String
        var  followers_url : String
        var following_url : String
        var  gists_url : String
        var starred_url: String
        var subscriptions_url: String
        var organizations_url: String
        var repos_url: String
        var events_url: String
        var received_events_url : String
        var type : String
        var site_admin : Bool
        var name : String
        var company : String
        var  blog: String
        var  location : String
        var email: String
        var hireable: String
        var bio : String
        var twitter_username: String
        var public_repos: Int
        var  public_gists: Int
        var followers: Int
        var  following: Int
        var created_at : Date
        var updated_at : Date
    }
    @IBOutlet weak var detailTableView: UITableView!
    var image = UIImage()
    var login = ""
    var content = ""
    var follower = ""
    var createAt = ""
    var userDetail = [String:Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        detailTableView.dataSource = self
        detailTableView.delegate = self
        print("login \(login)")
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->  Int{
        return 1
    }
    func  tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = detailTableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! DetailTableViewCell
        getURL() { (name,followers,avatar,dateString,avatar_url,content) in
            cell.nameLabel.text = name
            cell.gitImage.image = UIImage(named: "github.png")
            cell.nameLabel.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            cell.avtImage.sd_setImage(with: URL(string: avatar_url), placeholderImage: UIImage(named: "placeholder.png"))
            //            cell.avtImage.frame = CGRect(x:10, y:10, width: 200, height:200)
            //            cell.avtImage.layoutMargins =  UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
            cell.flLabel.text = "\(followers) Followers"
            cell.dateLabel.text = "Since \(dateString)"
            cell.contentLabel.text = content
        }
        
        return cell
    }
    func tableView(_ tableView:UITableView, heightForRowAt indexPath: IndexPath) ->CGFloat{return 1000}
    
    func getURL(completion: @escaping (String,String,String,String,String,String) -> Void) {
        let url = "https://api.github.com/users/\(login)"
        AF.request(url).responseJSON {response in
            if let value = response.value {
                let swiftyJsonVar = JSON(value)
                let followers = swiftyJsonVar["followers"].stringValue
                let name = swiftyJsonVar["name"].stringValue
                let avatar = swiftyJsonVar["avatar_url"].stringValue
                let created_at = swiftyJsonVar["created_at"].stringValue
                let avatar_url  =  swiftyJsonVar["avatar_url"].stringValue
                let content = swiftyJsonVar["bio"].stringValue
                let dateFormatter = DateFormatter()
                let tempLocale = dateFormatter.locale
                dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                let date = dateFormatter.date(from: created_at)!
                dateFormatter.dateFormat = "MMM d, yyyy"
                dateFormatter.locale = tempLocale // reset the locale
                let dateString = dateFormatter.string(from: date)
                
                completion(name,followers,avatar,dateString,avatar_url,content)
            }
        }
    }
    func fetchData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "InfoUser")
        do{
            infoUsers = try managedContext.fetch(fetchRequest)
            for data in infoUsers as!  [NSManagedObject]{
                print(data.value(forKey: "name") as! String )
            }
        }catch let error as NSError{
            print("Could not fetch ,\(error), \(error.userInfo)")
        }
    }
    
}

