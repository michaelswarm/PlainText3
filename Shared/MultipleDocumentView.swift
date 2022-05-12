//
//  MultipleDocumentView.swift
//  PlainText
//
//  Created by Michael Swarm on 06/03/22.
//

//  NOT USED.

import SwiftUI

struct MultipleDocumentView: View {
    @ObservedObject var main: MainModel
    //@EnvironmentObject var main: MainModel

    var body: some View {
        VStack {
            // Text("Active Document: \(main.active != nil ? main.active! : "Nil")")
            if main.key != nil {
                Text("Key Document: \(main.key!)")
            }
            HStack {
                Text("Multiple Documents (\(main.array.count)): ")
                ForEach(main.array, id: \.self) { uuidString in
                    Text(uuidString)

                }
            }
            .lineLimit(1)
        }
    }
}

/*struct MultipleDocumentView_Previews: PreviewProvider {
    static var previews: some View {
        MultipleDocumentView()
    }
}*/
