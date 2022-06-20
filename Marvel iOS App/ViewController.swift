import UIKit

class ViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //view.backgroundColor = .blue
        //titleLabel.text = HeroDetailConstants.name
        //titleLabel.text = MarvelAPI().fetchHeroesListing().last?.name ?? ""
    }
}

// 2022-06-17

class InitialViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    struct Hero {
        let name: String
        let image: String?
    }
    
    let heroData: [Hero] = [
        Hero(name: "Aegis (Trey Rollins)", image: "aegis"),
        Hero(name: "Ken Ellis", image: "kenellis"),
        Hero(name: "Warstar", image: "warstar")
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
    }
}





class HeroTableView: UITableViewCell {
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var heroLabel: UILabel!
}

extension InitialViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let hero = heroData[indexPath.row]
        let heroCell = tableView.dequeueReusableCell(withIdentifier: "heroCell", for: indexPath) as! HeroTableView
        
        heroCell.heroLabel.text = hero.name
        if let heroImage = hero.image {
            heroCell.heroImage.image = UIImage(named: heroImage)
        }
        
        return heroCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroData.count
    }
    
}

extension InitialViewController: UITableViewDelegate {
    
}


