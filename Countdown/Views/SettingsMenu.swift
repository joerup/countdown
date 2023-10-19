//
//  SettingsMenu.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 10/15/23.
//

import SwiftUI

struct SettingsMenu: View {
    
    @Environment(\.dismiss) var dismiss
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    @State private var presentShare: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Link(destination: URL(string: "https://www.joerup.com/countdown")!) {
                        row("Website")
                    }
                    Link(destination: URL(string: "https://www.joerup.com/countdown/support")!) {
                        row("Support")
                    }
                    Link(destination: URL(string: "https://www.joerup.com/countdown/privacy")!) {
                        row("Privacy Policy")
                    }
                }
                
                Section {
                    Button {
                        UIApplication.shared.open(URL(string: "")!, options: [:], completionHandler: nil)
                    } label: {
                        row("Rate the App")
                    }
                    Button {
                        self.presentShare.toggle()
                    } label: {
                        row("Share the App")
                    }
                    .sheet(isPresented: self.$presentShare, content: {
                        ActivityViewController(activityItems: [URL(string: "")!])
                    })
                }
                
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(appVersion ?? "")
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                            .fontDesign(.rounded)
                            .fontWeight(.semibold)
                    }
                }
            }
        }
        .tint(.pink)
    }
    
    private func row(_ text: String) -> some View {
        NavigationLink(destination: EmptyView()) {
            HStack {
                Text(text)
                Spacer()
            }
        }
    }
}

struct ActivityViewController: UIViewControllerRepresentable {

    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}

}
