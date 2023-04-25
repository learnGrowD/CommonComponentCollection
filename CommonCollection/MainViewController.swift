//
//  MainViewController.swift
//  CommonCollection
//
//  Created by 도학태 on 2023/04/25.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Then
import Lottie


/*
 Common
 - Modal
 - BottomModal
 - RetryView
 - LoadingView
 - Toast
 */


class MainViewController : BaseViewController {
    let disposeBag = DisposeBag()
    
    let commonModalVersion_1 = UILabel().then {
        $0.text = "CommonModalVersion_1"
    }
    
    let commonModalVersion_2 = UILabel().then {
        $0.text = "CommonModalVersion_2"
    }
    
    let commonModalVersion_3 = UILabel().then {
        $0.text = "CommonModalVersion_3"
    }
    
    let commonBottomModal = UILabel().then {
        $0.text = "CommonBottomModal"
    }
    
    let commomnLoadingViewButton = UILabel().then {
        $0.text = "CommonLoadingView"
    }
    
    
    let commonToast = UILabel().then {
        $0.text = "commonToast"
    }
    
    
    let detailPage = UILabel().then {
        $0.text = "Detail"
    }
    
    
    var commonLoadingView : CommonLoadingView? = nil
    
    var timeRemaining = 3.0
    var timer : Timer? = nil
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startLoadingTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: timeRemaining, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            self.timeRemaining -= self.timeRemaining

            if self.timeRemaining == 0 {
                self.commonLoadingView?.dismiss()
                self.commonLoadingView = nil
                
                self.timer?.invalidate()
                self.timer = nil
                
                self.timeRemaining = 3.0
            }
        }
        
    }
    
    func bind() {
        
        /*
         버튼 두개
         */
        commonModalVersion_1.rx.tapGesture()
            .when(.recognized)
            .bind(onNext : { _ in
                /*
                 Builder instance 생성 -> Method Chaining 기법을 통해서 설정 -> Build [CommonModal] -> show
                 */
                CommonModal.Builder()
                    .setTitle("알림")
                    .setMessage("이것은 CommonModalVersion_1 입니다.")
                    .setNagativeButton("취소") {
                        print("취소 버튼을 누름")
                        $0.dismiss(animated: true)
                    }
                    .setPositiveButton("확인") {
                        print("확인 버튼을 누름")
                        $0.dismiss(animated: true)
                    }
                    .build()
                    .show()
            })
            .disposed(by: disposeBag)
        
        /*
         버튼 하나
         */
        commonModalVersion_2.rx.tapGesture()
            .when(.recognized)
            .bind(onNext : { _ in
                CommonModal.Builder()
                    .setTitle("알림")
                    .setMessage("이것은 CommonModalVersion_2 입니다.")
                    .setPositiveButton("확인") {
                        print("확인 버튼을 누름")
                        $0.dismiss(animated: true)
                    }
                    .build()
                    .show()
            })
            .disposed(by: disposeBag)
        
        /*
         Img가 있는 경우
         */
        commonModalVersion_3.rx.tapGesture()
            .when(.recognized)
            .bind(onNext : { _ in
                CommonModal.Builder()
                    .setTitle("알림")
                    .setImage(UIImage(named: "background"), width: 32, height: 32)
                    .setMessage("이것은 CommonModalVersion_3 입니다.")
                    .setPositiveButton("확인") {
                        print("확인 버튼을 누름")
                        $0.dismiss(animated: true)
                    }
                    .build()
                    .show()
            })
            .disposed(by: disposeBag)
        
        
        commonBottomModal.rx.tapGesture()
            .when(.recognized)
            .bind(onNext : { _ in
                let swiftAction = CommoBottomModalAction(
                    title: "SWIFT",
                    titleColor: .systemPink
                ) { _ in
                    print("HELLO SWIFT")
                }
                let kotlinAction = CommoBottomModalAction(
                    title: "KOTIN",
                    titleColor: .purple
                ) { _ in
                    print("HELLO KOTLIN")
                }
                
                let actions = [swiftAction, kotlinAction]
                CommonBottomModal.Builder()
                    .setActions(actions)
                    .setCancelMessage("취소")
                    .build()
                    .show()
            })
            .disposed(by: disposeBag)
        
        
        commomnLoadingViewButton.rx.tapGesture()
            .when(.recognized)
            .bind(onNext : { [weak self] _ in
                guard let self = self else { return }
                self.commonLoadingView = CommonLoadingView()
                self.commonLoadingView?.show()
                self.startLoadingTimer()
            })
            .disposed(by: disposeBag)
        
        commonToast.rx.tapGesture()
            .when(.recognized)
            .bind(onNext : { _ in
                CommonToast.Builder()
                    .setBackgroundColor(.systemBlue)
                    .setMessage("TOAST SHOW!!!")
                    .setOnClickDelegate { _ in
                        print("HELLO TOAST")
                    }
                    .build()
                    .show()
            })
            .disposed(by: disposeBag)
        
        
        detailPage.rx.tapGesture()
            .when(.recognized)
            .bind(onNext : { [weak self] _ in
                let vc = DetailViewController()
                vc.view.backgroundColor = .white
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func layout() {
        [
            commonModalVersion_1,
            commonModalVersion_2,
            commonModalVersion_3,
            commonBottomModal,
            commomnLoadingViewButton,
            commonToast,
            detailPage,
        ].forEach {
            view.addSubview($0)
        }
        
        commonModalVersion_1.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            $0.centerX.equalToSuperview()
        }
        
        commonModalVersion_2.snp.makeConstraints {
            $0.top.equalTo(commonModalVersion_1.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
        }
        
        commonModalVersion_3.snp.makeConstraints {
            $0.top.equalTo(commonModalVersion_2.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
        }
        
        commonBottomModal.snp.makeConstraints {
            $0.top.equalTo(commonModalVersion_3.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
        }
        
        commomnLoadingViewButton.snp.makeConstraints {
            $0.top.equalTo(commonBottomModal.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
        }
        
        commonToast.snp.makeConstraints {
            $0.top.equalTo(commomnLoadingViewButton.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
        }
        
        detailPage.snp.makeConstraints {
            $0.top.equalTo(commonToast.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
        }
        
    }
}
