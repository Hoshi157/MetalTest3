//
//  ViewController.swift
//  MetalTest3
//
//  Created by 福山帆士 on 2020/07/24.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import MetalKit

class ViewController: UIViewController {
    
    private let device = MTLCreateSystemDefaultDevice()!
    
    private var commandQuere: MTLCommandQueue!
    
    private var texture: MTLTexture!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mtlView = MTKView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), device: device)
        view.addSubview(mtlView)
        
        mtlView.delegate = self
        
        commandQuere = device.makeCommandQueue()!
        
        let textureLoader = MTKTextureLoader(device: device)
        
        texture = try! textureLoader.newTexture(
            name: "red",
            scaleFactor: view.contentScaleFactor,
            bundle: nil)
        
        mtlView.colorPixelFormat = texture.pixelFormat
        
        mtlView.enableSetNeedsDisplay = true
        mtlView.framebufferOnly = false
        
        mtlView.setNeedsLayout()
        
        // Do any additional setup after loading the view.
        
        
    }


}

extension ViewController: MTKViewDelegate {
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }
    
    func draw(in view: MTKView) {
        
        guard let drawable = view.currentDrawable else {
            fatalError()
        }
        
        let commancBuffer = commandQuere.makeCommandBuffer()!
        
        let blitEncoder = commancBuffer.makeBlitCommandEncoder()!
        
        let w = min(texture.width, drawable.texture.width)
        
        let h = min(texture.height, drawable.texture.height)
        
        blitEncoder.copy(
            from: texture,
            sourceSlice: 0,
            sourceLevel: 0,
            sourceOrigin: MTLOriginMake(0, 0, 0),
            sourceSize: MTLSizeMake(w, h, texture.depth),
            to: drawable.texture,
            destinationSlice: 0,
            destinationLevel: 0,
            destinationOrigin: MTLOriginMake(0, 0, 0))
        
        blitEncoder.endEncoding()
        
        
        commancBuffer.present(drawable)
        
        commancBuffer.commit()
        
        commancBuffer.waitUntilCompleted()
        
        print(w, "width", h, "hight", texture.depth, "depth")
    }
    
    
}

