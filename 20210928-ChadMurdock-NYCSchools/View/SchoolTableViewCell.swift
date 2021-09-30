//
//  SchoolTableViewCell.swift
//  20210928-ChadMurdock-NYCSchools
//
//  Created by Chad Murdock on 9/28/21.
//

import UIKit

class SchoolTableViewCell: UITableViewCell {
    @IBOutlet weak var schoolNameLabel: UILabel!
    @IBOutlet weak var boroughLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setup(school: School){
        schoolNameLabel.text = school.schoolName
        boroughLabel.text = school.borough.capitalized
    }
    
}
