import SwiftUI
import Cocoa

@main
struct AgentLoftApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            AgentLoftView()
                .frame(minWidth: 860, minHeight: 720)
        }
        .windowStyle(.titleBar)
        .windowToolbarStyle(.unified(showsTitle: false))
        .defaultSize(width: 862, height: 740)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        guard let w = NSApplication.shared.windows.first else { return }
        w.title = ""
        w.titlebarAppearsTransparent = true
        w.backgroundColor = NSColor(red: 0.08, green: 0.06, blue: 0.12, alpha: 1.0)
        w.isMovableByWindowBackground = true
    }
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { true }
}

// MARK: - Models

enum AgentStatus: String { case idle, working, reading, done }

struct LiveAgent: Identifiable {
    let id: String
    let project: String
    var task: String
    var status: AgentStatus
    let charStyle: Int
    var deskIdx: Int
    let isRoutine: Bool
    var arrived: Date
    var cwd: String
    var subagents: [SubAgent]
    var activities: [Activity]
    var entrypoint: String
    var shortId: String
    var terminal: String
}

struct SubAgent: Identifiable {
    let id: String
    var status: AgentStatus
    let charStyle: Int
    var task: String
    var cwd: String
    var activities: [Activity]
}

struct Activity: Identifiable {
    let id = UUID()
    let icon: String
    let label: String
    let detail: String
}

struct CharLook { let hair: Color; let shirt: Color; let isRound: Bool }

let STYLES: [CharLook] = [
    CharLook(hair: Color(red: 0.78, green: 0.35, blue: 0.65), shirt: Color(red: 0.68, green: 0.52, blue: 0.85), isRound: false),
    CharLook(hair: Color(red: 0.30, green: 0.55, blue: 0.82), shirt: Color(red: 0.42, green: 0.68, blue: 0.95), isRound: false),
    CharLook(hair: Color(red: 0.88, green: 0.52, blue: 0.22), shirt: Color(red: 0.95, green: 0.65, blue: 0.32), isRound: false),
    CharLook(hair: Color(red: 0.25, green: 0.62, blue: 0.42), shirt: Color(red: 0.35, green: 0.75, blue: 0.52), isRound: false),
    CharLook(hair: Color(red: 0.82, green: 0.28, blue: 0.32), shirt: Color(red: 0.92, green: 0.42, blue: 0.42), isRound: false),
    CharLook(hair: Color(red: 0.95, green: 0.90, blue: 0.80), shirt: Color(red: 0.95, green: 0.70, blue: 0.70), isRound: true),
    CharLook(hair: Color(red: 0.22, green: 0.22, blue: 0.30), shirt: Color(red: 0.92, green: 0.55, blue: 0.22), isRound: false),
    CharLook(hair: Color(red: 0.28, green: 0.52, blue: 0.75), shirt: Color(red: 0.22, green: 0.85, blue: 0.80), isRound: false),
]

// MARK: - Palette

struct P {
    static let ceil       = Color(red: 0.10, green: 0.08, blue: 0.14)
    static let duct       = Color(red: 0.22, green: 0.20, blue: 0.26)
    static let ductHi     = Color(red: 0.28, green: 0.25, blue: 0.32)
    static let brkA       = Color(red: 0.50, green: 0.25, blue: 0.18)
    static let brkB       = Color(red: 0.60, green: 0.33, blue: 0.23)
    static let brkC       = Color(red: 0.55, green: 0.29, blue: 0.20)
    static let brkD       = Color(red: 0.48, green: 0.23, blue: 0.16)
    static let mortar     = Color(red: 0.36, green: 0.31, blue: 0.26)
    static let wdA        = Color(red: 0.72, green: 0.58, blue: 0.42)
    static let wdB        = Color(red: 0.64, green: 0.50, blue: 0.36)
    static let wdC        = Color(red: 0.78, green: 0.64, blue: 0.46)
    static let wdD        = Color(red: 0.68, green: 0.54, blue: 0.40)
    static let skyHi      = Color(red: 0.28, green: 0.45, blue: 0.72)
    static let skyMd      = Color(red: 0.42, green: 0.62, blue: 0.88)
    static let skyLo      = Color(red: 0.55, green: 0.75, blue: 0.95)
    static let bldg       = Color(red: 0.18, green: 0.20, blue: 0.28)
    static let bldgDk     = Color(red: 0.14, green: 0.16, blue: 0.22)
    static let bldgLit    = Color(red: 0.92, green: 0.85, blue: 0.48)
    static let bldgOff    = Color(red: 0.22, green: 0.24, blue: 0.32)
    static let wf         = Color(red: 0.16, green: 0.14, blue: 0.20)
    static let base       = Color(red: 0.28, green: 0.23, blue: 0.18)
    static let desk       = Color(red: 0.50, green: 0.38, blue: 0.28)
    static let deskT      = Color(red: 0.58, green: 0.45, blue: 0.33)
    static let mon        = Color(red: 0.12, green: 0.12, blue: 0.16)
    static let scrOn      = Color(red: 0.22, green: 0.82, blue: 0.48)
    static let scrOff     = Color(red: 0.22, green: 0.22, blue: 0.28)
    static let plDk       = Color(red: 0.14, green: 0.40, blue: 0.20)
    static let plLt       = Color(red: 0.28, green: 0.62, blue: 0.32)
    static let plMd       = Color(red: 0.20, green: 0.52, blue: 0.25)
    static let potC       = Color(red: 0.65, green: 0.42, blue: 0.26)
    static let chr        = Color(red: 0.24, green: 0.22, blue: 0.28)
    static let chrS       = Color(red: 0.30, green: 0.28, blue: 0.34)
    static let skin       = Color(red: 0.95, green: 0.82, blue: 0.70)
    static let skinSh     = Color(red: 0.88, green: 0.74, blue: 0.62)
    static let rugA       = Color(red: 0.48, green: 0.30, blue: 0.45)
    static let rugB       = Color(red: 0.40, green: 0.24, blue: 0.38)
    static let rugBd      = Color(red: 0.56, green: 0.36, blue: 0.52)
    static let neon       = Color(red: 1.00, green: 0.28, blue: 0.52)
    static let lmpW       = Color(red: 0.24, green: 0.20, blue: 0.28)
    static let lmpS       = Color(red: 0.85, green: 0.75, blue: 0.55)
    static let lmpG       = Color(red: 1.00, green: 0.95, blue: 0.80)
    static let wbFr       = Color(red: 0.62, green: 0.62, blue: 0.66)
    static let wb         = Color(red: 0.92, green: 0.92, blue: 0.95)
    static let couchB     = Color(red: 0.42, green: 0.23, blue: 0.38)
    static let couchS     = Color(red: 0.52, green: 0.30, blue: 0.46)
    static let couchL     = Color(red: 0.36, green: 0.18, blue: 0.32)
    static let door       = Color(red: 0.42, green: 0.30, blue: 0.20)
    static let doorFr     = Color(red: 0.32, green: 0.25, blue: 0.18)
    static let doorKn     = Color(red: 0.85, green: 0.75, blue: 0.50)
    static let cofM       = Color(red: 0.52, green: 0.52, blue: 0.56)
    static let cofD       = Color(red: 0.38, green: 0.20, blue: 0.12)
    static let panel      = Color(red: 0.11, green: 0.09, blue: 0.16)
    static let eye        = Color(white: 0.12)
    static let mouth      = Color(red: 0.85, green: 0.48, blue: 0.48)
}

// MARK: - Grid

let T: CGFloat = 6
let C = 140
let R = 88
let DKCOLS = [10, 40, 70, 100]
let DKCOLS2 = [25, 55, 85, 115]
let DKROW2_Y = 18

func t(_ ctx: inout GraphicsContext, x: Int, y: Int, w: Int = 1, h: Int = 1, c: Color) {
    ctx.fill(Path(CGRect(x: CGFloat(x)*T, y: CGFloat(y)*T, width: CGFloat(w)*T, height: CGFloat(h)*T)), with: .color(c))
}

// MARK: - Room

func drawRoom(_ ctx: inout GraphicsContext, services: [String]) {
    // Ceiling + ductwork
    t(&ctx, x: 0, y: 0, w: C, h: 4, c: P.ceil)
    for dx in stride(from: 5, to: C-5, by: 20) {
        t(&ctx, x: dx, y: 1, w: 15, h: 2, c: P.duct)
        t(&ctx, x: dx+2, y: 1, w: 11, h: 1, c: P.ductHi)
    }

    // Brick wall
    for y in 4..<34 {
        for x in 0..<C {
            let wy = y - 4
            let isH = wy % 4 == 0
            let off = (wy / 4) % 2 == 0 ? 0 : 5
            let isV = (x + off) % 10 == 0
            if isH || isV {
                t(&ctx, x: x, y: y, c: P.mortar)
            } else {
                let h = (x &* 7 &+ y &* 13) % 7
                t(&ctx, x: x, y: y, c: h < 2 ? P.brkA : (h < 4 ? P.brkB : (h < 6 ? P.brkC : P.brkD)))
            }
        }
    }

    // Baseboard
    t(&ctx, x: 0, y: 34, w: C, h: 2, c: P.base)

    // Floor with plank pattern
    for y in 36..<R {
        for x in 0..<C {
            let plank = x / 7
            let grain = (plank * 3 + y) % 4
            let colors = [P.wdA, P.wdB, P.wdC, P.wdD]
            t(&ctx, x: x, y: y, c: colors[grain])
        }
    }

    // 3 Windows with detailed skyline
    let bH = [9, 6, 12, 8, 5, 11, 7, 10, 4, 8, 13, 6, 9, 5, 11, 7, 10, 6]
    for wc in [10, 54, 98] {
        let ww = 23, wh = 20, wy = 8
        t(&ctx, x: wc, y: wy, w: ww, h: wh, c: P.wf)
        t(&ctx, x: wc+1, y: wy+1, w: ww-2, h: wh-2, c: P.skyMd)
        for sy in (wy+1)..<(wy+wh-1) {
            for sx in (wc+1)..<(wc+ww-1) {
                let ry = sy - wy - 1, rx = sx - wc - 1
                let bh = bH[rx % bH.count]
                if ry >= (wh - 2) - bh {
                    let isLit = (ry + rx) % 3 == 0 && rx % 2 == 0
                    t(&ctx, x: sx, y: sy, c: isLit ? P.bldgLit : ((rx % 4 < 2) ? P.bldg : P.bldgDk))
                } else {
                    let skyT = CGFloat(ry) / CGFloat(wh - 2)
                    t(&ctx, x: sx, y: sy, c: skyT < 0.3 ? P.skyHi : (skyT < 0.6 ? P.skyMd : P.skyLo))
                }
            }
        }
        // Cross bars
        t(&ctx, x: wc + ww/2, y: wy+1, w: 1, h: wh-2, c: P.wf)
        t(&ctx, x: wc+1, y: wy + wh/2, w: ww-2, h: 1, c: P.wf)
    }

    // Pendant lights
    for lc in [22, 66, 110] {
        t(&ctx, x: lc, y: 0, w: 1, h: 6, c: P.lmpW)
        t(&ctx, x: lc-2, y: 5, w: 5, h: 2, c: P.lmpS)
        t(&ctx, x: lc-1, y: 6, w: 3, h: 1, c: P.lmpG)
    }

    // Door
    t(&ctx, x: 0, y: 16, w: 6, h: 18, c: P.doorFr)
    t(&ctx, x: 0, y: 17, w: 5, h: 16, c: P.door)
    t(&ctx, x: 4, y: 25, w: 1, h: 1, c: P.doorKn)

    // Whiteboard with running services
    t(&ctx, x: 122, y: 10, w: 16, h: 18, c: P.wbFr)
    t(&ctx, x: 123, y: 11, w: 14, h: 16, c: P.wb)
    // Sticky notes
    t(&ctx, x: 124, y: 12, w: 4, h: 3, c: Color.yellow.opacity(0.8))
    t(&ctx, x: 129, y: 12, w: 4, h: 3, c: Color.pink.opacity(0.8))
    t(&ctx, x: 124, y: 16, w: 4, h: 3, c: Color.mint.opacity(0.8))
    t(&ctx, x: 129, y: 16, w: 4, h: 3, c: Color.orange.opacity(0.8))
    // Service status dots
    for (i, _) in services.prefix(4).enumerated() {
        let sx = 124 + (i % 2) * 5
        let sy = 21 + (i / 2) * 3
        t(&ctx, x: sx, y: sy, w: 1, h: 1, c: P.scrOn)
        t(&ctx, x: sx+1, y: sy, w: 3, h: 1, c: Color(white: 0.5))
    }

    // Plants (detailed)
    drawPlant(&ctx, x: 2, y: 42, tall: true)
    drawPlant(&ctx, x: 133, y: 48, tall: true)
    drawPlant(&ctx, x: 62, y: 44, tall: false)

    // Coffee station
    t(&ctx, x: 124, y: 55, w: 10, h: 2, c: P.deskT)
    t(&ctx, x: 124, y: 57, w: 1, h: 4, c: P.desk)
    t(&ctx, x: 133, y: 57, w: 1, h: 4, c: P.desk)
    t(&ctx, x: 126, y: 50, w: 6, h: 5, c: P.cofM)
    t(&ctx, x: 127, y: 51, w: 4, h: 3, c: P.cofD)
    // Cup
    t(&ctx, x: 125, y: 53, w: 2, h: 2, c: Color.white)
    t(&ctx, x: 125, y: 53, w: 2, h: 1, c: P.cofD)

    // Rug
    t(&ctx, x: 28, y: 70, w: 84, h: 15, c: P.rugA)
    t(&ctx, x: 28, y: 70, w: 84, h: 2, c: P.rugBd)
    t(&ctx, x: 28, y: 83, w: 84, h: 2, c: P.rugBd)
    t(&ctx, x: 28, y: 70, w: 2, h: 15, c: P.rugBd)
    t(&ctx, x: 110, y: 70, w: 2, h: 15, c: P.rugBd)
    for y in 72..<83 { for x in 30..<110 { if (x+y) % 5 == 0 { t(&ctx, x: x, y: y, c: P.rugB) } } }

    // Couch
    t(&ctx, x: 55, y: 73, w: 30, h: 2, c: P.couchB)
    t(&ctx, x: 54, y: 73, w: 2, h: 6, c: P.couchB)
    t(&ctx, x: 84, y: 73, w: 2, h: 6, c: P.couchB)
    t(&ctx, x: 55, y: 75, w: 30, h: 4, c: P.couchS)
    t(&ctx, x: 55, y: 79, w: 1, h: 2, c: P.couchL)
    t(&ctx, x: 84, y: 79, w: 1, h: 2, c: P.couchL)
}

func drawPlant(_ ctx: inout GraphicsContext, x: Int, y: Int, tall: Bool) {
    if tall {
        t(&ctx, x: x+2, y: y, w: 2, h: 6, c: P.plDk)
        t(&ctx, x: x, y: y, w: 2, h: 3, c: P.plLt)
        t(&ctx, x: x+4, y: y, w: 2, h: 3, c: P.plLt)
        t(&ctx, x: x+1, y: y+1, w: 1, h: 2, c: P.plMd)
        t(&ctx, x: x+4, y: y+2, w: 1, h: 2, c: P.plMd)
        t(&ctx, x: x, y: y+3, w: 6, h: 2, c: P.plLt)
        t(&ctx, x: x+5, y: y+1, w: 2, h: 1, c: P.plDk)
        t(&ctx, x: x+1, y: y+6, w: 4, h: 3, c: P.potC)
    } else {
        t(&ctx, x: x+1, y: y, w: 3, h: 3, c: P.plLt)
        t(&ctx, x: x, y: y+1, w: 1, h: 2, c: P.plMd)
        t(&ctx, x: x+4, y: y+1, w: 1, h: 1, c: P.plDk)
        t(&ctx, x: x+1, y: y+3, w: 3, h: 2, c: P.potC)
    }
}

// MARK: - Furniture

func deskPos(_ idx: Int) -> (col: Int, baseY: Int) {
    if idx < DKCOLS.count { return (DKCOLS[idx], 42) }
    let i2 = idx - DKCOLS.count
    if i2 < DKCOLS2.count { return (DKCOLS2[i2], 42) }
    return (10, 42)
}

func drawDesk(_ ctx: inout GraphicsContext, col: Int, baseY: Int, on: Bool) {
    let dy = baseY - 42
    t(&ctx, x: col+5, y: 46+dy, w: 6, h: 2, c: P.chr)
    t(&ctx, x: col+6, y: 54+dy, w: 5, h: 2, c: P.chrS)
    t(&ctx, x: col+6, y: 61+dy, w: 1, h: 3, c: P.chr)
    t(&ctx, x: col+10, y: 61+dy, w: 1, h: 3, c: P.chr)
    t(&ctx, x: col+5, y: 50+dy, w: 7, h: 5, c: P.mon)
    t(&ctx, x: col+6, y: 51+dy, w: 5, h: 3, c: on ? P.scrOn : P.scrOff)
    t(&ctx, x: col+8, y: 55+dy, w: 2, h: 1, c: P.mon)
    t(&ctx, x: col, y: 56+dy, w: 16, h: 2, c: P.deskT)
    t(&ctx, x: col, y: 58+dy, w: 16, h: 2, c: P.desk)
    t(&ctx, x: col, y: 60+dy, w: 2, h: 4, c: P.desk)
    t(&ctx, x: col+14, y: 60+dy, w: 2, h: 4, c: P.desk)
    t(&ctx, x: col+2, y: 55+dy, w: 4, h: 1, c: Color(white: 0.35))
}

// MARK: - Characters (8 wide x 12 tall)

func drawChar(_ ctx: inout GraphicsContext, s: CharLook, col: Int, baseY: Int, frame: Int, working: Bool) {
    let bob = frame % 4 < 2 ? 0 : -1
    let cx = col + 4, cy = baseY + bob

    if s.isRound {
        // Mochi-style (10 wide x 8 tall)
        t(&ctx, x: cx+2, y: cy+2, w: 5, h: 1, c: s.hair)
        t(&ctx, x: cx+1, y: cy+3, w: 7, h: 4, c: s.hair)
        t(&ctx, x: cx+2, y: cy+7, w: 5, h: 1, c: s.hair)
        t(&ctx, x: cx+2, y: cy+4, w: 2, h: 1, c: P.eye)
        t(&ctx, x: cx+5, y: cy+4, w: 2, h: 1, c: P.eye)
        t(&ctx, x: cx+1, y: cy+5, w: 1, h: 2, c: s.shirt)
        t(&ctx, x: cx+7, y: cy+5, w: 1, h: 2, c: s.shirt)
    } else {
        // Humanoid (8 wide x 12 tall)
        // Hair
        t(&ctx, x: cx+2, y: cy, w: 4, h: 1, c: s.hair)
        t(&ctx, x: cx+1, y: cy+1, w: 6, h: 2, c: s.hair)
        // Face
        t(&ctx, x: cx+1, y: cy+3, w: 6, h: 3, c: P.skin)
        t(&ctx, x: cx+1, y: cy+5, w: 6, h: 1, c: P.skinSh)
        // Eyes (2px wide each)
        t(&ctx, x: cx+2, y: cy+3, w: 1, h: 2, c: P.eye)
        t(&ctx, x: cx+5, y: cy+3, w: 1, h: 2, c: P.eye)
        // Eye highlights
        t(&ctx, x: cx+2, y: cy+3, w: 1, h: 1, c: Color(white: 0.25))
        t(&ctx, x: cx+5, y: cy+3, w: 1, h: 1, c: Color(white: 0.25))
        // Mouth
        t(&ctx, x: cx+3, y: cy+5, w: 2, h: 1, c: P.mouth)
        // Neck
        t(&ctx, x: cx+3, y: cy+6, w: 2, h: 1, c: P.skin)
        // Body
        t(&ctx, x: cx+1, y: cy+7, w: 6, h: 4, c: s.shirt)
        // Collar detail
        t(&ctx, x: cx+3, y: cy+7, w: 2, h: 1, c: s.shirt.opacity(0.7))
        // Arms
        if working {
            t(&ctx, x: cx-1, y: cy+8, w: 2, h: 2, c: P.skin)
            t(&ctx, x: cx+7, y: cy+8, w: 2, h: 2, c: P.skin)
        } else {
            t(&ctx, x: cx, y: cy+8, w: 1, h: 3, c: P.skin)
            t(&ctx, x: cx+7, y: cy+8, w: 1, h: 3, c: P.skin)
        }
    }
}

func drawIntern(_ ctx: inout GraphicsContext, s: CharLook, x: Int, baseY: Int, frame: Int, working: Bool) {
    let bob = frame % 4 < 2 ? 0 : -1
    let cy = baseY + 6 + bob
    // Smaller character (5 wide x 7 tall)
    t(&ctx, x: x+1, y: cy, w: 3, h: 1, c: s.hair)
    t(&ctx, x: x, y: cy+1, w: 5, h: 2, c: s.hair)
    t(&ctx, x: x, y: cy+3, w: 5, h: 2, c: P.skin)
    t(&ctx, x: x+1, y: cy+3, w: 1, h: 1, c: P.eye)
    t(&ctx, x: x+3, y: cy+3, w: 1, h: 1, c: P.eye)
    t(&ctx, x: x, y: cy+5, w: 5, h: 3, c: s.shirt)
    if working {
        t(&ctx, x: x-1, y: cy+6, w: 1, h: 1, c: P.skin)
        t(&ctx, x: x+5, y: cy+6, w: 1, h: 1, c: P.skin)
    }
}

func drawMochiOnCouch(_ ctx: inout GraphicsContext, frame: Int, awake: Bool) {
    let body = Color(red: 0.95, green: 0.90, blue: 0.80)
    let cheek = Color(red: 0.95, green: 0.70, blue: 0.70)
    let x = 64, y = 72

    if awake {
        // Sitting up on couch
        t(&ctx, x: x+1, y: y-3, w: 6, h: 1, c: body)
        t(&ctx, x: x, y: y-2, w: 8, h: 4, c: body)
        t(&ctx, x: x+1, y: y+2, w: 6, h: 1, c: body)
        // Eyes open
        t(&ctx, x: x+2, y: y-1, w: 1, h: 1, c: Color(white: 0.15))
        t(&ctx, x: x+5, y: y-1, w: 1, h: 1, c: Color(white: 0.15))
        // Cheeks
        t(&ctx, x: x, y: y, w: 1, h: 1, c: cheek)
        t(&ctx, x: x+7, y: y, w: 1, h: 1, c: cheek)
        // Smile
        t(&ctx, x: x+3, y: y+1, w: 2, h: 1, c: P.mouth)
        // Little sparkle
        let sp = frame % 6 < 3
        if sp { t(&ctx, x: x+9, y: y-4, w: 1, h: 1, c: Color.yellow.opacity(0.6)) }
    } else {
        // Lying down sleeping
        t(&ctx, x: x, y: y, w: 8, h: 3, c: body)
        // Closed eyes
        t(&ctx, x: x+1, y: y, w: 1, h: 1, c: Color(white: 0.35))
        t(&ctx, x: x+3, y: y, w: 1, h: 1, c: Color(white: 0.35))
        t(&ctx, x: x, y: y+1, w: 1, h: 1, c: cheek)
        t(&ctx, x: x+7, y: y+1, w: 1, h: 1, c: cheek)
        // Zzz
        let zy = y - (frame % 4 < 2 ? 1 : 2)
        t(&ctx, x: x+8, y: zy, w: 2, h: 1, c: Color.white.opacity(0.3))
        t(&ctx, x: x+9, y: zy-1, w: 2, h: 1, c: Color.white.opacity(0.2))
    }
}

// MARK: - View

struct AgentLoftView: View {
    @State private var agents: [LiveAgent] = []
    @State private var services: [String] = []
    @State private var selectedId: String? = nil
    @State private var selectedSubId: String? = nil
    @State private var deskMap: [String: Int] = [:]
    @State private var usedDesks: Set<Int> = []
    @State private var scanCount = 0
    @State private var debugInfo = ""
    @State private var mochiAwake = false
    @State private var mochiTask = ""
    @State private var mochiActivities: [Activity] = []
    @State private var mochiSelected = false
    @State private var scanning = false
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topLeading) {
                Color(red: 0.08, green: 0.06, blue: 0.12)

                TimelineView(.periodic(from: .now, by: 0.5)) { tl in
                    let fr = Int(tl.date.timeIntervalSince1970 * 2)
                    Canvas { ctx, _ in
                        drawRoom(&ctx, services: services)
                        let totalDesks = DKCOLS.count + DKCOLS2.count
                        for a in agents where a.deskIdx >= 0 && a.deskIdx < totalDesks {
                            let pos = deskPos(a.deskIdx)
                            drawDesk(&ctx, col: pos.col, baseY: pos.baseY, on: a.status == .working || a.status == .done)
                            drawChar(&ctx, s: STYLES[a.charStyle % STYLES.count], col: pos.col, baseY: pos.baseY, frame: fr, working: a.status == .working)
                            for (i, sub) in a.subagents.enumerated() {
                                let sx = pos.col + 17 + (i * 7)
                                drawIntern(&ctx, s: STYLES[sub.charStyle % STYLES.count], x: sx, baseY: pos.baseY, frame: fr, working: sub.status == .working)
                            }
                        }
                        drawMochiOnCouch(&ctx, frame: fr, awake: mochiAwake)
                        if mochiSelected {
                            ctx.stroke(Path(roundedRect: CGRect(x: 59*T, y: 66*T, width: 18*T, height: 16*T), cornerRadius: 3),
                                       with: .color(P.neon.opacity(0.7)), lineWidth: 2)
                        }
                        if let sid = selectedId, let a = agents.first(where: { $0.id == sid }), a.deskIdx >= 0 && a.deskIdx < totalDesks {
                            let pos = deskPos(a.deskIdx)
                            if let subSid = selectedSubId, let subIdx = a.subagents.firstIndex(where: { $0.id == subSid }) {
                                let sx = pos.col + 17 + (subIdx * 7)
                                ctx.stroke(Path(roundedRect: CGRect(x: CGFloat(sx-1)*T, y: CGFloat(pos.baseY+4)*T, width: 8*T, height: 12*T), cornerRadius: 2),
                                           with: .color(P.neon.opacity(0.7)), lineWidth: 2)
                            } else {
                                ctx.stroke(Path(roundedRect: CGRect(x: CGFloat(pos.col-2)*T, y: CGFloat(pos.baseY-2)*T, width: 20*T, height: 28*T), cornerRadius: 3),
                                           with: .color(P.neon.opacity(0.7)), lineWidth: 2)
                            }
                        }
                    }
                }
                .frame(width: CGFloat(C)*T, height: CGFloat(R)*T)
                .contentShape(Rectangle())
                .onTapGesture { loc in
                    let tx = Int(loc.x / T), ty = Int(loc.y / T)
                    // Mochi on couch (x=64, y=72, roughly 10x8 area)
                    if tx >= 60 && tx <= 76 && ty >= 67 && ty <= 80 {
                        mochiSelected.toggle(); selectedId = nil; selectedSubId = nil; return
                    }
                    let totalDesks = DKCOLS.count + DKCOLS2.count
                    for a in agents where a.deskIdx >= 0 && a.deskIdx < totalDesks {
                        let pos = deskPos(a.deskIdx)
                        for (i, sub) in a.subagents.enumerated() {
                            let sx = pos.col + 17 + (i * 7)
                            if tx >= sx - 1 && tx <= sx + 6 && ty >= pos.baseY && ty <= pos.baseY + 14 {
                                mochiSelected = false; selectedId = a.id; selectedSubId = selectedSubId == sub.id ? nil : sub.id; return
                            }
                        }
                        if tx >= pos.col && tx <= pos.col + 16 && ty >= pos.baseY - 2 && ty <= pos.baseY + 26 {
                            mochiSelected = false; selectedSubId = nil; selectedId = selectedId == a.id ? nil : a.id; return
                        }
                    }
                    mochiSelected = false; selectedId = nil; selectedSubId = nil
                }

                Text("AGENT LOFT")
                    .font(.system(size: 14, weight: .heavy, design: .monospaced))
                    .foregroundColor(P.neon)
                    .shadow(color: P.neon.opacity(0.9), radius: 10)
                    .shadow(color: P.neon.opacity(0.5), radius: 25)
                    .position(x: CGFloat(C)*T/2, y: 2.5*T)

                ForEach(agents.filter { $0.deskIdx >= 0 && $0.deskIdx < DKCOLS.count + DKCOLS2.count }) { a in
                    let pos = deskPos(a.deskIdx)
                    let termPrefix = a.terminal.isEmpty ? "" : "[\(a.terminal)] "
                    let label = a.subagents.isEmpty ? "\(termPrefix)\(a.project)" : "\(termPrefix)\(a.project) +\(a.subagents.count)"
                    Text(label)
                        .font(.system(size: 9, weight: .bold, design: .rounded))
                        .foregroundColor(.white.opacity(0.75))
                        .position(x: CGFloat(pos.col+8)*T, y: CGFloat(pos.baseY-3)*T)
                }

                ForEach(agents.filter { $0.deskIdx >= 0 && $0.deskIdx < DKCOLS.count + DKCOLS2.count }) { a in
                    let pos = deskPos(a.deskIdx)
                    let icon = a.status == .idle ? "💤" : (a.status == .working ? "⚡" : (a.status == .reading ? "📖" : "✅"))
                    Text(icon).font(.system(size: 13))
                        .position(x: CGFloat(pos.col+8)*T, y: CGFloat(pos.baseY-5)*T)
                }

                ForEach(agents.filter { $0.deskIdx >= 0 && $0.deskIdx < DKCOLS.count + DKCOLS2.count }) { a in
                    let pos = deskPos(a.deskIdx)
                    let tag = a.terminal.isEmpty ? a.shortId : "\(a.terminal.prefix(4).lowercased()):\(a.shortId)"
                    Text(tag)
                        .font(.system(size: 7, weight: .medium, design: .monospaced))
                        .foregroundColor(.white.opacity(0.3))
                        .position(x: CGFloat(pos.col+8)*T, y: CGFloat(pos.baseY-1)*T)
                }

                // Mochi label on couch
                Text(mochiAwake ? "🍡 Mochi" : "🍡 zzz")
                    .font(.system(size: 9, weight: .bold, design: .rounded))
                    .foregroundColor(.white.opacity(mochiAwake ? 0.75 : 0.35))
                    .position(x: 68*T, y: 69*T)

                // Services on whiteboard label
                VStack(alignment: .leading, spacing: 1) {
                    ForEach(services.prefix(4), id: \.self) { s in
                        HStack(spacing: 3) {
                            Circle().fill(P.scrOn).frame(width: 4, height: 4)
                            Text(s).font(.system(size: 6, weight: .medium, design: .monospaced))
                                .foregroundColor(Color(white: 0.4))
                        }
                    }
                }
                .position(x: 130*T, y: 23*T)

                if agents.isEmpty && scanCount > 0 {
                    VStack(spacing: 3) {
                        Text("The loft is quiet...")
                        Text("Start Claude Code in a terminal")
                        Text(debugInfo)
                            .font(.system(size: 8, design: .monospaced))
                            .foregroundColor(.yellow.opacity(0.5))
                    }
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.3))
                    .position(x: CGFloat(C)*T/2, y: 56*T)
                }

                HStack(spacing: 6) {
                    Circle().fill(agents.isEmpty ? .gray : P.scrOn).frame(width: 6, height: 6)
                    Text("\(agents.count) agent\(agents.count == 1 ? "" : "s")")
                        .font(.system(size: 9, weight: .bold, design: .rounded))
                        .foregroundColor(.white.opacity(0.6))
                    if !agents.isEmpty {
                        let grouped = Dictionary(grouping: agents, by: { $0.project.components(separatedBy: ":").first ?? $0.project })
                        ForEach(Array(grouped.keys.sorted()), id: \.self) { key in
                            let count = grouped[key]!.count
                            Text("\(key) \(count)")
                                .font(.system(size: 8, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.4))
                                .padding(.horizontal, 4)
                                .padding(.vertical, 1)
                                .background(RoundedRectangle(cornerRadius: 3).fill(.white.opacity(0.08)))
                        }
                    }
                }
                .position(x: CGFloat(C)*T - 100, y: 2.5*T)
            }
            .frame(width: CGFloat(C)*T, height: CGFloat(R)*T)

            // Tabs
            HStack(spacing: 0) {
                if agents.isEmpty {
                    Text("No active agents")
                        .font(.system(size: 11, design: .rounded)).foregroundColor(.white.opacity(0.3))
                        .frame(maxWidth: .infinity).padding(.vertical, 10)
                } else {
                    ForEach(agents) { a in
                        VStack(spacing: 0) {
                            Button(action: { mochiSelected = false; selectedSubId = nil; selectedId = selectedId == a.id ? nil : a.id }) {
                                HStack(spacing: 4) {
                                    Circle().fill(STYLES[a.charStyle % STYLES.count].hair).frame(width: 8, height: 8)
                                    if !a.terminal.isEmpty {
                                        Text(a.terminal).font(.system(size: 8, weight: .bold, design: .rounded))
                                            .foregroundColor(.white.opacity(0.3))
                                    }
                                    Text(a.project).font(.system(size: 11, weight: .semibold, design: .rounded)).lineLimit(1)
                                }
                                .foregroundColor(selectedId == a.id && selectedSubId == nil ? P.neon : .white.opacity(0.6))
                                .frame(maxWidth: .infinity).padding(.vertical, 10)
                                .background(selectedId == a.id && selectedSubId == nil ? P.neon.opacity(0.1) : .clear)
                            }
                            .buttonStyle(.plain)
                            if selectedId == a.id && !a.subagents.isEmpty {
                                ForEach(a.subagents) { sub in
                                    Button(action: { selectedId = a.id; selectedSubId = selectedSubId == sub.id ? nil : sub.id }) {
                                        HStack(spacing: 3) {
                                            Circle().fill(STYLES[sub.charStyle % STYLES.count].hair).frame(width: 5, height: 5)
                                            let icon = sub.status == .working ? "⚡" : (sub.status == .reading ? "📖" : (sub.status == .done ? "✅" : "💤"))
                                            Text("\(icon) sub").font(.system(size: 9, weight: .medium, design: .rounded)).lineLimit(1)
                                        }
                                        .foregroundColor(selectedSubId == sub.id ? P.neon : .white.opacity(0.4))
                                        .frame(maxWidth: .infinity).padding(.vertical, 4)
                                        .background(selectedSubId == sub.id ? P.neon.opacity(0.08) : .clear)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                }
            }
            .background(P.panel)
            .overlay(alignment: .top) { Divider().background(Color.white.opacity(0.1)) }

            // Detail
            Group {
                if let sid = selectedId, let a = agents.first(where: { $0.id == sid }) {
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack(alignment: .leading, spacing: 8) {
                            if let subSid = selectedSubId, let sub = a.subagents.first(where: { $0.id == subSid }) {
                                HStack {
                                    Button(action: { selectedSubId = nil }) {
                                        HStack(spacing: 4) {
                                            Image(systemName: "chevron.left").font(.system(size: 9, weight: .bold))
                                            Text(a.project).font(.system(size: 10, weight: .medium, design: .rounded))
                                        }
                                        .foregroundColor(P.neon.opacity(0.7))
                                    }
                                    .buttonStyle(.plain)
                                    Spacer()
                                    let dot: Color = sub.status == .working ? P.scrOn : (sub.status == .reading ? .orange : (sub.status == .done ? .green : .gray))
                                    Circle().fill(dot).frame(width: 8, height: 8)
                                }
                                HStack(spacing: 6) {
                                    Circle().fill(STYLES[sub.charStyle % STYLES.count].hair).frame(width: 10, height: 10)
                                    Text("Subagent").font(.system(size: 13, weight: .bold, design: .rounded)).foregroundColor(.white)
                                    Text(sub.status.rawValue.uppercased())
                                        .font(.system(size: 9, weight: .bold, design: .rounded)).foregroundColor(P.neon)
                                }
                                if !sub.cwd.isEmpty {
                                    Text(sub.cwd.replacingOccurrences(of: NSHomeDirectory(), with: "~"))
                                        .font(.system(size: 9, design: .monospaced)).foregroundColor(.white.opacity(0.3))
                                        .lineLimit(1)
                                }
                                Divider().background(Color.white.opacity(0.15))
                                Text(sub.task)
                                    .font(.system(size: 12, design: .rounded)).foregroundColor(.white.opacity(0.85)).lineLimit(4)
                                if !sub.activities.isEmpty {
                                    Divider().background(Color.white.opacity(0.1))
                                    Text("ACTIVITY").font(.system(size: 9, weight: .heavy, design: .rounded)).foregroundColor(.white.opacity(0.3))
                                    activityFeed(sub.activities)
                                }
                            } else {
                                HStack {
                                    Circle().fill(STYLES[a.charStyle % STYLES.count].hair).frame(width: 14, height: 14)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(a.project).font(.system(size: 15, weight: .bold, design: .rounded)).foregroundColor(.white)
                                        HStack(spacing: 6) {
                                            Text(a.status.rawValue.uppercased())
                                                .font(.system(size: 9, weight: .bold, design: .rounded)).foregroundColor(P.neon)
                                            if !a.cwd.isEmpty {
                                                Text(a.cwd.replacingOccurrences(of: NSHomeDirectory(), with: "~"))
                                                    .font(.system(size: 9, design: .monospaced)).foregroundColor(.white.opacity(0.3))
                                                    .lineLimit(1)
                                            }
                                        }
                                    }
                                    Spacer()
                                    let dot: Color = a.status == .working ? P.scrOn : (a.status == .reading ? .orange : (a.status == .done ? .green : .gray))
                                    Circle().fill(dot).frame(width: 8, height: 8)
                                }
                                Divider().background(Color.white.opacity(0.15))
                                Text(a.task)
                                    .font(.system(size: 12, design: .rounded)).foregroundColor(.white.opacity(0.85)).lineLimit(3)
                                HStack(spacing: 8) {
                                    let termLabel = a.terminal.isEmpty ? a.entrypoint : a.terminal
                                    Text("\(termLabel) · \(a.shortId) · \(timeAgo(a.arrived))")
                                        .font(.system(size: 10, weight: .medium, design: .monospaced)).foregroundColor(.white.opacity(0.35))
                                }
                                if !a.activities.isEmpty {
                                    Divider().background(Color.white.opacity(0.1))
                                    Text("ACTIVITY").font(.system(size: 9, weight: .heavy, design: .rounded)).foregroundColor(.white.opacity(0.3))
                                    activityFeed(a.activities)
                                }
                                if !a.subagents.isEmpty {
                                    Divider().background(Color.white.opacity(0.1))
                                    Text("SUBAGENTS").font(.system(size: 9, weight: .heavy, design: .rounded)).foregroundColor(.white.opacity(0.3))
                                    ForEach(a.subagents) { sub in
                                        Button(action: { selectedSubId = sub.id }) {
                                            VStack(alignment: .leading, spacing: 3) {
                                                HStack(spacing: 6) {
                                                    Circle().fill(STYLES[sub.charStyle % STYLES.count].hair).frame(width: 8, height: 8)
                                                    let icon = sub.status == .working ? "⚡" : (sub.status == .reading ? "📖" : (sub.status == .done ? "✅" : "💤"))
                                                    Text(icon).font(.system(size: 10))
                                                    Text(sub.task).font(.system(size: 11, design: .rounded)).foregroundColor(.white.opacity(0.7)).lineLimit(1)
                                                    Spacer()
                                                    Image(systemName: "chevron.right").font(.system(size: 8, weight: .bold)).foregroundColor(.white.opacity(0.2))
                                                }
                                                if let last = sub.activities.last {
                                                    HStack(spacing: 4) {
                                                        Text(last.icon).font(.system(size: 8))
                                                        Text(last.detail).font(.system(size: 9, design: .monospaced)).foregroundColor(.white.opacity(0.35)).lineLimit(1)
                                                    }
                                                    .padding(.leading, 14)
                                                }
                                            }
                                            .padding(.vertical, 5).padding(.horizontal, 8)
                                            .background(RoundedRectangle(cornerRadius: 4).fill(.white.opacity(0.04)))
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                        }
                        .padding(16)
                    }
                } else if mochiSelected {
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("🍡").font(.system(size: 18))
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Mochi").font(.system(size: 15, weight: .bold, design: .rounded)).foregroundColor(.white)
                                    Text(mochiAwake ? "AWAKE" : "NAPPING")
                                        .font(.system(size: 9, weight: .bold, design: .rounded))
                                        .foregroundColor(mochiAwake ? P.neon : .white.opacity(0.3))
                                }
                                Spacer()
                                Circle().fill(mochiAwake ? P.scrOn : .gray).frame(width: 8, height: 8)
                            }
                            Divider().background(Color.white.opacity(0.15))
                            if mochiAwake {
                                if !mochiTask.isEmpty {
                                    Text(mochiTask)
                                        .font(.system(size: 12, design: .rounded)).foregroundColor(.white.opacity(0.85)).lineLimit(3)
                                }
                                if !mochiActivities.isEmpty {
                                    Divider().background(Color.white.opacity(0.1))
                                    Text("ACTIVITY").font(.system(size: 9, weight: .heavy, design: .rounded)).foregroundColor(.white.opacity(0.3))
                                    activityFeed(mochiActivities)
                                }
                            } else {
                                Text("Mochi is resting on the couch... no active sessions")
                                    .font(.system(size: 11, design: .rounded)).foregroundColor(.white.opacity(0.35))
                            }
                        }
                        .padding(16)
                    }
                } else {
                    VStack(spacing: 6) {
                        Text(agents.isEmpty ? "Mochi is napping on the couch 💤" : "Click an agent to see what they're up to")
                            .font(.system(size: 12, design: .rounded)).foregroundColor(.white.opacity(0.3))
                        if agents.isEmpty {
                            Text(debugInfo)
                                .font(.system(size: 10, design: .monospaced)).foregroundColor(.yellow.opacity(0.6))
                                .textSelection(.enabled)
                        }
                    }
                    .padding(.vertical, 20)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 140, maxHeight: 280)
            .background(P.panel)
        }
        .onAppear { refresh() }
        .onReceive(timer) { _ in refresh() }
    }

    // MARK: - Scanner

    func refresh() {
        guard !scanning else { return }
        scanning = true
        DispatchQueue.global().async {
            let sess = scanSessions()
            let (mAwake, mTask, mActs) = checkMochi()
            let dbg = "scan=\(scanCount+1) found=\(sess.count)"
            DispatchQueue.main.async {
                updateAgents(sess)
                mochiAwake = mAwake
                mochiTask = mTask
                mochiActivities = mActs
                debugInfo = dbg
                scanCount += 1
                scanning = false
            }
        }
    }

    func checkMochi() -> (Bool, String, [Activity]) {
        let home = NSHomeDirectory()
        let mochiDir = URL(fileURLWithPath: home + "/.claude/projects/-")
        let cutoff = Date().addingTimeInterval(-2 * 3600)
        let fm = FileManager.default
        guard let contents = try? fm.contentsOfDirectory(at: mochiDir, includingPropertiesForKeys: [.contentModificationDateKey]) else { return (false, "", []) }
        var newest: URL? = nil
        var newestDate: Date = .distantPast
        for url in contents where url.pathExtension == "jsonl" {
            if let vals = try? url.resourceValues(forKeys: [.contentModificationDateKey]),
               let mod = vals.contentModificationDate, mod > cutoff {
                if mod > newestDate { newestDate = mod; newest = url }
            }
        }
        guard let url = newest else { return (false, "", []) }
        let (task, _, _, acts, _) = readSessionNative(url.path)
        return (true, task, acts)
    }

    struct Found { let id: String; let project: String; let task: String; let status: AgentStatus; let cwd: String; let subs: [FoundSub]; let activities: [Activity]; let entrypoint: String; let terminal: String }
    struct FoundSub { let id: String; let status: AgentStatus; let task: String; let cwd: String; let activities: [Activity] }

    func findJsonlFiles(_ dir: URL, cutoff: Date) -> (main: [URL], subs: [String: [URL]]) {
        let fm = FileManager.default
        guard let enumerator = fm.enumerator(at: dir, includingPropertiesForKeys: [.contentModificationDateKey], options: [.skipsHiddenFiles]) else { return ([], [:]) }
        var mains: [URL] = []
        var subs: [String: [URL]] = [:]
        while let url = enumerator.nextObject() as? URL {
            guard url.pathExtension == "jsonl" else { continue }
            if let vals = try? url.resourceValues(forKeys: [.contentModificationDateKey]),
               let mod = vals.contentModificationDate, mod > cutoff {
                if url.path.contains("/subagents/") {
                    let parts = url.path.components(separatedBy: "/subagents/")
                    if let parentPath = parts.first {
                        let parentId = URL(fileURLWithPath: parentPath).lastPathComponent
                        subs[parentId, default: []].append(url)
                    }
                } else {
                    mains.append(url)
                }
            }
        }
        return (mains, subs)
    }

    func parseActivities(_ path: String) -> [Activity] {
        let chunk = readTail(path, bytes: 40000)
        let lines = chunk.components(separatedBy: "\n")
        var acts: [Activity] = []

        for line in lines.reversed() {
            if acts.count >= 8 { break }
            // Tool uses from assistant messages
            if line.contains("\"tool_use\"") && line.contains("\"name\":\"") {
                if let nameR = line.range(of: "\"name\":\"") {
                    let after = line[nameR.upperBound...]
                    if let end = after.firstIndex(of: "\"") {
                        let toolName = String(after[after.startIndex..<end])
                        let (icon, detail) = toolDetail(toolName, line: line)
                        acts.append(Activity(icon: icon, label: toolName, detail: detail))
                    }
                }
            }
            // Assistant text (not tool calls)
            else if line.contains("\"role\":\"assistant\"") && line.contains("\"type\":\"text\"") && !line.contains("\"tool_use\"") {
                if let r1 = line.range(of: "\"text\":\"") {
                    let after = line[r1.upperBound...]
                    var text = ""
                    var escaped = false
                    for ch in after {
                        if escaped { text.append(ch); escaped = false; continue }
                        if ch == "\\" { escaped = true; continue }
                        if ch == "\"" { break }
                        text.append(ch)
                    }
                    let clean = text.trimmingCharacters(in: .whitespacesAndNewlines)
                    if !clean.isEmpty && clean.count > 5 {
                        acts.append(Activity(icon: "💬", label: "said", detail: String(clean.prefix(100))))
                    }
                }
            }
        }
        return acts.reversed()
    }

    func toolDetail(_ name: String, line: String) -> (String, String) {
        switch name {
        case "Bash":
            if let r = line.range(of: "\"command\":\"") {
                let after = line[r.upperBound...]
                var cmd = ""
                var escaped = false
                for ch in after {
                    if escaped { cmd.append(ch); escaped = false; continue }
                    if ch == "\\" { escaped = true; continue }
                    if ch == "\"" { break }
                    cmd.append(ch)
                }
                let clean = cmd.components(separatedBy: "\n").first ?? cmd
                return ("⚡", String(clean.prefix(80)))
            }
            return ("⚡", "")
        case "Read":
            return ("👁", extractPath(line))
        case "Edit":
            return ("📝", extractPath(line))
        case "Write":
            return ("✏️", extractPath(line))
        case "Agent":
            if let r = line.range(of: "\"description\":\"") {
                let after = line[r.upperBound...]
                if let end = after.firstIndex(of: "\"") {
                    return ("🤖", String(after[after.startIndex..<end]))
                }
            }
            return ("🤖", "spawned subagent")
        case "WebSearch", "WebFetch":
            return ("🌐", name == "WebSearch" ? "searching..." : "fetching...")
        case "AskUserQuestion":
            return ("❓", "asking user")
        default:
            if name.hasPrefix("mcp_") || name.hasPrefix("mcp__") { return ("🔌", name.components(separatedBy: "__").last ?? name) }
            return ("🔧", name)
        }
    }

    func extractPath(_ line: String) -> String {
        if let r = line.range(of: "\"file_path\":\"") {
            let after = line[r.upperBound...]
            if let end = after.firstIndex(of: "\"") {
                let p = String(after[after.startIndex..<end])
                return p.replacingOccurrences(of: NSHomeDirectory(), with: "~")
            }
        }
        return ""
    }

    func readTail(_ path: String, bytes: Int) -> String {
        guard let fh = FileHandle(forReadingAtPath: path) else { return "" }
        defer { fh.closeFile() }
        let end = fh.seekToEndOfFile()
        let start = end > UInt64(bytes) ? end - UInt64(bytes) : 0
        fh.seek(toFileOffset: start)
        let data = fh.readDataToEndOfFile()
        return String(data: data, encoding: .utf8) ?? ""
    }

    func findLiveSessions() -> (urls: [URL], terminals: [String: String]) {
        let home = NSHomeDirectory()
        let fm = FileManager.default

        // Use lsof +D on tasks dir to find active sessions AND their PIDs
        let lsofRaw = shWithTimeout("lsof +D \(home)/.claude/tasks/ 2>/dev/null", seconds: 4)

        var sidToPid: [String: Int] = [:]
        for line in lsofRaw.components(separatedBy: "\n") {
            guard line.contains(".claude/tasks/") else { continue }
            let cols = line.split(separator: " ", omittingEmptySubsequences: true)
            guard cols.count >= 2, let pid = Int(cols[1]), let pathCol = cols.last else { continue }
            let parts = String(pathCol).components(separatedBy: "/tasks/")
            if parts.count >= 2, let tail = parts.last {
                let sid = tail.components(separatedBy: "/").first ?? tail
                let clean = sid.trimmingCharacters(in: .whitespacesAndNewlines)
                if clean.contains("-") && clean.count > 30 { sidToPid[clean] = pid }
            }
        }
        // Build process tree for terminal detection
        let psRaw = shWithTimeout("ps -axo pid=,ppid=,comm=", seconds: 3)
        var ppidMap: [Int: Int] = [:]
        var commMap: [Int: String] = [:]
        for line in psRaw.components(separatedBy: "\n") {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            guard !trimmed.isEmpty else { continue }
            let parts = trimmed.split(separator: " ", maxSplits: 2)
            guard parts.count >= 3, let pid = Int(parts[0]), let ppid = Int(parts[1]) else { continue }
            ppidMap[pid] = ppid
            commMap[pid] = String(parts[2])
        }

        func walkToTerminal(_ pid: Int) -> String {
            var current = pid
            for _ in 0..<15 {
                let c = (commMap[current] ?? "").lowercased()
                if c.contains("warp") { return "Warp" }
                if c.contains("iterm") { return "iTerm" }
                if c.contains("alacritty") { return "Alacritty" }
                if c.contains("kitty") { return "Kitty" }
                if c.contains("hyper") { return "Hyper" }
                if c.hasSuffix("/terminal") || c == "terminal" { return "Terminal" }
                if c.contains("claude") && c.contains("/macos/claude") { return "Claude Desktop" }
                guard let parent = ppidMap[current], parent > 1, parent != current else { break }
                current = parent
            }
            return ""
        }

        var terminals: [String: String] = [:]
        for (sid, pid) in sidToPid {
            let t = walkToTerminal(pid)
            if !t.isEmpty { terminals[sid] = t }
        }
        let projectsDir = URL(fileURLWithPath: home + "/.claude/projects")
        var urls: [URL] = []
        if let dirs = try? fm.contentsOfDirectory(at: projectsDir, includingPropertiesForKeys: nil) {
            for dir in dirs {
                for sid in sidToPid.keys {
                    let jsonl = dir.appendingPathComponent(sid + ".jsonl")
                    if fm.fileExists(atPath: jsonl.path) { urls.append(jsonl) }
                }
            }
        }
        return (urls, terminals)
    }

    func shWithTimeout(_ cmd: String, seconds: Int) -> String {
        let p = Process(); p.executableURL = URL(fileURLWithPath: "/bin/zsh"); p.arguments = ["-c", cmd]
        let pipe = Pipe(); p.standardOutput = pipe; p.standardError = FileHandle.nullDevice
        var env = ProcessInfo.processInfo.environment
        env["PATH"] = NSHomeDirectory() + "/.local/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin"
        p.environment = env
        var output = Data()
        let lock = NSLock()
        pipe.fileHandleForReading.readabilityHandler = { fh in
            let d = fh.availableData
            if !d.isEmpty { lock.lock(); output.append(d); lock.unlock() }
        }
        try? p.run()
        let deadline = Date().addingTimeInterval(Double(seconds))
        while p.isRunning && Date() < deadline { Thread.sleep(forTimeInterval: 0.05) }
        if p.isRunning { p.terminate(); p.waitUntilExit() }
        pipe.fileHandleForReading.readabilityHandler = nil
        Thread.sleep(forTimeInterval: 0.05)
        lock.lock(); let result = String(data: output, encoding: .utf8) ?? ""; lock.unlock()
        return result
    }

    func logDebug(_ msg: String) {
        let logPath = NSHomeDirectory() + "/agentloft_debug.log"
        let ts = ISO8601DateFormatter().string(from: Date())
        let line = "[\(ts)] \(msg)\n"
        if let fh = FileHandle(forWritingAtPath: logPath) {
            fh.seekToEndOfFile(); fh.write(line.data(using: .utf8)!); fh.closeFile()
        } else {
            try? line.write(toFile: logPath, atomically: true, encoding: .utf8)
        }
    }

    func scanSessions() -> [Found] {
        let home = NSHomeDirectory()
        let projectsDir = URL(fileURLWithPath: home + "/.claude/projects")
        let cutoff = Date().addingTimeInterval(-10 * 60)
        let (recentMains, subMap) = findJsonlFiles(projectsDir, cutoff: cutoff)

        let (liveMains, tMap) = findLiveSessions()
        let recentIds = Set(recentMains.map { $0.deletingPathExtension().lastPathComponent })
        var mains = recentMains
        for url in liveMains {
            let sid = url.deletingPathExtension().lastPathComponent
            if !recentIds.contains(sid) { mains.append(url) }
        }

        var found: [Found] = []
        for url in mains {
            let dir = url.deletingLastPathComponent().lastPathComponent
            if dir == "-" { continue }
            let sid = url.deletingPathExtension().lastPathComponent

            let (task, st, cwd, acts, ep) = readSessionNative(url.path)
            if cwd == "/" { continue }
            let proj = cwd.isEmpty ? projectName(dir) : projectFromCwd(cwd)
            let term = tMap[sid] ?? (ep == "vscode" ? "VS Code" : (ep == "desktop" ? "Claude Desktop" : ""))

            var subs: [FoundSub] = []
            if let subFiles = subMap[sid] {
                for sf in subFiles {
                    let subId = sf.deletingPathExtension().lastPathComponent
                    let (subTask, subSt, subCwd, subActs, _) = readSessionNative(sf.path)
                    subs.append(FoundSub(id: subId, status: subSt, task: subTask, cwd: subCwd, activities: subActs))
                }
            }

            found.append(Found(id: sid, project: proj, task: task, status: st, cwd: cwd, subs: subs, activities: acts, entrypoint: ep, terminal: term))
        }
        return found
    }

    func readSessionNative(_ path: String) -> (String, AgentStatus, String, [Activity], String) {
        let chunk = readTail(path, bytes: 80000)
        let lines = chunk.components(separatedBy: "\n")

        var task = "Working..."
        var cwd = ""
        var entrypoint = "cli"

        for line in lines.reversed() {
            if entrypoint == "cli", let e1 = line.range(of: "\"entrypoint\":\"") {
                let after = line[e1.upperBound...]
                if let e2 = after.firstIndex(of: "\"") {
                    entrypoint = String(after[after.startIndex..<e2])
                }
            }
            guard line.contains("\"type\":\"user\"") else { continue }
            if cwd.isEmpty, let c1 = line.range(of: "\"cwd\":\"") {
                let after = line[c1.upperBound...]
                if let c2 = after.firstIndex(of: "\"") {
                    cwd = String(after[after.startIndex..<c2])
                }
            }
            if task == "Working..." && !line.contains("tool_result") && !line.contains("task-notification") && !line.contains("system-reminder") && !line.contains("hook_success") && !line.contains("\"userType\":\"external\"") {
                if let r1 = line.range(of: "\"content\":\"") {
                    let after = line[r1.upperBound...]
                    if let r2 = after.range(of: "\",\"") {
                        var raw = String(after[after.startIndex..<r2.lowerBound].prefix(120))
                            .replacingOccurrences(of: "\\n", with: " ")
                            .replacingOccurrences(of: "\\\"", with: "\"")
                        // Strip any remaining XML tags
                        while let open = raw.range(of: "<"), let close = raw.range(of: ">", range: open.upperBound..<raw.endIndex) {
                            raw.removeSubrange(open.lowerBound...close.lowerBound)
                        }
                        raw = raw.trimmingCharacters(in: .whitespaces)
                        if !raw.isEmpty && raw.count > 3 { task = String(raw.prefix(80)) }
                    }
                }
            }
            if cwd != "" && task != "Working..." && entrypoint != "cli" { break }
        }

        var st: AgentStatus = .idle
        let tail = readTail(path, bytes: 5000)
        if tail.contains("\"Edit\"") || tail.contains("\"Write\"") { st = .working }
        else if tail.contains("\"Read\"") || tail.contains("\"Bash\"") || tail.contains("\"Grep\"") { st = .reading }
        else if tail.contains("\"assistant\"") { st = .done }

        let acts = parseActivities(path)
        return (task, st, cwd, acts, entrypoint)
    }

    func projectFromCwd(_ cwd: String) -> String {
        let home = NSHomeDirectory()
        let rel = cwd.hasPrefix(home) ? String(cwd.dropFirst(home.count + 1)) : cwd
        if rel.isEmpty || rel == "/" { return "Home" }
        if rel.contains("rdp-worktrees") {
            let parts = rel.components(separatedBy: "/")
            if let idx = parts.firstIndex(of: "rdp-worktrees"), idx + 1 < parts.count {
                return "RDP: \(parts[idx+1].prefix(18))"
            }
            return "RDP Worktree"
        }
        if rel.contains("core-360-react-views") { return "P360 Views" }
        if rel.hasSuffix("/rdp") || rel.hasSuffix("/rdp/") { return "RDP" }
        if rel.contains("Video editing") || rel.contains("Video-editing") { return "Video Editing" }
        if rel.contains("360-collect") { return "360 Collect" }
        let last = URL(fileURLWithPath: cwd).lastPathComponent
        if last.count > 20 { return String(last.prefix(18)) + "…" }
        return last
    }

    func projectName(_ e: String) -> String {
        if e.hasSuffix("-rdp") { return "RDP" }
        if e.contains("core-360-react-views") { return "P360 Views" }
        if e.contains("Video-editing") { return "Video Editing" }
        if e.contains("rdp-worktrees") { return "RDP Worktree" }
        if e == "-" || e == "." { return "Routine" }
        if e == "-Users-olmeeann" { return "Home" }
        if e.contains("360-collect") { return "360 Collect" }
        if let r = e.range(of: "-Projects-") { return String(e[r.upperBound...]).components(separatedBy: "-").prefix(3).joined(separator: "-") }
        return e.split(separator: "-").last.map(String.init) ?? e
    }

    func readSession(_ path: String) -> (String, AgentStatus, String) {
        let chunk = sh("tail -500 '\(path)' 2>/dev/null")
        let lines = chunk.components(separatedBy: "\n")

        var task = "Working..."
        var cwd = ""

        for line in lines.reversed() {
            guard line.contains("\"type\":\"user\"") else { continue }
            if cwd.isEmpty, let c1 = line.range(of: "\"cwd\":\"") {
                let after = line[c1.upperBound...]
                if let c2 = after.firstIndex(of: "\"") {
                    cwd = String(after[after.startIndex..<c2])
                }
            }
            if task == "Working..." && !line.contains("tool_result") {
                if let r1 = line.range(of: "\"content\":\"") {
                    let after = line[r1.upperBound...]
                    if let r2 = after.range(of: "\",\"") {
                        task = String(after[after.startIndex..<r2.lowerBound].prefix(80))
                            .replacingOccurrences(of: "\\n", with: " ")
                            .replacingOccurrences(of: "\\\"", with: "\"")
                    }
                }
            }
            if cwd != "" && task != "Working..." { break }
        }

        let tail30 = sh("tail -30 '\(path)' 2>/dev/null")
        var st: AgentStatus = .idle
        if tail30.contains("\"Edit\"") || tail30.contains("\"Write\"") { st = .working }
        else if tail30.contains("\"Read\"") || tail30.contains("\"Bash\"") || tail30.contains("\"Grep\"") { st = .reading }
        else if tail30.contains("\"assistant\"") { st = .done }
        return (task, st, cwd)
    }

    func updateAgents(_ found: [Found]) {
        var na: [LiveAgent] = []
        var dm = deskMap
        var ud = Set<Int>()
        let totalDesks = DKCOLS.count + DKCOLS2.count
        for f in found {
            let ex = agents.first(where: { $0.id == f.id })
            let d: Int
            if let v = dm[f.id] { d = v }
            else { d = (0..<totalDesks).first(where: { !usedDesks.contains($0) && !ud.contains($0) }) ?? -1; if d >= 0 { dm[f.id] = d } }
            ud.insert(d)
            let ci = ex?.charStyle ?? (f.id.unicodeScalars.reduce(0) { $0 + Int($1.value) } % STYLES.count)
            let subs = f.subs.enumerated().map { i, s in
                SubAgent(id: s.id, status: s.status, charStyle: (ci + i + 1) % STYLES.count, task: s.task, cwd: s.cwd, activities: s.activities)
            }
            let short = String(f.id.prefix(6))
            na.append(LiveAgent(id: f.id, project: f.project, task: f.task, status: f.status, charStyle: ci, deskIdx: d, isRoutine: false, arrived: ex?.arrived ?? Date(), cwd: f.cwd, subagents: subs, activities: f.activities, entrypoint: f.entrypoint, shortId: short, terminal: f.terminal))
        }
        for old in dm where !na.contains(where: { $0.id == old.key }) { dm.removeValue(forKey: old.key) }
        agents = na; deskMap = dm; usedDesks = ud
        if let s = selectedId, !agents.contains(where: { $0.id == s }) { selectedId = nil; selectedSubId = nil }
        if let s = selectedSubId, let a = agents.first(where: { $0.id == selectedId }), !a.subagents.contains(where: { $0.id == s }) { selectedSubId = nil }
    }

    @ViewBuilder
    func activityFeed(_ activities: [Activity]) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            ForEach(activities) { act in
                HStack(alignment: .top, spacing: 6) {
                    Text(act.icon).font(.system(size: 10)).frame(width: 16)
                    Text(act.label)
                        .font(.system(size: 10, weight: .semibold, design: .monospaced))
                        .foregroundColor(.white.opacity(0.5))
                        .frame(width: 40, alignment: .leading)
                    Text(act.detail)
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(.white.opacity(0.4))
                        .lineLimit(1)
                }
                .padding(.vertical, 1)
            }
        }
    }

    func timeAgo(_ d: Date) -> String {
        let s = Int(Date().timeIntervalSince(d))
        if s < 60 { return "just now" }
        if s < 3600 { return "\(s/60)m ago" }
        return "\(s/3600)h ago"
    }

    func sh(_ cmd: String) -> String { shWithTimeout(cmd, seconds: 5) }
}
