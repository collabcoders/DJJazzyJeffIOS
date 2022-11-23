//
//  LoginViewController.swift
//  BAYNOUNAH
//
//  Created by Jigar Khatri on 22/06/22.
//

import UIKit
import TextFieldEffects

class LoginViewController: UIViewController {
    
    //DECLARE VARIABLE
    @IBOutlet weak var tblView: UITableView!

    @IBOutlet var txtEmail: HoshiTextField!
    @IBOutlet var txtPassword: HoshiTextField!

    @IBOutlet var btnForgotPassword: UIButton!
    @IBOutlet var btnSignIn: UIButton!
    @IBOutlet var btnSignUp: UIButton!
    @IBOutlet var imgLogo: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SET KEYBORD
        setupKeyboard(true)
        
        //SET THE VIEW
        self.setTheView()
    }
    

    override func viewWillAppear(_ animated: Bool) {

        //SET PORTRAIT MODE
        AppUtility.PortraitMode()
    
        
        //SET NAVIGAITON AND TABBAR
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = true
            
        self.txtEmail.text = ""
        self.txtPassword.text = ""
        
        
        #if DEBUG
        self.txtEmail.text = "khatri6168@gmail.com"
        self.txtPassword.text = "123123"
        #endif
        
    }

    
    
    //SET THE VIEW
    func setTheView() {

        //SET FONT
        txtEmail.placeholder = str.strEmail
        txtEmail.configureTextAnimation()

        txtPassword.placeholder = str.strPassword
        txtPassword.configureTextAnimation()

        //SET BUTTON FONT
        btnForgotPassword.configureLable(bgColour: .clear, textColor: .secondary, fontName: GlobalConstants.APP_FONT_Bold, fontSize: 18.0, text: str.strForgotPassword)
        btnForgotPassword.btnUnderLineAttributes(str: str.strForgotPassword, textColor: .secondary)

        btnSignIn.configureLable(bgColour: .red_main, textColor: .primary, fontName: GlobalConstants.APP_FONT_Bold, fontSize: 20.0, text: str.strSignIn)
        btnSignIn.viewCorneRadius(radius: 0, isRound: true)
        
        btnSignUp.configureLable(bgColour: .clear, textColor: .primary, fontName: GlobalConstants.APP_FONT_Bold, fontSize: 18.0, text: str.strSignUp)
        btnSignUp.btnUnderLineAttributes(str: str.strSignUp, textColor: .primary)
   
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
extension LoginViewController{
    
    @IBAction func btnForgotPasswordClicked(_ sender: UIButton) {
        
        let alert = UIAlertController(title: nil, message: str.strForgotPAsswordTitle, preferredStyle: .alert)
        if #available(iOS 13.0, *) {
            alert.overrideUserInterfaceStyle = .dark
        } else {
            // Fallback on earlier versions
        }
        alert.view.tintColor = UIColor.secondary
        alert.addTextField() { newTextField in
            newTextField.placeholder = str.strEmail
        }
        alert.addAction(UIAlertAction(title: str.strForgotPassowrdCancel, style: .cancel) { _ in  })
        alert.addAction(UIAlertAction(title: str.strForgotPassowrdSubmit, style: .default) { action in
            if
                let textFields = alert.textFields,
                let tf = textFields.first,
                let result = tf.text
            {
                //CHECK VALIDATION
                let strEmial: String = result.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

                if strEmial == ""{
                    showAlertMessage(strMessage: str.errorEmail)
                }
                else if !validateEmail(enteredEmail: strEmial){
                    showAlertMessage(strMessage: str.errorValidEmail)
                }
                else{
                    //CALL API
                    self.forgetPasswordAPI(ForgetPasswordParameater: ForgetPasswordParameater(email: strEmial))
                }
            }
            else
            {
                showAlertMessage(strMessage: str.errorEmail)
            }
        })
        navigationController?.present(alert, animated: true)
    }
    
    @IBAction func btnSignUpClicked(_ sender: UIButton) {
        
        //MOVE TO SIGNUP SCREEN
        let storyBoard: UIStoryboard = UIStoryboard(name: GlobalConstants.LOGIN_MODEL, bundle: nil)
        if let newViewController = storyBoard.instantiateViewController(withIdentifier: "SingUpViewController") as? SingUpViewController{
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    
    
    @IBAction func btnLoginClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        
        //CHECK VALIDATION
        let strEmail: String = self.txtEmail.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? ""
        
        if strEmail == ""{
            showAlertMessage(strMessage: str.errorEmail)
        }
        else if !validateEmail(enteredEmail: strEmail){
            showAlertMessage(strMessage: str.errorValidEmail)
        }
        else if self.txtPassword.text == ""{
            showAlertMessage(strMessage: str.errorPassword)
        }
        else{
            //CALL API
            self.loginAPI(LoginParameater: LoginParameater(username: strEmail, password: self.txtPassword.text ?? ""))
        }
    }
}
