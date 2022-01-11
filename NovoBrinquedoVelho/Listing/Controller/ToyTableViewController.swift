//
//  ToyTableViewController.swift
//  NovoBrinquedoVelho
//
//  Created by Petrus Ribeiro Lima da Costa on 02/01/22.
//

import UIKit
import CoreData
import SwiftUI
import FirebaseFirestore

class ToyTableViewController: UITableViewController {
    
    @ObservedObject
    private var toyAPI = ToyAPI()
    
    var toys: [Toy] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadToys()
    }
    
    func loadToys() {
        self.toyAPI.loadToys { [weak self] result in
            switch result {
            case .success(let toys):
                self?.toys = toys
                self?.tableView.reloadData()
            default:
                print("Erro!!!")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let toyViewController = segue.destination as? ToyViewController
            , let indexPath = tableView.indexPathForSelectedRow
        {
            toyViewController.toy = self.toys[indexPath.row]
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return toys.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ToyTableViewCell else {
            return UITableViewCell()
        }
        cell.configureWith(self.toys[indexPath.row])
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ToyAPI().deleteToy(toy: self.toys[indexPath.row])
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
