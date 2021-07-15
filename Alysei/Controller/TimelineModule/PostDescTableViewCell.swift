//
//  PostDescTableViewCell.swift
//  Alysei
//
//  Created by SHALINI YADAV on 4/26/21.
//

import UIKit
import SocketIO

struct PostLikeUnlikeRequestModel: Codable, SocketData {
    let postOwnerID: Int
    let userID: Int
    let postID: Int
    let likeStatus: Int

    private enum CodingKeys: String, CodingKey {
        case postOwnerID = "post_owner_id"
        case userID = "user_id"
        case postID = "post_id"
        case likeStatus = "like_status"
    }
}

    let manager = SocketManager(socketURL: URL(string: "https://alyseisocket.ibyteworkshop.com")!, config: [.log(true), .compress])

class PostDescTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userNickName: UILabel!
    @IBOutlet weak var lblPostDesc: UILabel!
    @IBOutlet weak var lblPostLikeCount: UILabel!
    @IBOutlet weak var lblPostCommentCount: UILabel!
    @IBOutlet weak var imageHeightCVConstant: NSLayoutConstraint!
    @IBOutlet weak var imagePostCollectionView: UICollectionView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var viewLike: UIView!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var commentImage: UIImageView!
    @IBOutlet weak var lblPostTime: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!

    var data: NewFeedSearchDataModel?
    var likeCallback:((Int) -> Void)? = nil
    var commentCallback:((PostCommentsUserData) -> Void)? = nil
    var islike: Int?
    var index: Int?
    var imageArray = [String]()
//    let manager = SocketManager(socketURL: URL(string: "https://alyseisocket.ibyteworkshop.com")!, config: [.log(true), .compress])
//    let socket = SocketManager(socketURL: URL(string: "https://alyseisocket.ibyteworkshop.com")!, config: [.log(true), .compress]).defaultSocket


    let socket = manager.defaultSocket

    override func awakeFromNib() {
        super.awakeFromNib()
        imagePostCollectionView.delegate = self
        imagePostCollectionView.dataSource = self
        imagePostCollectionView.isHidden = false
        userImage.layer.cornerRadius = userImage.frame.height / 2
        userImage.layer.masksToBounds = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(likeAction))
        self.viewLike.addGestureRecognizer(tap)


        let tap2 = UITapGestureRecognizer(target: self, action: #selector(likeAction))
        tap2.numberOfTapsRequired = 2


        self.imagePostCollectionView.addGestureRecognizer(tap2)


        let showCommentsGesture = UITapGestureRecognizer(target: self, action: #selector(self.showCommentsScreen))
        showCommentsGesture.numberOfTapsRequired = 1
        self.commentImage.addGestureRecognizer(showCommentsGesture)

        
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configCell(_ data: NewFeedSearchDataModel, _ index: Int){

        let selfID = Int(kSharedUserDefaults.loggedInUserModal.userId ?? "-1") ?? 0

        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")

            print(data)
            print(ack)

            print("socket is connected")

            let userIDSD = ["user_id": selfID].socketRepresentation()

            self.socket.emit("init", userIDSD) {
                print("init done")
            }

            self.socket.on("connected") { connectedData, connectedAck in
                print(connectedData)
            }

        }

        socket.on(clientEvent: .error) { data, ack in
            print(data)
        }

        socket.connect()


        self.data = data
        self.index = index
        userName.text = data.subjectId?.companyName?.capitalized
        userNickName.text = data.subjectId?.name?.capitalized
        lblPostDesc.text = data.body
        lblPostLikeCount.text = "\(data.likeCount ?? 0)"
        lblPostCommentCount.text = "\(data.commentCount ?? 0)"
        lblPostTime.text = data.posted_at
        //islike = data.likeFlag
        if data.attachmentCount == 0 {
            imageHeightCVConstant.constant = 0
//            imagePostCollectionView.alpha = 0.0
        }else{
            imageHeightCVConstant.constant = 220
//            imagePostCollectionView.alpha = 1.0
        }
        self.userImage.layer.borderWidth = 0.5
        self.userImage.layer.borderColor = UIColor.lightGray.cgColor
        print("ImageUrl--------------------------------\(String.getString(data.subjectId?.avatarId?.attachmentUrl) )")
        if String.getString(data.subjectId?.avatarId?.attachmentUrl) == ""{
            self.userImage.image = UIImage(named: "profile_icon")
        }else{
        self.userImage.setImage(withString: kImageBaseUrl + String.getString(data.subjectId?.avatarId?.attachmentUrl))
        }
        likeImage.image = data.likeFlag == 0 ? UIImage(named: "like_icon") : UIImage(named: "liked_icon")

        self.imagePostCollectionView.isPagingEnabled = true

        self.imagePostCollectionView.showsHorizontalScrollIndicator = false

        self.imageArray.removeAll()
        for i in  0..<(data.attachmentCount ?? 0) {
            self.imageArray.append(data.attachments?[i].attachmentLink?.attachmentUrl ?? "")
        }


        if imageArray.count <= 0 {
            self.pageControl.alpha = 0
        } else {
            self.pageControl.alpha = 1
            self.pageControl.numberOfPages = imageArray.count
        }

        self.imagePostCollectionView.reloadData()
    }

    @objc func likeAction(_ tap: UITapGestureRecognizer){
        if self.data?.likeFlag == 0 {
            islike = 1
        }else{
            islike = 0
        }

//        if (islike ?? 0) == 0 {
//            callLikeUnlikeApi(self.islike, self.data?.activityActionId, self.index)
//            return
//        }

        let selfID = Int(kSharedUserDefaults.loggedInUserModal.userId ?? "-1") ?? 0
        let params = ["post_owner_id": self.data?.subjectId?.userId ?? -1,
                      "user_id": selfID,
                      "post_id": self.data?.postID ?? -1,
                      "like_status": islike ?? 1]

        let sd = params.socketRepresentation()

        socket.emit("doLike", with: [sd]) {
            print("doLike - inside ")
        }

        socket.on("showLike") { showLikeData, showLikeAck in
            print("inside show like - start")
            print(showLikeData)
            print("inside show like - end")

//            socket.disconnect()

            if let data = showLikeData[0] as? [String: Any] {

                if let postID = data["post_id"] as? Int {
                    if postID != (self.data?.postID ?? -1) {
                        return
                    }
                }

                let totalLikes = data["total_likes"] as? Int
                self.data?.likeCount = totalLikes ?? 0

                let likeStatus = data["like_status"] as? Int
                self.data?.likeFlag = likeStatus ?? 0

                self.likeCallback?(self.index ?? 0)
            }


        }


        socket.on(clientEvent: .error) { data, ack in
            print(data)
        }

    }

    @objc func showCommentsScreen() {
        let model = PostCommentsUserData(userID: self.data?.subjectId?.userId ?? -1,
                                         postID: self.index ?? 0)
        self.commentCallback?(model)
    }


}
extension PostDescTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = imagePostCollectionView.dequeueReusableCell(withReuseIdentifier: "PostImageCollectionViewCell", for: indexPath) as? PostImageCollectionViewCell else{
            return UICollectionViewCell()
        }

        print("ImageArray---------------------------------\(self.imageArray)")
//        for i in 0..<imageArray.count {
//            cell.imagePost.setImage(withString: kImageBaseUrl + String.getString(imageArray[i]))
//            cell.imagePost.backgroundColor = .yellow
//        }

        cell.imagePost.setImage(withString: kImageBaseUrl + String.getString(imageArray[indexPath.row]))
        cell.imagePost.contentMode = .scaleAspectFill
        //cell.imagePost.setImage(withString: kImageBaseUrl + String.getString(data?.attachments?.attachmentLink?.attachmentUrl))
        return cell
    }

//    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        self.pageControl.currentPage = indexPath.row
//    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //return CGSize(width: self.imagePostCollectionView.frame.width - 20, height: 220)
        return CGSize(width: (self.imagePostCollectionView.frame.width), height: 220);
    }
//
//     func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        imagePostCollectionView?.collectionViewLayout.invalidateLayout();
//   }
}

extension PostDescTableViewCell {
    
    func callLikeUnlikeApi(_ isLike: Int?, _ postId: Int? ,_ indexPath: Int?){
        let selfID = Int(kSharedUserDefaults.loggedInUserModal.userId ?? "-1") ?? 0

        let params: [String:Any] = [
            "post_id": postId ?? 0,
            "like_or_unlike": isLike ?? 0,
            "user_id": selfID

        ]
        TANetworkManager.sharedInstance.requestApi(withServiceName: APIUrl.kLikeApi, requestMethod: .POST, requestParameters: params, withProgressHUD: true) { (dictResponse, error, errorType, statusCode) in
            self.data?.likeFlag = isLike
            if isLike == 0{
            self.data?.likeCount = ((self.data?.likeCount ?? 1) - 1)
            }else{
                self.data?.likeCount = ((self.data?.likeCount ?? 1) + 1)
            }
             self.likeCallback?(indexPath ?? 0)
            
        }
    }
}

class PostImageCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate{
    @IBOutlet weak var imagePost: UIImageView!

    var originalFrame = CGRect()

    var overlay: UIView = {
        let view = UIView(frame: UIScreen.main.bounds);

        view.alpha = 0
        view.backgroundColor = .black

        return view
    }()

    var isZooming = false
    var originalImageCenter:CGPoint?

    var fullScreenImage: UIImageView!



    override func awakeFromNib() {
        super.awakeFromNib()

        self.originalImageCenter = imagePost.center
        self.originalFrame = imagePost.frame

        self.imagePost.isUserInteractionEnabled = true

        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.pinch(sender:)))
//        pinch.minimumNumberOfTouches = 2
//        pinch.maximumNumberOfTouches = 2
        self.imagePost.addGestureRecognizer(pinch)

        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.pan(sender:)))
        pan.minimumNumberOfTouches = 2
        pan.maximumNumberOfTouches = 2
        pan.delegate = self
        self.imagePost.addGestureRecognizer(pan)
    }

    @objc func pinch(sender:UIPinchGestureRecognizer) {
        var touchBaseView = sender.view
        if let tab = UIApplication.shared.windows.first?.rootViewController as? UITabBarController {
            if let navCon = tab.viewControllers?.first as? UINavigationController {
                if let viewCon = navCon.viewControllers.first as? HomeViewC {
                    touchBaseView = viewCon.view
                }
            }
        }
//        let touch1 = sender.location(ofTouch: 0, in: touchBaseView)

        let touch1 = sender.location(ofTouch: 0, in: touchBaseView)
        var midPointX = touch1.x
        var midPointY = touch1.y
        if sender.numberOfTouches > 1 {
            let touch2 = sender.location(ofTouch: 1, in: touchBaseView)
            midPointX = (touch1.x + touch2.x)/2
            midPointY = (touch1.y + touch2.y)/2
        }

        let touchedPoint = CGPoint(x: midPointX, y: midPointY)
//        let touch2 = sender.location(ofTouch: 1, in: sender.view)

        if sender.state == .began {
            self.imagePost.frame = UIScreen.main.bounds
            let currentScale = self.imagePost.frame.size.width / self.imagePost.bounds.size.width
            let newScale = currentScale*sender.scale
            if newScale > 1 {
                self.isZooming = true
            }
            self.showAlertOnTab(1.0, frame: self.imagePost.frame, center: touchedPoint)

        } else if sender.state == .changed {
            guard let view = sender.view else {return}
            let pinchCenter = CGPoint(x: sender.location(in: view).x - view.bounds.midX,
                                      y: sender.location(in: view).y - view.bounds.midY)
            let transform = view.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
                .scaledBy(x: sender.scale, y: sender.scale)
                .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
            let currentScale = self.imagePost.frame.size.width / self.imagePost.bounds.size.width
            var newScale = currentScale*sender.scale
            if newScale < 1 {
                newScale = 1
                let transform = CGAffineTransform(scaleX: newScale, y: newScale)
                self.imagePost.transform = transform
                sender.scale = 1
            }else {
                view.transform = transform
                sender.scale = 1
            }
            self.showAlertOnTab(1.0, frame: self.imagePost.frame, center: touchedPoint)
        } else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
            self.showAlertOnTab(0.0, frame: self.imagePost.frame, center: CGPoint())
            guard let center = self.originalImageCenter else {return}

            self.imagePost.frame = self.bounds
            UIView.animate(withDuration: 0.3, animations: {
                self.imagePost.transform = CGAffineTransform.identity
                self.imagePost.center = center
                sender.scale = 1
            }, completion: { _ in
                self.isZooming = false
            })
        }
    }

    @objc func pan(sender: UIPanGestureRecognizer) {
        if self.isZooming && sender.state == .began {
            self.originalImageCenter = sender.view?.center
        } else if self.isZooming && sender.state == .changed {
            let translation = sender.translation(in: self)
            if let view = sender.view {
                view.center = CGPoint(x:view.center.x + translation.x,
                                      y:view.center.y + translation.y)
            }
            sender.setTranslation(CGPoint.zero, in: self.imagePost.superview)
        }
    }

    func  showAlertOnTab(_ alpha: CGFloat, frame: CGRect, center: CGPoint) {
        if let tab = UIApplication.shared.windows.first?.rootViewController as? UITabBarController {
            if let navCon = tab.viewControllers?.first as? UINavigationController {
                if let viewCon = navCon.viewControllers.first as? HomeViewC {
                    viewCon.fullScreenImageView.frame = frame
                    viewCon.fullScreenImageView.center = center
                    viewCon.fullScreenImageView.alpha = alpha
                    viewCon.fullScreenImageView.contentMode = .scaleAspectFill
                    viewCon.fullScreenImageView.image = self.imagePost.image
                    print(viewCon.description)
                }
            }
        }
    }
}


