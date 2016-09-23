//
//  AdditionalInterfaceController.swift
//  weatherAppForLab1
//
//  Created by Daniel on 22.09.16.
//  Copyright © 2016 Daniel. All rights reserved.
//

import WatchKit
import Foundation


class AdditionalInterfaceController: WKInterfaceController {

    @IBOutlet var pressureLabel: WKInterfaceLabel!
    @IBOutlet var humidityLabel: WKInterfaceLabel!
    @IBOutlet var cloudsLabel: WKInterfaceLabel!
    @IBOutlet var windLabel: WKInterfaceLabel!
    
    var pressure: Int = 0 {
        didSet{
            pressureLabel.setText(String(pressure))
        }
    }
    var humidity: Int = 0{
        didSet{
            pressureLabel.setText(String(humidity))
        }
    }
    var clouds: Int = 0{
        didSet{
            pressureLabel.setText(String(clouds))
        }
    }
    var wind: Float = 0.0{
        didSet{
            pressureLabel.setText(String(wind))
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
    }
}
