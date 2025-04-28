//
//  LeftAlignedColFlowLayout.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/5.
//

import UIKit

import UIKit

extension UICollectionViewLayoutAttributes {
    func leftAlignFrame(with sectionInset: UIEdgeInsets) {
        var frame = self.frame
        frame.origin.x = sectionInset.left
        self.frame = frame
    }
}


class LeftAlignedColFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let originalAttributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        var updatedAttributes: [UICollectionViewLayoutAttributes] = []
        
        for attributes in originalAttributes {
            let newAttributes = attributes.copy() as! UICollectionViewLayoutAttributes
            if newAttributes.representedElementCategory == .cell {
                newAttributes.frame = layoutAttributesForItem(at: newAttributes.indexPath)?.frame ?? newAttributes.frame
            }
            updatedAttributes.append(newAttributes)
        }
        
        return updatedAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let currentItemAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else { return nil }
        
        let sectionInset = evaluatedSectionInset(for: indexPath.section)
        let layoutWidth = collectionView!.bounds.width - sectionInset.left - sectionInset.right
        
        if indexPath.item == 0 {
            currentItemAttributes.leftAlignFrame(with: sectionInset)
            return currentItemAttributes
        }
        
        let previousIndexPath = IndexPath(item: indexPath.item - 1, section: indexPath.section)
        let previousAttributes = layoutAttributesForItem(at: previousIndexPath)!
        let previousFrame = previousAttributes.frame
        let previousFrameRightPoint = previousFrame.origin.x + previousFrame.size.width
        
        let currentFrame = currentItemAttributes.frame
        let stretchedCurrentFrame = CGRect(x: sectionInset.left,
                                           y: currentFrame.origin.y,
                                           width: layoutWidth,
                                           height: currentFrame.size.height)
        
        let isFirstItemInRow = !stretchedCurrentFrame.intersects(previousFrame)
        
        if isFirstItemInRow {
            currentItemAttributes.leftAlignFrame(with: sectionInset)
            return currentItemAttributes
        }
        
        var frame = currentItemAttributes.frame
        frame.origin.x = previousFrameRightPoint + evaluatedMinimumInteritemSpacing(for: indexPath.section)
        currentItemAttributes.frame = frame
        
        return currentItemAttributes
    }
    
    private func evaluatedMinimumInteritemSpacing(for sectionIndex: Int) -> CGFloat {
        if let delegate = collectionView?.delegate as? UICollectionViewDelegateFlowLayout {
            return delegate.collectionView!(collectionView!, layout: self, minimumInteritemSpacingForSectionAt: sectionIndex)
        } else {
            return minimumInteritemSpacing
        }
    }
    
    private func evaluatedSectionInset(for sectionIndex: Int) -> UIEdgeInsets {
        if let delegate = collectionView?.delegate as? UICollectionViewDelegateFlowLayout {
            return delegate.collectionView!(collectionView!, layout: self, insetForSectionAt: sectionIndex)
        } else {
            return sectionInset
        }
    }
}
