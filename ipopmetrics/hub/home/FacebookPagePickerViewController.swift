import UIKit
import Foundation

final class FacebookPageTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    static let identifier = String(describing: FacebookPageTableViewCell.self)
    
    var facebookPage: FacebookAccount?
    
    // MARK: Initialize
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = nil
        contentView.backgroundColor = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        update()
        
        let imgHeight = CGFloat(25)
        imageView?.frame.size = CGSize(width: imgHeight, height: imgHeight)
        imageView?.layer.cornerRadius = imgHeight/2

        imageView?.roundedCorners = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        accessoryType = selected ? .checkmark : .none
    }
    
    func configure(with facebookPage: FacebookAccount) {
        self.facebookPage = facebookPage
        DispatchQueue.main.async {
            self.update()
        }
    }
    
    func update() {
        guard let facebookPage = facebookPage else { return }
        
        if let picture = facebookPage.picture {
            imageView?.af_setImage(withURL: URL(string: picture)!, placeholderImage: nil)
        }
        textLabel?.text = facebookPage.name
        detailTextLabel?.text = facebookPage.username
        
    }
}

final class FacebookPagePickerViewController: UIViewController {
    
    // MARK: UI Metrics
    
    struct UI {
        static let rowHeight: CGFloat = 64
        static let separatorColor: UIColor = UIColor.lightGray.withAlphaComponent(0.4)
    }
    
    // MARK: Properties
    
    public typealias Selection = (FacebookAccount?) -> ()
    fileprivate var selection: Selection?
    fileprivate var facebookPages = [FacebookAccount]()
    fileprivate var selectedFacebookPage: FacebookAccount?
    
    fileprivate lazy var tableView: UITableView = { [unowned self] in
        $0.dataSource = self
        $0.delegate = self
        $0.allowsMultipleSelection = false
        $0.rowHeight = UI.rowHeight
        $0.separatorColor = UI.separatorColor
        $0.bounces = true
        $0.backgroundColor = UIColor.white
        $0.tableFooterView = UIView()
        $0.sectionIndexBackgroundColor = .clear
        $0.sectionIndexTrackingBackgroundColor = .clear
        $0.register(FacebookPageTableViewCell.self,
                    forCellReuseIdentifier: FacebookPageTableViewCell.identifier)
        return $0
        }(UITableView(frame: .zero, style: .plain))
    
    // MARK: Initialize
    
    required init(facebookPages: [FacebookAccount], selection: Selection?) {
        self.selection = selection
        self.facebookPages = facebookPages
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            preferredContentSize.width = UIScreen.main.bounds.width / 2
        }
        
        extendedLayoutIncludesOpaqueBars = true
        edgesForExtendedLayout = .bottom
        definesPresentationContext = true
        
        setupNavigationWithBackButton()
        updateFacebookPages()
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        preferredContentSize.height = tableView.contentSize.height
    }
    
    func updateFacebookPages() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    func facebookPage(at indexPath: IndexPath) -> FacebookAccount? {
        return facebookPages[indexPath.row]
    }
    
}

// MARK: - TableViewDelegate
extension FacebookPagePickerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let facebookPage = facebookPage(at: indexPath) else { return }
        selectedFacebookPage = facebookPage
        selection?(selectedFacebookPage)
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - TableViewDataSource
extension FacebookPagePickerViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return facebookPages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FacebookPageTableViewCell.identifier) as! FacebookPageTableViewCell
        
        guard let facebookPage = facebookPage(at: indexPath) else { return UITableViewCell() }
        
        if let selectedFacebookPage = selectedFacebookPage, selectedFacebookPage.id == facebookPage.id {
            cell.setSelected(true, animated: true)
        }
        
        cell.configure(with: facebookPage)
        return cell
    }
}

