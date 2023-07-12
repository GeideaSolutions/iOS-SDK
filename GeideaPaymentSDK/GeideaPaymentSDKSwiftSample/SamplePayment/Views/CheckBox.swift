//
//  CheckBox.swift
//  GeideaPaymentSDKSwiftSample
//
//  Created by Saiempu Stephy on 12/06/23.
//

import UIKit



class CheckBox : UIView{
    
    var changeView : UIImageView!
    var tapGesture: UITapGestureRecognizer!
    var selected = false{
        didSet{
            if selected{
                changeView.image = UIImage().getCheckBoxImageActive()
            } else {
                changeView.image = UIImage().getCheckBoxImageInActive()
            }
        }
    }
    
    convenience init(tapGestureEnable: Bool){
        self.init()
        
        changeView = UIImageView.init(image: UIImage().getCheckBoxImageInActive())
        changeView.clipsToBounds = true
        changeView.contentMode = .scaleAspectFit
        if tapGestureEnable{
            tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapDetected(sender:)))
            self.addGestureRecognizer(tapGesture)
        } else {
            changeView = UIImageView.init(image: UIImage().getCheckBoxImageInActive())
        }
        self.addSubview(changeView)
    }
    
    func resetImage(){
        changeView = UIImageView.init(image: UIImage().getCheckBoxImageInActive())
    }
  
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    @objc func tapDetected(sender: UITapGestureRecognizer){
        selected = !selected
        self.layer.borderColor = selected ? UIColor.clear.cgColor : UIColor.gray.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initConstraints()
    }
    
    func initConstraints(){
        changeView.translatesAutoresizingMaskIntoConstraints = false
        changeView.widthAnchor.constraint(equalToConstant: self.bounds.width).isActive = true
        changeView.heightAnchor.constraint(equalToConstant: self.bounds.height).isActive = true
        changeView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        changeView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
    }
}


extension UIImage{
    func getCheckBoxImageActive()->UIImage{
        return UIImage.init(named: "ic_check_box_black_24px")!
    }
    func getCheckBoxImageInActive()->UIImage{
        return UIImage.init(named: "Rectangle 9")!
    }
}

