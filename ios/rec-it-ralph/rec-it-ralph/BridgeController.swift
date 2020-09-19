import MapKit
import Turbolinks
import WebKit

class Location : NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let url: URL?
    
    init?(feature: MKGeoJSONFeature) {
        guard
            let point = feature.geometry.first as? MKPointAnnotation,
            let propertiesData = feature.properties,
            let json = try? JSONSerialization.jsonObject(with: propertiesData),
            let properties = json as? [String: Any]
        else {
          return nil
        }
        
        if let urlString = properties["url"] as? String {
            url = URL(string: urlString)
        } else {
            url = nil
        }
        
        coordinate = point.coordinate
        super.init()
    }
}

class BridgeController : NSObject, ObservableObject, SessionDelegate, WKScriptMessageHandler, MKMapViewDelegate {
    var mapView : MKMapView?
    var navigationController : UINavigationController?
    var turbolinksSession : Session?
    
    func session(_ session: Session, didFailRequestForVisitable visitable: Visitable, withError error: NSError) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        navigationController!.present(alert, animated: true, completion: nil)
    }
    
    func session(_ session: Session, didProposeVisitToURL URL: URL, withAction action: Action) {
          switch action {
          case .Replace:
            visit(URL, withSession: session, animated: false)
          default:
            visit(URL, withSession: session, animated: true)
          }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard
            let json = message.body as? String
        else { return }
        
        do {
            let data = json.data(using: .utf8)
            let geoJson = try MKGeoJSONDecoder().decode(data!)
            let features = geoJson.compactMap { $0 as? MKGeoJSONFeature }
            let annotations = features.compactMap(Location.init)
        
            if let map = mapView {
                let previousAnnotations = map.annotations
                if let center = annotations[0] as Location? {
                    map.setCenter(center.coordinate, animated: true)
                }
                
                map.showAnnotations(annotations, animated: true)
                map.removeAnnotations(previousAnnotations)
            }
        } catch {
            
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard
            let location = view.annotation as! Location?,
            let url = location.url
        else { return }
        
        visit(url, withSession: nil, animated: true)
    }
    
    func visit(_ URL: URL, withSession session: Session?, animated: Bool) {
        let visitable = VisitableViewController(url: URL)
        navigationController!.pushViewController(visitable, animated: animated)
        
        if ((session) == nil) {
            turbolinksSession!.visit(visitable)
        } else {
            session!.visit(visitable)
        }
    }
}

