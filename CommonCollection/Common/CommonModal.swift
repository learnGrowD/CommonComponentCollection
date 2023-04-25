//
//  CommonModal.swift
//  CommonCollection
//
//  Created by 도학태 on 2023/04/25.
//

import Foundation
import UIKit
import Then
import RxSwift
import RxCocoa
import RxGesture
import SnapKit
import Kingfisher


class CommonModal : BaseViewController {
    let disposeBag = DisposeBag()
    
    let blurView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.3)
    }
    
    let parentView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 16
    }
    
    let titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.numberOfLines = 1
    }
    
    let imageView = UIImageView()
    
    let messageLabel = UILabel().then {
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    let underLineView = UIView().then {
        $0.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    let nagativeButton = UILabel().then {
        $0.textAlignment = .center
    }
    
    var nagativeDelegate : (CommonModal) -> Void = { _ in }
    
    let positiveButton = UILabel().then {
        $0.textAlignment = .center
    }
    
    var positiveDelegate : (CommonModal) -> Void = { _ in }
    
    
    lazy var buttonStackView = UIStackView(arrangedSubviews: [nagativeButton, positiveButton]).then {
        $0.heightAnchor.constraint(equalToConstant: 44).isActive = true
        $0.distribution = .fillEqually
        $0.axis = .horizontal
    }
    
    let pillarLineView = UIView().then {
        $0.widthAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /*
     화연에 표시
     */
    func show() {
        /*
         현재 화면의 최상단에 보이는 ViewController가 자기 자신인지 판단.
         */
        if topMostViewController !== self {
            /*
             최상단 ViewController를 통해서 Modal 보여주기
             */
            self.view.backgroundColor = .clear
            self.modalTransitionStyle = .crossDissolve
            self.modalPresentationStyle = .overFullScreen
            topMostViewController?.present(self, animated: true)
        }
    }
    
    func bind() {
        nagativeButton.rx.tapGesture()
            .when(.recognized)
            .bind(onNext : { [weak self] _ in
                guard let self = self else { return }
                self.nagativeDelegate(self)
            })
            .disposed(by: disposeBag)
        
        positiveButton.rx.tapGesture()
            .when(.recognized)
            .bind(onNext : { [weak self] _ in
                guard let self = self else { return }
                self.positiveDelegate(self)
            })
            .disposed(by: disposeBag)
    }
    
    private func configure(
        title : String,
        message : String,
        
        image : UIImage?,
        imageUrl : String?,
        imgWidth : Int,
        imgHeight : Int,
        
        nagativeButtonStr : String,
        nagativeButtonDelegate : @escaping (CommonModal) -> Void,
        positiveButtonStr : String,
        positiveButtonDelegate : @escaping (CommonModal) -> Void,
        
        /*
         속성
         */
        titleColor : UIColor,
        messageColor : UIColor,
        nagativeButtonColor : UIColor,
        positiveButtonColor : UIColor,
        modalBackgroundColor : UIColor,
        lineColor : UIColor
    ) {
        self.titleLabel.text = title
        
        self.messageLabel.text = message
        
        /*
         image
         */
        
        imageView.snp.makeConstraints {
            $0.width.equalTo(imgWidth)
            $0.height.equalTo(imgHeight)
        }
        
        if let image = image {
            imageView.image = image
            imageView.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            }
        }
        
        if let imageUrl = imageUrl {
            imageView.kf.setImage(with: URL(string: imageUrl))
            imageView.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            }
        }
        
        /*
         setNavigationButton을 안한다면 숨겨서 positiveButton만 보이게 동작하자...
         */
        self.nagativeButton.isHidden = nagativeButtonStr.isEmpty
        self.pillarLineView.isHidden = nagativeButtonStr.isEmpty
        
        self.nagativeButton.text = nagativeButtonStr
        self.nagativeDelegate = nagativeButtonDelegate
        
        self.positiveButton.text = positiveButtonStr
        self.positiveDelegate = positiveButtonDelegate
        
        /*
         속성
        */
        self.titleLabel.textColor = titleColor
        self.messageLabel.textColor = messageColor
        self.nagativeButton.textColor = nagativeButtonColor
        self.positiveButton.textColor = positiveButtonColor
        self.parentView.backgroundColor = modalBackgroundColor
        self.underLineView.backgroundColor = lineColor
        self.pillarLineView.backgroundColor = lineColor
    }
    
    /*
     자신의 Design에 맞게 layout을 배치
     정확히는 설정을 했을때 그릇이 되는 View들에 대해서
     각 상황에 대응하는 layout을 배치하는 것이 핵심
     */
    func layout() {
        [
            blurView,
            parentView,
            titleLabel,
            imageView,
            messageLabel,
            underLineView,
            buttonStackView,
            pillarLineView,
        ].forEach {
            view.addSubview($0)
        }
        
        blurView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        parentView.snp.makeConstraints {
            $0.width.equalTo(270)
            $0.center.equalToSuperview()
            $0.top.equalTo(titleLabel).offset(-16)
            $0.bottom.equalTo(buttonStackView)
        }
        
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(parentView)
            $0.centerX.equalTo(parentView).inset(16)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.centerX.equalTo(parentView)
        }
        
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(parentView).inset(16)
        }
        
        underLineView.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(parentView)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(underLineView.snp.bottom)
            $0.leading.trailing.equalTo(parentView)
            $0.bottom.equalTo(parentView)
        }
        
        pillarLineView.snp.makeConstraints {
            $0.top.bottom.equalTo(buttonStackView)
            $0.centerX.equalTo(buttonStackView)
        }
    }
    
    class Builder {
        /*
         ...
         이후 필요한 속성에 대해서 지속적으로 추가하면 된다
         ex) Title, Message, button Font
         */
        
        /*
         Default 값 설정
         */
        private var title : String = ""
        private var message : String = ""
        
        private var image : UIImage? = nil
        private var imageUrl : String? = nil
        private var imgWidt : Int = 0
        private var imghight : Int = 0
        
        private var nagativeButtonStr : String = ""
        private var nagativeButtonDelegate : (CommonModal) -> Void = { _ in }
        private var positiveButtonStr : String = ""
        private var positiveButtonDelegate : (CommonModal) -> Void = { _ in }
        
        /*
         color 속성
         Default 값 설정
         */
        private var titleColor : UIColor = .black
        private var messageColor : UIColor = .black
        private var nagativeButtonColor : UIColor = .blue
        private var positiveButtonColor : UIColor = .red
        private var modalBackgroindColor : UIColor = .white
        private var lineColor : UIColor = .gray
        
        
        func setTitle(_ title : String) -> Self {
            self.title = title
            return self
        }
        
        func setMessage(_ message : String) -> Self {
            self.message = message
            return self
        }
        
        func setImage(_ image : UIImage?, width : Int, height : Int) -> Self {
            self.image = image
            self.imgWidt = width
            self.imghight = height
            return self
        }
        
        func setImageUrl(_ url : String?, width : Int, height : Int) -> Self {
            self.imageUrl = url
            self.imgWidt = width
            self.imghight = height
            return self
        }
        
        func setNagativeButton(
            _ label : String,
            _ delegate : @escaping (CommonModal) -> Void
        ) -> Self {
            self.nagativeButtonStr = label
            self.nagativeButtonDelegate = delegate
            return self
        }
        
        func setPositiveButton(
            _ label : String,
            _ delegate : @escaping (CommonModal) -> Void
        ) -> Self {
            self.positiveButtonStr = label
            self.positiveButtonDelegate = delegate
            return self
        }
        
        /*
         color 속성
         */
        
        func setTitleColor(_ color : UIColor) -> Self {
            self.titleColor = color
            return self
        }
        
        func messageColor(_ color : UIColor) -> Self {
            self.messageColor = color
            return self
        }
        
        func setNagativeButtonColor(_ color : UIColor) -> Self {
            self.nagativeButtonColor = color
            return self
        }
        
        func setPositiveButtonColor(_ color : UIColor) -> Self {
            self.positiveButtonColor = color
            return self
        }
        
        func setModalBackgroundColor(_ color : UIColor) -> Self {
            self.modalBackgroindColor = color
            return self
        }
        
        func setLineColor(_ color : UIColor) -> Self {
            self.lineColor = color
            return self
        }
        
        func build() -> CommonModal {
            return CommonModal().then {
                $0.configure(
                    title: title,
                    message: message,
                    image: image,
                    imageUrl: imageUrl,
                    imgWidth: imgWidt,
                    imgHeight: imghight,
                    nagativeButtonStr: nagativeButtonStr,
                    nagativeButtonDelegate: nagativeButtonDelegate,
                    positiveButtonStr: positiveButtonStr,
                    positiveButtonDelegate: positiveButtonDelegate,
                    titleColor: titleColor,
                    messageColor: messageColor,
                    nagativeButtonColor: nagativeButtonColor,
                    positiveButtonColor: positiveButtonColor,
                    modalBackgroundColor: modalBackgroindColor,
                    lineColor: lineColor
                )
            }
        }
    }
    
    
}
