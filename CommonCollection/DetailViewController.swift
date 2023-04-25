//
//  DetailViewController.swift
//  CommonCollection
//
//  Created by 도학태 on 2023/04/25.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class DetailViewController : BaseViewController {
    let disposeBag = DisposeBag()
    
    let commonRetry = UILabel().then {
        $0.text = "CommonRetry"
    }
    
    
    
    
    var loadingView : CommonLoadingView? = nil
    var timeRemaining = 2.0
    var timer : Timer? = nil
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: timeRemaining, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            self.timeRemaining -= self.timeRemaining

            if self.timeRemaining == 0 {
                CommonRetryView.Builder()
                    .setTitle("알림")
                    .setRetryStr("재시도")
                    .build()
                    .show()
                
                
                self.loadingView?.dismiss()
                self.loadingView = nil
                /*
                 초기화
                 */
                self.timer?.invalidate()
                self.timer = nil
                self.timeRemaining = 2.0
            }
        }
    }
    
    
    func bind() {
        
        commonRetry.rx.tapGesture()
            .when(.recognized)
            .bind(onNext : { [weak self] _ in
                self?.loadingView = CommonLoadingView()
                self?.loadingView?.show()
                
                
                self?.startTimer()
            })
            .disposed(by: disposeBag)
    }
    
    override func retry() {
        super.retry()
        print("HELLO RETRY")
    }
    
    
    func layout() {
        [
            commonRetry
        ].forEach {
            view.addSubview($0)
        }
        
        
        commonRetry.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(32)
            $0.centerX.equalToSuperview()
        }
    }
    
    
    
}
