//
//  InfoViewController.swift
//  WeatherTestMani
//
//  Created by srihari ponnapalli on 01/09/20.
//  Copyright © 2020 ManiKanta. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet var infolable: UILabel!
    var infoString : String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        infolable.text = infoString;
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
