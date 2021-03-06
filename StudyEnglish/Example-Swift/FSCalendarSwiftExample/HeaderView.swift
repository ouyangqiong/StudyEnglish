//
//  HeaderView.swift
//  Instagram
//
//  Created by 朱恩庆 on 2017/5/11.
//  Copyright © 2017年 刘铭. All rights reserved.
//

import UIKit

class HeaderView: UICollectionReusableView {
    
    @IBOutlet weak var avaImg: UIImageView!       // 用户头像
    @IBOutlet weak var fullnameLbl: UILabel!      // 用户名称
    @IBOutlet weak var webTxt: UITextView!        // 个人主页地址
    @IBOutlet weak var bioLbl: UILabel!           // 个人简介
    
    @IBOutlet weak var posts: UILabel!            // 帖子数
    @IBOutlet weak var followers: UILabel!        // 关注者数
    @IBOutlet weak var followings: UILabel!       // 关注数
    
    @IBOutlet weak var postTitle: UILabel!        // 帖子的Label
    @IBOutlet weak var followersTitle: UILabel!   // 关注者的Label
    @IBOutlet weak var followingsTitle: UILabel!  // 关注的Label
    
    @IBOutlet weak var button: UIButton!          // 编辑个人主页按钮
    
        
}
