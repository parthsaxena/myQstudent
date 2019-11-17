//
//  LoginViewController.swift
//  myQstudent
//
//  Created by Parth Saxena on 10/12/19.
//  Copyright © 2019 Parth Saxena. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Pastel

class LoginViewController: UIViewController, UITextFieldDelegate {

    var pastelView: PastelView!
    
    @IBOutlet weak var pin_textField: UITextField!
    @IBOutlet weak var pwd_textField: UITextField!
    
    var blur: UIVisualEffectView!
    var activityIndicatorView: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: self.view.center.x - 30, y: self.view.center.y - 30, width: 80, height: 80), type: .ballZigZag, color: UIColor(red: 127/255, green: 194/255, blue: 78/255, alpha: 1.0), padding: 0)
        NVActivityIndicatorPresenter.sharedInstance.setMessage("This will take a few moments...")
                
        pin_textField.delegate = self
        pwd_textField.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        pastelView = PastelView(frame: view.bounds)
        pastelView.animationDuration = 2.5
        
        pastelView.setColors([UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0),
                              UIColor(red: 73/255, green: 112/255, blue: 204/255, alpha: 1.0),
                              UIColor(red: 79/255, green: 167/255, blue: 89/255, alpha: 1.0),
                              UIColor(red: 198/255, green: 203/255, blue: 146/255, alpha: 1.0),
                              UIColor(red: 245/255, green: 48/255, blue: 88/255, alpha: 1.0)])
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
        print("animated")
        //stopAnimating()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func startAnimating() {
        blur = UIVisualEffectView(effect: nil)
        blur.frame = self.view.frame
        self.activityIndicatorView.center = self.view.center
        self.activityIndicatorView.alpha = 0
        self.view.addSubview(blur)
        self.view.addSubview(activityIndicatorView)
        UIView.animate(withDuration: 0.4) {
            self.blur.effect = UIBlurEffect(style: .light)
            self.activityIndicatorView.alpha = 1
        }
        activityIndicatorView.startAnimating()
    }
    
    func stopAnimating() {
        DispatchQueue.main.async {
            let vc = self.storyboard?.instantiateViewController(identifier: "GradesVC")
            self.modalPresentationStyle = .overCurrentContext
            vc!.modalPresentationStyle = .overCurrentContext
            self.present(vc!, animated: true, completion: nil)
            
            let over_view = UIView(frame: self.view.frame)
            over_view.backgroundColor = UIColor.white
            self.view.addSubview(over_view)
            over_view.alpha = 0
            
            UIView.animate(withDuration: 0.4, animations: {
                self.blur.alpha = 0
                over_view.alpha = 1
                self.activityIndicatorView.alpha = 0
            }) { (success) in
                self.blur.removeFromSuperview()
                self.activityIndicatorView.stopAnimating()
                self.activityIndicatorView.removeFromSuperview()
                self.blur.removeFromSuperview()
            
            }
        }
    }
    
    @IBAction func sign_in_tapped(_ sender: Any) {
        let pin = pin_textField.text!
        let password = pwd_textField.text!
        
        retrieveData(pin: pin, pwd: password)
        DispatchQueue.main.async {
            self.startAnimating()
            print("loading 1")
        }
    }
    
    func retrieveData(pin: String, pwd: String) {
        var urlRequest = URLRequest(url: URL(string: "http://10.141.59.142:8088")!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let parameters: [String: Any] = [
            "pin": pin,
            "pwd": pwd
        ]
        let postString = "pin=\(pin)&pwd=\(pwd)"
        urlRequest.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {                                              // check for fundamental networking error
                print("error", error ?? "Unknown error")
                return
            }

            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }

            guard let responseString = String(data: data, encoding: .utf8) else {
                return
            }
            if responseString == "Wrong Info" {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.4, animations: {
                        self.blur.alpha = 0
                        self.activityIndicatorView.alpha = 0
                    }) { (success) in
                        self.blur.removeFromSuperview()
                        self.activityIndicatorView.stopAnimating()
                        self.activityIndicatorView.removeFromSuperview()
                        self.blur.removeFromSuperview()
                        let alert = UIAlertController(title: "whoops", message: "incorrect id / password", preferredStyle: .alert)
                        alert.view.tintColor = UIColor.red
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            } else {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    if let class_data = json as? [[String: Any]] {
                        for class_item in class_data {
                            var tmp_assignments = [Assignment]()
                            if let assignments = class_item["assignments"] as? [String: Any] {
                                for assignment in assignments {
                                    if let assignment_dict = assignment.value as? [String: Any] {
                                        var assign = Assignment(title: assignment_dict["title"] as! String, grade: assignment_dict["grade"] as! String, date: assignment_dict["date"] as! String)
                                        tmp_assignments.append(assign)
                                    }
                                }
                            }
                            var name = (class_item["class"] as! String).dropFirst(9)
                            var class_add = Class(name: String(name), grade: class_item["grade"] as! String, assignments: tmp_assignments)
                            print("added class: \(class_add.name!)")
                            GlobalVars.classes.append(class_add)
                        }
                        // finished adding classes
                        DispatchQueue.main.async {
                            print("finished adding classes")
                            self.stopAnimating()
                        }
                    }
                } catch {
                    print("Error serializing JSON: \(error)")
                }
            }
        }

        task.resume()
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
