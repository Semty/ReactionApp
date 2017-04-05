// The MIT License (MIT)
// Copyright © 2017 Ivan Vorobei (hello@ivanvorobei.by)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

class SPLabelWithSubLabelView: UIView {
    
    let additionalLabel: UILabel = UILabel()
    let mainLabel: UILabel = UILabel()
    
    var relativeHeightFactor: CGFloat = 0.758
    
    init() {
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.addSubview(self.additionalLabel)
        self.addSubview(self.mainLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.additionalLabel.frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.height * (1 - self.relativeHeightFactor))
        self.mainLabel.frame = CGRect.init(x: 0, y: self.additionalLabel.frame.height, width: self.frame.width, height: self.frame.height * self.relativeHeightFactor)
    }
}

class SPLabelWithSubLabelButton: UIButton {
    
    let additionalLabel: UILabel = UILabel()
    let mainLabel: UILabel = UILabel()
    
    var relativeHeightFactor: CGFloat = 0.758
    
    init() {
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.addSubview(self.additionalLabel)
        self.addSubview(self.mainLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.additionalLabel.frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.height * (1 - self.relativeHeightFactor))
        self.mainLabel.frame = CGRect.init(x: 0, y: self.additionalLabel.frame.height, width: self.frame.width, height: self.frame.height * self.relativeHeightFactor)
    }
}
