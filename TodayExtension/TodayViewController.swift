//
//  TodayViewController.swift
//  TodayExtension
//
//  Created by Paul Wong on 2/11/15.
//  Copyright (c) 2015 funnyordie. All rights reserved.
//

import UIKit
import NotificationCenter
import TechTalkKit

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        self.preferredContentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), 100.0)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        WeatherService.sharedInstance.fetchDataWithSuccess({ (weather: Weather, isUpdated: Bool) in
            if isUpdated {
                self.setLabelsWithWeather(weather)
            }
            }, failure: { (error: NSError) in
                
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.
        
        WeatherService.sharedInstance.fetchDataWithSuccess({ (weather: Weather, isUpdated: Bool) in
            if isUpdated {
                self.setLabelsWithWeather(weather)
                completionHandler(NCUpdateResult.NewData)
            } else {
                completionHandler(NCUpdateResult.NoData)
            }
            }, failure: { (error: NSError) in
                completionHandler(NCUpdateResult.Failed)
        })
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0.0, defaultMarginInsets.left, 0.0, defaultMarginInsets.right)
    }
    
    func setLabelsWithWeather(weather: Weather) {
        dispatch_async(dispatch_get_main_queue(), {
            self.locationLabel.text = weather.location
            self.currentTemperatureLabel.text = weather.currentTemperature
            self.weatherConditionLabel.text = weather.weatherCondition
        })
    }
}
