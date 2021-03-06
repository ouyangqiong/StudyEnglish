//
//  SignUpVC.swift
//  Instagram
//
//  Created by 刘铭 on 16/6/23.
//  Copyright © 2016年 刘铭. All rights reserved.
//

import UIKit
import AVOSCloud

class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  @IBOutlet weak var avaImg: UIImageView!
  
  @IBOutlet weak var usernameTxt: UITextField!
  @IBOutlet weak var passwordTxt: UITextField!
  @IBOutlet weak var repeatPasswordTxt: UITextField!
  @IBOutlet weak var emailTxt: UITextField!
  
  @IBOutlet weak var phoneTxt: UITextField!
    

  @IBOutlet weak var parentPhoneTxt: UITextField!
    
    
  @IBOutlet weak var fullnameTxt: UITextField!
//  @IBOutlet weak var bioTxt: UITextField!
    
    @IBOutlet weak var verifyCode: UITextField!
    

  @IBOutlet weak var scrollView: UIScrollView!
  
  @IBOutlet weak var signUpBtn: UIButton!
  @IBOutlet weak var cancelBtn: UIButton!
  
    @IBOutlet weak var getVerfiyCode: UIButton!
  
  // 根据需要，设置滚动视图的高度
  var scrollViewHeight: CGFloat = 0
  
  // 获取虚拟键盘的大小
  var keyboard: CGRect = CGRect()
		
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 滚动视图的frame size
    scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
    scrollView.contentSize.height = self.view.frame.height
    scrollViewHeight = self.view.frame.height
    
    // 检测键盘出现或消失的状态
    NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: Notification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
    
    let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardTap))
    hideTap.numberOfTapsRequired = 1
    self.view.isUserInteractionEnabled = true
    self.view.addGestureRecognizer(hideTap)
    
    // 改变avaImg的外观为圆形
    avaImg.layer.cornerRadius = avaImg.frame.width / 2
    avaImg.clipsToBounds = true
    
    let imgTap = UITapGestureRecognizer(target: self, action: #selector(loadImg))
    imgTap.numberOfTapsRequired = 1
    avaImg.isUserInteractionEnabled = true
    avaImg.addGestureRecognizer(imgTap)
    
    // UI元素布局
    
    avaImg.frame = CGRect(x: self.view.frame.width / 2 - 40, y: 20, width: 80, height: 80)
    
    let viewWidth = self.view.frame.width
    let rightGap = CGFloat(40);
    let eidtWidth = self.view.frame.width - rightGap*2;
    let eidtHigh=CGFloat(20);
    
    let topGap=CGFloat(30);
    
    usernameTxt.frame = CGRect(x: rightGap,
                               y: avaImg.frame.origin.y + 90,
                               width: eidtWidth,
                               height: eidtHigh)
    
    passwordTxt.frame = CGRect(x: rightGap,
                               y: usernameTxt.frame.origin.y + topGap,
                               width: eidtWidth/2 - CGFloat(10),
                               height: eidtHigh)
    
    repeatPasswordTxt.frame = CGRect(x: rightGap + eidtWidth/2 + CGFloat(10),
                                     y: usernameTxt.frame.origin.y + topGap,
                                     width: eidtWidth/2 - CGFloat(10),
                                     height: CGFloat(eidtHigh))
    
    emailTxt.frame = CGRect(x: rightGap,
                            y: repeatPasswordTxt.frame.origin.y + topGap,
                            width: eidtWidth,
                            height: eidtHigh)
    
    phoneTxt.frame = CGRect(x: rightGap,
                            y: emailTxt.frame.origin.y + topGap,
                            width: eidtWidth/2 - CGFloat(10),
                            height: eidtHigh)
    parentPhoneTxt.frame = CGRect(x: rightGap + eidtWidth/2 + CGFloat(10),
                                  y: emailTxt.frame.origin.y + topGap,
                                  width: eidtWidth/2 - CGFloat(10),
                                  height: eidtHigh)
    
    
    verifyCode.frame = CGRect(x: rightGap,
                            y: phoneTxt.frame.origin.y + topGap,
                            width: eidtWidth/2 - CGFloat(10),
                            height: eidtHigh)
    getVerfiyCode.frame = CGRect(x: rightGap + eidtWidth/2 + CGFloat(10),
                                  y: phoneTxt.frame.origin.y + topGap,
                                  width: eidtWidth/2 - CGFloat(10),
                                  height: eidtHigh)
    
    fullnameTxt.frame = CGRect(x: rightGap,
                               y: verifyCode.frame.origin.y + topGap,
                               width: eidtWidth,
                               height: eidtHigh)
    


    signUpBtn.frame = CGRect(x: rightGap,
                             y: fullnameTxt.frame.origin.y + 50,
                             width: viewWidth / 4,
                             height: 30)
    cancelBtn.frame = CGRect(x: rightGap + eidtWidth - viewWidth / 4,
                             y: signUpBtn.frame.origin.y,
                             width: viewWidth / 4,
                             height: 30)
    
//       cancelBtn.frame = CGRect(x: viewWidth - viewWidth / 4 - 20, y: signUpBtn.frame.origin.y, width: viewWidth / 4, height: 30)
    
    //设置背景图
    let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
    
    bg.image = UIImage(named: "deep.png")
//    bg.image = UIImage(named: "bg.jpg")
    bg.layer.zPosition = -1
    self.view.addSubview(bg)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // 调出照片获取器选择照片
  func loadImg(recognizer: UITapGestureRecognizer) {
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.sourceType = .photoLibrary
    picker.allowsEditing = true
    present(picker, animated: true, completion: nil)
  }
  
  // 关联选择好的照片图像到image view
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    avaImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
    self.dismiss(animated: true, completion: nil)
  }
  
  // 用户取消获取器操作时调用的方法
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    self.dismiss(animated: true, completion: nil)
  }
  
  // 隐藏视图中的虚拟键盘
  func hideKeyboardTap(recognizer: UITapGestureRecognizer) {
    self.view.endEditing(true)
  }
  
  func showKeyboard(notification: Notification) {
    
    // 定义keyboard大小
    let rect = ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey]!)!) as! NSValue
    keyboard = rect.cgRectValue
    
    // 当虚拟键盘出现以后，将滚动视图的实际高度缩小为屏幕高度减去键盘的高度。
    UIView.animate(withDuration: 0.4) {
      self.scrollView.frame.size.height = self.scrollViewHeight - self.keyboard.size.height
    }
  }

  func hideKeyboard(notification: Notification) {
    // 当虚拟键盘消失后，将滚动视图的实际高度改变为屏幕的高度值。
    UIView.animate(withDuration: 0.4) {
      self.scrollView.frame.size.height = self.view.frame.height
    }
  }
    
    func notify(title:String, meesage:String){
        
        let alert = UIAlertController(title: title, message: meesage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
  
    // 获取验证码按钮被点击
    @IBAction func getVerfiyCodeBtn_clicl(_ sender: AnyObject) {
        print(phoneTxt.text)
        
        AVOSCloud.requestSmsCode(withPhoneNumber: phoneTxt.text!, callback: {(succeeded: Bool, error: Error?) in
            if succeeded {
                self.notify(title: "请注意",meesage: "验证码已发送，请输入验证码")
            }
            else{
                
                self.notify(title: "验证码发送失败",meesage: (error?.localizedDescription)!)
                
            }
//            if self.filterError(error) {
//                self.alertViewHelper.showInputView("验证码已发送，请输入验证码", block: { (smsCode) -> Void in
//                    AVUser.signUpOrLoginWithMobilePhoneNumberInBackground(phoneNumber, smsCode: smsCode, block: {(user: AVUser?, error: NSError?) in
//                        if self.filterError(error) {
//                            self.log("注册或登录成功 phone:\(phoneNumber)\nuser:\(user)")
//                        }
//                    })
//                })
//            }
        })
        
//        AVUser.requestLoginSmsCode(phoneTxt.text, with: {(succeeded: Bool, error: Error?) in
//            if succeeded {
//                self.notify(title: "请注意",meesage: "验证码已发送，请输入验证码")
//                }
//            else{
//                
//                self.notify(title: "验证码发送失败",meesage: (error?.localizedDescription)!)
//
//            }
//            
//        })
        
    }
    
    
  // 注册按钮被点击
  @IBAction func signUpBtn_click(_ sender: AnyObject) {
    print("注册按钮被按下！")
    
    // 隐藏keyboard
    self.view.endEditing(true)
    
    if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty || repeatPasswordTxt.text!.isEmpty || emailTxt.text!.isEmpty || fullnameTxt.text!.isEmpty   {
      let alert = UIAlertController(title: "请注意", message: "请填写好所有的字段", preferredStyle: .alert)
      let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
      alert.addAction(ok)
      self.present(alert, animated: true, completion: nil)
      
      return
    }
    
    // 如果两次输入的密码不同
    if passwordTxt.text != repeatPasswordTxt.text {
      let alert = UIAlertController(title: "请注意", message: "两次输入的密码不一致", preferredStyle: .alert)
      let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
      alert.addAction(ok)
      self.present(alert, animated: true, completion: nil)
      
      return
    }
    
    let user = AVUser()
    user.username = usernameTxt.text?.lowercased()
    user.email = emailTxt.text?.lowercased()
    user.password = passwordTxt.text
    user["fullname"] = fullnameTxt.text?.lowercased()
//    user["bio"] = bioTxt.text
//    user["web"] = webTxt.text?.lowercased()
    user["gender"] = ""
    
    // 转换头像数据并发送到服务器
    let avaData = UIImageJPEGRepresentation(avaImg.image!, 0.5)
    let avaFile = AVFile(name: "ava.jpg", data: avaData!)
    user["ava"] = avaFile
    
    
//    let user = AVUser()
//    user.username = self.randomString(6)
//    user.password = self.testPassword
    user.mobilePhoneNumber = phoneTxt.text;
    // 保存信息到服务器
//    user.signUpInBackground({(succeeded: Bool, error: Error?) in
//        if succeeded {
//        self.alertViewHelper.showInputView("验证短信已发送，请输入验证码", block: { (smsCode) -> Void in
//                AVUser.verifyMobilePhone(smsCode, withBlock: {(succeeded: Bool, error: NSError?) in
//                    if self.filterError(error) {
//                        self.log("成功注册  手机号 \(phoneNumber) 密码 \(self.testPassword)")
//                    }
//                })
//            })
//        }
//    })
    
    // 保存信息到服务器
    user.signUpInBackground { (success:Bool, error:Error?) in
      if success {
        print("用户注册成功！")
        
        // 记住登陆的用户
        UserDefaults.standard.set(user.username, forKey: "username")
        UserDefaults.standard.synchronize()
        
        // 从AppDelegate类中调用login方法
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.login()
        
      }else {
        print(error?.localizedDescription)
        
        let alert2 = UIAlertController(title: "请注意", message: error?.localizedDescription, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert2.addAction(ok)
        self.present(alert2, animated: true, completion: nil)
        
        return

      }
    }
  }
  
  // 取消按钮被点击
  @IBAction func cancelBtn_click(_ sender: AnyObject) {
    self.view.endEditing(true)
    self.dismiss(animated: true, completion: nil)
  }
  
  
}
