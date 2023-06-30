//
//  BNPLFlowLayout.swift
//  GeideaPaymentSDK
//
//  Created by Eugen Vidolman on 25.05.2022.
//

import UIKit

class BNPLFlowLayout: UICollectionViewFlowLayout {

    let cellsPerRow: Int

    required init(cellsPerRow: Int = 1, minimumInteritemSpacing: CGFloat = 0, minimumLineSpacing: CGFloat = 0, sectionInset: UIEdgeInsets = .zero) {
        self.cellsPerRow = cellsPerRow

        super.init()

        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
        self.sectionInset = sectionInset
        estimatedItemSize = CGSize(width: 100, height: 80)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let layoutAttributes = super.layoutAttributesForItem(at: indexPath) else { return nil }
        guard let collectionView = collectionView else { return layoutAttributes }

        let marginsAndInsets = collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + sectionInset.left + sectionInset.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        layoutAttributes.bounds.size.width = ((collectionView.bounds.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)

        return layoutAttributes
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let superLayoutAttributes = super.layoutAttributesForElements(in: rect)!.map { $0.copy() as! UICollectionViewLayoutAttributes }
        guard scrollDirection == .vertical else { return superLayoutAttributes }

        let layoutAttributes = superLayoutAttributes.compactMap { layoutAttribute in
            return layoutAttribute.representedElementCategory == .cell ? layoutAttributesForItem(at: layoutAttribute.indexPath) : layoutAttribute
        }

        // (optional) Uncomment to top align cells that are on the same line
        /*
        let cellAttributes = layoutAttributes.filter({ $0.representedElementCategory == .cell })
        for (_, attributes) in Dictionary(grouping: cellAttributes, by: { ($0.center.y / 10).rounded(.up) * 10 }) {
            guard let max = attributes.max(by: { $0.size.height < $1.size.height }) else { continue }
            for attribute in attributes where attribute.size.height != max.size.height {
                attribute.frame.origin.y = max.frame.origin.y
            }
        }
         */

        // (optional) Uncomment to bottom align cells that are on the same line
        /*
        let cellAttributes = layoutAttributes.filter({ $0.representedElementCategory == .cell })
        for (_, attributes) in Dictionary(grouping: cellAttributes, by: { ($0.center.y / 10).rounded(.up) * 10 }) {
            guard let max = attributes.max(by: { $0.size.height < $1.size.height }) else { continue }
            for attribute in attributes where attribute.size.height != max.size.height {
                attribute.frame.origin.y += max.frame.maxY - attribute.frame.maxY
            }
        }
         */

        return layoutAttributes
    }

}
