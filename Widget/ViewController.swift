//
//  ViewController.swift
//  Widget
//
//  Created by 汤天明 on 2020/10/19.
//

import UIKit

class ViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func pickerAction(_ sender: UIButton) {
        
        present(MotivationViewController(), animated: true, completion: nil)
    }
}

