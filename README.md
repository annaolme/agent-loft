# Agent Loft

A pixel-art macOS app that shows every running Claude Code agent as an animated character in a startup loft.

## What it does

- Detects Claude Code sessions (CLI, Desktop, web) by reading the session files in `~/.claude/projects/`
- Gives each agent its own pixel character at a desk in the loft
- Animates characters by activity: typing while working, idle when done
- Shows subagents as smaller "intern" characters next to their parent's desk
- Click an agent to see what it's working on, its working directory and status
- Shows agent counts per project in the status bar, e.g. "RDP 2 · Video Editing 1"
- Lists running dev servers (bun dev, next dev, …) on the whiteboard

## Tech

- Single-file SwiftUI app
- Pixel art on a 6 px tile grid (140 × 88), drawn with `Canvas` and `TimelineView`
- Native file I/O with `FileHandle` and `FileManager`
- Reads the last 80 KB of each session file and uses its `cwd` for project names
- Refreshes every 5 seconds in the background
- 8 character styles; the room has brick walls, windows with a city skyline, pendant lights, a whiteboard, a coffee station, a couch and plants

## Build

```bash
swiftc -O -o AgentLoft AgentLoft.swift -framework SwiftUI -framework Cocoa -framework AppKit -parse-as-library
./AgentLoft
```

## History

The source was not kept in git while I built it. The first two commits mark real work days (7 and 12 May 2026) using the dates of the built app, my project note and a debug log; the source commit is dated when the file was last saved.
