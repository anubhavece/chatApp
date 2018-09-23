import UIKit
import Firebase
import SVProgressHUD

class RegisterViewController: UIViewController {

    
    /
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    //registering
    
    @IBAction func registerPressed(_ sender: AnyObject) {
        var regCheck : Bool = false
        SVProgressHUD.show()
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            if error != nil{
                print("ERROR")
                print (error!)
            }else{
                regCheck = true
                print("no registration error")
                    SVProgressHUD.dismiss()
            }
            if regCheck == true{
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
        }
        
        //TODO: Set up a new user on our Firbase database
        
        

        
        
    } 
    
    
}
