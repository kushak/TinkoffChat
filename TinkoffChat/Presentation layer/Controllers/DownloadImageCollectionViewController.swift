//
//  DownloadImageCollectionViewController.swift
//  TinkoffChat
//
//  Created by user on 14.05.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

protocol DownloadImageCollectionViewControllerDelegate {
    func setImage(imageToShow: UIImage)
}

class DownloadImageCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var delegate: DownloadImageCollectionViewControllerDelegate?
    let imageModel = ImageModel(imageService: ImageService(requestSender: RequestSender()))
    var dataSource = [ImageApiModel]()
    var emitter: Emitter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emitter = Emitter(view: view)
        imageModel.fetchImage(completionHandler: { [unowned self] _ in
            self.dataSource = self.imageModel.imageShow
            print(self.dataSource.count)
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        })
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageCollectionViewCell
        
        let image = dataSource[indexPath.row]
        let imageURL = URL(string: image.url)
        
        let backgroundQueue = DispatchQueue(label: "backgroundQueue", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        
        backgroundQueue.async {
            if let imageData = try? Data(contentsOf: imageURL!) {
                DispatchQueue.main.async {
                    cell.image.image = UIImage(data: imageData)
                }
            }
        }
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = (collectionView.cellForItem(at: indexPath) as! ImageCollectionViewCell).image.image
        delegate?.setImage(imageToShow: image!)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width / 3 - 3
        let height = width
        
        return CGSize(width: width, height: height)
    }

}
