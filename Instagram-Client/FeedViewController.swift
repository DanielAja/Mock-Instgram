//
//  FeedViewController.swift
//  Instagram-Client
//
//  Created by Daniel Ajagbusi on 11/15/19.
//  Copyright © 2019 Daniel Ajagbusi. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage
import Alamofire
import MessageInputBar

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    let commentBar = MessageInputBar()
    var posts = [PFObject]()
    var showCommentBar = false
    var currentPost: PFObject!
    
    override var inputAccessoryView: UIView? {
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return showCommentBar
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let post = posts[section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        return comments.count+2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
            let user = post["User"] as! PFUser
            cell.usernameLable.text = user.username
            
            cell.captionLable.text = (post["caption"] as! String)
            
            let imageFile = post["image"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            
            cell.photoView.af_setImage(withURL: url)
            
            return cell
        } else if indexPath.row <= comments.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            let comment = comments[indexPath.row - 1]
            cell.commentLable.text = (comment["text"] as! String)
            let user = comment["author"] as! PFUser
            cell.usernameLable.text = (user.username!)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell")!
            return cell
        }
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        commentBar.inputTextView.placeholder = "Add A comment"
        commentBar.sendButton.title = "Post"
        commentBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        DataRequest.addAcceptableImageContentTypes(["application/octet-stream"])
        
        tableView.keyboardDismissMode = .interactive
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)),name: UIResponder.keyboardWillHideNotification, object:nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let query = PFQuery(className: "posts")
        query.includeKeys(["User", "comments", "comments.author"])
        query.limit = 20
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
            }
        }
        
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String){
        let comment = PFObject(className: "comments")
        comment["text"] = text
        comment["post"] = currentPost
        comment["author"] = PFUser.current()!

        currentPost.add(comment, forKey: "comments")
        currentPost.saveInBackground { (success, eror) in
            if success {
                print("Comment Saved")
            } else {
                print("Failed to save comment")
            }
        }
        tableView.reloadData()
        commentBar.inputTextView.text = nil
        showCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
    }
    
    @objc func keyboardWillBeHidden(note: Notification){
        commentBar.inputTextView.text = nil
        showCommentBar = false
        becomeFirstResponder()
        
    }
    
    
    @IBAction func onLogout(_ sender: Any) {
        
        
        PFUser.logOut()
        let main = UIStoryboard(name: "Main", bundle: nil)
        let LoginViewCon = main.instantiateViewController(withIdentifier: "LoginViewCon")
        
        let delegate = self.view.window?.windowScene?.delegate as! SceneDelegate
        delegate.window?.rootViewController = LoginViewCon
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        if (indexPath.row == comments.count+1) {
            showCommentBar = true
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
            currentPost = post
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
