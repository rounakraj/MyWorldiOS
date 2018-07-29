//
//  BlockListVc.swift
//  MyWorld
//
//  Created by mac on 28/07/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
class BlockListVc: UIViewController , UITableViewDataSource,UITableViewDelegate{

    @IBOutlet weak var tableViewBlock: UITableView!
    var blockArray = NSArray()

    @IBAction func btnBackPress(_ sender: Any) {
        
        navigationController?.popToRootViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getUpdatesDetailData()
    }
    
    func getUpdatesDetailData() -> Void {
        
        let postData = NSMutableData(data: "userId=\(String(describing: UserDefaults.standard.string(forKey: "userId")!))".data(using: String.Encoding.utf8)!)
        
        ApiManager.getData(paramValue: postData as NSMutableData, isactivity: true, apiName: "blockedUsers.php", uiView: self.view, withCompletionHandler: {data,error in
            if error != nil {
                
                print(error ?? "error")
                DispatchQueue.main.async(execute: {
                    let alertController = UIAlertController(title: "MyWorld", message: error?.localizedDescription, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                        // Do whatever you want with inputTextField?.text
                        
                    })
                    alertController.addAction(ok)
                    self.present(alertController, animated: true, completion: nil)
                })
                
            }else{
                
                print(data);
                
                if data .value(forKey: "responseCode") as! String == "200"{
                    DispatchQueue.main.async(execute: {
                        
                        let value: AnyObject? = data.value(forKey: "User") as AnyObject
                        
                        if value is NSString {
                            print("It's a string")
                            
                        } else if value is NSArray {
                            print("It's an NSArray")
                            self.blockArray = value as! NSArray

                        }
                        self.tableViewBlock.reloadData()
                    })
                }else{
                    DispatchQueue.main.async(execute: {
                        let alertController = UIAlertController(title: "MyWorld", message: data .value(forKey: "responseMessage") as? String, preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                            // Do whatever you want with inputTextField?.text
                            
                        })
                        alertController.addAction(ok)
                        self.present(alertController, animated: true, completion: nil)
                    })
                }
                
            }
            
        })
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return blockArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
            return 120;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Block")as? Block else{ return UITableViewCell ()}
        var dict = NSDictionary()
        dict = blockArray[indexPath.row] as! NSDictionary
            let firstName = dict.value(forKey: "firstName") as? String
            let lastName = dict.value(forKey: "lastName") as? String
        cell.btnUnblock.addTarget(self, action: #selector(unBlockUser(sender:)), for: .touchUpInside)
        cell.blockUserName.text =  firstName!+" "+lastName!
        cell.blockUserStutas.text = dict.value(forKey: "emailId")as? String
        cell.blockUserImage.layer.cornerRadius = cell.blockUserImage.frame.size.width / 2;
        cell.blockUserImage.clipsToBounds = true;
        
        cell.btnUnblock.layer.borderWidth = 0.8
        cell.btnUnblock.layer.cornerRadius = 5.0
        cell.btnUnblock.layer.borderColor = UIColor.gray.cgColor
        
        if let profileImage = dict.value(forKey: "profileImage") as? String {
            
            if (profileImage.hasPrefix("graph")){
                if let imageURL = URL(string: "https://"+profileImage){
                    cell.blockUserImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "ic_profile"))
                }
            }else{
                cell.blockUserImage.sd_setImage(with: URL(string: profileImage), placeholderImage: UIImage(named: "ic_profile"))
            }
        }
    
        return cell
    }
    
     @objc func unBlockUser(sender : UIButton){
        
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tableViewBlock)
        let indexPath = self.tableViewBlock.indexPathForRow(at: buttonPosition)
        var dict = NSDictionary()
        dict = blockArray[(indexPath?.row)!] as! NSDictionary
        let userId = dict.value(forKey: "userId")as? String

        let dic = ["login_user_id" : UserDefaults.standard.string(forKey: "userId")!,
                   "block_user_id" : userId!]  as [String : Any]
        
        self.sendDataToServerUsingWrongContent(param:dic)
    }
    func sendDataToServerUsingWrongContent(param:[String:Any]){
        
        SVProgressHUD.show(withStatus: "Loading")
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in param {
                
                multipartFormData.append(((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!), withName: key )
                
            }
            
        }, to: WEBSERVICE_URL + "blockAndReport.php")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                    print("progress \(progress) " )
                    
                })
                
                upload.responseJSON { response in
                    //print response.result
                    print("response data \(response) " )
                    let jsonResponse = response.result.value as! NSDictionary
                    if jsonResponse.value(forKey: "responseCode") as! String == "200"{
                        let alertController = UIAlertController(title: "Block and Report", message: jsonResponse.value(forKey: "responseMessage") as? String, preferredStyle: .alert)
                        SVProgressHUD.dismiss()
                        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                            self.navigationController?.popToRootViewController(animated: true)

                            self.viewWillAppear(true)
                        })
                        alertController.addAction(ok)
                        self.present(alertController, animated: true, completion: nil)
                        
                    }else{
                        DispatchQueue.main.async(execute: {
                            let alertController = UIAlertController(title: "Block and Report", message: jsonResponse.value(forKey: "responseMessage") as? String, preferredStyle: .alert)
                            SVProgressHUD.dismiss()
                            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                                // Do whatever you want with inputTextField?.text
                                self.navigationController?.popViewController(animated:true)
                            })
                            alertController.addAction(ok)
                            self.present(alertController, animated: true, completion: nil)
                        })
                    }
                    
                }
                
            case .failure( _):
                SVProgressHUD.dismiss()
                break
                //print encodingError.description
                
            }
        }
    }
    
   
}
