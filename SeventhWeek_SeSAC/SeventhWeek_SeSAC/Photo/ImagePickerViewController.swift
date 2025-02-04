//
//  ImagePickerViewController.swift
//  SeventhWeek_SeSAC
//
//  Created by 박신영 on 2/4/25.
//

import UIKit

import SnapKit

final class ImagePickerViewController: UIViewController {
    
    private let pickerButton = UIButton()
    private let photoImageView = UIImageView()
    
//    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    func configureView() {
        view.backgroundColor = .white
        
//        imagePicker.delegate = self
        
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
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera //실기기 빌드
        imagePicker.allowsEditing = true //편집 해줄지 말지
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    

}

extension ImagePickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //이미지 선택 시
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(#function)

        //Any => UIImage
        let image = info[UIImagePickerController.InfoKey.editedImage]
        
        if let result = image as? UIImage {
            photoImageView.image = result
        } else {
            print("실패!")
        }
        
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print(#function)
        dismiss(animated: true)
    }
    
}
