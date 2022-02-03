//
//  ViewController+ARSCNViewDelegate.swift
//  ARKit-Drawing
//
//  Created by Konstantin Ryabtsev on 03.02.2022.
//
import ARKit

// MARK: - ARSCNViewDelegate
extension ViewController: ARSCNViewDelegate {
    func createFloor(with size: CGSize, opacity: CGFloat = 0.25) -> SCNNode {
        let plane = SCNPlane(width: size.width, height: size.height)
        plane.firstMaterial?.diffuse.contents = UIColor.white
        
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x -= .pi / 2
        planeNode.opacity = opacity
        
        return planeNode
    }
    
    func nodeAdded(_ node: SCNNode, for anchor: ARImageAnchor) {
        // Put a plane at the image
        let size = anchor.referenceImage.physicalSize
        let coverNode = createFloor(with: size, opacity: 0.1)
        coverNode.name = "image"
        node.addChildNode(coverNode)
    }
    
    func nodeAdded(_ node: SCNNode, for anchor: ARPlaneAnchor) {
        let extent = anchor.extent
        let size = CGSize(width: CGFloat(extent.x), height: CGFloat(extent.z))
        let planeNode = createFloor(with: size)
        planeNode.isHidden = arePlanesHidden
        
        // Add plane to the plane node list
        planeNodes.append(planeNode)
        
        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        switch anchor {
        case let imageAnchor as ARImageAnchor:
            nodeAdded(node, for: imageAnchor)
        case let planeAnchor as ARPlaneAnchor:
            nodeAdded(node, for: planeAnchor)
        default:
            print(#line, #function, "Unknown anchor type \(anchor) is found")
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        switch anchor {
        case is ARImageAnchor:
            break
        case let planeAnchor as ARPlaneAnchor:
            updateFloor(for: node, anchor: planeAnchor)
        default:
            print(#line, #function, "Unknown anchor type \(anchor) is updated")
        }
    }
    
    func updateFloor(for node: SCNNode, anchor: ARPlaneAnchor) {
        guard let planeNode = node.childNodes.first, let plane = planeNode.geometry as? SCNPlane else { return }
        
        // Get estimated plane size
        let extent = anchor.extent
        plane.width = CGFloat(extent.x)
        plane.height = CGFloat(extent.z)
        
        // Position the plane node in the center
        planeNode.simdPosition = anchor.center
    }
}
