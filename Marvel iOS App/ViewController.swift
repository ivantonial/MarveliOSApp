import UIKit
import CommonCrypto

class ViewController: UIViewController {

    @IBOutlet weak var titleHero: UILabel!
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var comicsTitle: UILabel!
    @IBOutlet weak var comicsDescription: UILabel!
    @IBOutlet weak var eventsTitle: UILabel!
    @IBOutlet weak var eventsDescription: UILabel!
    
    var heroesData: Result?
    var heroComics = [Comics]()
    var heroStories = [Stories]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let heroData = heroesData {
            titleHero.text = heroData.name
            
            var heroImagePath = heroData.thumbnail.path+"/standard_fantastic."+heroData.thumbnail.extension
            heroImagePath.insert("s", at: heroImagePath.index(heroImagePath.startIndex, offsetBy: 4))
            heroImage.loadFrom(URLAddress: heroImagePath)
            
            let heroId = heroData.id
            
            let urlStringComics: String = makeURL(heroId: heroId, information: "comics")
            
            let urlStringStories: String = makeURL(heroId: heroId, information: "stories")
            
            requestComics(urlString: urlStringComics)
            requestStories(urlString: urlStringStories)
            
//            if let urlComics = URL(string: urlStringComics) {
//                if let data = try? Data(contentsOf: urlComics) {
//                    //print(data)
//                    parseComics(JSON: data)
//                }
//            }
        }
        
        
        // Do any additional setup after loading the view.
        //view.backgroundColor = .blue
        //titleLabel.text = HeroDetailConstants.name
        //titleLabel.text = MarvelAPI().fetchHeroesListing().last?.name ?? ""
        //titleHero.text = heroesData?.name ?? ""
   
    }
    
    func requestComics(urlString: String) {
        if let url = URL(string: urlString) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    self.parseComicsJSON(json: data)
                }
            }
            
        }
    }
    
    func parseComicsJSON(json: Data) {
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(WelcomeComics.self, from: json)
            self.heroComics = decodedData.data.results
            DispatchQueue.main.async {
                if let title = self.heroComics.object(at: 0)?.title {
                    self.comicsTitle.text = title
                    if let heroComicsDescription = self.heroComics[0].description {
                        self.comicsDescription.text = heroComicsDescription
                    } else {
                        self.comicsDescription.text = "No information!"
                    }
                } else {
                    self.comicsTitle.text = "No Comics Information"
                    self.comicsDescription.text = ""
                }
            }
            
        } catch {
            self.comicsTitle.text = "No Comics Information"
            self.comicsDescription.text = ""
        }
    }
    
    func requestStories(urlString: String) {
        if let url = URL(string: urlString) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    self.parseStoriesJSON(json: data)
                }
            }
            
        }
    }
    
    func parseStoriesJSON(json: Data) {
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(WelcomeStories.self, from: json)
            self.heroStories = decodedData.data.results
            DispatchQueue.main.async {
                if let title = self.heroStories.object(at: 0)?.title {
                    self.eventsTitle.text = title
                    if let heroEventsDescription = self.heroStories[0].description {
                        self.eventsDescription.text = heroEventsDescription
                    } else {
                        self.eventsDescription.text = "No information!"
                    }
                } else {
                    self.eventsTitle.text = "No Events Information"
                    self.eventsDescription.text = ""
                }
            }
            
        } catch {
            self.eventsTitle.text = "No Comics Information"
            self.eventsDescription.text = ""
        }
    }
    
    func loadDataComics(decodedData: WelcomeComics?) {
        self.heroComics = decodedData?.data.results ?? []
        //self.tableView.reloadData()
    }
    
//    func performComicsRequest<T: Codable>(urlString: String, completion: @escaping (T?) -> Void) {
//        print("performing request")
//        if let url = URL(string: urlString) {
//            
//            let session = URLSession(configuration: .default)
//            let task = session.dataTask(with: url) { (data, response, error) in
//                DispatchQueue.main.async {
//                    print("request done")
//                    if error != nil {
//                        print(error!)
//                        return
//                    }
//                    if let safeData = data {
//                        let parsedJson: T? = self.parseJSON(json: safeData)
//                        completion(parsedJson)
//                    }
//                    
//                }
//            }
//            task.resume()
//        }
//    }
//    
//    func parseComicsJSON(json: Data) {
//        do {
//            let decoder = JSONDecoder()
//            let decodedDataComics = decoder.decode(heroComics.self, from: json)
//            self.heroComics = decodedDataComics.data.results
//            if let title = heroComics.object(at: 0)?.title {
//                
//            }
//        }
//    }
    
    func parseJSON<T: Codable>(json: Data) -> T? {
        let decoder = JSONDecoder()
//        if let decodedData = try? decoder.decode(WelcomeComics.self, from: json) {
//            DispatchQueue.main.async {
//                self.dataClass = decodedData.data.results
//                self.initialTableView.reloadData()
//            }
//        }
        return try? decoder.decode(T.self, from: json)
    }
    
    
//        func parseComics(JSON: Data) {
//            let decoder = JSONDecoder()
//            if let comicsJSON = try? decoder.decode(WelcomeComics.self, from: JSON) {
//                heroComics = comicsJSON.data.results
//                print(comicsJSON.data.results)
//            }
//        }
    


    func makeURL(heroId: Int, information: String) -> String {
        let timeStamp = "\(Date().timeIntervalSince1970)"
        let hash = (timeStamp + authKeys.privateKey + authKeys.publicKey).md5
        
        return "https://gateway.marvel.com:443/v1/public/characters/\(heroId)/\(information)?ts=\(timeStamp)&apikey=\(authKeys.publicKey)&hash=\(hash)"
    }
    
}

extension Array {
    func object(at index: Int) -> Element? {
        guard index < count else {
            return nil
        }
        return self[index]
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
        
        performRequest(urlString: urlString, completion: loadData(decodedData: ))
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }

    func loadData(decodedData: Welcome?) {
        self.heroData = decodedData?.data.results ?? []
        self.tableView.reloadData()
    }
    
    func performRequest<T: Codable>(urlString: String, completion: @escaping (T?) -> Void) {
        print("performing request")
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                DispatchQueue.main.async {
                    print("request done")
                    if error != nil {
                        print(error!)
                        return
                    }
                    if let safeData = data {
                        let parsedJson: T? = self.parseJSON(json: safeData)
                        completion(parsedJson)
                    }
                    
                }
            }
            task.resume()
        }
    }
    
    
    func parseJSON<T: Codable>(json: Data) -> T? {
        let decoder = JSONDecoder()
//        if let decodedData = try? decoder.decode(ModalStruct.self, from: json) {
//            DispatchQueue.main.async {
//                self.dataClass = decodedData.data.results
//                self.initialTableView.reloadData()
//            }
//        }
        return try? decoder.decode(T.self, from: json)
    }
    
//    func parse(jsonData: Data) {
//        let decoder = JSONDecoder()
//        if let jsonDataClass = try? decoder.decode(Welcome.self, from: jsonData) {
//            heroData = jsonDataClass.data.results
//            tableView.reloadData()
//        }
//    }
    
    
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
        let identifier = Int.random(in: Int.min...Int.max)
        tag = identifier
        image = nil
        DispatchQueue.global().async { [weak self] in
            guard let imageData = try? Data(contentsOf: url) else {
                return
            }
            guard let loadedImage = UIImage(data: imageData) else {
                return
            }
            DispatchQueue.main.async {
                self?.image = loadedImage
            }
        }
        
    }
}



private struct authKeys {
    static let publicKey = "924035b8338151bdab2d160dfbc2c66a"
    static let privateKey = "de02308e64422ca7cdaf11764ea3390bc140b2d9"
}

extension String {
    var md5: String {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)
        
        if let data = data(using: String.Encoding.utf8) {
            _ = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
                return CC_MD5(bytes.baseAddress, CC_LONG(data.count), &digest)
            }
        }
        
        return (0..<length).reduce("") {
            $0 + String(format: "%02x", digest[$1])
        }
    }
}
