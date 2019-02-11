//
//  ScrollableSlider.swift
//
//  Created by Nate Thompson on 10/24/17.
//  Modified by Arc676/Alessandro Vinciguerra 02/11/19.
//


class ScrollableSlider: NSSlider {
    override func scrollWheel(with event: NSEvent) {
        guard self.isEnabled else { return }
        
        let range = Float(self.maxValue - self.minValue)
        var delta = Float(0)
        
        //Allow horizontal scrolling on horizontal and circular sliders
        var vertical = false
        if #available(OSX 10.12, *) {
            vertical = self.isVertical
        }
        if vertical && self.sliderType == .linear {
            delta = Float(event.deltaY)
        } else if self.userInterfaceLayoutDirection == .rightToLeft {
            delta = Float(event.deltaY + event.deltaX)
        } else {
            delta = Float(event.deltaY - event.deltaX)
        }
        
        //Account for natural scrolling
        if event.isDirectionInvertedFromDevice {
            delta *= -1
        }
        
        let increment = range * delta / 100
        var value = self.floatValue + increment
        
        //Wrap around if slider is circular
        if self.sliderType == .circular {
            let minValue = Float(self.minValue)
            let maxValue = Float(self.maxValue)
            
            if value < minValue {
                value = maxValue - fabs(increment)
            }
            if value > maxValue {
                value = minValue + fabs(increment)
            }
        }
        
        self.floatValue = value
        self.sendAction(self.action, to: self.target)
    }
}
