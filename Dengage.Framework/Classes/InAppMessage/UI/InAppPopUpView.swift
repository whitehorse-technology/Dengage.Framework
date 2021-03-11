import UIKit

final class InAppPopUpView:UIView{
    
    let imageView:UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.widthAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var imageViewContainer:UIView = {
        let view = UIView()
        view.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 4).isActive = true
        return view
    }()
    
    let titleLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    let messageLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var textStackView:UIStackView = {
        let view = UIStackView.init(arrangedSubviews: [titleLabel,
                                                       messageLabel])
        view.alignment = .leading
        view.axis = .vertical
        return view
    }()
    
    private lazy var contentStackView:UIStackView = {
        let view = UIStackView.init(arrangedSubviews: [imageViewContainer,
                                                       textStackView])
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 8
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .yellow
        arrangeViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func arrangeViews(){
        addSubview(contentStackView)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
    }
    
    func populateUI(with message:InAppMessage){
        imageView.downloaded(from: "https://picsum.photos/200")//message.data.content.props.imageURL)
        titleLabel.text = message.data.content.props.title
        messageLabel.text = message.data.content.props.message
        messageLabel.isHidden = (message.data.content.props.message ?? "").isEmpty
        messageLabel.textColor = UIColor(hex:message.data.content.props.secondaryColor) ?? .black
        titleLabel.textColor = UIColor(hex:message.data.content.props.primaryColor) ?? .black
        self.layer.cornerRadius = 4.0
        backgroundColor = UIColor(hex:message.data.content.props.backgroundColor) ?? .white
    }
}
