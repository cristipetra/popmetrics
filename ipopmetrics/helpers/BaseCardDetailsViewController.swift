
import UIKit

class BaseCardDetailsViewController: BaseViewController {
    
    var hubCard: HubCard!
    var hubController: HubControllerProtocol!
    
    internal var isBottomVisible = false
    
    @IBOutlet weak var actionsView: UIView!
    
    var openedFrom: String = "home"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationWithBackButton()
        
        self.view.addSwipeGestureRecognizer {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
    }
    
    public func configure(card: HubCard) {
        self.hubCard = card
    }
    
    private func setupNavigationWithBackButton() {
        
        let leftSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        leftSpace.width = 5
        
        let leftButtonItem = UIBarButtonItem.init(image: UIImage(named: "calendarIconLeftArrow"), style: .plain, target: self, action: #selector(handlerClickBack))
        leftButtonItem.tintColor = PopmetricsColor.darkGrey
        
        self.navigationItem.leftBarButtonItems = [leftSpace, leftButtonItem]
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black

    }
    
    @objc func handlerClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func didPressShare(_ sender: AnyObject) {
        print("Pressed Share")
        
        let textToShare = "Check out this Popmetrics Analysis... "+Config.sharedInstance.environment.baseURL+"/card/"+hubCard.cardId!
        let activityVC = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
    
}
