
import UIKit

protocol AvatarViewDelegate: AnyObject {
    func avatarView(_ view: AvatarView, photoButtonDidTap: Void)
}

final class AvatarView: UIView {
    
    //MARK: - Outlets & Properties
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var imgView: UIImageView!
    @IBOutlet private weak var editButton: UIButton!
    
    weak var delegate:AvatarViewDelegate?
    
    @IBInspectable var photoButtonIsActive: Bool = true {
        didSet {
            editButton.isHidden = !photoButtonIsActive
        }
    }
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialSetup()
    }
    
    //MARK: - Functions
    private func initialSetup() {
        contentView = loadNib()
        backgroundColor = .clear
        addSubview(contentView)
        setupNibConstraints(contentView)
        setNeedsLayout()
    }
    
    func roundAvatar() {
        backgroundView.layer.cornerRadius = backgroundView.frame.height / 2
        imgView.layer.cornerRadius = imgView.frame.height / 2
        imgView.clipsToBounds = true
    }
    
    func setup(img: UIImage) {
        imgView.image = img
    }
    
    @IBAction private func didTapEdit(_ sender: Any) {
        delegate?.avatarView(self, photoButtonDidTap: ())
    }
    
}
