//
//  School.swift
//  20210928-ChadMurdock-NYCSchools
//
//  Created by Chad Murdock on 9/29/21.
//

import Foundation

struct SchoolScore {
    var testTakers = ""
    var reading = ""
    var math = ""
    var writing = ""
    var schoolName = ""
    var dbn = ""
    var school: School?
}

struct School {
    var testTakers = ""
    var location = ""
    var borough = ""
    var schoolName = ""
    var dbn = ""
    var overview = ""
}
