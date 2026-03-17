//
//  ShareImageView.swift
//  RoomPlanPDP
//
//  Created by Baidetskyi Yurii on 27.01.2025.
//

import SwiftUI

struct ShareImageView: View {
    @Binding private var shouldShareImage: Bool
    @Binding private var shareFormat: ImageFormat?
    @Binding private var roomOptionType: RoomOptionType?
    
    @State var selectedOption: ImageFormat = .png
    
    init(shouldShareImage: Binding<Bool>,
         shareFormat: Binding<ImageFormat?>,
         roomOptionType: Binding<RoomOptionType?>) {
        _shouldShareImage = shouldShareImage
        _shareFormat = shareFormat
        _roomOptionType = roomOptionType
    }
    
    var body: some View {
        contentView
    }
}

// MARK: Views
private extension ShareImageView {
    var contentView: some View {
        VStack(spacing: 20) {
            header
            
            allFormatButtons
            
            exportButton
            
            Spacer()
        }
        .padding(.all, 20)
        .background(.teal)
    }
    
    var allFormatButtons: some View {
        HStack {
            ForEach(ImageFormat.allCases, id: \.self) { option in
                Button {
                    selectFormat(option)
                } label: {
                    Text(option.descriptionFormat)
                        .foregroundStyle(.black)
                        .font(.caption)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(selectedOption == option ? Color.blue : Color.clear, lineWidth: 4)
                        )
                        .tag(option)
                }
            }
        }
    }
    
    var exportButton: some View {
        Button {
            withAnimation {
                exportImage()
            }
        } label: {
            Text("Export")
                .foregroundStyle(.black)
                .font(.headline)
                .padding()
                .frame(width: 200)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 24))
        }
    }
    
    var header: some View {
        HStack {
            Text("Select file format!")
                .foregroundStyle(.black)
                .font(.title)
            Spacer()
            
            Button {
                withAnimation {
                    closeView()
                }
            } label: {
                Image(systemName: "xmark.square.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(.white)
            }
        }
    }
}

// MARK: Action
private extension ShareImageView {
    func closeView() {
        shareFormat = nil
        shouldShareImage = false
        roomOptionType = nil
    }
    
    func exportImage() {
        shareFormat = selectedOption
        shouldShareImage = false
        roomOptionType = nil
    }
    
    func selectFormat(_ option: ImageFormat) {
        selectedOption = option
    }
}

#Preview {
    ShareImageView(shouldShareImage: .constant(true),
                   shareFormat: .constant(.jpeg),
                   roomOptionType: .constant(nil))
}
