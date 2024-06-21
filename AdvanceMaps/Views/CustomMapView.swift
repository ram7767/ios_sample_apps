//
//  CustomMapView.swift
//  AdvanceMaps
//
//  Created by Ram on 18/06/24.
//

import MapKit
import SwiftUI
import CoreLocation

struct CustomMapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    @Binding var tappedCoordinate: CLLocationCoordinate2D?
    var tappedOnMap: () -> Void
    
    class Coordinator: NSObject, MKMapViewDelegate, UIGestureRecognizerDelegate {
        var parent: CustomMapView
        
        init(parent: CustomMapView) {
            self.parent = parent
        }
        
        @objc func handleTap(gestureRecognizer: UITapGestureRecognizer) {
            let location = gestureRecognizer.location(in: gestureRecognizer.view)
            if let mapView = gestureRecognizer.view as? MKMapView {
                let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
                parent.tappedCoordinate = coordinate
                
                let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                let newRegion = MKCoordinateRegion(center: coordinate, span: span)
                
                mapView.setRegion(newRegion, animated: true)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                mapView.removeAnnotations(mapView.annotations)
                mapView.addAnnotation(annotation)
                mapView.view(for: annotation)?.image = UIImage(systemName: "mappin.and.ellipse")
                self.parent.tappedOnMap()
            }
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "TappedLocation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                annotationView?.image = UIImage(systemName: "mappin.and.ellipse")
            } else {
                annotationView?.annotation = annotation
                annotationView?.image = UIImage(systemName: "mappin.and.ellipse")
            }
            
            return annotationView
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(gestureRecognizer:)))
        mapView.addGestureRecognizer(tapGesture)
        
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.setRegion(region, animated: true)
    }
}

extension CLLocationCoordinate2D: Identifiable {
    public var id: String {
        "\(latitude),\(longitude)"
    }
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.location = location.coordinate
        }
    }
}
