//
//  UICollectionViewExt.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/3.
//


public extension GTBas where Base: UICollectionView {
    
    /// 是否滚动到顶部
    /// - Parameter animated: 是否要动画
    func scrollToTop(animated: Bool) {
        bas.setContentOffset(CGPoint(x: 0, y: 0), animated: animated)
    }
    
    /// 是否滚动到底部
    /// - Parameter animated: 是否要动画
    func scrollToBottom(animated: Bool) {
        let y = bas.contentSize.height - bas.frame.size.height
        if y < 0 { return }
        bas.setContentOffset(CGPoint(x: 0, y: y), animated: animated)
    }
    
    /// 滚动到什么位置（CGPoint）
    /// - Parameter animated: 是否要动画
    func scrollToOffset(offsetX: CGFloat = 0, offsetY: CGFloat = 0, animated: Bool) {
        bas.setContentOffset(CGPoint(x: offsetX, y: offsetY), animated: animated)
    }
    
    /// 注册自定义cell
    /// - Parameter cellClass: UICollectionViewCell类型
    func register(cellClass: UICollectionViewCell.Type) {
        bas.register(cellClass.self, forCellWithReuseIdentifier: cellClass.className)
    }
    
    /// 注册Xib自定义cell
    /// - Parameter nib: nib description
    func register(nib: UINib) {
        bas.register(nib, forCellWithReuseIdentifier: nib.className)
    }
    
    /// 创建UICollectionViewCell(注册后使用该方法)
    /// - Parameters:
    ///   - cellType: UICollectionViewCell类型
    ///   - indexPath: indexPath description
    /// - Returns: 返回UICollectionViewCell类型
    func dequeueReusableCell<T: UICollectionViewCell>(cellType: T.Type, cellForRowAt indexPath: IndexPath) -> T {
        return bas.dequeueReusableCell(withReuseIdentifier: cellType.className, for: indexPath) as! T
    }
    
    /// 注册自定义: Section 的Header或者Footer
    /// - Parameters:
    ///   - reusableView: UICollectionReusableView类
    ///   - elementKind: elementKind： header：UICollectionView.elementKindSectionHeader  还是 footer：UICollectionView.elementKindSectionFooter
    func registerCollectionReusableView(reusableView: UICollectionReusableView.Type, forSupplementaryViewOfKind elementKind: String) {
        bas.register(reusableView.self, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: reusableView.className)
    }
    
    /// 创建Section 的Header或者Footer(注册后使用该方法)
    /// - Parameters:
    ///   - reusableView: UICollectionReusableView类
    ///   - collectionView: collectionView
    ///   - elementKind:  header：UICollectionView.elementKindSectionHeader  还是 footer：UICollectionView.elementKindSectionFooter
    ///   - indexPath: indexPath description
    /// - Returns: 返回UICollectionReusableView类型
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(reusableView: T.Type, in collectionView: UICollectionView, ofKind elementKind: String, for indexPath: IndexPath) -> T {
        return collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: reusableView.className, for: indexPath) as! T
    }
}
