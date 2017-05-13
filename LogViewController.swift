//
//  LogViewController.swift
//  MySiemensTracker
//
//  Created by Brennan Hoeting on 5/12/17.
//  Copyright © 2017 bustasari. All rights reserved.
//

import UIKit

class LogViewController: UIViewController {
    @IBOutlet var startWorkingButton: UIButton!
    @IBOutlet var eatLunchButton: UIButton!
    @IBOutlet var finishEatingButton: UIButton!
    @IBOutlet var goHomeButton: UIButton!
    @IBOutlet var resetButton: UIButton!
    
    @IBOutlet var firstWorkingTimeLabel: UILabel!
    @IBOutlet var lunchTimeLabel: UILabel!
    @IBOutlet var secondWorkingTimeLabel: UILabel!
	
	override var preferredStatusBarStyle : UIStatusBarStyle {
		return UIStatusBarStyle.lightContent;
	}

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimerLabels), userInfo: nil, repeats: true)
        
        self.updateTimerLabels()
        
        if AppManager.isWorkingMorning() {
            self.eatLunchButton.isEnabled = true
        } else if AppManager.isEating() {
            self.finishEatingButton.isEnabled = true
        } else if AppManager.isWorkingAfternoon() {
            self.goHomeButton.isEnabled = true
        } else if !AppManager.isDayFinished() {
            self.startWorkingButton.isEnabled = true
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTimerLabels() {
        DispatchQueue.main.async {
            self.firstWorkingTimeLabel.text = AppManager.morningWorkingTimeString()
            self.lunchTimeLabel.text = AppManager.eatingTimeString()
            self.secondWorkingTimeLabel.text = AppManager.workingAfternoonTimeString()
        }
    }
    
    @IBAction func startWorkingTapped(_ sender: UIButton) {
        AppManager.startWorking()
        self.startWorkingButton.isEnabled = false
        self.eatLunchButton.isEnabled = true
    }
    
    @IBAction func startLunchTapped(_ sender: UIButton) {
        AppManager.startEating()
        self.finishEatingButton.isEnabled = true
        self.eatLunchButton.isEnabled = false
    }
    
    @IBAction func finishLunchTapped(_ sender: UIButton) {
        AppManager.finishEating()
        self.finishEatingButton.isEnabled = false
        self.goHomeButton.isEnabled = true
    }
    
    @IBAction func goHomeTapped(_ sender: UIButton) {
        AppManager.goHome()
        self.goHomeButton.isEnabled = false
    }
    
    @IBAction func resetTapped(_ sender: UIButton) {
        AppManager.reset()
        self.startWorkingButton.isEnabled = true
        self.updateTimerLabels()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
