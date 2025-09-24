//
//  splash_screen.swift
//  ADG2025
//
//  Created by Rachit Tibrewal on 24/09/25.
//

import SwiftUI

struct GetStartedView: View {
    @State private var isBottomSheetVisible = false
    @State private var isContentVisible = false
    @State private var phoneRotation: Double = -15
    @State private var phoneScale: CGFloat = 0.8
    @State private var phoneOpacity: Double = 0
    @State private var dealsRotation: Double = 0
    @State private var dealsScale: CGFloat = 1.0
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.lightBlue, Color.deepBlue]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    // Roamio text above the 3D model
                    Text("Roamio")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
                        .padding(.bottom, 30)
                    
                    // 3D Phone model with deals image as screen content - Centered
                    ZStack {
                        // Phone frame - Black layout
                        RoundedRectangle(cornerRadius: 25)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [.black, .black.opacity(0.9)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 200, height: 400)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(LinearGradient(
                                        gradient: Gradient(colors: [.gray.opacity(0.6), .gray.opacity(0.3)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ), lineWidth: 2)
                            )
                            .shadow(color: .black.opacity(0.7), radius: 15, x: 8, y: 8)
                            .shadow(color: .white.opacity(0.1), radius: 5, x: -2, y: -2)
                        
                        // Screen content - Using the deals image as iPhone screen
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.black)
                            .frame(width: 180, height: 380)
                            .overlay(
                                Image("DEAL")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 180, height: 380)
                                    .clipShape(RoundedRectangle(cornerRadius: 18))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                            )
                        
                        // Notch - Black to blend with frame
                        RoundedRectangle(cornerRadius: 9)
                            .fill(Color.black)
                            .frame(width: 63, height: 20)
                            .offset(y: -174)
                            .overlay(
                                RoundedRectangle(cornerRadius: 9)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                        
                        // Home indicator - Subtle white
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.white.opacity(0.4))
                            .frame(width: 45, height: 3)
                            .offset(y: 185)
                        
                        // Side buttons - Black theme
                        VStack(spacing: 40) {
                            // Volume buttons
                            RoundedRectangle(cornerRadius: 1)
                                .fill(Color.black)
                                .frame(width: 3, height: 30)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 1)
                                        .stroke(Color.gray.opacity(0.4), lineWidth: 0.5)
                                )
                            
                            RoundedRectangle(cornerRadius: 1)
                                .fill(Color.black)
                                .frame(width: 3, height: 30)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 1)
                                        .stroke(Color.gray.opacity(0.4), lineWidth: 0.5)
                                )
                        }
                        .offset(x: 104)
                        
                        // Power button
                        RoundedRectangle(cornerRadius: 1)
                            .fill(Color.black)
                            .frame(width: 3, height: 50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 1)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 0.5)
                            )
                            .offset(x: -104, y: -40)
                    }
                    .rotation3DEffect(
                        .degrees(phoneRotation),
                        axis: (x: 0, y: 1, z: 0),
                        perspective: 2
                    )
                    .scaleEffect(phoneScale)
                    .opacity(phoneOpacity)
                    
                    Spacer()
                    
                    // Bottom sheet positioned below the iPhone
                    if isBottomSheetVisible {
                        bottomSheetContent
                            .transition(.asymmetric(
                                insertion: .move(edge: .bottom).combined(with: .opacity),
                                removal: .move(edge: .bottom).combined(with: .opacity)
                            ))
                    }
                }
            }
            
            .toolbarBackground(Color.black.opacity(0.9), for: .navigationBar)
            .onAppear {
                // Staggered animations for smoother effect
                withAnimation(.easeOut(duration: 0.8)) {
                    phoneOpacity = 1
                    phoneScale = 1
                }
                
                // 3D rotation animation
                withAnimation(.easeInOut(duration: 3).delay(0.5)) {
                    phoneRotation = 15
                }
                
                // Continuous subtle rotation
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                        phoneRotation = -15
                    }
                }
                
                // Bottom sheet animation with slight delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                        isBottomSheetVisible = true
                    }
                }
                
                // Delayed content fade-in for better polish
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    withAnimation(.easeInOut(duration: 0.6).delay(0.1)) {
                        isContentVisible = true
                    }
                }
            }
        }
    }
    
    private var bottomSheetContent: some View {
        VStack(spacing: 30) {
            if isContentVisible {
                VStack(spacing: 25) {
                    Text("Discover. Book. Travel.")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Your Ultimate Travel Companion")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 10)
                    
                    NavigationLink(destination: HomeView()) {
                        Text("Get Started")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.deepBlue)
                            .frame(maxWidth: .infinity, minHeight: 56)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                    }
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .scale(scale: 0.9)).combined(with: .offset(y: 20)),
                        removal: .opacity
                    ))
                }
            }
        }
        .padding(.horizontal, 32)
        .padding(.top, 30)
        .padding(.bottom, 40)
        .frame(maxWidth: .infinity)
        .background(Color.violet)
        .clipShape(
            UnevenRoundedRectangle(
                cornerRadii: RectangleCornerRadii(
                    topLeading: 25,
                    topTrailing: 25
                )
            )
        )
        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: -5)
    }
}

// Placeholder HomeView
struct GetStartedHomeView: View {
    var body: some View {
        ZStack {
            Color.deepBlue.ignoresSafeArea()
            
            
        }
    }
}

#Preview {
    GetStartedView()
}
