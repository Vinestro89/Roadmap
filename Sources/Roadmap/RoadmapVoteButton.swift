//
//  RoadmapVoteButton.swift
//  
//
//  Created by Hidde van der Ploeg on 20/02/2023.
//

import SwiftUI


struct RoadmapVoteButton : View {
    @ObservedObject var viewModel : RoadmapFeatureViewModel
    
    @State private var isHovering = false
    @State private var showNumber = false
    @State private var hasVoted = false
    
    var body: some View {
        Button {
            if !viewModel.feature.hasVoted {
                    viewModel.vote()
                #if os(iOS)
                let haptic = UIImpactFeedbackGenerator(style: .soft)
                haptic.impactOccurred()
                #endif
            }
        } label: {
            ZStack {
                viewModel.configuration.tintColor
                    .opacity(hasVoted ? 1 : 0.1)
                    .clipShape(RoundedRectangle(cornerRadius: viewModel.configuration.style.radius, style: .continuous))
                
                VStack(spacing: isHovering ? 2 : 0) {
                    viewModel.configuration.style.upvoteIcon
                        .frame(maxWidth: 24, maxHeight: 24)
                        .foregroundColor(hasVoted ? viewModel.configuration.style.selectedForegroundColor : viewModel.configuration.tintColor)
                        .imageScale(.large)
                        .font(viewModel.configuration.style.numberFont)
                    
                    if showNumber {
                        Text("\(viewModel.voteCount)")
                            .lineLimit(1)
                            .foregroundColor(hasVoted ? viewModel.configuration.style.selectedForegroundColor : viewModel.configuration.tintColor)
                            .minimumScaleFactor(0.5)
                            .font(viewModel.configuration.style.numberFont)
                    }
                }
            }
            .contentShape(RoundedRectangle(cornerRadius: viewModel.configuration.style.radius, style: .continuous))
            .frame(width: 56, height: 64)
            .overlay(overlayBorder)
        }
        .buttonStyle(.plain)
        .onChange(of: viewModel.voteCount) { newCount in
            if newCount > 0 {
                withAnimation(.spring(response: 0.45, dampingFraction: 0.4, blendDuration: 0)) {
                    showNumber = true
                }
            }
        }
        .onChange(of: viewModel.feature.hasVoted) { newVote in
            withAnimation(.spring(response: 0.45, dampingFraction: 0.4, blendDuration: 0)) {
                hasVoted = newVote
            }
        }
        .onHover { newHover in
            if !hasVoted {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7, blendDuration: 0)) {
                    isHovering = newHover
                }
            }
        }
        .onAppear {
            showNumber = viewModel.voteCount > 0
            withAnimation(.spring(response: 0.45, dampingFraction: 0.4, blendDuration: 0)) {
                hasVoted = viewModel.feature.hasVoted
            }
        }
        .accessibilityHint(Text("Vote for \(viewModel.feature.title)"))
        .help("Vote for \(viewModel.feature.title)")
        .animateAccessible()
    }
    
    
    @ViewBuilder
    var overlayBorder : some View {
        if isHovering {
            RoundedRectangle(cornerRadius: viewModel.configuration.style.radius, style: .continuous)
                .stroke(viewModel.configuration.tintColor, lineWidth: 1)
        }
    }
    
    
}
