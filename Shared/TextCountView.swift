//
//  TextCountView.swift
//  PlainText3
//
//  Created by Michael Swarm on 08/03/22.
//


//  Use InspectorLayout from DesignElements!
//  May want leading headings and trailing justified items?
//  Generic for right justified?
//  Group used because ViewBuilder >10 components.

import SwiftUI

struct TextCountView: View {
    @Binding var document: PlainText3Document
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text("Word Counts").font(.headline).foregroundColor(.secondary).padding(.horizontal, 4)
                HStack {
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("Word Count: \(document.wordCount)")
                        Text("NL Word Count: \(document.nlpWordCount)")
                    }
                    .font(.caption)
                }
                .padding(.horizontal)
                Divider()
            }
            
            Group {
                Text("Line Counts").font(.headline).foregroundColor(.secondary).padding(.horizontal, 4)
                HStack {
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("Line Count: \(document.lineCount)")
                        Text("NL Line Count: \(document.nlpLineCount)")
                    }
                    .font(.caption)
                }
                .padding(.horizontal)
                Divider()
            }
            
            Group {
                Text("Sentence Counts").font(.headline).foregroundColor(.secondary).padding(.horizontal, 4)
                HStack {
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("NL Sentence Count: \(document.nlpSentenceCount)")
                    }
                    .font(.caption)
                }
                .padding(.horizontal)
                Divider()
            }
            
            Group {
                Text("Section Counts").font(.headline).foregroundColor(.secondary).padding(.horizontal, 4)
                HStack {
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("Section Count: \(document.sectionCount)")
                    }
                    .font(.caption)
                }
                .padding(.horizontal)
                Divider()
            }
            
            Spacer()
        }
    }
}

struct TextCountView_Previews: PreviewProvider {
    static var previews: some View {
        TextCountView(document: .constant(PlainText3Document(text: "Hello World!")))
    }
}
