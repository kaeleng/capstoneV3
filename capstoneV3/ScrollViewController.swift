//
//  ScrollViewController.swift
//  capstoneV3
//
//  Created by Kaelen Guthrie on 2/27/19.
//  Copyright © 2019 Kaelen Guthrie. All rights reserved.
//

import UIKit

class ScrollViewController: UIViewController, UIScrollViewDelegate {
    
    //    @IBOutlet weak var scrollView: UIScrollView!
    
    var images = ["1", "2", "3"]
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.currentPageIndicatorTintColor = .darkGray
        pc.pageIndicatorTintColor = .gray
        pc.numberOfPages = images.count
        return pc
        
    }()
    
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height:view.frame.height))
        sv.isPagingEnabled = true
        return sv
    }()
    
    lazy var startButton: UIButton = {
        let sb = UIButton(frame: CGRect(x: view.frame.width/2 - (200/2), y: view.frame.height-110, width: 200, height: 50))
        sb.setTitle("Start Walking", for: .normal)
        sb.addTarget(self, action: #selector(startWalking), for:.touchUpInside)
        sb.backgroundColor = UIColor(displayP3Red: 109.0/255.0, green: 118.0/255.0, blue: 127.0/255.0, alpha: 1.0)
        return sb
    }()
    
    fileprivate func setupView() {
        view.addSubview(scrollView)
        view.addSubview(pageControl)
        delay(8.0, closure: {self.view.addSubview(self.startButton)})
        
        NSLayoutConstraint.activate([
            
            pageControl.leftAnchor.constraint(equalTo:view.leftAnchor),
            pageControl.bottomAnchor.constraint(equalTo:view.bottomAnchor, constant:-150.0),
            pageControl.rightAnchor.constraint(equalTo:view.rightAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 50)
            
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        for index in 0..<images.count {
            frame.origin.x = scrollView.frame.size.width * CGFloat(index)
            frame.size = scrollView.frame.size
            let imageView = UIImageView(frame: frame)
            imageView.image = UIImage(named: images[index])
            self.scrollView.addSubview(imageView)
        }
        scrollView.contentSize = CGSize(width: (scrollView.frame.size.width * CGFloat(images.count)), height: (scrollView.frame.height))
        scrollView.delegate = self
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    @objc func startWalking(sender: UIButton!){
//        let vc = ViewController()
//        self.present(vc, animated: true, completion:nil)
//        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ViewController")
        self.present(controller, animated: true, completion: nil)
    }

}
