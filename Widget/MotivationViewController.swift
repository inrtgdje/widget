//
//  MotivationViewController.swift
//  Widget
//
//  Created by 汤天明 on 2020/10/19.
//

import UIKit
import  PhotosUI

class MotivationViewController: UIViewController {

    
    
    struct ImageItem:Hashable {
        let image:UIImage
        let uuid = UUID()
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(uuid)
        }
    }
    
    
    var dataSource:UICollectionViewDiffableDataSource<Int,ImageItem>! = nil
    var collectionView:UICollectionView! = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureDataSource()
        
        // Do any additional setup after loading the view.
    }
    
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(0.3))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize:groupSize, subitems: [item])
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.delegate = self
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ListCell,MotivationViewController.ImageItem> { (cell, indexPath, imageItem) in
            cell.accessoryImageView.image = imageItem.image
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int,ImageItem>(collectionView: collectionView, cellProvider: { (collectionView, indxePath, imageItem) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indxePath, item: imageItem)
        })
        
        let firstImageItem = ImageItem(image: UIImage(named: "ico_img_add")!)
        var snapshot = NSDiffableDataSourceSnapshot<Int,ImageItem>()
        snapshot.appendSections([0])
        snapshot.appendItems([firstImageItem])
        dataSource.apply(snapshot, animatingDifferences: false, completion: nil)
    }
}


extension MotivationViewController {
    func imagePicker(){
        
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
      
    }
}


extension MotivationViewController:UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            print("The \(indexPath.item) image")
            let configuration = PHPickerConfiguration()
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            present(picker, animated: true, completion: nil)
        }
    }
}


extension MotivationViewController:PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        var items :[ImageItem] = [ImageItem]()
        for result in results {
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                    if let image = image {
                        let item = ImageItem.init(image: image as! UIImage)
                        items.append(item)
                    }
                }
            }
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Int,ImageItem>()
        
        snapshot.appendItems(items)
    }
    
    
}
