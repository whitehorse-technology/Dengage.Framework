
import Foundation
protocol InAppMessagesViewControllerDelegate:AnyObject{
    func didTapView(messageId:String)
    func didTapNotification(messageId:String)
}

final class InAppMessagesViewController: UIViewController{
    
    lazy var popUpView = InAppPopUpView()
    private var bottomConstraint: NSLayoutConstraint?
    private var centerConstraint: NSLayoutConstraint?
    private var topConstraint: NSLayoutConstraint?
    
    let inAppMessage: InAppMessage
    weak var delegate: InAppMessagesViewControllerDelegate?
    init(with message: InAppMessage) {
        inAppMessage = message
        super.init(nibName: nil, bundle: nil)
        arrangeViews()
        popUpView.populateUI(with: message)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapView(sender:)))
        self.view.addGestureRecognizer(tapGesture)
        let popUpTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapNotification(sender:)))
        self.popUpView.addGestureRecognizer(popUpTapGesture)
        self.popUpView.alpha = 0.0
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            self.popUpView.alpha = 1.0
        })
    }
    
    @objc func didTapView(sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseOut, animations: {
            self.popUpView.alpha = 0.0
            
        },completion: { (finished: Bool) in
            self.delegate?.didTapView(messageId: self.inAppMessage.id)
        })
    }
    
    @objc func didTapNotification(sender: UITapGestureRecognizer) {
        self.delegate?.didTapNotification(messageId: self.inAppMessage.id)
        guard let urlString = self.inAppMessage.data.content.targetUrl, let url = URL(string: urlString) else {return}
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func arrangeViews(){
        view.addSubview(popUpView)
        popUpView.translatesAutoresizingMaskIntoConstraints = false
        popUpView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        popUpView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        bottomConstraint = popUpView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60)
        centerConstraint = popUpView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
        topConstraint = popUpView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60)
        popUpView.dropShadow()
        switch inAppMessage.data.content.props.position{
        case .top:
            topConstraint?.isActive = true
        case .middle:
            centerConstraint?.isActive = true
        case .bottom:
            bottomConstraint?.isActive = true
        }
    }
}
