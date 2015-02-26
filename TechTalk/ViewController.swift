//
//  ViewController.swift
//  TechTalk
//
//  Created by Paul Wong on 2/11/15.
//  Copyright (c) 2015 funnyordie. All rights reserved.
//

import UIKit
import TechTalkKit

let kSanFrancisco = "San Francisco"
let kSydney = "Sydney"
let kWundergroundSFURL = "http://api.wunderground.com/api/6e2d7640645b2904/conditions/q/CA/San_Francisco.json"
let kWundergroundAUURL = "http://api.wunderground.com/api/6e2d7640645b2904/geolookup/conditions/forecast/q/Australia/Sydney.json"

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    let locationURLs = [kWundergroundSFURL, kWundergroundAUURL]
    let locationNames = [kSanFrancisco, kSydney]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setInitialPickerViewValue()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setLabelsWithWeather(weather: Weather) {
        dispatch_async(dispatch_get_main_queue(), {
            self.locationLabel.text = weather.location
            self.currentTemperatureLabel.text = weather.currentTemperature
            self.weatherConditionLabel.text = weather.weatherCondition
        })
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return locationURLs.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return self.locationNames[row]
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let locationURL = self.locationURLs[row]
        
        WeatherService.sharedInstance.cacheLocationURL(locationURL)
        WeatherService.sharedInstance.fetchDataWithSuccess({ (weather: Weather, isUpdated: Bool) in
            self.setLabelsWithWeather(weather)
            }, failure: { (error: NSError) in
                println("Fetched Error: \(error.localizedDescription)")
        })
    }
    
    func setInitialPickerViewValue() {
        var locationURLIndex = 0
        for locationURL in locationURLs {
            if WeatherService.sharedInstance.getCachedLocationURL() == locationURL {
                break
            }
            
            locationURLIndex++
        }
        
        self.pickerView.selectRow(locationURLIndex, inComponent: 0, animated: false)
        
        WeatherService.sharedInstance.fetchDataWithSuccess({ (weather: Weather, isUpdated: Bool) in
            self.setLabelsWithWeather(weather)
            }, failure: { (error: NSError) in
                println("Fetched Error: \(error.localizedDescription)")
        })
    }
}