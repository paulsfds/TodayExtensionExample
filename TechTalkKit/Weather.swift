//
//  Weather.swift
//  TechTalkTodayExtension
//
//  Created by Paul Wong on 2/10/15.
//  Copyright (c) 2015 funnyordie. All rights reserved.
//

import UIKit

public class Weather: NSObject, NSCoding {
    public var location: String
    public var currentTemperature: String
    public var weatherCondition: String
    
    init(location: String, currentTemperature: String, weatherCondition: String) {
        self.location = location
        self.currentTemperature = currentTemperature
        self.weatherCondition = weatherCondition
    }
    
    public required init(coder aDecoder: NSCoder)  {
        self.location = aDecoder.decodeObjectForKey("location") as String
        self.currentTemperature = aDecoder.decodeObjectForKey("currentTemperature") as String
        self.weatherCondition = aDecoder.decodeObjectForKey("weatherCondition") as String
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.location, forKey: "location")
        aCoder.encodeObject(self.currentTemperature, forKey: "currentTemperature")
        aCoder.encodeObject(self.weatherCondition, forKey: "weatherCondition")
    }
    
    func description() -> String {
        return "The weather in \(self.location) is \(self.currentTemperature) and \(self.weatherCondition)"
    }
}
