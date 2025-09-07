# Advanced Hyprland Power User Tricks

These are features that go **way beyond** what Cosmic offers - things that will revolutionize your workflow once you get used to them.

## 1. Dynamic Window Rules (Game Changer!)

### Smart Application Placement
```nix
# Add to your windowrule section
windowrule = [
  # Development workspace auto-setup
  "workspace 1, ^(alacritty)$ title:^(main)$"     # Main terminal to workspace 1
  "workspace 2, ^(alacritty)$ title:^(build)$"    # Build terminal to workspace 2  
  "workspace 2, ^(code)$"                         # VS Code with build terminal
  
  # Browser intelligence
  "workspace 3, ^(firefox)$ title:.*YouTube.*"    # YouTube to media workspace
  "workspace 2, ^(firefox)$ title:.*GitHub.*"     # GitHub with development
  "workspace 4, ^(firefox)$ title:.*Documentation.*"
  
  # Communication auto-organization
  "workspace 6, ^(discord)$"
  "workspace 6, ^(slack)$"
  "workspace 6, ^(teams)$"
  
  # Floating windows that make sense
  "float, ^(pavucontrol)$"
  "float, ^(Calculator)$"
  "float, title:^(Picture-in-Picture)$"
  
  # Pin important apps to all workspaces
  "pin, ^(keepassxc)$"          # Password manager always available
  "pin, ^(flameshot)$"          # Screenshot tool
];
```

### Context-Aware Window Sizing
```nix
windowrule = [
  # Perfect sizing for different app types
  "size 800 600, ^(pavucontrol)$"
  "size 1200 800, ^(nautilus)$"
  "size 400 300, ^(Calculator)$"
  
  # Maximize certain apps automatically
  "maximize, ^(gimp)$"
  "maximize, ^(blender)$"
  
  # Center floating windows
  "center, floating:1"
];
```

## 2. Advanced Grouping (Better than Cosmic Stacking)

### Automatic Grouping by Purpose
```bash
# Create development group
SUPER + CTRL + D    # Group all development windows
SUPER + CTRL + W    # Group all web browsers  
SUPER + CTRL + C    # Group all communication apps
```

Add these bindings:
```nix
bind = [
  # Smart grouping
  "SUPER CTRL, D, exec, ~/.local/bin/group-dev-windows"
  "SUPER CTRL, W, exec, ~/.local/bin/group-web-windows"
  "SUPER CTRL, C, exec, ~/.local/bin/group-comm-windows"
  
  # Group navigation
  "SUPER, TAB, changegroupactive, f"           # Next in group
  "SUPER SHIFT, TAB, changegroupactive, b"     # Previous in group
  "SUPER ALT, TAB, focusurgentorlast"         # Last focused window
  
  # Advanced group manipulation
  "SUPER CTRL, G, moveoutofgroup"             # Remove from group
  "SUPER CTRL SHIFT, G, moveintogroup, l"     # Add to left group
];
```

Create the helper scripts:
```bash
# ~/.local/bin/group-dev-windows
#!/bin/bash
hyprctl clients -j | jq -r '.[] | select(.class | test("(code|alacritty|vim)"; "i")) | .address' | while read addr; do
    hyprctl dispatch focuswindow address:$addr
    hyprctl dispatch togglegroup
done
```

## 3. Intelligent Scratchpads (Cosmic Has Nothing Like This)

### Multiple Purpose-Built Scratchpads
```nix
bind = [
  # Different scratchpads for different purposes
  "SUPER, grave, togglespecialworkspace, terminal"    # ` for terminal
  "SUPER, F12, togglespecialworkspace, sysmon"        # System monitor
  "SUPER SHIFT, C, togglespecialworkspace, calc"      # Calculator
  "SUPER SHIFT, N, togglespecialworkspace, notes"     # Notes
  "SUPER SHIFT, M, togglespecialworkspace, music"     # Music player
  
  # Move windows to specific scratchpads
  "SUPER SHIFT, grave, movetoworkspace, special:terminal"
  "SUPER CTRL SHIFT, F12, movetoworkspace, special:sysmon"
];

# Auto-populate scratchpads
exec-once = [
  "[workspace special:terminal silent] alacritty --title=ScratchTerminal"
  "[workspace special:sysmon silent] alacritty -e htop"
  "[workspace special:calc silent] gnome-calculator"
  "[workspace special:notes silent] alacritty -e nvim ~/scratch.md"
  "[workspace special:music silent] spotify"
];
```

## 4. Workspace Automation Scripts

### Project Workspace Setup
```bash
# ~/.local/bin/setup-project-workspace
#!/bin/bash
PROJECT_NAME=$1
WORKSPACE=$2

if [ -z "$PROJECT_NAME" ] || [ -z "$WORKSPACE" ]; then
    echo "Usage: setup-project-workspace <project-name> <workspace-num>"
    exit 1
fi

# Switch to the workspace
hyprctl dispatch workspace $WORKSPACE

# Set up development environment
alacritty --working-directory ~/Projects/$PROJECT_NAME --title "main-$PROJECT_NAME" &
sleep 0.5

code ~/Projects/$PROJECT_NAME &
sleep 1

# Group them together
hyprctl dispatch togglegroup

# Open project browser tab
firefox "https://github.com/username/$PROJECT_NAME" &
sleep 1
hyprctl dispatch togglegroup

echo "Project $PROJECT_NAME set up on workspace $WORKSPACE"
```

Bind it:
```nix
bind = [
  "SUPER CTRL, P, exec, ~/.local/bin/rofi-project-setup"
];
```

### Smart Workspace Switching with Context
```bash
# ~/.local/bin/smart-workspace-switch
#!/bin/bash
CURRENT_WS=$(hyprctl activeworkspace -j | jq -r '.id')
TARGET_WS=$1

# If switching to development workspace, auto-setup if empty
if [ "$TARGET_WS" -le 3 ]; then
    WS_WINDOWS=$(hyprctl workspaces -j | jq -r ".[] | select(.id == $TARGET_WS) | .windows")
    if [ "$WS_WINDOWS" -eq 0 ]; then
        # Auto-setup development environment
        hyprctl dispatch workspace $TARGET_WS
        alacritty &
        sleep 0.5
        code &
    else
        hyprctl dispatch workspace $TARGET_WS
    fi
else
    hyprctl dispatch workspace $TARGET_WS
fi
```

## 5. Advanced Tiling Layouts

### Master-Stack Layout for Specific Workspaces
```nix
bind = [
  # Switch to master layout for coding
  "SUPER, K, exec, hyprctl keyword general:layout master"
  
  # Switch back to dwindle for general use  
  "SUPER, D, exec, hyprctl keyword general:layout dwindle"
  
  # Master layout controls
  "SUPER, M, layoutmsg, swapwithmaster"
  "SUPER SHIFT, M, layoutmsg, addmaster"
  "SUPER CTRL, M, layoutmsg, removemaster"
];
```

### Custom Layout Rules per Workspace
```nix
workspace = [
  # Coding workspaces use master layout
  "1, layoutopt:master:always_center_master:true"
  "2, layoutopt:master:always_center_master:true"
  
  # Communication workspaces use dwindle
  "6, layoutopt:dwindle:split_width_multiplier:1.2"
  "7, layoutopt:dwindle:split_width_multiplier:1.2"
];
```

## 6. Conditional Window Management

### Smart Window Positioning Based on Content
```bash
# ~/.local/bin/smart-window-placement
#!/bin/bash
WINDOW_CLASS=$(hyprctl activewindow -j | jq -r '.class')
WINDOW_TITLE=$(hyprctl activewindow -j | jq -r '.title')

case $WINDOW_CLASS in
    "firefox")
        if [[ $WINDOW_TITLE == *"YouTube"* ]]; then
            hyprctl dispatch movetoworkspace 7  # Media workspace
        elif [[ $WINDOW_TITLE == *"GitHub"* ]]; then
            hyprctl dispatch movetoworkspace 2  # Development workspace
        fi
        ;;
    "code")
        hyprctl dispatch movetoworkspace 2
        # Auto-open terminal alongside
        alacritty &
        sleep 0.5
        hyprctl dispatch togglegroup
        ;;
esac
```

## 7. Multi-Monitor Workflow Automation

### Automatic Monitor-Specific App Placement
```nix
windowrule = [
  # Left monitor (development)
  "monitor DP-1, ^(code)$"
  "monitor DP-1, ^(alacritty)$" 
  "monitor DP-1, ^(nautilus)$"
  
  # Right monitor (communication/media)
  "monitor DP-2, ^(discord)$"
  "monitor DP-2, ^(slack)$"
  "monitor DP-2, ^(spotify)$"
];
```

### Smart Monitor Focus
```bash
# ~/.local/bin/smart-monitor-focus
#!/bin/bash
CURRENT_MONITOR=$(hyprctl activeworkspace -j | jq -r '.monitor')
ACTIVE_WINDOW_CLASS=$(hyprctl activewindow -j | jq -r '.class')

# If opening development app, switch to development monitor
case $ACTIVE_WINDOW_CLASS in
    "code"|"alacritty"|"vim")
        if [ "$CURRENT_MONITOR" != "DP-1" ]; then
            hyprctl dispatch focusmonitor DP-1
        fi
        ;;
    "discord"|"slack"|"spotify")
        if [ "$CURRENT_MONITOR" != "DP-2" ]; then
            hyprctl dispatch focusmonitor DP-2  
        fi
        ;;
esac
```

## 8. Advanced Rofi Integration

### Context-Aware App Launcher
```bash
# ~/.local/bin/rofi-smart-launcher
#!/bin/bash
CURRENT_WS=$(hyprctl activeworkspace -j | jq -r '.id')

if [ "$CURRENT_WS" -le 3 ]; then
    # Development workspace - show dev apps first
    rofi -show drun -filter "code terminal vim git" -show-icons
elif [ "$CURRENT_WS" -ge 6 ] && [ "$CURRENT_WS" -le 8 ]; then
    # Communication workspace - show communication apps
    rofi -show drun -filter "discord slack teams firefox" -show-icons
else
    # General launcher
    rofi -show drun -show-icons
fi
```

### Workspace-Aware Window Switcher
```bash
# ~/.local/bin/rofi-smart-window-switcher
#!/bin/bash
CURRENT_WS=$(hyprctl activeworkspace -j | jq -r '.id')

# Show only windows from current workspace by default
# But allow showing all with a modifier
if [ "$1" = "all" ]; then
    rofi -show window
else
    hyprctl clients -j | jq -r ".[] | select(.workspace.id == $CURRENT_WS) | \"\(.title) - \(.class)\"" | rofi -dmenu -p "Window"
fi
```

## 9. Performance Optimizations for Power Users

### Adaptive Performance Based on Usage
```bash
# ~/.local/bin/adaptive-performance
#!/bin/bash
ACTIVE_WINDOWS=$(hyprctl clients -j | jq '. | length')

if [ "$ACTIVE_WINDOWS" -gt 10 ]; then
    # Reduce effects when many windows are open
    hyprctl keyword decoration:blur:enabled false
    hyprctl keyword animations:enabled false
    hyprctl keyword decoration:drop_shadow false
    notify-send "Performance mode enabled"
else
    # Full effects when few windows
    hyprctl keyword decoration:blur:enabled true
    hyprctl keyword animations:enabled true
    hyprctl keyword decoration:drop_shadow true
fi
```

### Monitor-Specific Performance
```nix
# Optimize per monitor
monitor = [
  "DP-1,2560x1440@144,0x0,1"      # High refresh rate for primary
  "DP-2,1920x1080@60,2560x0,1.2"  # Lower refresh, higher scale for secondary
];
```

## 10. Integration with External Tools

### Automatic Project Detection
```bash
# ~/.local/bin/detect-project-workspace
#!/bin/bash
# Automatically detect what project you're working on and set up workspace

if [ -f "package.json" ]; then
    PROJECT_TYPE="node"
elif [ -f "Cargo.toml" ]; then
    PROJECT_TYPE="rust"  
elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
    PROJECT_TYPE="python"
elif [ -f "flake.nix" ]; then
    PROJECT_TYPE="nix"
fi

case $PROJECT_TYPE in
    "node")
        code . &
        alacritty -e npm run dev &
        ;;
    "rust")
        code . &
        alacritty -e cargo watch -x run &
        ;;
    "python")
        code . &
        alacritty -e python -m venv venv && source venv/bin/activate &
        ;;
esac
```

These advanced features make Hyprland incredibly powerful for users who heavily utilize tiling, workspaces, and multi-monitor setups. Once you start using these patterns, you'll never want to go back to a simpler window manager!
