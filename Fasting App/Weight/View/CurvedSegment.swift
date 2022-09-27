//
//  CurveAlgorithm.swift
//  RALineChart
//
//  Copyright (c) 2017-2021 RichAppz Limited (https://richappz.com)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import UIKit

public struct CurvedSegment {
    public var controlPoint1: CGPoint
    public var controlPoint2: CGPoint
}

public class CurveAlgorithm {
    
    // ==========================================
    // MARK: Singleton
    // ==========================================
    
    public static let shared = CurveAlgorithm()
    
    // ==========================================
    // MARK: Helpers
    // ==========================================
    
    /**
     Create a curved bezier path that connects all points in the dataset
     */
    public func createCurvedPath(_ dataPoints: [CGPoint]) -> UIBezierPath? {
        let path = UIBezierPath()
        path.move(to: dataPoints[0])
        
        var curveSegments: [CurvedSegment] = []
        curveSegments = controlPointsFrom(points: dataPoints)
        
        for idx in 1..<dataPoints.count {
            path.addCurve(to: dataPoints[idx], controlPoint1: curveSegments[idx-1].controlPoint1, controlPoint2: curveSegments[idx-1].controlPoint2)
        }
        return path
    }
    
    // ==========================================
    // MARK: Private Helpers
    // ==========================================
    
    private func controlPointsFrom(points: [CGPoint]) -> [CurvedSegment] {
        var result: [CurvedSegment] = []
        let delta: CGFloat = 0.3
        
        for idx in 1..<points.count {
            let pointA = points[idx-1]
            let pointB = points[idx]
            let controlPoint1 = CGPoint(x: pointA.x + delta*(pointB.x-pointA.x), y: pointA.y + delta*(pointB.y - pointA.y))
            let controlPoint2 = CGPoint(x: pointB.x - delta*(pointB.x-pointA.x), y: pointB.y - delta*(pointB.y - pointA.y))
            let curvedSegment = CurvedSegment(
                controlPoint1: controlPoint1,
                controlPoint2: controlPoint2
            )
            result.append(curvedSegment)
        }
        
        for idx in 1..<points.count-1 {
            let point2 = result[idx-1].controlPoint2
            let point1 = result[idx].controlPoint1
            let pointA = points[idx]
            let MM = CGPoint(x: 2 * pointA.x - point2.x, y: 2 * pointA.y - point2.y)
            let NN = CGPoint(x: 2 * pointA.x - point1.x, y: 2 * pointA.y - point1.y)
            
            result[idx].controlPoint1 = CGPoint(x: (MM.x + point1.x)/2, y: (MM.y + point1.y)/2)
            result[idx-1].controlPoint2 = CGPoint(x: (NN.x + point2.x)/2, y: (NN.y + point2.y)/2)
        }
        
        return result
    }
    
}
