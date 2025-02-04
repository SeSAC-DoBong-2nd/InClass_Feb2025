//
//  BasicPHPickerViewController.swift
//  SeventhWeek_SeSAC
//
//  Created by 박신영 on 2/4/25.
//

import UIKit

import PhotosUI //PHPicker
import SnapKit

final class BasicPHPickerViewController: UIViewController {

    private let pickerButton = UIButton()
    let photoImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    func configureView() {
        view.backgroundColor = .white
        
        view.addSubview(photoImageView)
        view.addSubview(pickerButton)
        
        photoImageView.snp.makeConstraints {
            $0.size.equalTo(300)
            $0.center.equalToSuperview()
        }
        
        pickerButton.snp.makeConstraints {
            $0.top.equalTo(photoImageView.snp.bottom).offset(100)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(300)
            $0.height.equalTo(50)
        }
        
        photoImageView.backgroundColor = .lightGray
        photoImageView.contentMode = .scaleAspectFit
        
        pickerButton.backgroundColor = .blue
        pickerButton.addTarget(self, action: #selector(pickerButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func pickerButtonTapped() {
        print(#function)
        var config = PHPickerConfiguration()
        config.filter = .any(of: [.screenshots, .images]) //필터링 요소 여러개 사용
        config.selectionLimit = 3
        config.mode = .default
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }

}

extension BasicPHPickerViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        print(#function)
        
        if let itemProvider = results.first?.itemProvider {
            print("1",Thread.isMainThread)
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                print("2",Thread.isMainThread)
                
                //실질적으로 갤러리에서 사진을 불러오는 과정 자체가 비동기로 돌아간다.
                //즉, 애플에서 만들 때, 갤러리에서 사진을 불러오는 과정이 생각보다 길어질 수 있다고 판단되어 비동기로 처리한 것이다.
                itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    print("3",Thread.isMainThread) //여기부터 비동기
                    
                    DispatchQueue.main.async {
                        self.photoImageView.image = image as? UIImage
                    }
                }
            }
        }
        
        dismiss(animated: true)
    }
    
}
