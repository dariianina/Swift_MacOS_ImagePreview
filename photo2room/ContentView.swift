//
//  ContentView.swift
//  photo2room
//
//  Created by user252334 on 9/16/24.
//

import SwiftUI
import QuickLook
import QuickLookUI
import AppKit

func openPanelURL() -> [URL]? {
   let openPanel = NSOpenPanel()
   openPanel.allowedFileTypes = ["png", "jpg", "jpeg", "tiff"]
   openPanel.allowsMultipleSelection = true
   openPanel.canChooseDirectories = true
   openPanel.canChooseFiles = true
   openPanel.runModal()
   let response = openPanel.runModal()
   return response == .OK ? openPanel.urls : nil
}


func loadImage(with name: URL) -> NSImage {
    return NSImage(byReferencing: name)
}
    

func collectImagesPreview() -> [NSImage] {
    //var imagesPreview : [ImagesPreview] = []
    var imagesPreview : [NSImage] = []
    let openURL = openPanelURL()
    if openURL != nil {
        if openURL?.count != 0 {
            for i in 0...openURL!.count-1 {
                let fileurl = openURL?[i]
                if let fileurl {
                    imagesPreview.append(loadImage(with: fileurl))
                }
            }
        }
    }
    return imagesPreview
}


struct ImagesTable: View{
    var imagesPreview : [NSImage] = []
    var H = 1; var W = 1
    
    init(imagesPreview: [NSImage], H: Int, W: Int){
        self.imagesPreview = imagesPreview
        self.H = H
        self.W = W
    }
    
    var body: some View{
        if self.imagesPreview.count != 0 {
            
            VStack{
                ForEach(0...self.H-1, id: \.self){i in
                    ImageRow(columns: self.W, images: self.imagesPreview).getRow(i: i*self.W)
                }
                
            }
            
        }
    }
    
    struct ImageRow{
        var row: some View = HStack{}
        var columns: Int = 0
        var images: [NSImage] = []
        
        init(columns: Int, images: [NSImage]){
            self.columns = columns
            self.images = images
            
        }
        @ViewBuilder func getRow(i: Int) -> some View{
            HStack{
                if min(i+self.columns, self.images.count-1) >= i {
                    ForEach(i...min(i+self.columns, self.images.count-1), id: \.self){
                        j in Image(nsImage: self.images[j])
                    }
                }
            }
        }
    }
}

struct ContentView: View {
  @State var filenames = []
  @State var showFileChooser = false
  @State var imagesPreview : [NSImage] = []

  var body: some View {
      VStack {
          Button("select images")
          {
              imagesPreview = collectImagesPreview()
          }
          ImagesTable(imagesPreview: imagesPreview, H: 5, W:5)
      }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

#Preview {
    ContentView()
}
