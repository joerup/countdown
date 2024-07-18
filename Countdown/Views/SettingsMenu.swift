//
//  SettingsMenu.swift
//  Countdown
//
//  Created by Joe Rupertus on 10/15/23.
//

import SwiftUI
import CountdownData

struct SettingsMenu: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var premium: Premium
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    @State private var presentShare: Bool = false
    @State private var presentStore: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    if premium.isActive {
                        HStack {
                            Text("Premium")
                            Spacer()
                            Text("Unlocked")
                                .foregroundStyle(.secondary)
                        }
                    } else {
                        Button {
                            self.presentStore.toggle()
                        } label: {
                            row("Premium")
                        }
                        .sheet(isPresented: $presentStore) {
                            PremiumView()
                        }
                    }
                }
//                Section {
//                    Toggle("Notifications", isOn: $clock.notifications)
//                }
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
                        UIApplication.shared.open(URL(string: "https://apps.apple.com/app/id6469441334?action=write-review")!, options: [:], completionHandler: nil)
                    } label: {
                        row("Rate the App")
                    }
                    Button {
                        self.presentShare.toggle()
                    } label: {
                        row("Share the App")
                    }
                    .sheet(isPresented: $presentShare) {
                        ActivityViewController(activityItems: [URL(string: "https://apps.apple.com/us/app/countdown-creator/id6469441334/")!])
                    }
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
