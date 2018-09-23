import UIKit
import Firebase
import ChameleonFramework

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
   
    var messageArray : [Message] = [Message]()
    
    
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegates
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTextfield.delegate = self
        
        
        
        //setting tap gesture to close keyboard
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(gesture)
        
        //regitering xib file
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        handleTableSize()
        retrieveMessage()
        messageTableView.separatorStyle = .none
        
        
    }
    
    @objc func tableViewTapped(){
        messageTextfield.endEditing(true)
    }
    
    ///////////////////////////////////////////
    
    //MARK: - TableView
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "egg")
        if cell.senderUsername.text == Auth.auth().currentUser?.email{
            cell.avatarImageView.backgroundColor = UIColor.flatSkyBlueColorDark()
            cell.messageBody.backgroundColor = UIColor.flatRed()
        }else{
            cell.avatarImageView.backgroundColor = UIColor.flatLime()
            cell.messageBody.backgroundColor = UIColor.flatSkyBlue()
        
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    
   //autosizing tableview cells
    func handleTableSize(){
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
    
    ///////////////////////////////////////////
    
    //closing keyboard
    var textDone : Bool = false
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        UIView.animate(withDuration: 0.5){
            self.heightConstraint.constant = 358
            self.view.layoutIfNeeded()
            self.textDone = true
        }
    }
    
   
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5){
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    
    
    
    
    ///////////////////////////////////////////
    
    
    //sending user messages to Firebase
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        messageTextfield.endEditing(true)
        
        //TODO: Send the message to Firebase and save it in our database
        messageTextfield.isEnabled = false
        
        let messageDatabase = Database.database().reference().child("Messages")
        let messageDict = ["Sender" : Auth.auth().currentUser?.email, "MessageBody" : messageTextfield.text]
        
        messageDatabase.childByAutoId().setValue(messageDict){
            (error, reference) in
            
            if error != nil {
                print (error!)
            }else{
                print("all good brother msg sent")
                self.messageTextfield.isEnabled = true
                self.messageTextfield.text = ""
                self.sendButton.isEnabled = true
                
            }
        }
    }
    
   //getting data from firebase
    func retrieveMessage(){
        let messageDB = Database.database().reference().child("Messages")
        messageDB.observe(.childAdded) { (snapshot) in
            let snapVal = snapshot.value as! Dictionary<String,String>
            
            let text = snapVal["MessageBody"]
            let senderEmail = snapVal["Sender"]!
            
            let msg = Message()
            msg.messageBody = text ?? ""
            
            msg.sender = senderEmail
            
            self.messageArray.append(msg)
            self.messageTableView.reloadData()
            
            
            
        }
    }
    //log out
    @IBAction func logOutPressed(_ sender: AnyObject) {
        do{
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
            
        }catch{
            print("error")
        }
        
    }
    
    
    
}
