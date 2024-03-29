import UIKit
import WebKit
final class InAppMessageHTMLView: UIView{
    
    private(set) lazy var webView: WKWebView = {
        let view = WKWebView()
        view.scrollView.isScrollEnabled = false
        view.scrollView.bounces = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    
    private var bottomConstraint: NSLayoutConstraint?
    private var centerConstraint: NSLayoutConstraint?
    private var topConstraint: NSLayoutConstraint?
    private var leftConstraint: NSLayoutConstraint?
    private var rightConstraint: NSLayoutConstraint?

    var height: NSLayoutConstraint?
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        addSubview(webView)
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        leftConstraint = webView
            .leadingAnchor
            .constraint(lessThanOrEqualTo: leadingAnchor,
                        constant: 0)
        
        rightConstraint = webView
            .trailingAnchor
            .constraint(greaterThanOrEqualTo: trailingAnchor,
                        constant: 0)
        
        height = webView
            .heightAnchor
            .constraint(equalToConstant: 0)
        
        height?.isActive = true
        
        bottomConstraint = webView
            .bottomAnchor
            .constraint(equalTo: bottomAnchor,
                        constant: 0)
        centerConstraint = webView
            .centerYAnchor
            .constraint(equalTo: centerYAnchor,
                        constant: 0)
        topConstraint = webView
            .topAnchor
            .constraint(equalTo: topAnchor,
                        constant: 0)
    }
    
    private func set(radius:Int?){
        webView.layer.cornerRadius = CGFloat(radius ?? 0)
    }
    
    private func set(maxWidth:CGFloat?){
        guard let width = maxWidth else {return}
        webView.widthAnchor.constraint(lessThanOrEqualToConstant: width).isActive = true
    }
    
    func setupConstaints(for params: ContentParams){
        set(maxWidth: params.maxWidth)
        set(radius: params.radius)
        topConstraint?.constant = getVerticalByPercentage(for: params.marginTop)
        bottomConstraint?.constant = -getVerticalByPercentage(for:params.marginBottom)
        leftConstraint?.constant = getHorizaltalByPercentage(for:params.marginLeft)
        rightConstraint?.constant = -getHorizaltalByPercentage(for:params.marginRight)
        leftConstraint?.isActive = true
        rightConstraint?.isActive = true
        switch params.position{
        case .top:
            topConstraint?.isActive = true
        case .middle:
            centerConstraint?.isActive = true
        case .bottom:
            bottomConstraint?.isActive = true
        case .full:
            topConstraint?.isActive = true
            bottomConstraint?.isActive = true
        }
    }
    
    func getVerticalByPercentage(for margin: CGFloat? = 1.0) -> CGFloat {
        return (UIScreen.main.bounds.height * (margin! / 100))
    }
    
    func getHorizaltalByPercentage(for margin: CGFloat? = 1.0) -> CGFloat {
        return (UIScreen.main.bounds.width * (margin! / 100))
    }
}
