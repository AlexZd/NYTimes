//
//  ArticleView.swift
//  NYTimes
//
//  Created by Alex on 19/11/2020.
//

import SwiftUI
import SafariServices

struct ArticleView: View {
    @ObservedObject var viewModel: ArticleViewModel
    @State var showSafari = false

    init(with viewModel: ArticleViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                if !self.viewModel.isPhotoHidden {
                    Image(uiImage: self.viewModel.photo ?? UIImage())
                        .resizable()
                        .aspectRatio(3/2, contentMode: .fill)
                        .background(Color.init(UIColor.systemFill))
                        .cornerRadius(4)
                }
                if let caption = self.viewModel.mediaCaption {
                    Text(caption)
                        .font(/*@START_MENU_TOKEN@*/.caption/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color(UIColor.label))
                }
                HStack {
                    Spacer()
                    Text(self.viewModel.date)
                        .font(/*@START_MENU_TOKEN@*/.caption/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color(UIColor.secondaryLabel))
                        .multilineTextAlignment(.trailing)
                }
                Group {
                    Text(self.viewModel.title)
                        .font(/*@START_MENU_TOKEN@*/.headline/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color(UIColor.label))
                    Text(self.viewModel.subtitle)
                        .font(.subheadline)
                        .foregroundColor(Color(UIColor.secondaryLabel))
                    Text(self.viewModel.text)
                        .font(.body)
                        .foregroundColor(Color(UIColor.label))
                    HStack {
                        Spacer()
                        Button("Read more...") {
                            self.showSafari = true
                        }
                        .sheet(isPresented: $showSafari) {
                            SafariView(url: self.viewModel.url)
                        }
                        .padding(8)
                    }

                }
                Group {
                    Text("Keywords")
                        .font(/*@START_MENU_TOKEN@*/.headline/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color(UIColor.label))
                    Text(self.viewModel.keywords)
                        .font(/*@START_MENU_TOKEN@*/.caption/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color(UIColor.label))
                }
            }
            .padding()
        }
    }
}

struct SafariView: UIViewControllerRepresentable {
    typealias UIViewControllerType = SFSafariViewController

    let url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {

    }

}

final class ArticleViewController: UIHostingController<ArticleView> {
    override init(rootView: ArticleView) {
        super.init(rootView: rootView)
        self.title = "Details"
        self.navigationItem.largeTitleDisplayMode = .never
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#if DEBUG

struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        let article = Article.Factory.Mock.mock()
        let viewModel = ArticleViewModel(with: article)
        ArticleView(with: viewModel)
    }
}

#endif
