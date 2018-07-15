//
//  PasscodeViewController.swift
//  videoCallPrincess
//
//  Created by Colter Conway on 2/18/18.
//  Copyright © 2018 Colter Conway. All rights reserved.
//

import UIKit
import LocalAuthentication
import SVProgressHUD

protocol PasscodeTextFieldDelegate: class {
  func textFieldDidDelete(textField: PasscodeTextField)
}

class PasscodeTextField: UITextField {

  weak var myDelegate: PasscodeTextFieldDelegate?

  override func deleteBackward() {
    super.deleteBackward()
    myDelegate?.textFieldDidDelete(textField: self)
  }
}

class PasscodeViewController: UIViewController {

  @IBOutlet var digitOne: PasscodeTextField!
  @IBOutlet var digitTwo: PasscodeTextField!
  @IBOutlet var digitThree: PasscodeTextField!
  @IBOutlet var digitFour: PasscodeTextField!
  @IBOutlet weak var changePasswordButton: UIButton!

  enum ScreenType {
    case enterPasscode
    case setPasscode
    case confirmPasscode(passcode: String)
    case askOldPasscode
    case setNewPasscode
    case confirmNewPasscode(passcode: String)
  }

  var type: ScreenType!

  var storePassCode: String?
  var passCodeDic: [Int: String] = [:]

  let defaults = UserDefaults.standard

  @IBOutlet weak var passcodeInfoLbl: UILabel!
    
  let yellowColor = UIColor(red: 0xFF, green: 0xD8, blue: 0x66)


  override func viewDidLoad() {
    super.viewDidLoad()

    TouchIDCall()

    digitOne.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
    digitTwo.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
    digitThree.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
    digitFour.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)

    digitOne.myDelegate = self
    digitTwo.myDelegate = self
    digitThree.myDelegate = self
    digitFour.myDelegate = self

    self.reset()
  }

  func reset() {
    self.storePassCode = defaults.string(forKey: "PasscodeKey")
    if self.type == nil {
      self.type = self.storePassCode == nil ? ScreenType.setPasscode : ScreenType.enterPasscode
    }

    self.resetTextField()

    changePasswordButton.isHidden = true

    switch self.type! {
    case .enterPasscode:
      passcodeInfoLbl.text = "Please enter your passcode"
      changePasswordButton.isHidden = false
    case .setPasscode:
      passcodeInfoLbl.text = "Please set your passcode"
    case .confirmPasscode:
      passcodeInfoLbl.text = "Please confirm your passcode"
      changePasswordButton.isHidden = true
    case .askOldPasscode:
      passcodeInfoLbl.text = "Please enter your current passcode"
    case .setNewPasscode:
      passcodeInfoLbl.text = "Please enter new passcode"
    case .confirmNewPasscode:
      passcodeInfoLbl.text = "Please confirm your passcode"
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func TouchIDCall() {
    let touchIDPermission = defaults.bool(forKey: "TouchIDKey")
    if touchIDPermission == true {
      let authContext : LAContext = LAContext()

      if authContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil){

        authContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "For Parents Only Section", reply: {
          (wasSuccessful, error) in

          if wasSuccessful{
            print("TouchID Successful")
            DispatchQueue.main.async() {
              NotificationCenter.default.post(name: NSNotification.Name.init("dismissAllPasscodeScreenAndPresentParentScreen"), object: nil)
//                self.performSegue(withIdentifier: "segueParents", sender: self)
            }
          } else {
            print("TouchID Unsuccessful")
            DispatchQueue.main.async() {
              self.digitOne.becomeFirstResponder()
            }
          }
        })
      } else {
        self.digitOne.becomeFirstResponder()
      }
    }
  }

  @objc func textFieldDidChange(textField:UITextField) {
    let code = textField.text

    if code?.count == 1 {
      switch textField {
      case digitOne:
        if digitTwo.text?.count == 1 {
          digitOne.resignFirstResponder()
        }
        else {
          passCodeDic[1] = code!
          digitOne.text = ""
          digitOne.backgroundColor = yellowColor
          digitOne.isEnabled = false
          digitTwo.becomeFirstResponder()
        }
      case digitTwo:
        if digitThree.text?.count == 1 {
          digitTwo.resignFirstResponder()
        }
        else {
          passCodeDic[2] = code!
          digitTwo.text = ""
          digitTwo.backgroundColor = yellowColor
          digitTwo.isEnabled = false
          digitThree.becomeFirstResponder()
        }
      case digitThree:
        if digitFour.text?.count == 1 {
          digitThree.resignFirstResponder()
        }
        else {
          passCodeDic[3] = code!
          digitThree.text = ""
          digitThree.backgroundColor = yellowColor
          digitThree.isEnabled = false
          digitFour.becomeFirstResponder()
        }
      case digitFour:
        digitFour.resignFirstResponder()
        passCodeDic[4] = code!
        digitFour.text = ""
        digitFour.backgroundColor = yellowColor

        let userEnteredPasscode = passCodeDic[1]! + passCodeDic[2]! + passCodeDic[3]! + passCodeDic[4]!
        switch self.type! {
        case .enterPasscode:
          if userEnteredPasscode == self.storePassCode {
            NotificationCenter.default.post(name: NSNotification.Name.init("dismissAllPasscodeScreenAndPresentParentScreen"), object: nil)
          } else {
            self.resetTextField()
            SVProgressHUD.showError(withStatus: "Oops! Wrong passcode.")
            SVProgressHUD.dismiss(withDelay: 3)
             self.digitOne.becomeFirstResponder()
          }
        case .setPasscode:
          self.presentNewScreen(type: ScreenType.confirmPasscode(passcode: userEnteredPasscode))
          self.digitOne.becomeFirstResponder()
        case .confirmPasscode(let step1Passcode):
          if userEnteredPasscode == step1Passcode {
            defaults.set(userEnteredPasscode, forKey: "PasscodeKey")
            SVProgressHUD.showSuccess(withStatus: "New Password\nSet!")
            SVProgressHUD.dismiss(withDelay: 3) {
              NotificationCenter.default.post(name: NSNotification.Name.init("dismissAllPasscodeScreenAndPresentParentScreen"), object: nil)
            }
          } else {
            self.resetTextField()
            SVProgressHUD.showError(withStatus: "Oops! Wrong passcode.")
            SVProgressHUD.dismiss(withDelay: 3)
            self.digitOne.becomeFirstResponder()
          }
        case .askOldPasscode:
          if userEnteredPasscode == self.storePassCode {
            self.presentNewScreen(type: PasscodeViewController.ScreenType.setNewPasscode)
            self.digitOne.becomeFirstResponder()
          } else {
            self.resetTextField()
            SVProgressHUD.showError(withStatus: "Oops! Wrong passcode.\nPlease try again or re-download the app to create a new passcode.")
            SVProgressHUD.dismiss(withDelay: 3)
            self.digitOne.becomeFirstResponder()
          }
        case .setNewPasscode:
          self.presentNewScreen(type: PasscodeViewController.ScreenType.confirmNewPasscode(passcode: userEnteredPasscode))
          self.digitOne.becomeFirstResponder()
        case .confirmNewPasscode(let step1Passcode):
          if userEnteredPasscode == step1Passcode {
            defaults.set(userEnteredPasscode, forKey: "PasscodeKey")
            SVProgressHUD.showSuccess(withStatus: "New Password\nSet!")
            SVProgressHUD.dismiss(withDelay: 3) {
              NotificationCenter.default.post(name: NSNotification.Name.init("dismissAllPasscodeScreenAndPresentParentScreen"), object: nil)
            }
          } else {
            self.resetTextField()
            SVProgressHUD.showError(withStatus: "Oops! Wrong passcode.")
            SVProgressHUD.dismiss(withDelay: 3)
            self.digitOne.becomeFirstResponder()
          }
        }
      default: break
      }
    }
  }

  func presentNewScreen(type: ScreenType) {
    self.type = type
    self.reset()
  }

  func resetTextField() {
    digitOne.isEnabled = true
    digitTwo.isEnabled = true
    digitThree.isEnabled = true
    digitFour.isEnabled = true

    digitOne.backgroundColor = UIColor.white
    digitTwo.backgroundColor = UIColor.white
    digitThree.backgroundColor = UIColor.white
    digitFour.backgroundColor = UIColor.white
    //    digitOne.becomeFirstResponder()
  }

  @IBAction func passwordChangeBtn(_ sender: Any) {
//    passcodeInfoLbl.text = "Please enter your current passcode"
//    self.type = ScreenType.askOldPasscode
    self.presentNewScreen(type: PasscodeViewController.ScreenType.askOldPasscode)
  }

  @IBAction func cancelBtn(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
}

extension PasscodeViewController: PasscodeTextFieldDelegate {
  func textFieldDidDelete(textField: PasscodeTextField) {
    if textField == digitOne {
      passCodeDic.removeValue(forKey: 1)
      digitOne.backgroundColor = UIColor.white
    } else if textField == digitTwo {
      passCodeDic.removeValue(forKey: 2)
      digitOne.isEnabled = true
      digitOne.becomeFirstResponder()
      digitTwo.backgroundColor = UIColor.white
    } else if textField == digitThree {
      passCodeDic.removeValue(forKey: 3)
      digitTwo.isEnabled = true
      digitTwo.becomeFirstResponder()
      digitThree.backgroundColor = UIColor.white
    } else {
      passCodeDic.removeValue(forKey: 4)
      digitThree.isEnabled = true
      digitThree.becomeFirstResponder()
      digitFour.backgroundColor = UIColor.white
    }
  }
}
