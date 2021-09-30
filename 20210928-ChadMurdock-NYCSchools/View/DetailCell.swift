//
//  DetailCell.swift
//  20210928-ChadMurdock-NYCSchools
//
//  Created by Chad Murdock on 9/28/21.
//

import UIKit
import MapKit

extension MKMapView {
    
    /**
     Adds an annotation to the mapView representing the school's location.
     
        As a bonus feature, I thought the user would find it useful to see the school's location pointed out on a map.
        It's great when you realise the schools are close to streets and highways that you're familiar with
     - parameter latLon: The school's lat and lon location values parsed from the location value returned in the API call.
     */
    func addSchoolAnnotation(latLon: (lat: String, lon: String)?){
        guard let latLon = latLon else { return }
        let annotation = MKPointAnnotation()
        guard let lat = Double(latLon.lat), let lon = Double(latLon.lon) else { return }
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        addAnnotation(annotation)
    }
}

class DetailCell: UITableViewCell, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var schoolNameLabel: UILabel!
    @IBOutlet weak var writingScoreLabel: UILabel!
    @IBOutlet weak var mathScoreLabel: UILabel!
    @IBOutlet weak var readingScoreLabel: UILabel!
    @IBOutlet weak var overViewLabel: UILabel!
    @IBOutlet weak var testTakerLabel: UILabel!
    var latLon: (lat: String, lon: String)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyStyles()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(schoolScore: SchoolScore){
        let location = schoolScore.school?.location ?? ""
        schoolNameLabel.text = schoolScore.school?.schoolName ?? schoolScore.schoolName
        addressLabel.text = getAddress(location: location)
        mathScoreLabel.text = getScore(score: schoolScore.math)
        readingScoreLabel.text =  getScore(score: schoolScore.reading)
        writingScoreLabel.text = getScore(score: schoolScore.writing)
        testTakerLabel.text = "Average scores based on \(schoolScore.testTakers) students"
        overViewLabel.text = schoolScore.school?.overview
        latLon = getLatLon(location: location)
        testTakerLabel.isHidden = schoolScore.testTakers == "s"
        setupMapView(latLon: latLon)
    }
    
    private func getScore(score: String)->String{
        return score != "s" ? score : "---"
    }
    
    private func applyStyles(){
        // Here I'd style the view along with it's subview, labels etc
    }
    
    private func setupMapView(latLon: (lat: String, lon: String)?){
        mapView.delegate = self
        mapView.addSchoolAnnotation(latLon: latLon)
        if let lat = Double(latLon?.lat ?? ""), let lon = Double(latLon?.lon ?? "") {
            let points = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            DispatchQueue.main.async {
                let region = MKCoordinateRegion(center: points, latitudinalMeters: 1000, longitudinalMeters: 1000)
                self.mapView.setRegion(region, animated: true)
            }
        }
    }
    
    /**
     Parses the string location(address + lat lon value) for the latLon value. Return a tuple of lat and lon values
        - parameter location: (address + lat lon values)
     */
    private func getLatLon(location: String)->(lat: String, lon: String)?{
        let splitLocation = location.split(separator: "(")
        guard splitLocation.count > 1 else { return nil }
        let locationStr = splitLocation[1]
        let dirtyLatLon = locationStr.split(separator: ",")
        guard dirtyLatLon.count > 1 else { return nil}
        let lat = String(dirtyLatLon[0].dropFirst(0))
        var lon = String(dirtyLatLon[1].dropLast(1))
        lon = String(lon.dropFirst(1))
        return (lat, lon)
    }
    
    private func getAddress(location: String)-> String{
        let splitLocation = location.split(separator: "(")
        guard splitLocation.count > 0 else { return "" }
        return String(splitLocation[0])
    }
    
}
