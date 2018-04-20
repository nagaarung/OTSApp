//
//  RegisterViewController.swift
//  OTSApp
//
//  Created by Naga Arun on 20/04/18.
//  Copyright © 2018 Naga Arun. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var nameTF: HoshiTextField!
    @IBOutlet weak var emailTF: HoshiTextField!
    @IBOutlet weak var mobileTF: HoshiTextField!
    @IBOutlet weak var passwordTF: HoshiTextField!
    @IBOutlet weak var reEnterPass: HoshiTextField!
    
    @IBOutlet weak var label1: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var googleBT: UIButton!
    @IBOutlet weak var fbBT: UIButton!
    @IBOutlet weak var registerBT: UIButton!
    
    @IBAction func registerACBT(_ sender: UIButton) {
        
        if nameTF.text!.isEmpty || emailTF.text!.isEmpty  || mobileTF.text!.isEmpty || passwordTF.text!.isEmpty || reEnterPass.text!.isEmpty{
            
            print("Registration failed. Empty TextField")
            label1.text = "Registration failed. Empty TextField"
        } else {
            
            if ((passwordTF.text?.elementsEqual(reEnterPass.text!))! == true)
            {
                // prepare json data
                let url = URL(string: "https://offtheshelfstocks.com/rest/register?")!
                var request = URLRequest(url: url)
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "POST"
                
                print(passwordTF.text ?? "No Values")
                
                let eMailVal = emailTF.text
                let nameVal = nameTF.text
                let mobileVal = mobileTF.text
                let passVal = passwordTF.text
                
                let postString = "email_id=\(eMailVal ?? "No Values")&customer_name=\(nameVal ?? "No Values")&mobile_number=\(mobileVal ?? "No Values")&password=\(passVal ?? "No Values")"
                print(postString)
                
                request.httpBody = postString.data(using: .utf8)
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, error == nil else { // check for fundamental networking error
                        print("error=\(String(describing: error))")
                        return
                    }
                    
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 { // check for http errors
                        print("statusCode should be 200, but is \(httpStatus.statusCode)")
                        print("response = \(String(describing: response))")
                    }
                    
                    let responseString = String(data: data, encoding: .utf8)
                    print("responseString = \(String(describing: responseString ?? "No Values"))")
                    
                    let jsonData = responseString?.data(using: .utf8)
                    let dictionary = try? JSONSerialization.jsonObject(with: jsonData!, options: .mutableLeaves) as! [String: String]
                    print(dictionary!["message"] ?? "Not Registed"  as Any)
                    
                    let cccc: String = dictionary!["message"] ?? "Not Registed"  as Any as! String
                    
                    let alertController = UIAlertController(title: "Registration", message: "\(cccc)", preferredStyle: .alert)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                task.resume()
                // prepare json data
                return
            } else {
                print("Password Not Match")
                label1.text = "Password Not Match"
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
