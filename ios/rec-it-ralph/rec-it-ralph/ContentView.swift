import MapKit
import SlideOverCard
import SwiftUI
import WebKit
import Turbolinks

struct ContentView : View {
    @State private var position = CardPosition.middle
    @State private var background = BackgroundStyle.solid
    @EnvironmentObject var bridgeController : BridgeController
    
    var body: some View {
        ZStack(alignment: Alignment.top) {
            MapView()
            SlideOverCard($position, backgroundStyle: $background) {
                VStack {
                    TurbolinksView()
                    Spacer()
                }
            }
        }
        .edgesIgnoringSafeArea(.vertical)
    }
}

struct TurbolinksView : UIViewControllerRepresentable {
    @EnvironmentObject var bridgeController : BridgeController
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let viewController = UINavigationController()
        self.bridgeController.navigationController = viewController
        
        if let url = URL(string: "http://localhost:3000") {
            self.bridgeController.visit(url, withSession: nil, animated: false)
        }
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        
    }
}

struct MapView : UIViewRepresentable {
    @EnvironmentObject var bridgeController : BridgeController
    
    func makeUIView(context: Context) -> MKMapView {
        let view = MKMapView(frame: .zero)
        view.delegate = bridgeController
        bridgeController.mapView = view
        
        return view
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        return ContentView()
    }
}
