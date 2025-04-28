//
//  MineCellLayoutable.swift
//  Golaa
//
//  Created by Cb on 2024/5/14.
//

import Foundation

protocol MineCellLayoutable {
    static var modules: [Self] { get }
    static var itemHeights: [CGFloat] { get }
    
    var title: String { get }
    var icon: String { get }
    var modules: [Self] { get }
    var iconHeight: CGFloat { get }
    func itemWidth(indexPath: IndexPath) -> CGFloat
    func itemHeight(row: Int) -> CGFloat
    func heightForSizeWidth() -> CGFloat
    static func totalHeight() -> CGFloat
    func push()
}

extension MineCellLayoutable {
    static var modules: [Self] { [] }
    static var itemHeights: [CGFloat] { modules.map({ $0.heightForSizeWidth() }) }
    
    var title: String { "" }
    
    var icon: String { "" }

    var modules: [Self] { [] }
    
    func push() {}
    
    var iconHeight: CGFloat { MineLayout.iconHeight }

    func itemWidth(indexPath: IndexPath) -> CGFloat { MineLayout.itemWidth }
    
    func itemHeight(row: Int) -> CGFloat {
        if let max = Self.maxOfElementGroupAtIndex(index: row) {
            return max
        }
        return 0
    }    
    
    func heightForSizeWidth() -> CGFloat {
        let height = (title as NSString).boundingRect(with: CGSize(width: MineLayout.itemWidth, 
                                                                   height: .greatestFiniteMagnitude),
                                                      options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                      attributes: [.font: UIFontReg(12)],
                                                      context: nil).size.height + 6 + iconHeight + MineLayout.padingLeading
        return height
    }
    
    static func totalHeight() -> CGFloat {
        let otherMargin = 53.0 + MineLayout.padingLeading
        let itemHeight = sumOfMaxEveryHorCountElements(array: itemHeights) + otherMargin
        return itemHeight
    }
    
    // 函数：每三个元素取最大值并求和
    private static func sumOfMaxEveryHorCountElements(array: [CGFloat] = itemHeights) -> CGFloat {
        var sum: CGFloat = 0
        let groupSize = Int(MineLayout.horCount) // 设定每组的大小为3
        
        // 遍历数组，步长为3
        for index in stride(from: 0, to: array.count, by: groupSize) {
            let group = array[index..<min(index + groupSize, array.count)] // 获取当前组
            if let max = group.max() { // 获取当前组的最大值
                sum += max // 将最大值加到总和中
            }
        }
        return sum
    }
    
    // 函数：根据索引找到索引所在的每三个元素的分组，并返回该分组的最大值
    private static func maxOfElementGroupAtIndex(array: [CGFloat] = itemHeights, index: Int) -> CGFloat? {
        let groupSize = Int(MineLayout.horCount) // 设定每组的大小为3
        
        // 计算索引所在分组的起始索引
        let groupStartIndex = (index / groupSize) * groupSize
        
        // 确保索引在数组范围内
        guard groupStartIndex < array.count else { return nil }
        
        // 计算分组的结束索引
        let groupEndIndex = min(groupStartIndex + groupSize, array.count)
        
        // 获取当前分组
        let group = array[groupStartIndex..<groupEndIndex]
        
        // 返回分组的最大值
        return group.max()
    }
}
