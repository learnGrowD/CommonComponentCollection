//
//  CommonToastView.swift
//  CommonCollection
//
//  Created by 도학태 on 2023/04/25.
//

import Foundation
import Toast_Swift
import RxSwift
import RxCocoa

class CommonToast : UIView {
    
    
    private let disposeBag = DisposeBag()
    
    private var onClickDelegate : (CommonToast) -> Void = { _ in }
    
    private let messageLabel = UILabel().then {
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        let topMostViewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topMostViewController
        topMostViewController?.view.showToast(self, duration: 1, position: .bottom)
    }
    
    private func bind() {
        /*
         ToastButton을 탭 했을때
         */
        self.rx.tapGesture()
            .when(.recognized)
            .bind(onNext : { [weak self] _ in
                guard let self = self else { return }
                self.onClickDelegate(self)
            })
            .disposed(by: disposeBag)
    }
    
    private func configure(
        message : String,
        messageColor : UIColor,
        backgroundColor : UIColor,
        onClickDelegate : @escaping (CommonToast) -> Void
    ) {
        self.messageLabel.text = message
        self.messageLabel.textColor = messageColor
        
        self.backgroundColor = backgroundColor
        
        self.onClickDelegate = onClickDelegate
    }
    
    
    private func layout() {
        [
            messageLabel
        ].forEach {
            addSubview($0)
        }
        
        messageLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    
    /*
     필요에 의해서 추가 속성 등록 및 사용
     */
    
    class Builder {
        private var message : String = ""
        private var messageColor : UIColor = .black
        private var backgroundColor : UIColor = .cyan
        private var heightSize : CGFloat = 56
        
        private(set) var onClickDelegate : (CommonToast) -> Void = { _ in }
        
        func setMessage(_ message : String) -> Self {
            self.message = message
            return self
        }
        
        func setMessageColor(_ color : UIColor) -> Self {
            self.messageColor = color
            return self
        }
        
        func setBackgroundColor(_ color : UIColor) -> Self {
            self.backgroundColor = color
            return self
        }
        
        func setHeightSize(_ height : CGFloat) -> Self {
            self.heightSize = height
            return self
        }
        
        func setOnClickDelegate(_ delegate : @escaping (CommonToast) -> Void) -> Self {
            self.onClickDelegate = delegate
            return self
        }
        
        func build() -> CommonToast {
            let rootViewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController
            return CommonToast(frame: .init(x: 0, y: 0, width: rootViewController?.view.frame.width ?? 0, height: heightSize)).then {
                $0.configure(
                    message: message,
                    messageColor: messageColor,
                    backgroundColor: backgroundColor,
                    onClickDelegate: onClickDelegate
                )
            }
        }
    }
    
    
    
}
