import UIKit

protocol GetStartedDelegate {
  func tapGetStarted(_ btn: UIButton,cell: TutorialCollectionCell) -> Void
}

class TutorialCollectionCell: UICollectionViewCell {
    
  //MARK: - IBOutlet -
  
  @IBOutlet weak var lblWelcome: UILabel!
  @IBOutlet weak var lblDescription: UILabel!
  @IBOutlet weak var imgViewTutorial: UIImageView!
  @IBOutlet weak var pageControl: UIPageControl!
  @IBOutlet weak var btnGetStarted: UIButton!
  @IBOutlet weak var btnSkip: UIButton!
  
  //MARK: - Properties -
  
  var delegate: GetStartedDelegate?
  
  override func layoutIfNeeded() {
    
    super.layoutIfNeeded()
    self.btnGetStarted.makeCornerRadius(radius: 5.0)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.layoutIfNeeded()
  }
  
  //MARK: - IBAction -
  
  @IBAction func tapGetStarted(_ sender: UIButton) {
    self.delegate?.tapGetStarted(self.btnGetStarted, cell: self)
  }
  
  @IBAction func tapSkip(_ sender: UIButton) {
    
    self.delegate?.tapGetStarted(self.btnSkip, cell: self)
  }
  
  //MARK: - Public Methods -
  
  public func configure(_ indexPath: IndexPath){
    
    switch indexPath.item {
    case 0:
      self.btnSkip.isHidden = false
      self.btnGetStarted.setTitle(AppConstants.GetStarted, for: .normal)
    default:
      if indexPath.item == StaticArrayData.kTutorialDict.count - 1{
        self.btnGetStarted.setTitle(AppConstants.Finish, for: .normal)
        self.btnSkip.isHidden = true
      }
      else{
        self.btnSkip.isHidden = false
        self.btnGetStarted.setTitle(AppConstants.Next, for: .normal)
      }
    }
    
    imgViewTutorial.image = UIImage.init(named: StaticArrayData.kTutorialDict[indexPath.item].image)
    lblWelcome.text = StaticArrayData.kTutorialDict[indexPath.item].title
    lblDescription.text = StaticArrayData.kTutorialDict[indexPath.item].description
    pageControl.currentPage = indexPath.item
  }
  
}

