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
    
    func updateMap() {
        if let cell = collectionView.visibleCells.first as? BukoliPointDialogCell {
            bukoliMapViewController.moveMap(cell.bukoliPoint)
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
        return BukoliPointCell.sizeForItem(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let spacing = ((collectionView.frame.size.width - BukoliPointCell.sizeForItem(collectionView).width) - 2 * 10) / 2
        return UIEdgeInsets(top: 0, left: spacing+10, bottom: 0, right: spacing+10)
    }
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !swipeImageView.isHidden {
            swipeImageView.isHidden =  true
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let newTargetOffset = calculateTargetOffset(scrollView, velocity: velocity, targetContentOffset: targetContentOffset.pointee)
        targetContentOffset.pointee.x = newTargetOffset
    }
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        updateMap()
//    }
//    
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if !decelerate {
//            updateMap()
//        }
//    }
    
    // MARK: Offset Calculation
    
    func calculateTargetOffset(_ scrollView: UIScrollView, velocity: CGPoint, targetContentOffset: CGPoint) -> CGFloat {
        let pageWidth = BukoliPointCell.sizeForItem(collectionView).width + 10
        let pageFloat = targetContentOffset.x/pageWidth;
        
        var page = 0
        if velocity.x > 0 {
            page = Int(ceil(pageFloat))
        }
        else if velocity.x < 0 {
            page = Int(floor(pageFloat))
        }
        else {
            page = Int(round(pageFloat))
        }
        
        // Page
        let newTargetOffset = Float(page*Int(pageWidth))
        
        return CGFloat(newTargetOffset);
    }
    
    func indexForOffset(_ scrollView: UIScrollView, currentOffset: CGFloat) -> Int {
        return Int(currentOffset / (BukoliPointCell.sizeForItem(scrollView).width + 10))
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        collectionView.isHidden = true
        swipeImageView.tintColor = UIColor.white
        
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        
        isScrolled = false
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
            //            bukoliMapViewController.moveMap(bukoliPoints[index])
        }
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.collectionView.collectionViewLayout.invalidateLayout()
        
        let index = indexForOffset(self.collectionView, currentOffset: self.collectionView.contentOffset.x);
        
        coordinator.animate(alongsideTransition: { _ in
            let indexPath = IndexPath(row: index, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }, completion:nil)
        
    }
    
}
