//
//  ViewController.swift
//  WeatherTestMani
//
//  Created by srihari ponnapalli on 01/09/20.
//  Copyright © 2020 ManiKanta. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet var weatherMapView: MKMapView!
    
    var locationManager : CLLocationManager? = CLLocationManager()
    var tappedLocation : CLLocationCoordinate2D?
    override func viewDidLoad() {
        super.viewDidLoad()
//        locationManager = CLLocationManager()
//        locationManager?.showsBackgroundLocationIndicator = true
        
        // Do any additional setup after loading the view.
        
        locationManager!.requestWhenInUseAuthorization()
        var currentLoc: CLLocation!
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
        CLLocationManager.authorizationStatus() == .authorizedAlways) {
            currentLoc = locationManager?.location
//           print(currentLoc.coordinate.latitude)
//           print(currentLoc.coordinate.longitude)
        }
        
        weatherMapView.showsUserLocation = true;
        weatherMapView.isZoomEnabled = false
        weatherMapView.pointOfInterestFilter = .includingAll
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(tapAction))
           tapGR.numberOfTapsRequired = 2
        weatherMapView.addGestureRecognizer(tapGR)
        
        
    }
    
    @objc func tapAction(gesture : UITapGestureRecognizer) {
       print("tapAction")   // ** ISSUE: THIS NEVER APPEARS IN THE CONSOLE OUTPUT
       tappedLocation =  weatherMapView.convert(gesture.location(in: weatherMapView), toCoordinateFrom: weatherMapView)
        print(tappedLocation?.latitude as Any)
        //self.perform(#selector(dobleTappAction), with: nil, afterDelay: 1.0)
        serivceCall()
    }
    
//    @objc func dobleTappAction(){
//        print(tappedLocation?.latitude as Any)
//    }

    
    func serivceCall(){
        
        let coordinateParameter = "lat=\(String(describing: tappedLocation!.latitude))&lon=\(String(describing: tappedLocation!.longitude))"

        let headers = [
            "x-rapidapi-host": "community-open-weather-map.p.rapidapi.com",
            "x-rapidapi-key": "7d2a464f3bmsh4364ac27a13f7ebp19076fjsndd11aa9b8e2a"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://community-open-weather-map.p.rapidapi.com/weather?callback=test&id=2172797&units=%2522metric%2522%20or%20%2522imperial%2522&mode=xml%252C%20html&"+coordinateParameter)! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse as Any)
                
                do {
                    //let trimmedData = data!.subdata(in: Range(NSRange(location: 32, length: data!.count - 33))!)//!.subdataWithRange(NSRange(location:8, length: data!.length - 9))
                    let result =  String(data: data!, encoding: String.Encoding.utf8)//JSONSerialization.jsonObject(with: trimmedData, options: JSONSerialization.ReadingOptions.allowFragments)
                    let string : String = (result?.components(separatedBy: "test")[1])!
                    print(string )
                    
                    DispatchQueue.main.async { // Correct
                       let infoVC = (self.storyboard?.instantiateViewController(identifier: "InfoViewController"))! as InfoViewController
                       infoVC.infoString = string
                       self.navigationController?.pushViewController(infoVC, animated: true)
                    }
                    

                } catch let err as NSError {
                    print(err)
                }
                
                
            }
        })

        dataTask.resume()
    }

}

extension ViewController : MKMapViewDelegate {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print(coordinator)
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print(mapView.centerCoordinate.latitude)
        tappedLocation = mapView.centerCoordinate
    }
}

