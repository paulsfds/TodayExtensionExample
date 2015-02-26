//
//  WeatherService.swift
//  TechTalkTodayExtension
//
//  Created by Paul Wong on 2/10/15.
//  Copyright (c) 2015 funnyordie. All rights reserved.
//

import UIKit

public class WeatherService {
    var userDefaults: NSUserDefaults!
    
    public class var sharedInstance: WeatherService {
        struct Singleton {
            static let instance = WeatherService()
        }
        return Singleton.instance
    }
    
    init() {
        self.userDefaults = NSUserDefaults(suiteName: kAppGroupID)
        
        if self.getCachedLocationURL() == nil {
            self.cacheLocationURL(kWundergroundSFURL)
        }
    }
    
    public func fetchDataWithSuccess(success: (weather: Weather, isUpdated: Bool) -> (), failure: (error: NSError) -> ()) {
        let url = NSURL(string: self.getCachedLocationURL()!)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            var jsonError: NSError?
            let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &jsonError)
            
            if let jsonDictionary = json as? NSDictionary {
                if let currentObservation = jsonDictionary["current_observation"] as? NSDictionary {
                    if let displayLocation = currentObservation["display_location"] as? NSDictionary {
                        let location = displayLocation["full"] as? NSString
                        let currentTemperature = currentObservation["temperature_string"] as? NSString
                        let weatherCondition = currentObservation["weather"] as? NSString
                        let weather = Weather(location: location!, currentTemperature: currentTemperature!, weatherCondition: weatherCondition!)
                        var isUpdated = false
                        if let cachedWeather = self.getCachedWeather() {
                            isUpdated = weather.location == cachedWeather.location
                        }
                        
                        self.cacheWeather(weather)
                        
                        success(weather: weather, isUpdated: isUpdated)
                    }
                }
            }
        }
        
        task.resume()
    }
    
    public func cacheWeather(weather: Weather) {
        let weatherData = NSKeyedArchiver.archivedDataWithRootObject(weather)
        self.userDefaults.setObject(weatherData, forKey: "weatherData")
        self.userDefaults.synchronize()
    }
    
    public func getCachedWeather() -> Weather? {
        if let weatherData = self.userDefaults.objectForKey("weatherData") as? NSData {
            let weather = NSKeyedUnarchiver.unarchiveObjectWithData(weatherData) as Weather
            return weather
        }
        
        return nil
    }
    
    public func cacheLocationURL(locationURL: String) {
        self.userDefaults.setObject(locationURL, forKey: "locationURL")
        self.userDefaults.synchronize()
    }
    
    public func getCachedLocationURL() -> String? {
        if let locationURL = self.userDefaults.objectForKey("locationURL") as? String {
            return locationURL
        }
        
        return nil
    }
}
