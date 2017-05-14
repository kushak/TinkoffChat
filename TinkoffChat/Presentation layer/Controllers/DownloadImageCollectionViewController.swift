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

class DownloadImageCollectionViewController: UICollectionViewController {

    var delegate: DownloadImageCollectionViewControllerDelegate?
    let imageModel = ImageModel(imageService: ImageService(requestSender: RequestSender()))
    var dataSource = [ImageApiModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageModel.fetchImage(completionHandler: { [unowned self] _ in
            self.dataSource = self.imageModel.imageShow
            
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        })
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 0
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

}
