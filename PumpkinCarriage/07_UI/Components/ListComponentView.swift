






import SwiftUI

struct ListComponentView: View {
        
    var vendorSummaries: [VendorSummary]
    var category: VendorCategory = .all
    @Environment(\.repositories) private var repos


    //MARK: - Rating (MVP2)
    //    func getRating(vendor: Vendor) -> some View {
    //        HStack(spacing: 3) {
    //            Spacer()
    //            Image(systemName: "star.fill")
    //                .captionTextStyle()
    //            HStack (spacing: 3){
    //                Text("\(vendor.rating, specifier: "%.1f") / 5")
    //                    .secondaryTextStyle()
    //                Text("(\(vendor.reviewCount))")
    //                    .captionTextStyle().opacity(0.8)
    //            }
    //        }
    //
    //    }
    
    func getMarks(_ vendor: VendorSummary) -> some View {
        HStack(spacing: 3) {
            Spacer()
            Text(String(vendor.markCount))
                .secondaryTextStyle()
            Image(systemName: "bookmark.fill")
                .secondaryTextStyle()
        }
    }

    var body: some View {
        ForEach(vendorSummaries) { vendor in
            NavigationLink {
                VendorDetailView(vendorSummary: vendor)
            } label: {
                if category == .all || vendor.category == category {
                    VStack {
                        HStack (alignment: .top) {
                            if let thumbnail = vendor.thumbnail {
                                ImageResourceView(
                                    storagePath: thumbnail.storagePath,
                                    repository: repos.imageResolve,
                                    contentMode: .fill,
                                    cornerRadius: 8,
                                    placeholderHeight: 80
                                )
                                .frame(width: 80, height: 80)
                                .clipped()
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                                .padding(.trailing, 10)
                            } else {
                                ImagePlaceholderView(
                                    height: 80,
                                    cornerRadius: 8
                                )
                                .frame(width: 80, height: 80)
                                .padding(.trailing, 10)
                            }
                            VStack (alignment: .leading) {
                                Text(vendor.name)
                                    .primaryTextStyle()
                                Text("\(vendor.locationCountry.displayName), \(vendor.locationCity.displayName), \(vendor.locationDistrict)")
                                    .logoTextStyle()
                                Spacer()
                                
                                getMarks(vendor)
                            }
                        }
                        Divider()
                            //.padding(.leading, 90)
                    }
                }
            }
        }
        .foregroundStyle(.main)
        
    }
}

#Preview {
    ListComponentView(vendorSummaries: VendorMockSeed.makeSummaries())
}



