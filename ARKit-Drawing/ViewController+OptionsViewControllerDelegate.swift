//
//  ViewController+OptionsViewControllerDelegate.swift
//  ARKit-Drawing
//
//  Created by Konstantin Ryabtsev on 03.02.2022.
//

import ARKit

// MARK: - OptionsViewControllerDelegate
extension ViewController: OptionsViewControllerDelegate {
    
    func objectSelected(node: SCNNode) {
        dismiss(animated: true, completion: nil)
        selectedNode = node
    }
    
    func togglePlaneVisualization() {
        dismiss(animated: true)
        
        guard objectMode == .plane else { return }
        arePlanesHidden.toggle()
    }
    
    func undoLastObject() {
        if let lastObject = objectsPlaced.last {
            lastObject.removeFromParentNode()
            objectsPlaced.removeLast()
        } else {
            dismiss(animated: true)
        }
    }
    
    func resetScene() {
        reloadConfiguration(reset: true)
        dismiss(animated: true)
    }
}
