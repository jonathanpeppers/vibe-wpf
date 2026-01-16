---
name: tree
description: Get the visual tree structure of the running WPF application. Use this skill when asked to inspect, debug, or understand the element hierarchy, control structure, or layout of the WPF UI.
---

# Vibe Visual Tree Skill

This skill retrieves the complete WPF visual tree as JSON, showing all UI elements, their types, names, and hierarchy.

## When to Use

Use this skill when:
- Inspecting the structure of the WPF UI
- Finding element names for automation or testing
- Debugging layout or control hierarchy issues
- Understanding how controls are nested
- Verifying that elements exist in the visual tree

## Prerequisites

The WPF application must be running with the VibeServer extension. Start it with:
```powershell
cd MyWpfApp
dotnet watch run
```

## Usage

Run the script from the repository root:
```powershell
.\.github\skills\vibe-tree\get-tree.ps1
```

## Output

Returns a JSON representation of the visual tree with:
- Element type (e.g., `Button`, `TextBlock`, `Grid`)
- Element name (x:Name attribute)
- Child elements (nested hierarchy)

Example output:
```json
{
  "Type": "MainWindow",
  "Name": "mainWindow",
  "Children": [
    {
      "Type": "Grid",
      "Name": "rootGrid",
      "Children": [...]
    }
  ]
}
```

## Workflow Integration

Use this skill alongside vibe-screenshot to:
1. Capture a screenshot to see the visual appearance
2. Get the tree to understand the element structure
3. Make targeted XAML changes based on element names
