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
        if let cell = collectionView.visibleCells().first as? BukoliPointDialogCell {
            bukoliMapViewController.moveMap(cell.bukoliPoint)
        }
        
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bukoliPoints.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BukoliPointDialogCell", forIndexPath: indexPath) as! BukoliPointDialogCell
        cell.bukoliDetailDialog = self
        return cell
    }
    
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let cell = cell as! BukoliPointDialogCell
        let index = indexPath.row
        let bukoliPoint = bukoliPoints[index]
        cell.index = index
        cell.bukoliPoint = bukoliPoint
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return BukoliPointCell.sizeForItem(collectionView)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let spacing = ((collectionView.frame.size.width - BukoliPointCell.sizeForItem(collectionView).width) - 2 * 10) / 2
        return UIEdgeInsets(top: 0, left: spacing+10, bottom: 0, right: spacing+10)
        
    }
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if !swipeImageView.hidden {
            swipeImageView.hidden =  true
        }
        
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let newTargetOffset = calculateTargetOffset(scrollView, targetContentOffset: targetContentOffset.memory)
        targetContentOffset.memory.x = newTargetOffset
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        updateMap()
    }
    
    // MARK: Offset Calculation
    
    func calculateTargetOffset(scrollView: UIScrollView, targetContentOffset: CGPoint) -> CGFloat {
        
        let contentWidth = Float(scrollView.contentSize.width)
        let pageWidth = Float(BukoliPointCell.sizeForItem(scrollView).width + 10)
        let currentOffset = Float(scrollView.contentOffset.x)
        let targetOffset = Float(targetContentOffset.x)
        
        var newTargetOffset:Float = 0.0
        
        if targetOffset > currentOffset {
            newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth
        }
        else {
            newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth
        }
        
        // Correction
        newTargetOffset = min(max(newTargetOffset, 0), contentWidth)
        
        return CGFloat(newTargetOffset);
    }
    
    func indexForOffset(scrollView: UIScrollView, currentOffset: CGFloat) -> Int {
        return Int(currentOffset / (BukoliPointCell.sizeForItem(scrollView).width + 10))
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        collectionView.hidden = true
        swipeImageView.tintColor = UIColor.whiteColor()
        
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        
        isScrolled = false
        let bukoliUserDefault = NSUserDefaults(suiteName: "bukoli")!
        
        if bukoliUserDefault.boolForKey("isSwipeShownBefore"){
            swipeImageView.hidden = true
        } else{
            bukoliUserDefault.setObject(true, forKey: "isSwipeShownBefore")
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (!isScrolled) {
            isScrolled = true
            self.collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem:index,
                inSection:0),atScrollPosition: .CenteredHorizontally,animated: false)
            collectionView.hidden = false
        }
        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        self.collectionView.collectionViewLayout.invalidateLayout()
        
        let index = indexForOffset(self.collectionView, currentOffset: self.collectionView.contentOffset.x);
        
        coordinator.animateAlongsideTransition( { _ in
            let indexPath = NSIndexPath(forRow:index, inSection: 0)
            self.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: false)
            }, completion:nil)
    }
    
}
