//
//  ViewController.swift
//  Dog
//
//  Created by spark-04 on 2024/02/16.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var dogResponse: DogResponse?
    let dog = Dog()
    
    var breeds = [String()]
    
    
    @IBOutlet weak var dogList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dogList.delegate = self
        dogList.dataSource = self
        fetchDogBreedList()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        let dogList = breeds[indexPath.row]
        cell.textLabel!.text = dogList
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        return cell
    }
    
    func fetchDogBreedList() {
        Task {
            let dogString = await dog.fetchDogBreeds()
            switch dogString {
            case .success(let dogBreeds):
                self.dogResponse = dogBreeds
                self.breeds = dogResponse?.message.keys.sorted() ?? []
                dogList.reloadData()
            case .failure(let error):
                print("Error fetchDog : \(error)")
            }
        }
        
        func showError(alertMessage: String) {
            let dialog = UIAlertController(title: "確認", message: alertMessage, preferredStyle: .alert)
            dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.fetchDogBreedList()
            }))
            self.present(dialog, animated: true, completion: nil)
        }
    }
}
