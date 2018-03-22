import UIKit
import Foundation
import AlamofireImage

final class FacebookPageTableViewCell: UITableViewCell {

    static let identifier = String(describing: FacebookPageTableViewCell.self)

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(text: String, details: String, imageUrl: String?, placeholderImage: UIImage?) {
        if let picture = imageUrl {
            imageView?.af_setImage(
                withURL: URL(string: picture)!,
                placeholderImage: placeholderImage
            )
        }else{
            imageView?.image = placeholderImage
        }
        textLabel?.text = text
        detailTextLabel?.numberOfLines = 2
        detailTextLabel?.lineBreakMode = NSLineBreakMode.byCharWrapping
        detailTextLabel?.text = details

    }

    override func prepareForReuse() {
        super.prepareForReuse()

        imageView?.af_cancelImageRequest()
        imageView?.layer.removeAllAnimations()
        imageView?.image = nil
        textLabel?.text = nil
        detailTextLabel?.text = nil
    }
}

final class FacebookPagePickerViewController: UITableViewController {
    
    public typealias Selection = (FacebookAccount?) -> ()
    fileprivate var selection: Selection?
    fileprivate var facebookPages = [FacebookAccount]()
    fileprivate var selectedFacebookPage: FacebookAccount?
    
    
    required init(facebookPages: [FacebookAccount], selection: Selection?) {
        self.selection = selection
        self.facebookPages = facebookPages
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationWithBackButton()
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorColor = UIColor.lightGray.withAlphaComponent(0.4)
        self.tableView.register(FacebookPageTableViewCell.self, forCellReuseIdentifier: FacebookPageTableViewCell.identifier)
        self.tableView.allowsMultipleSelection = false
        self.tableView.reloadData()
    }
    
    private func setupNavigationWithBackButton() {
        let titleWindow = "Select Facebook Page"
        
        let leftSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        leftSpace.width = 5
        
        let titleButton = UIBarButtonItem(title: titleWindow, style: .plain, target: self, action: #selector(handlerClickBack))
        titleButton.tintColor = PopmetricsColor.darkGrey
        let titleFont = UIFont(name: FontBook.extraBold, size: 18)
        titleButton.setTitleTextAttributes([NSAttributedStringKey.font: titleFont], for: .normal)
        titleButton.setTitleTextAttributes([NSAttributedStringKey.font: titleFont], for: .selected)
        
        let leftButtonItem = UIBarButtonItem.init(image: UIImage(named: "calendarIconLeftArrow"), style: .plain, target: self, action: #selector(handlerClickBack))
        leftButtonItem.tintColor = PopmetricsColor.darkGrey
        
        self.navigationItem.leftBarButtonItems = [leftSpace, leftButtonItem, titleButton]
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
    }
    
    @objc
    func handlerClickBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func facebookPage(at indexPath: IndexPath) -> FacebookAccount? {
        return facebookPages[indexPath.row]
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let facebookPage = facebookPage(at: indexPath) else { return }
        selectedFacebookPage = facebookPage
        selection?(selectedFacebookPage)
        self.dismiss(animated: true, completion: nil)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return facebookPages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FacebookPageTableViewCell.identifier) as! FacebookPageTableViewCell
        
        guard let facebookPage = facebookPage(at: indexPath) else { return UITableViewCell() }
        
        if let selectedFacebookPage = selectedFacebookPage, selectedFacebookPage.id == facebookPage.id {
            cell.setSelected(true, animated: true)
        }
        
        cell.configure(text: facebookPage.name, details: facebookPage.link, imageUrl: facebookPage.picture  , placeholderImage: UIImage(named: "iconFacebookSocial"))
        return cell
    }
    
}

