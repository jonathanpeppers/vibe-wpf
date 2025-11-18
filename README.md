# vibe-wpf

A WPF application demonstrating rapid UI development and iteration using live inspection capabilities. This project showcases a Steam Store mockup interface built with WPF and .NET.

## About

This is a sample project exploring the "vibe code inner loop" - a development workflow that leverages `dotnet watch` and automated screenshots for rapid UI iteration. The application demonstrates how to build rich desktop interfaces with WPF while maintaining fast feedback cycles during development.

The UI design is based on the [Steam Desktop App Redesign](https://dribbble.com/shots/20659983-Steam-Desktop-App-Redesign) by [Juxtopposed](https://dribbble.com/Juxtopposed) on Dribbble.

## Features

- **Live Inspection**: HTTP server exposing UI screenshots and visual tree
- **Hot Reload**: Automatic rebuild and restart on file changes via `dotnet watch`
- **Rapid Iteration**: PowerShell script for automated UI capture and app control
- **Modern WPF UI**: Demonstrates gradients, rounded corners, image brushes, and responsive layouts

## Attribution

### Design

- Original Steam Store Redesign by [Juxtopposed](https://dribbble.com/Juxtopposed)
- Design Source: [Steam Desktop App Redesign on Dribbble](https://dribbble.com/shots/20659983-Steam-Desktop-App-Redesign)

### Trademarks

All game titles, logos, and brand imagery are property of their respective owners. See [Images/README.md](MyWpfApp/Images/README.md) for detailed trademark attributions.

### Technologies

- WPF (Windows Presentation Foundation)
- .NET 10.0
- VibeExtensions (HTTP server for live inspection)
