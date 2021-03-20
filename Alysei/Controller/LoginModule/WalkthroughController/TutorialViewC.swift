
import UIKit

class TutorialViewC: AlysieBaseViewC{

  //MARK: - IBOutlet -
    
  @IBOutlet weak var collectionViewTutorial: UICollectionView!
    
  //MARK: - ViewLifeCycle Methods -

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  //MARK: - Private Methods -
  
  private func getTutorialCollectionCell(_ indexPath: IndexPath) -> UICollectionViewCell{
    
    let tutorialCollectionCell = collectionViewTutorial.dequeueReusableCell(withReuseIdentifier: TutorialCollectionCell.identifier(), for: indexPath) as! TutorialCollectionCell
    tutorialCollectionCell.configure(indexPath)
    tutorialCollectionCell.delegate = self
    return tutorialCollectionCell
  }
}
   
//MARK: - CollectionView Methods -

extension TutorialViewC: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return StaticArrayData.kTutorialDict.count
  }
    
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    return self.getTutorialCollectionCell(indexPath)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    return CGSize(width: kScreenWidth, height:kScreenHeight)
  }
}

extension TutorialViewC: GetStartedDelegate{
  
  
  func tapGetStarted(_ btn: UIButton, cell: TutorialCollectionCell) {
    
    if btn == cell.btnGetStarted{
      
      //let walkthroughArray = self.getWalkThroughViewModel.arrWalkThroughs.count
      let currentIndexPath = collectionViewTutorial.indexPath(for: cell)!
      if currentIndexPath.item < StaticArrayData.kTutorialDict.count - 1{
        
        let indexPath = IndexPath(item: currentIndexPath.item+1, section: 0)
        self.collectionViewTutorial.scrollToItem(at: indexPath, at: .right, animated: true)
        self.collectionViewTutorial.reloadItems(at: [indexPath])
      }
      else{
        _ = pushViewController(withName: LoginAccountViewC.id(), fromStoryboard: StoryBoardConstants.kLogin)
      }
    }
    else if btn == cell.btnSkip{
      _ = pushViewController(withName: LoginAccountViewC.id(), fromStoryboard: StoryBoardConstants.kLogin)
    }
  }

}
