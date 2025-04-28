//
//  UIImageExt.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/2.
//

import AVFoundation
import Dispatch
import Photos

extension UIImage: GTCompble {}

extension UIImage {
    static func colorToImage(_ color: UIColor) -> UIImage? {
        return gt.image(color: color)
    }
    
    static func saveAlbum(_ view: UIView) {
        let rect = view.bounds

        UIGraphicsBeginImageContext(rect.size)

        guard let ctx: CGContext = UIGraphicsGetCurrentContext() else {
            return
        }

        view.layer.render(in: ctx)

        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        // 保存相册
        UIImageWriteToSavedPhotosAlbum(image!, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc static private func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
         if error == nil {
             ToastHud.showToastAction(message: "saveSuccessful".globalLocalizable())
         }
     }
}

// MARK: - 图片保存
extension UIImage {
    
    /// 保存url到相册
    static func savrImgUrl(url: String) {
        guard let imgUrl = URL(string: url),
              let imageData = try? Data(contentsOf: imgUrl),
              let img = UIImage.init(data: imageData) else {
            return
        }
        img.saveImgToAlbum()
    }
    
    /// 保存图片到相册中
    func saveImgToAlbum() {
        self.gt.savePhotosImageToAlbum { result, error in
            if result {
                ToastHud.showToastAction(message: "saveSuccessful".globalLocalizable())
            } else {
                if let error = error {
                    ToastHud.showToastAction(message: error.localizedDescription)
                }
            }
        }
    }
}


public extension GTBas where Base: UIImage {
    
    /// 生成指定尺寸的纯色图像
    /// - Parameters:
    ///   - color: 图片颜色
    ///   - size: 图片尺寸
    /// - Returns: 返回对应的图片
    static func image(color: UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0)) -> UIImage? {
        return image(color: color, size: size, corners: .allCorners, radius: 0)
    }
    
    /// 生成指定尺寸和圆角的纯色图像
    /// - Parameters:
    ///   - color: 图片颜色
    ///   - size: 图片尺寸
    ///   - corners: 剪切的方式
    ///   - round: 圆角大小
    /// - Returns: 返回对应的图片
    static func image(color: UIColor, size: CGSize, corners: UIRectCorner, radius: CGFloat) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        // 防止size：(0, 0)崩溃
        var drawSize = size
        if drawSize.width <= 0 || drawSize.height <= 0 {
            drawSize = CGSize(width: 1, height: 1)
        }
        UIGraphicsBeginImageContextWithOptions(drawSize, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        if radius > 0 {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            color.setFill()
            path.fill()
        } else {
            context?.setFillColor(color.cgColor)
            context?.fill(rect)
        }
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    /// 保存图片到相册
    func savePhotosImageToAlbum(completion: @escaping ((Bool, Error?) -> Void)) {
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAsset(from: self.bas)
        } completionHandler: { (isSuccess: Bool, error: Error?) in
            completion(isSuccess, error)
        }
    }
    
    /// 生成二维码图片
    /// - Parameters:
    ///   - content: 二维码里面的内容
    ///   - size: 二维码的大小
    ///   - logoSize: logo的大小
    ///   - logoImage: logo图片
    /// - Returns: 返回生成二维码图片
    static func QRImage(with content: String, size: CGSize, isLogo: Bool = true, logoSize: CGSize?, logoImage: UIImage? = nil, logoRoundCorner: CGFloat? = nil) -> UIImage? {
        // 1、创建名为"CIQRCodeGenerator"的CIFilter
        let filter = CIFilter(name: "CIQRCodeGenerator")
        // 2、将filter所有属性设置为默认值
        filter?.setDefaults()
        // 3、将所需尽心转为UTF8的数据，并设置给filter
        let data = content.data(using: String.Encoding.utf8)
        filter?.setValue(data, forKey: "inputMessage")
        // 4、设置二维码的纠错水平，越高纠错水平越高，可以污损的范围越大
        /*
         L: 7%
         M: 15%
         Q: 25%
         H: 30%
         */
        filter?.setValue("H", forKey: "inputCorrectionLevel")
        // 5、拿到二维码图片，此时的图片不是很清晰，需要二次加工
        guard let outPutImage = filter?.outputImage else { return nil }
        
        return getHDImgWithCIImage(with: outPutImage, size: size, isLogo: isLogo, logoSize: logoSize, logoImage: logoImage, logoRoundCorner: logoRoundCorner)
    }
    
    /// 调整二维码清晰度，添加水印图片
    /// - Parameters:
    ///   - image: 模糊的二维码图片
    ///   - size: 二维码的宽高
    ///   - logoSize: logo的大小
    ///   - logoImage: logo图片
    /// - Returns: 添加 logo 图片后，清晰的二维码图片
    private static func getHDImgWithCIImage(with image: CIImage, size: CGSize, isLogo: Bool = true, logoSize: CGSize?, logoImage: UIImage? = nil, logoRoundCorner: CGFloat? = nil) -> UIImage? {
        let extent = image.extent.integral
        let scale = min(size.width / extent.width, size.height / extent.height)
        //1.创建bitmap
        let width = extent.width * scale
        let height = extent.height * scale
        
        // 创建基于GPU的CIContext对象,性能和效果更好
        let context = CIContext(options: nil)
        // 创建CoreGraphics image
        guard let bitmapImage = context.createCGImage(image, from: extent) else { return nil }
        
        // 创建一个DeviceGray颜色空间
        let cs = CGColorSpaceCreateDeviceGray()
        // CGBitmapContextCreate(void * _Nullable data, size_t width, size_t height, size_t bitsPerComponent, size_t bytesPerRow, CGColorSpaceRef  _Nullable space, uint32_t bitmapInfo)
        // width：图片宽度像素
        // height：图片高度像素
        // bitsPerComponent：每个颜色的比特值，例如在rgba-32模式下为8
        // bitmapInfo：指定的位图应该包含一个alpha通道
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: CGImageAlphaInfo.none.rawValue) //图形上下文，画布
        bitmapRef?.interpolationQuality = CGInterpolationQuality.none //写入质量
        bitmapRef?.scaleBy(x: scale, y: scale) //调整“画布”的缩放
        bitmapRef?.draw(bitmapImage, in: extent) //绘制图片
        
        //2.保存bitmap到图片
        guard let scaledImage = bitmapRef?.makeImage() else { return nil }
        
        // 清晰的二维码图片
        let outputImage = UIImage(cgImage: scaledImage)
        
        guard isLogo == true, let logoSize = logoSize, let logoImage = logoImage else {
            return outputImage
        }
        
        var newLogo: UIImage = logoImage
        if let newLogoRoundCorner = logoRoundCorner, let roundCornerLogo = logoImage.gt.isRoundCorner(radius: newLogoRoundCorner, byRoundingCorners: .allCorners, imageSize: logoSize) {
            newLogo = roundCornerLogo
        }
        // 防止size：(0, 0)崩溃
        var drawSize = outputImage.size
        if drawSize.width <= 0 || drawSize.height <= 0 {
            drawSize = CGSize(width: 1, height: 1)
        }
        // 给二维码加 logo 图
        UIGraphicsBeginImageContextWithOptions(drawSize, false, UIScreen.main.scale)
        outputImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        // 把水印图片画到生成的二维码图片上，注意尺寸不要太大（根据上面生成二维码设置的纠错程度设置），否则有可能造成扫不出来
        let waterImgW = logoSize.width
        let waterImgH = logoSize.height
        let waterImgX = (size.width - waterImgW) * 0.5
        let waterImgY = (size.height - waterImgH) * 0.5
        newLogo.draw(in: CGRect(x: waterImgX, y: waterImgY, width: waterImgW, height: waterImgH))
        let newPicture = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newPicture
    }
    
    /// 设置图片的圆角
    /// - Parameters:
    ///   - radius: 圆角大小 (默认:3.0,图片大小)
    ///   - corners: 切圆角的方式
    ///   - imageSize: 图片的大小
    /// - Returns: 剪切后的图片
    func isRoundCorner(radius: CGFloat = 3, byRoundingCorners corners: UIRectCorner = .allCorners, imageSize: CGSize?) -> UIImage? {
        var drawSize = imageSize ?? bas.size
        if drawSize.width <= 0 || drawSize.height <= 0 {
            drawSize = bas.size
        }
        // 防止size：(0, 0)崩溃
        if drawSize.width <= 0 || drawSize.height <= 0 {
            drawSize = CGSize(width: 1, height: 1)
        }
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: drawSize)
        // 开始图形上下文
        UIGraphicsBeginImageContextWithOptions(drawSize, false, UIScreen.main.scale)
        guard let contentRef: CGContext = UIGraphicsGetCurrentContext() else {
            // 关闭上下文
            UIGraphicsEndImageContext()
            return nil
        }
        // 绘制路线
        contentRef.addPath(UIBezierPath(roundedRect: rect,
                                        byRoundingCorners: UIRectCorner.allCorners,
                                        cornerRadii: CGSize(width: radius, height: radius)).cgPath)
        // 裁剪
        contentRef.clip()
        // 将原图片画到图形上下文
        bas.draw(in: rect)
        contentRef.drawPath(using: .fillStroke)
        guard let output = UIGraphicsGetImageFromCurrentImageContext() else {
            // 关闭上下文
            UIGraphicsEndImageContext()
            return nil
        }
        // 关闭上下文
        UIGraphicsEndImageContext()
        return output
    }
    
    
    /// 生成渐变色的图片 ["#B0E0E6", "#00CED1", "#2E8B57"]
    /// - Parameters:
    ///   - hexsString: 十六进制字符数组
    ///   - size: 图片大小
    ///   - locations: locations 数组
    ///   - direction: 渐变的方向
    /// - Returns: 渐变的图片
    static func gradient(_ hexsString: [String], size: CGSize = CGSize(width: 1, height: 1), locations:[CGFloat]? = nil, direction: JKImageGradientDirection = .horizontal) -> UIImage? {
        return gradient(hexsString.map{ UIColor.hexStrToColor($0) }, size: size, locations: locations, direction: direction)
    }
    
    /// 生成渐变色的图片 [UIColor, UIColor, UIColor]
    /// - Parameters:
    ///   - colors: UIColor 数组
    ///   - size: 图片大小
    ///   - locations: locations 数组
    ///   - direction: 渐变的方向
    /// - Returns: 渐变的图片
    static func gradient(_ colors: [UIColor], size: CGSize = CGSize(width: 10, height: 10), locations:[CGFloat]? = nil, direction: JKImageGradientDirection = .horizontal) -> UIImage? {
        return gradient(colors, size: size, radius: 0, locations: locations, direction: direction)
    }
    
    /// 生成带圆角渐变色的图片 [UIColor, UIColor, UIColor]
    /// - Parameters:
    ///   - colors: UIColor 数组
    ///   - size: 图片大小
    ///   - radius: 圆角
    ///   - locations: locations 数组
    ///   - direction: 渐变的方向
    /// - Returns: 带圆角的渐变的图片
    static func gradient(_ colors: [UIColor],
                         size: CGSize = CGSize(width: 10, height: 10),
                         radius: CGFloat,
                         locations:[CGFloat]? = nil,
                         direction: JKImageGradientDirection = .horizontal) -> UIImage? {
        if colors.count == 0 { return nil }
        if colors.count == 1 {
            return image(color: colors[0])
        }
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height), cornerRadius: radius)
        path.addClip()
        context?.addPath(path.cgPath)
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors.map{$0.cgColor} as CFArray, locations: locations?.map { CGFloat($0) }) else { return nil
        }
        let directionPoint = direction.point(size: size)
        context?.drawLinearGradient(gradient, start: directionPoint.0, end: directionPoint.1, options: .drawsBeforeStartLocation)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

public enum JKImageGradientDirection {
    /// 水平从左到右
    case horizontal
    /// 垂直从上到下
    case vertical
    /// 左上到右下
    case leftOblique
    /// 右上到左下
    case rightOblique
    /// 自定义
    case other(CGPoint, CGPoint)
    
    public func point(size: CGSize) -> (CGPoint, CGPoint) {
        switch self {
        case .horizontal:
            return (CGPoint(x: 0, y: 0), CGPoint(x: size.width, y: 0))
        case .vertical:
            return (CGPoint(x: 0, y: 0), CGPoint(x: 0, y: size.height))
        case .leftOblique:
            return (CGPoint(x: 0, y: 0), CGPoint(x: size.width, y: size.height))
        case .rightOblique:
            return (CGPoint(x: size.width, y: 0), CGPoint(x: 0, y: size.height))
        case .other(let stat, let end):
            return (stat, end)
        }
    }
}
