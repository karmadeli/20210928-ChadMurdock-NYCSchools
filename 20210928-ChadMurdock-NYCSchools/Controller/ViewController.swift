//
//  ViewController.swift
//  20210928-ChadMurdock-NYCSchools
//
//  Created by Chad Murdock on 9/28/21.
//

import UIKit

class ViewController: UITableViewController {

    var dataSource: [School] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadData()
    }
    
    func setupTableView(){
        tableView.register(UINib(nibName: "SchoolTableViewCell", bundle: nil), forCellReuseIdentifier: "schoolTableViewCell")
        tableView.tableFooterView = UIView()
    }
    
    func loadData(){
        NetWorking.getSchools { [weak self] schools in
            self?.dataSource = schools
            // Nice To Have: if schools empty then I'd show an empty state
            DispatchQueue.main.asyncAfter(deadline: .now(), qos: .userInteractive) {
                self?.tableView.reloadData()
            }
        }
    }
    
    @IBAction func reloadAction(_ sender: Any) {
        loadData()
    }

    // MARK: TableView Datasource Method(s)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "schoolTableViewCell", for: indexPath) as? SchoolTableViewCell else { return UITableViewCell() }
        cell.setup(school: dataSource[indexPath.row])
        return cell
    }
    
    // MARK: TableView Delegate Method(s)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailController") as? DetailController{
            vc.school = dataSource[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

