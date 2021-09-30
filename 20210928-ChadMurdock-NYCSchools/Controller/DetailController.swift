//
//  DetailController.swift
//  20210928-ChadMurdock-NYCSchools
//
//  Created by Chad Murdock on 9/28/21.
//

import UIKit

class DetailController: UITableViewController {

    var schoolScore: SchoolScore?
    var school: School?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadData()
    }

    // MARK: - Table view data source
    func setupTableView(){
        tableView.register(UINib(nibName: "DetailCell", bundle: nil), forCellReuseIdentifier: "detailCell")
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
    }
    
    func loadData(){
        NetWorking.getScores(dbn: school?.dbn ?? "") { score in
            self.schoolScore = score.count > 0 ? score[0] : self.schoolScore
            self.schoolScore?.school = self.school
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: TableView Delegate Method(s)
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // MARK: TableView Datasource Method(s)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as? DetailCell, let schoolScore = schoolScore else { return UITableViewCell() }
        cell.setup(schoolScore: schoolScore)
        return cell
    }
    
}
