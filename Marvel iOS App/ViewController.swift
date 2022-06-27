import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var titleHero: UILabel!
    @IBOutlet weak var heroImage: UIImageView!
    
    var heroesData: Result?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let heroData = heroesData {
            titleHero.text = heroData.name
            
            var heroImagePath = heroData.thumbnail.path+"/standard_fantastic."+heroData.thumbnail.extension
            heroImagePath.insert("s", at: heroImagePath.index(heroImagePath.startIndex, offsetBy: 4))
            heroImage.loadFrom(URLAddress: heroImagePath)
        }
        
        // Do any additional setup after loading the view.
        //view.backgroundColor = .blue
        //titleLabel.text = HeroDetailConstants.name
        //titleLabel.text = MarvelAPI().fetchHeroesListing().last?.name ?? ""
        //titleHero.text = heroesData?.name ?? ""
   
    }
}

// 2022-06-17

class InitialViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
//    struct Hero {
//        let name: String
//        let image: String?
//    }
    
//    let heroData: [HeroInformation] = [
//        HeroInformation(name: "Aegis (Trey Rollins)", image: "aegis"),
//        HeroInformation(name: "Ken Ellis", image: "kenellis"),
//        HeroInformation(name: "Warstar", image: "warstar")
//    ]
    
    var heroData = [Result]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let urlString = "https://demo3937237.mockable.io/heros"
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(jsonData: data)
                
            }
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    func parse(jsonData: Data) {
        let decoder = JSONDecoder()
        if let jsonDataClass = try? decoder.decode(Welcome.self, from: jsonData) {
            heroData = jsonDataClass.data.results
            tableView.reloadData()
        }
    }
    
    func showHero(index: Int) {
        guard let viewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "ViewController") as? ViewController else {
            return
        }
        
        viewController.heroesData = heroData[index]
        
        self.navigationController?.pushViewController(viewController, animated: true)
        //self.present(viewController, animated: true)
        
    }
    
}


extension InitialViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let hero = heroData[indexPath.row]
        let heroCell = tableView.dequeueReusableCell(withIdentifier: "heroCell", for: indexPath) as! CustomCell

        
        var heroImagePath = hero.thumbnail.path+"/landscape_incredible."+hero.thumbnail.extension
        heroImagePath.insert("s", at: heroImagePath.index(heroImagePath.startIndex, offsetBy: 4))
        
        heroCell.heroImage?.loadFrom(URLAddress: heroImagePath)
        heroCell.heroName?.text = hero.name
        
        
        
//        heroCell.heroName.text = hero.name
//        if let heroImage = hero.image {
//            heroCell.heroImage.image = UIImage(named: heroImage)
//        }
        
        return heroCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroData.count
    }
    
}

extension InitialViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showHero(index: indexPath.row)
    }
}

extension UIImageView {
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                        self?.image = loadedImage
                }
            }
        }
    }
}


