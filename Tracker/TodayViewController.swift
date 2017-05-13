//
//  TodayViewController.swift
//  Tracker
//
//  Created by Brennan Hoeting on 5/12/17.
//  Copyright © 2017 bustasari. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet var timerLabel: UILabel!
	@IBOutlet var morningLabel: UILabel!
	@IBOutlet var lunchLabel: UILabel!
	
    @IBOutlet var actionButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSize(width: 0, height: 200)
        self.updateUI()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		let _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateUI), userInfo: nil, repeats: true)
		self.updateUI()
	}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
		self.updateUI()
		
        completionHandler(NCUpdateResult.newData)
    }
	
	
	func updateButton() {
		if AppManager.isDayFinished() {
			self.actionButton.setTitle("reset", for: .normal)
		} else if AppManager.isWorkingAfternoon() {
			self.actionButton.setTitle("Go Home",for: .normal)
		} else if AppManager.isEating() {
			self.actionButton.setTitle("Finished Eating",for: .normal)
		} else if AppManager.isWorkingMorning() {
			self.actionButton.setTitle("Eat Lunch",for: .normal)
		} else {
			self.actionButton.setTitle("Start working", for: .normal)
		}
	}
	
	func updateLabel() {
		self.morningLabel.isHidden = true
		self.lunchLabel.isHidden = true
		func showLunch() {
			self.lunchLabel.text = "lunch: " + AppManager.eatingTimeString()
			self.lunchLabel.isHidden = false
		}
		func showMorning() {
			self.morningLabel.text = "morning: " + AppManager.morningWorkingTimeString()
			self.morningLabel.isHidden = false
		}
		func showBoth() {
			showLunch()
			showMorning()
		}
		if AppManager.isDayFinished() {
			self.timerLabel.text = "afternoon: " + AppManager.workingAfternoonTimeString()
			showBoth()
		} else if AppManager.isWorkingAfternoon() {
			self.timerLabel.text = AppManager.workingAfternoonTimeString()
			showBoth()
		} else if AppManager.isEating() {
			self.timerLabel.text = AppManager.eatingTimeString()
			showMorning()
		} else if AppManager.isWorkingMorning() {
			self.timerLabel.text = AppManager.morningWorkingTimeString()
		} else {
			self.timerLabel.text = "00:00:00"
		}
	}
	
	func updateUI() {
		DispatchQueue.main.async {
			self.updateButton()
			self.updateLabel()
		}
	}
	
    @IBAction func actionTapped(_ sender: Any) {
		if AppManager.isDayFinished() {
			AppManager.reset()
		} else if AppManager.isWorkingAfternoon() {
			AppManager.goHome()
		} else if AppManager.isEating()	{
			AppManager.finishEating()
		} else if AppManager.isWorkingMorning() {
			AppManager.startEating()
		} else {
			AppManager.startWorking()
		}
		self.updateButton()
    }
        
}
