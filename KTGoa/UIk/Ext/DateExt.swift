//
//  DateExt.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/1.
//

extension Date: GTCompble {}

// MARK: - 一、Date 基本的扩展
public extension GTBas where Base == Date {
    
    // MARK: - 获取当前 秒级 时间戳 - 10 位
    static var secondStamp : String {
        let timeInterval: TimeInterval = Base().timeIntervalSince1970
        return "\(Int(timeInterval))"
    }
    
    // MARK: - 获取当前 毫秒级 时间戳 - 13 位
    /// 获取当前 毫秒级 时间戳 - 13 位
    static var milliStamp : String {
        let timeInterval: TimeInterval = Base().timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
    }
    
    // MARK: - 获取当前的时间 Date
    /// 获取当前的时间 Date
    static var currentDate : Date {
        return Base()
    }
    
    // MARK: 昨天的日期（相对于date的昨天日期）
    static var yesterDayDate: Date? {
        return Calendar.current.date(byAdding: DateComponents(day: -1), to: Date())
    }
    
    // MARK: 是否为今天（只比较日期，不比较时分秒）
    var isToday: Bool {
        return Calendar.current.isDate(self.bas, inSameDayAs: Date())
    }
    
    // MARK: 是否为昨天
    /// 是否为昨天
    var isYesterday: Bool {
        // 1.先拿到昨天的 date
        guard let date = Base.gt.yesterDayDate else {
            return false
        }
        // 2.比较当前的日期和昨天的日期
        return Calendar.current.isDate(self.bas, inSameDayAs: date)
    }
    
    // MARK: 从 Date 获取年份
    /// 从 Date 获取年份
    var year: Int {
        return Calendar.current.component(Calendar.Component.year, from: self.bas)
    }
    
    // MARK: 从 Date 获取月份
    /// 从 Date 获取年份
    var month: Int {
        return Calendar.current.component(Calendar.Component.month, from: self.bas)
    }
    
    // MARK: 从 Date 获取 日
    /// 从 Date 获取 日
    var day: Int {
        return Calendar.current.component(.day, from: self.bas)
    }
    
    // MARK: 从 Date 获取 小时
    /// 从 Date 获取 日
    var hour: Int {
        return Calendar.current.component(.hour, from: self.bas)
    }
    
    // MARK: 从 Date 获取 分钟
    /// 从 Date 获取 分钟
    var minute: Int {
        return Calendar.current.component(.minute, from: self.bas)
    }
    
    // MARK: 从 Date 获取 秒
    /// 从 Date 获取 秒
    var second: Int {
        return Calendar.current.component(.second, from: self.bas)
    }
    
    // MARK: 从 Date 获取 毫秒
    /// 从 Date 获取 毫秒
    var nanosecond: Int {
        return Calendar.current.component(.nanosecond, from: self.bas)
    }
    
    // MARK: 是否为今年
    var isThisYear: Bool  {
        let calendar = Calendar.current
        let nowCmps = calendar.dateComponents([.year], from: Date())
        let selfCmps = calendar.dateComponents([.year], from: self.bas)
        let result = nowCmps.year == selfCmps.year
        return result
    }

    // MARK: 获取两个日期之间的分钟
    /// 获取两个日期之间的分钟
    /// - Parameter date: 对比的日期
    /// - Returns: 两个日期之间的分钟
    func numberOfMinutes(from date: Date) -> Int? {
       return componentCompare(from: date, unit: [.minute]).minute
    }
    
    // MARK: 获取两个日期之间的数据
    /// 获取两个日期之间的数据
    /// - Parameters:
    ///   - date: 对比的日期
    ///   - unit: 对比的类型
    /// - Returns: 两个日期之间的数据
    func componentCompare(from date: Date, unit: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute]) -> DateComponents {
        let calendar = Calendar.current
        let component = calendar.dateComponents(unit, from: date, to: bas)
        return component
    }
}

extension Date {
    
    /// 消息时间显示
    /// - Parameters:
    ///   - timeStamp: 时间戳
    ///   - timeType: 时间格式
    /// - Returns: description
    func chatMsgShowTime() -> String {
        
        let date = self

        let dfmatter = DateFormatter()
        
        if date.gt.isToday == true { // 表示今天
            dfmatter.dateFormat = "HH:mm"
            return dfmatter.string(from: date as Date)
        }
        
        // 表示昨天
        if date.gt.isYesterday == true {
            dfmatter.dateFormat = "MM-dd HH:mm"
            let formatString = "\(dfmatter.string(from: date as Date))"
            return formatString
        }
        
        // 判断是否是今年
        if date.gt.isThisYear { // 表示今年
            // 显示月日
            dfmatter.dateFormat = "MM-dd HH:mm"
            return dfmatter.string(from: date as Date)
        } else {
            dfmatter.dateFormat = "YYYY-MM-dd HH:mm"
            return dfmatter.string(from: date as Date)
        }
    }
    
    /// 会话列表时间显示
    func chatSessionShowTime() -> String {
        
        let date = self

        let dfmatter = DateFormatter()
        
        if date.gt.isToday { // 表示今天
            dfmatter.dateFormat = "HH:mm"
            return dfmatter.string(from: date as Date)
        }
        
        // 判断是否是今年
        if date.gt.isThisYear { // 表示今年
            // 显示月日
            dfmatter.dateFormat = "MM-dd"
            return dfmatter.string(from: date as Date)
        } else {
            dfmatter.dateFormat = "YYYY-MM-dd"
            return dfmatter.string(from: date as Date)
        }
    }
    
    func dateStr() -> String {
        let dFormatter = DateFormatter()
        dFormatter.dateFormat = "YYYY-MM-dd"
        return dFormatter.string(from: self)
    }
}
