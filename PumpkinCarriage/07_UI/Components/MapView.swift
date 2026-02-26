






import SwiftUI
import MapKit

struct MapLocation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    let address: String
    
    @State private var position: MapCameraPosition = .automatic
    @State private var foundLocation: MapLocation?

    var body: some View {
        Map(position: $position) {
            if let location = foundLocation {
                Marker(address, coordinate: location.coordinate)
                    .tint(.red)
            }
        }
        .onAppear {
            searchAddress()
        }
        .mapControls {
            MapCompass()
            MapScaleView()
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func searchAddress() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = address
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let item = response?.mapItems.first else {
                print("DEBUG: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            let coordinate = item.placemark.coordinate

            withAnimation(.easeInOut) {
                self.foundLocation = MapLocation(coordinate: coordinate)
                self.position = .region(MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                ))
            }
        }
    }
}

#Preview {
    MapView(address: "Seoul Gangnam-ku Nonhyeon-Dong")
}
