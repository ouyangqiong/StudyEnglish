//
//  Home2VC.swift
//  Instagram
//
//  Created by 朱恩庆 on 2017/5/13.
//  Copyright © 2017年 刘铭. All rights reserved.
//

import UIKit
import AVOSCloud

private let reuseIdentifier = "Cell"

class Home2VC: UICollectionViewController {

    // 刷新控件
    var refresher: UIRefreshControl!
    
    // 每页载入帖子（图片）的数量
    var page: Int = 10
    
    var uuidArray = [String]()
    var picArray = [AVFile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.alwaysBounceVertical = true
        self.collectionView?.bounces = true
        
        self.navigationItem.title = AVUser.current()?.username?.uppercased()
        
        // 设置refresher控件到集合视图之中
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        collectionView?.addSubview(refresher)
        
        loadPosts()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func refresh() {
        collectionView?.reloadData()
        
        // 停止刷新动画
        refresher.endRefreshing()
    }
    
    func loadPosts() {
        let query = AVQuery(className: "Posts")
        query.whereKey("username", equalTo: AVUser.current()?.username)
        query.limit = page
//        query.findObjectsInBackground({ (objects:[Any]?, error:Error?) in
//            // 查询成功
//            if error == nil {
//                // 清空两个数组
//                self.uuidArray.removeAll(keepingCapacity: false)
//                self.picArray.removeAll(keepingCapacity: false)
//                
//                for object in objects! {
//                    // 将查询到的数据添加到数组中
//                    self.uuidArray.append((object as AnyObject).value(forKey: "uuid") as! String)
//                    self.picArray.append((object as AnyObject).value(forKey: "pic") as! AVFile)
//                }
//                
//                self.collectionView?.reloadData()
//            }else {
//                print(error?.localizedDescription)
//            }
//        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = self.collectionView?.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header2", for: indexPath) as! HeaderView
        
        header.fullnameLbl.text = (AVUser.current()?.object(forKey: "fullname") as? String)?.uppercased()
        header.webTxt.text = AVUser.current()?.object(forKey: "web") as? String
        header.webTxt.sizeToFit()
        header.bioLbl.text = AVUser.current()?.object(forKey: "bio") as? String
        header.bioLbl.sizeToFit()
        
        let avaQuery = AVUser.current()?.object(forKey: "ava") as! AVFile
        
        avaQuery.getDataInBackground { (data:Data?, error:Error?) in
            if data == nil {
                print(error?.localizedDescription)
            }else {
                header.avaImg.image = UIImage(data: data!)
            }
        }
        
        let currentUser: AVUser = AVUser.current()!
        
        let followeesQuery = AVQuery(className: "_Followee")
        followeesQuery.whereKey("user", equalTo: currentUser)
        followeesQuery.countObjectsInBackground({ (count:Int, error:Error?) in
            if error == nil {
                header.followings.text = String(count)
            }
        })
        
        
        let followersQuery = AVQuery(className: "_Follower")
        followersQuery.whereKey("user", equalTo: currentUser)
        followersQuery.countObjectsInBackground({ (count:Int, error:Error?) in
            if error == nil {
                header.followers.text = String(count)
            }
        })
        
        
        let postsQuery = AVQuery(className: "Posts")
        postsQuery.whereKey("username", equalTo: currentUser.username)
        postsQuery.countObjectsInBackground({ (count:Int, error:Error?) in
            if error == nil {
                header.posts.text = String(count)
            }
        })
        
        
        //    currentUser.getFollowers { (followers:[AnyObject]?, error:NSError?) in
        //      if error != nil {
        //        print(error?.localizedDescription)
        //      }else {
        //        print("数量为：\(followers?.count)")
        //      }
        //    }
        //
        //    currentUser.getFollowees{ (followees:[AnyObject]?, error:NSError?) in
        //      if error != nil {
        //        print(error?.localizedDescription)
        //      }else {
        //        print("数量为：\(followees?.count)")
        //
        //        if let followees = followees {
        //          for followee in followees {
        //            print(followee.username)
        //          }
        //        }
        //
        //      }
        //    }
        
        // STEP 3. 实现单击手势
        
        // 点击帖子数
        let postsTap = UITapGestureRecognizer(target: self, action: #selector(postsTap(_:)))
        postsTap.numberOfTapsRequired = 1
        header.posts.isUserInteractionEnabled = true
        header.posts.addGestureRecognizer(postsTap)
        
        // 点击关注者数
        let followersTap = UITapGestureRecognizer(target: self, action: #selector(followersTap(_:)))
        followersTap.numberOfTapsRequired = 1
        header.followers.isUserInteractionEnabled = true
        header.followers.addGestureRecognizer(followersTap)
        
        // 点击关注数
        let followingsTap = UITapGestureRecognizer(target: self, action: #selector(followingsTap(_:)))
        followingsTap.numberOfTapsRequired = 1
        header.followings.isUserInteractionEnabled = true
        header.followings.addGestureRecognizer(followingsTap)
        
        return header
    }
    
    func postsTap(_ recognizer:UITapGestureRecognizer) {
        if !picArray.isEmpty {
            let index = IndexPath(item: 0, section: 0)
            self.collectionView?.scrollToItem(at: index, at: UICollectionViewScrollPosition.top, animated: true)
        }
    }
    
    func followersTap(_ recognizer:UITapGestureRecognizer) {
        
        // 从故事板载入FollowersVC的视图
        let followers = self.storyboard?.instantiateViewController(withIdentifier: "FollowersVC") as! FollowersVC
        
        followers.user = (AVUser.current()?.username)!
        followers.show = "关 注 者"
        
        self.navigationController?.pushViewController(followers, animated: true)
    }
    
    func followingsTap(_ recognizer:UITapGestureRecognizer) {
        
        // 从故事板载入FollowersVC的视图
        let followings = self.storyboard?.instantiateViewController(withIdentifier: "FollowersVC") as! FollowersVC
        
        followings.user = (AVUser.current()?.username)!
        followings.show = "关 注"
        
        self.navigationController?.pushViewController(followings, animated: true)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 从集合视图的可复用队列中获取单元格对象
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PictureCell
        
        // 从picArray数组中获取图片
        picArray[indexPath.row].getDataInBackground { (data:Data?, error:Error?) in
            if error == nil {
                cell.picImg.image = UIImage(data: data!)
            }else{
                print(error?.localizedDescription)
            }
        }
        
        return cell
    }
    
    

}
