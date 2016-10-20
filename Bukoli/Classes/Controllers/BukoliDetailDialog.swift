//
//  BukoliDetailDialog.swift
//  Pods
//
//  Created by Utku Yıldırım on 03/10/2016.
//
//

import UIKit
import AlamofireImage

class BukoliDetailDialog: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var swipeImageView: UIImageView!
    
    var bukoliMapViewController: BukoliMapViewController!
    var index: Int!
    
    var isScrolled = false
    
    var bukoliPoints:[BukoliPoint] {
        get {
            return bukoliMapViewController.bukoliPoints
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bukoliPoints.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BukoliPointDialogCell", for: indexPath) as! BukoliPointDialogCell
        cell.bukoliDetailDialog = self
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! BukoliPointDialogCell
        
        let index = indexPath.row
        let bukoliPoint = bukoliPoints[index]
        cell.index = index
        cell.bukoliPoint = bukoliPoint
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            updateMap()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateMap()
    }
    
    func updateMap() {
        if let cell = collectionView.visibleCells.first as? BukoliPointDialogCell {
            bukoliMapViewController.moveMap(cell.bukoliPoint)
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !swipeImageView.isHidden {
            swipeImageView.isHidden =  true
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.isHidden = true
        swipeImageView.tintColor = UIColor.white
        
        let bukoliUserDefault = UserDefaults(suiteName: "bukoli")!
        if bukoliUserDefault.bool(forKey: "isSwipeShownBefore") {
            swipeImageView.isHidden = true
        }
        else {
            bukoliUserDefault.set(true, forKey: "isSwipeShownBefore")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (!isScrolled) {
            isScrolled = true
            collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: false)
            collectionView.isHidden = false
            updateMap()
        }
        
    }
    
    
    

}
