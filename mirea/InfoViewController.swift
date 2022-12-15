//
//  InfoViewController.swift
//  amc-youtube
//
//  Created by thisdjango on 10.03.2020.
//  Copyright © 2020 thisdjango. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    @IBAction func showDetails(_ sender: UIButton) {

        var stringForURL = ""
        switch (sender.titleLabel?.text) {
        case "Кабинет":
            stringForURL = "https://lk.mirea.ru/"
        case "Расписание":
            stringForURL = "https://www.mirea.ru/schedule/"
        case "Портал":
            stringForURL = "https://online-edu.mirea.ru/"
        default:
            break
        }
        guard let url = URL(string: stringForURL) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func callAction(_ sender: UIButton) {
        let url = URL(string: "tel://\(sender.titleLabel!.text!)")
        guard let url = url,
              UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func sendEmail(_ sender: UIButton) {
        let url = URL(string: "mailto:\(sender.titleLabel!.text!)")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    @IBAction func showSite(_ sender: UIButton) {
        let url = URL(string: sender.titleLabel!.text!)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
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
