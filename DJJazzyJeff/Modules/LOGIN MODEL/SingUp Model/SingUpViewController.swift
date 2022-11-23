//
//  SingUpViewController.swift
//  DJ Jazzy Jaff
//
//  Created by Jigar Khatri on 20/11/22.
//

import UIKit
import TextFieldEffects

class SingUpViewController: UIViewController {
    //DECLARE VARIABLE
    @IBOutlet weak var tblView: UITableView!

    @IBOutlet var txtFirstName: HoshiTextField!
    @IBOutlet var txtLastName: HoshiTextField!
    @IBOutlet var txtEmail: HoshiTextField!
    @IBOutlet var txtPhone: HoshiTextField!
    @IBOutlet var txtPassword: HoshiTextField!
    @IBOutlet var txtConfirmPassword: HoshiTextField!

    @IBOutlet var btnSignIn: UIButton!
    @IBOutlet var btnSignUp: UIButton!
    @IBOutlet var imgLogo: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SET KEYBORD
        setupKeyboard(true)
        
        showAlertMessageWithTitle(strTitle: str.strTitleSignup, strMessage: str.strMessageSignup, button: str.ok)
    }
    

    override func viewWillAppear(_ animated: Bool) {

        //SET PORTRAIT MODE
        AppUtility.PortraitMode()
    
        
        //SET NAVIGAITON AND TABBAR
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = true
        
        
        //SET THE VIEW
        self.setTheView()
      
        
        
    }

    
    
    //SET THE VIEW
    func setTheView() {

        //SET FONT
        self.txtFirstName.placeholder = str.strFirstName
        self.txtFirstName.configureTextAnimation()
        
        self.txtLastName.placeholder = str.strLastName
        self.txtLastName.configureTextAnimation()

        self.txtEmail.placeholder = str.strEmail
        self.txtEmail.configureTextAnimation()

        self.txtPhone.placeholder = str.strPhone
        self.txtPhone.configureTextAnimation()
        self.txtPhone.delegate = self
        
        self.txtPassword.placeholder = str.strPassword
        self.txtPassword.configureTextAnimation()

        self.txtConfirmPassword.placeholder = str.strConfirmPass
        self.txtConfirmPassword.configureTextAnimation()


        //SET BUTTON FONT
        btnSignUp.configureLable(bgColour: .red_main, textColor: .primary, fontName: GlobalConstants.APP_FONT_Bold, fontSize: 20.0, text: str.strRegistration)
        btnSignUp.viewCorneRadius(radius: 0, isRound: true)
        
        btnSignIn.configureLable(bgColour: .clear, textColor: .primary, fontName: GlobalConstants.APP_FONT_Bold, fontSize: 18.0, text: str.strReturnSignIn)
        btnSignIn.btnUnderLineAttributes(str: str.strReturnSignIn, textColor: .primary)
        
        
        //SET HEADER
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            //SET TABLE HEADER
            let vw_Table = self.tblView.tableHeaderView
            vw_Table?.frame = CGRect(x: 0, y: 0, width: self.tblView.frame.size.width, height: self.imgLogo.frame.origin.y + self.imgLogo.frame.size.height + 20)
            self.tblView.tableHeaderView = vw_Table
        }
    }
}

//MARK: - BUTTON ACTION
extension SingUpViewController{
    @IBAction func btnBackClicked(_ sender: UIButton) {
        
        //MOVE TO BACK SCREEN
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSignUpClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        
        //CHECK VALIDATION
        let strFirstName: String = self.txtFirstName.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? ""
        let strLastName: String = self.txtLastName.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? ""
        let strEmail: String = self.txtEmail.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? ""
        let strPhone: String = self.txtPhone.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? ""
        
        if strFirstName == ""{
            showAlertMessage(strMessage: str.errorFirstName)
        }
        else if strLastName == ""{
            showAlertMessage(strMessage: str.errorLastName)
        }
        else if strEmail == ""{
            showAlertMessage(strMessage: str.errorEmail)
        }
        else if !validateEmail(enteredEmail: strEmail){
            showAlertMessage(strMessage: str.errorValidEmail)
        }
        else if strPhone == ""{
            showAlertMessage(strMessage: str.errorPhone)
        }
        else if txtPassword.text == ""{
            showAlertMessage(strMessage: str.errorPassword)
        }
        else if txtConfirmPassword.text == ""{
            showAlertMessage(strMessage: str.errorConfirmPassword)
        }
        else if txtPassword.text != txtConfirmPassword.text{
            showAlertMessage(strMessage: str.errorPasswordNotMatch)
        }
        else{
            //CALL API
            self.signUpAPI(SingUpParameater: SingUpParameater(firstName: strFirstName, lastName: strLastName, email: strEmail, phone: strPhone, password: self.txtPassword.text ?? "", confirmPassword: self.txtConfirmPassword.text ?? ""))
        }
    }
}




//MARK: - KEYBORD DELEGATE
extension SingUpViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.txtPhone{
            let inverseSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let components = string.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")
            
            if filtered == string {
                return true
            } else {
                return false
            }
        }
        else{
            return true
        }
        
    }
}
