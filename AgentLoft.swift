import SwiftUI
import Cocoa

@main
struct AgentLoftApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            AgentLoftView()
                .frame(minWidth: 864, minHeight: 790)
        }
        .windowStyle(.titleBar)
        .windowToolbarStyle(.unified(showsTitle: false))
        .defaultSize(width: 864, height: 820)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        let args = CommandLine.arguments
        if let i = args.firstIndex(of: "--snapshot"), i + 1 < args.count {
            renderSnapshot(to: args[i + 1])
            NSApp.terminate(nil)
            return
        }
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

// Character look: which sprite sheet in assets/ and the accent colour used in the UI
struct CharLook { let sheet: Int; let accent: Color }

let STYLES: [CharLook] = [
    CharLook(sheet: 0, accent: Color(red: 0.30, green: 0.50, blue: 0.80)),
    CharLook(sheet: 1, accent: Color(red: 0.88, green: 0.62, blue: 0.30)),
    CharLook(sheet: 2, accent: Color(red: 0.92, green: 0.45, blue: 0.18)),
    CharLook(sheet: 3, accent: Color(red: 0.85, green: 0.85, blue: 0.90)),
    CharLook(sheet: 4, accent: Color(red: 0.70, green: 0.45, blue: 0.28)),
    CharLook(sheet: 5, accent: Color(red: 0.88, green: 0.32, blue: 0.32)),
]

// MARK: - Palette

struct P {
    static let ceil       = Color(red: 0.10, green: 0.08, blue: 0.14)
    static let duct       = Color(red: 0.18, green: 0.16, blue: 0.22)
    static let ductHi     = Color(red: 0.24, green: 0.21, blue: 0.28)
    static let bricks     = [Color(red: 0.50, green: 0.25, blue: 0.18), Color(red: 0.60, green: 0.33, blue: 0.23),
                             Color(red: 0.55, green: 0.29, blue: 0.20), Color(red: 0.48, green: 0.23, blue: 0.16)]
    static let brickHi    = Color(red: 0.66, green: 0.38, blue: 0.27)
    static let mortar     = Color(red: 0.36, green: 0.31, blue: 0.26)
    static let skyHi      = Color(red: 0.10, green: 0.12, blue: 0.28)
    static let skyMd      = Color(red: 0.16, green: 0.19, blue: 0.40)
    static let skyLo      = Color(red: 0.30, green: 0.26, blue: 0.48)
    static let star       = Color(red: 0.90, green: 0.90, blue: 1.00)
    static let bldg       = Color(red: 0.14, green: 0.15, blue: 0.24)
    static let bldgDk     = Color(red: 0.10, green: 0.11, blue: 0.18)
    static let bldgLit    = Color(red: 0.95, green: 0.85, blue: 0.48)
    static let wf         = Color(red: 0.16, green: 0.14, blue: 0.20)
    static let wfHi       = Color(red: 0.30, green: 0.27, blue: 0.34)
    static let sill       = Color(red: 0.62, green: 0.58, blue: 0.56)
    static let wb         = Color(red: 0.93, green: 0.93, blue: 0.95)
    static let wbFrame    = Color(red: 0.62, green: 0.62, blue: 0.66)
    static let base       = Color(red: 0.24, green: 0.19, blue: 0.15)
    static let rugBd      = Color(red: 0.36, green: 0.20, blue: 0.34)
    static let neon       = Color(red: 1.00, green: 0.28, blue: 0.52)
    static let lampWire   = Color(red: 0.24, green: 0.20, blue: 0.28)
    static let lampShade  = Color(red: 0.85, green: 0.75, blue: 0.55)
    static let lampGlow   = Color(red: 1.00, green: 0.95, blue: 0.80)
    static let warmLight  = Color(red: 1.00, green: 0.85, blue: 0.55)
    static let moonLight  = Color(red: 0.55, green: 0.65, blue: 1.00)
    static let panel      = Color(red: 0.11, green: 0.09, blue: 0.16)
    static let scrOn      = Color(red: 0.22, green: 0.82, blue: 0.48)
    static let screenGlow = Color(red: 0.45, green: 0.85, blue: 1.00)
    static let mochi      = Color(red: 0.97, green: 0.93, blue: 0.85)
    static let mochiSh    = Color(red: 0.88, green: 0.82, blue: 0.74)
    static let mochiLine  = Color(red: 0.30, green: 0.20, blue: 0.26)
    static let cheek      = Color(red: 0.95, green: 0.62, blue: 0.66)
    static let eye        = Color(white: 0.12)
    static let mouth      = Color(red: 0.85, green: 0.48, blue: 0.48)
}

// MARK: - Grid
// The scene is drawn in art pixels (16 px tiles, like the sprites) and scaled up by K.

let K: CGFloat = 3
let SW = 288
let SH = 208
let WALL_TOP = 10
let WALL_BOT = 44
let FLOOR_Y = 46
let DESK_SLOTS = 8

func t(_ ctx: inout GraphicsContext, x: Int, y: Int, w: Int = 1, h: Int = 1, c: Color) {
    ctx.fill(Path(CGRect(x: CGFloat(x)*K, y: CGFloat(y)*K, width: CGFloat(w)*K, height: CGFloat(h)*K)), with: .color(c))
}

// MARK: - Sprites

enum Sprites {
    // PNGs live in assets/ next to the binary (or in the app bundle's Resources)
    static let dir = Bundle.main.resourceURL!.appendingPathComponent("assets")
    // Pre-scaled with nearest-neighbour so pixels stay crisp on Retina screens
    static let renderScale = 2
    static var cache: [String: CGImage] = [:]

    static func image(_ name: String) -> CGImage? {
        if let c = cache[name] { return c }
        guard let src = CGImageSourceCreateWithURL(dir.appendingPathComponent(name + ".png") as CFURL, nil),
              let raw = CGImageSourceCreateImageAtIndex(src, 0, nil) else { return nil }
        cache[name] = raw
        return raw
    }

    static func scaled(_ name: String, crop: CGRect? = nil) -> CGImage? {
        let key = crop.map { "\(name)@\($0.minX),\($0.minY)" } ?? name + "@"
        if let c = cache[key] { return c }
        guard var img = image(name) else { return nil }
        if let crop, let c = img.cropping(to: crop) { img = c }
        let s = Int(K) * renderScale
        guard let ctx = CGContext(data: nil, width: img.width * s, height: img.height * s, bitsPerComponent: 8, bytesPerRow: 0,
                                  space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else { return nil }
        ctx.interpolationQuality = .none
        ctx.draw(img, in: CGRect(x: 0, y: 0, width: img.width * s, height: img.height * s))
        guard let out = ctx.makeImage() else { return nil }
        cache[key] = out
        return out
    }

    // Character sheets: 7 frames of 16x32 per row. Row 0 faces the viewer.
    // Frames 0-2 walk, 3-4 typing, 5-6 reading.
    static func character(_ sheet: Int, frame: Int) -> CGImage? {
        scaled("char_\(sheet)", crop: CGRect(x: frame * 16, y: 0, width: 16, height: 32))
    }
}

func sprite(_ ctx: inout GraphicsContext, _ img: CGImage?, x: Int, y: Int) {
    guard let img else { return }
    let s = CGFloat(Sprites.renderScale)
    ctx.draw(Image(decorative: img, scale: s).interpolation(.none),
             in: CGRect(x: CGFloat(x)*K, y: CGFloat(y)*K, width: CGFloat(img.width)/s, height: CGFloat(img.height)/s))
}

func sprite(_ ctx: inout GraphicsContext, _ name: String, x: Int, y: Int) {
    sprite(&ctx, Sprites.scaled(name), x: x, y: y)
}

// MARK: - Room

let WINDOWS = [18, 127, 236]
let WB_X = 68, WB_Y = WALL_TOP + 5, WB_W = 42, WB_H = 22

func drawRoom(_ ctx: inout GraphicsContext, frame: Int) {
    // Ceiling + ductwork
    t(&ctx, x: 0, y: 0, w: SW, h: WALL_TOP, c: P.ceil)
    for dx in stride(from: 4, to: SW - 30, by: 48) {
        t(&ctx, x: dx, y: 3, w: 34, h: 4, c: P.duct)
        t(&ctx, x: dx + 2, y: 3, w: 30, h: 1, c: P.ductHi)
    }

    // Brick wall (12x6 bricks, with a light top edge)
    for y in WALL_TOP..<WALL_BOT {
        let wy = y - WALL_TOP
        let off = (wy / 6) % 2 == 0 ? 0 : 6
        for x in 0..<SW {
            if wy % 6 == 5 || (x + off) % 12 == 11 {
                t(&ctx, x: x, y: y, c: P.mortar)
            } else if wy % 6 == 0 {
                t(&ctx, x: x, y: y, c: P.brickHi)
            } else {
                let b = ((x + off) / 12 &* 7 &+ wy / 6 &* 13) % 4
                t(&ctx, x: x, y: y, c: P.bricks[b])
            }
        }
    }
    t(&ctx, x: 0, y: WALL_BOT, w: SW, h: 2, c: P.base)

    // Wooden floor
    for y in stride(from: FLOOR_Y, to: SH, by: 32) {
        for x in stride(from: 0, to: SW, by: 32) { sprite(&ctx, "floor_wood", x: x, y: y) }
    }

    // Night windows with skyline; a few office lights switch on and off
    let bH = [9, 6, 12, 8, 5, 11, 7, 10, 4, 8, 13, 6, 9, 5, 11, 7, 10, 6]
    let ww = 34, wh = 26, wy = WALL_TOP + 4
    for wc in WINDOWS {
        t(&ctx, x: wc - 1, y: wy - 1, w: ww + 2, h: wh + 2, c: P.wf)
        for sy in 0..<(wh - 2) {
            let f = CGFloat(sy) / CGFloat(wh - 2)
            t(&ctx, x: wc + 1, y: wy + 1 + sy, w: ww - 2, c: f < 0.35 ? P.skyHi : (f < 0.7 ? P.skyMd : P.skyLo))
        }
        for (sx, sy) in [(4, 3), (13, 6), (22, 2), (29, 7), (9, 9)] {
            t(&ctx, x: wc + sx, y: wy + sy, c: P.star.opacity((sx + frame / 3) % 4 == 0 ? 0.4 : 0.9))
        }
        for rx in 0..<(ww - 2) {
            let bh = bH[(rx + wc) % bH.count]
            for ry in (wh - 2 - bh)..<(wh - 2) {
                let lit = ry % 3 == 1 && rx % 2 == 0 && ((rx * 7 + ry * 3 + wc + frame / 12) % 5 != 0)
                t(&ctx, x: wc + 1 + rx, y: wy + 1 + ry, c: lit ? P.bldgLit : (rx % 4 < 2 ? P.bldg : P.bldgDk))
            }
        }
        t(&ctx, x: wc + ww / 2, y: wy, w: 1, h: wh, c: P.wf)
        t(&ctx, x: wc, y: wy + wh / 2, w: ww, h: 1, c: P.wf)
        t(&ctx, x: wc, y: wy, w: ww, h: 1, c: P.wfHi)
        t(&ctx, x: wc - 2, y: wy + wh, w: ww + 4, h: 2, c: P.sill)
    }

    // Wall decor
    // Whiteboard (running dev services are written on it as text)
    t(&ctx, x: WB_X - 1, y: WB_Y - 1, w: WB_W + 2, h: WB_H + 2, c: P.wbFrame)
    t(&ctx, x: WB_X, y: WB_Y, w: WB_W, h: WB_H, c: P.wb)
    t(&ctx, x: WB_X + 2, y: WB_Y + WB_H + 1, w: WB_W - 4, h: 1, c: P.wbFrame)
    t(&ctx, x: WB_X + 4, y: WB_Y + WB_H, w: 3, h: 1, c: P.neon)
    t(&ctx, x: WB_X + 8, y: WB_Y + WB_H, w: 3, h: 1, c: P.screenGlow)
    sprite(&ctx, "CLOCK", x: 182, y: WALL_TOP - 2)
    sprite(&ctx, "LARGE_PAINTING", x: 198, y: WALL_TOP + 2)

    // Pendant lights
    for lc in [63, 172] {
        t(&ctx, x: lc, y: 0, w: 1, h: 14, c: P.lampWire)
        t(&ctx, x: lc - 3, y: 13, w: 7, h: 3, c: P.lampShade)
        t(&ctx, x: lc - 2, y: 16, w: 5, h: 1, c: P.lampGlow)
    }

    // Lounge: rug, couch, coffee corner, plants, bookshelf
    let rx = 84, ry = 172, rw = 120, rh = 34
    t(&ctx, x: rx - 1, y: ry - 1, w: rw + 2, h: rh + 2, c: P.rugBd)
    var clip = ctx
    clip.clip(to: Path(CGRect(x: CGFloat(rx)*K, y: CGFloat(ry)*K, width: CGFloat(rw)*K, height: CGFloat(rh)*K)))
    for y in stride(from: ry, to: ry + rh, by: 16) {
        for x in stride(from: rx, to: rx + rw, by: 16) { sprite(&clip, "rug", x: x, y: y) }
    }
    sprite(&ctx, "SOFA_FRONT", x: 128, y: 178)
    sprite(&ctx, "SMALL_TABLE_FRONT", x: 30, y: 172)
    sprite(&ctx, "COFFEE", x: 38, y: 177)
    sprite(&ctx, "BIN", x: 64, y: 188)
    sprite(&ctx, "LARGE_PLANT", x: 0, y: 156)
    sprite(&ctx, "DOUBLE_BOOKSHELF", x: 222, y: 170)
    sprite(&ctx, "PLANT", x: 258, y: 174)
    sprite(&ctx, "PLANT_2", x: 272, y: 174)
}

// Soft light drawn on top of everything: moonlight from the windows, warm pools under the lamps, dark edges
func drawLighting(_ ctx: inout GraphicsContext) {
    for wc in WINDOWS {
        var p = Path()
        p.move(to: CGPoint(x: CGFloat(wc) * K, y: CGFloat(FLOOR_Y) * K))
        p.addLine(to: CGPoint(x: CGFloat(wc + 34) * K, y: CGFloat(FLOOR_Y) * K))
        p.addLine(to: CGPoint(x: CGFloat(wc + 46) * K, y: CGFloat(FLOOR_Y + 30) * K))
        p.addLine(to: CGPoint(x: CGFloat(wc + 8) * K, y: CGFloat(FLOOR_Y + 30) * K))
        p.closeSubpath()
        ctx.fill(p, with: .linearGradient(Gradient(colors: [P.moonLight.opacity(0.14), P.moonLight.opacity(0)]),
                                          startPoint: CGPoint(x: 0, y: CGFloat(FLOOR_Y) * K),
                                          endPoint: CGPoint(x: 0, y: CGFloat(FLOOR_Y + 30) * K)))
    }
    for (lx, ly) in [(63, 90), (172, 90), (144, 186)] {
        let c = CGPoint(x: CGFloat(lx) * K, y: CGFloat(ly) * K)
        ctx.fill(Path(ellipseIn: CGRect(x: c.x - 70*K, y: c.y - 45*K, width: 140*K, height: 90*K)),
                 with: .radialGradient(Gradient(colors: [P.warmLight.opacity(0.13), P.warmLight.opacity(0)]),
                                       center: c, startRadius: 0, endRadius: 70*K))
    }
    let full = CGRect(x: 0, y: 0, width: CGFloat(SW)*K, height: CGFloat(SH)*K)
    ctx.fill(Path(full), with: .radialGradient(Gradient(colors: [.clear, .clear, Color.black.opacity(0.35)]),
                                               center: CGPoint(x: full.midX, y: full.midY * 1.1),
                                               startRadius: 0, endRadius: full.width * 0.62))
}

// MARK: - Workstations

// Top-left corner of the desk sprite for each slot (two rows of four)
func stationPos(_ idx: Int) -> (x: Int, y: Int) {
    (12 + (idx % 4) * 70, idx < 4 ? 70 : 124)
}

func poseFrame(_ status: AgentStatus, _ frame: Int) -> Int {
    switch status {
    case .working: return 3 + frame % 2
    case .reading: return 5 + (frame / 2) % 2
    case .idle, .done: return 1
    }
}

func drawEmptyDesk(_ ctx: inout GraphicsContext, slot: Int) {
    let (x, y) = stationPos(slot)
    sprite(&ctx, "DESK_FRONT", x: x, y: y)
    sprite(&ctx, "PC_BACK", x: x + 6, y: y - 6)
}

func drawStation(_ ctx: inout GraphicsContext, slot: Int, look: CharLook, status: AgentStatus, subs: [SubAgent], frame: Int) {
    let (x, y) = stationPos(slot)
    // Agent sits behind the desk, facing us, with the monitor turned towards them
    sprite(&ctx, Sprites.character(look.sheet, frame: poseFrame(status, frame)), x: x + 24, y: y - 14)
    sprite(&ctx, "DESK_FRONT", x: x, y: y)
    sprite(&ctx, "PC_BACK", x: x + 6, y: y - 6)
    if status == .working || status == .reading {
        let c = CGPoint(x: CGFloat(x + 14) * K, y: CGFloat(y + 2) * K)
        ctx.fill(Path(ellipseIn: CGRect(x: c.x - 16*K, y: c.y - 10*K, width: 32*K, height: 20*K)),
                 with: .radialGradient(Gradient(colors: [P.screenGlow.opacity(0.22), P.screenGlow.opacity(0)]),
                                       center: c, startRadius: 0, endRadius: 16*K))
    }
    // First subagent stands next to the desk; the name tag shows how many there are
    if let sub = subs.first {
        let f = sub.status == .working || sub.status == .reading ? 5 + (frame / 2) % 2 : 1
        sprite(&ctx, Sprites.character(STYLES[sub.charStyle % STYLES.count].sheet, frame: f), x: x + 50, y: y - 2)
    }
}

// MARK: - Mochi

let MOCHI_X = 139
let MOCHI_Y = 181

func drawMochi(_ ctx: inout GraphicsContext, frame: Int, awake: Bool) {
    let h = awake ? 10 : 7
    let x = MOCHI_X
    let y = MOCHI_Y + (awake ? (frame % 4 < 2 ? -4 : -5) : 0)
    let line = P.mochiLine
    // Rounded body with outline
    t(&ctx, x: x + 2, y: y - 1, w: 6, h: 1, c: line)
    t(&ctx, x: x + 1, y: y, c: line); t(&ctx, x: x + 8, y: y, c: line)
    t(&ctx, x: x, y: y + 1, w: 1, h: h - 2, c: line); t(&ctx, x: x + 9, y: y + 1, w: 1, h: h - 2, c: line)
    t(&ctx, x: x + 1, y: y + h - 1, c: line); t(&ctx, x: x + 8, y: y + h - 1, c: line)
    t(&ctx, x: x + 2, y: y + h, w: 6, h: 1, c: line)
    t(&ctx, x: x + 2, y: y, w: 6, h: 1, c: P.mochi)
    t(&ctx, x: x + 1, y: y + 1, w: 8, h: h - 2, c: P.mochi)
    t(&ctx, x: x + 2, y: y + h - 1, w: 6, h: 1, c: P.mochiSh)
    t(&ctx, x: x + 2, y: y + 1, w: 2, h: 1, c: .white)
    if awake {
        t(&ctx, x: x + 3, y: y + 3, w: 1, h: 2, c: P.eye)
        t(&ctx, x: x + 6, y: y + 3, w: 1, h: 2, c: P.eye)
        t(&ctx, x: x + 2, y: y + 5, c: P.cheek); t(&ctx, x: x + 7, y: y + 5, c: P.cheek)
        t(&ctx, x: x + 4, y: y + 6, w: 2, h: 1, c: P.mouth)
        if frame % 6 < 3 { t(&ctx, x: x + 11, y: y - 2, c: P.bldgLit) }
    } else {
        t(&ctx, x: x + 2, y: y + 3, w: 2, h: 1, c: line)
        t(&ctx, x: x + 6, y: y + 3, w: 2, h: 1, c: line)
        t(&ctx, x: x + 1, y: y + 4, c: P.cheek); t(&ctx, x: x + 8, y: y + 4, c: P.cheek)
    }
}

// MARK: - Scene

func statusIcon(_ s: AgentStatus) -> String {
    switch s {
    case .idle: return "💤"
    case .working: return "⚡"
    case .reading: return "📖"
    case .done: return "✅"
    }
}

// Everything inside the loft: pixel art plus name tags. Used by the live window and by --snapshot.
struct LoftStage: View {
    let agents: [LiveAgent]
    let services: [String]
    let frame: Int
    let mochiAwake: Bool
    var selectedId: String? = nil
    var selectedSubId: String? = nil
    var mochiSelected = false

    var seated: [LiveAgent] { agents.filter { $0.deskIdx >= 0 && $0.deskIdx < DESK_SLOTS } }

    var body: some View {
        ZStack(alignment: .topLeading) {
            Canvas { ctx, _ in
                drawRoom(&ctx, frame: frame)
                // Back row first so the front row overlaps it
                let taken = Set(seated.map(\.deskIdx))
                for slot in 0..<DESK_SLOTS where !taken.contains(slot) { drawEmptyDesk(&ctx, slot: slot) }
                for a in seated.sorted(by: { $0.deskIdx < $1.deskIdx }) {
                    drawStation(&ctx, slot: a.deskIdx, look: STYLES[a.charStyle % STYLES.count], status: a.status, subs: a.subagents, frame: frame)
                }
                drawMochi(&ctx, frame: frame, awake: mochiAwake)
                drawLighting(&ctx)
                let hl = GraphicsContext.Shading.color(P.neon.opacity(0.8))
                if mochiSelected {
                    ctx.stroke(Path(roundedRect: CGRect(x: 124*K, y: 160*K, width: 40*K, height: 36*K), cornerRadius: 6), with: hl, lineWidth: 2)
                }
                if let sid = selectedId, let a = seated.first(where: { $0.id == sid }) {
                    let (x, y) = stationPos(a.deskIdx)
                    if let subSid = selectedSubId, a.subagents.first?.id == subSid {
                        ctx.stroke(Path(roundedRect: CGRect(x: CGFloat(x + 51)*K, y: CGFloat(y - 2)*K, width: 14*K, height: 32*K), cornerRadius: 4), with: hl, lineWidth: 2)
                    } else {
                        ctx.stroke(Path(roundedRect: CGRect(x: CGFloat(x - 2)*K, y: CGFloat(y - 14)*K, width: 52*K, height: 46*K), cornerRadius: 6), with: hl, lineWidth: 2)
                    }
                }
            }

            // Name tags
            ForEach(seated) { a in
                let (x, y) = stationPos(a.deskIdx)
                let look = STYLES[a.charStyle % STYLES.count]
                HStack(spacing: 4) {
                    Text(statusIcon(a.status)).font(.system(size: 9))
                    if !a.terminal.isEmpty {
                        Text(a.terminal).font(.system(size: 8, weight: .bold, design: .rounded)).foregroundColor(.white.opacity(0.4))
                    }
                    Text(a.project).font(.system(size: 10, weight: .bold, design: .rounded)).foregroundColor(.white)
                    if !a.subagents.isEmpty {
                        Text("+\(a.subagents.count)").font(.system(size: 9, weight: .bold, design: .rounded)).foregroundColor(look.accent)
                    }
                    Text(a.shortId).font(.system(size: 8, weight: .medium, design: .monospaced)).foregroundColor(.white.opacity(0.35))
                }
                .lineLimit(1)
                .padding(.horizontal, 7).padding(.vertical, 3)
                .background(Capsule().fill(Color.black.opacity(0.6)))
                .overlay(Capsule().stroke(look.accent.opacity(0.7), lineWidth: 1))
                .frame(maxWidth: 200)
                .fixedSize()
                .position(x: CGFloat(x + 32) * K, y: CGFloat(y - 17) * K)
            }

            Text(mochiAwake ? "🍡 Mochi" : "🍡 zzz")
                .font(.system(size: 9, weight: .bold, design: .rounded))
                .foregroundColor(.white.opacity(mochiAwake ? 0.8 : 0.45))
                .padding(.horizontal, 6).padding(.vertical, 2)
                .background(Capsule().fill(Color.black.opacity(0.45)))
                .position(x: 144 * K, y: 170 * K)

            // Running dev services on the whiteboard
            VStack(alignment: .leading, spacing: 1) {
                ForEach(services.prefix(4), id: \.self) { s in
                    HStack(spacing: 3) {
                        Circle().fill(P.scrOn).frame(width: 4, height: 4)
                        Text(s).font(.system(size: 7, weight: .medium, design: .monospaced)).foregroundColor(Color(white: 0.25)).lineLimit(1)
                    }
                }
            }
            .frame(width: CGFloat(WB_W - 4) * K, height: CGFloat(WB_H - 2) * K, alignment: .topLeading)
            .position(x: CGFloat(WB_X + WB_W / 2) * K, y: CGFloat(WB_Y + WB_H / 2) * K)

            Text("AGENT LOFT")
                .font(.system(size: 14, weight: .heavy, design: .monospaced))
                .foregroundColor(P.neon)
                .shadow(color: P.neon.opacity(0.9), radius: 10)
                .shadow(color: P.neon.opacity(0.5), radius: 25)
                .position(x: CGFloat(SW) * K / 2, y: CGFloat(WALL_TOP) * K / 2)

            HStack(spacing: 6) {
                Circle().fill(agents.isEmpty ? .gray : P.scrOn).frame(width: 6, height: 6)
                Text("\(agents.count) agent\(agents.count == 1 ? "" : "s")")
                    .font(.system(size: 9, weight: .bold, design: .rounded))
                    .foregroundColor(.white.opacity(0.6))
                // Per-project chips only while they fit next to the title
                let grouped = Dictionary(grouping: agents, by: { $0.project.components(separatedBy: ":").first ?? $0.project })
                ForEach(grouped.count <= 3 ? Array(grouped.keys.sorted()) : [], id: \.self) { key in
                    Text("\(key) \(grouped[key]!.count)")
                        .font(.system(size: 8, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.4))
                        .padding(.horizontal, 4)
                        .padding(.vertical, 1)
                        .background(RoundedRectangle(cornerRadius: 3).fill(.white.opacity(0.08)))
                }
            }
            .lineLimit(1)
            .fixedSize()
            .frame(width: 320, height: CGFloat(WALL_TOP) * K, alignment: .trailing)
            .position(x: CGFloat(SW) * K - 170, y: CGFloat(WALL_TOP) * K / 2)
        }
        .frame(width: CGFloat(SW) * K, height: CGFloat(SH) * K)
    }
}

// MARK: - Snapshot
// `AgentLoft --snapshot out.png` renders the loft with demo agents and quits (handy for README screenshots).

@MainActor
func renderSnapshot(to path: String) {
    func demo(_ id: String, _ project: String, _ status: AgentStatus, style: Int, desk: Int, subs: [AgentStatus] = []) -> LiveAgent {
        LiveAgent(id: id, project: project, task: "", status: status, charStyle: style, deskIdx: desk, isRoutine: false,
                  arrived: Date(), cwd: "", subagents: subs.enumerated().map { i, s in
                      SubAgent(id: "\(id)-\(i)", status: s, charStyle: style + i + 1, task: "", cwd: "", activities: [])
                  }, activities: [], entrypoint: "cli", shortId: String(id.prefix(6)), terminal: "")
    }
    let agents = [
        demo("61ce94", "Process Views", .working, style: 0, desk: 0, subs: [.working]),
        demo("a16015", "rdp-latest-draft", .reading, style: 1, desk: 1),
        demo("4ad60b", "agent-loft", .working, style: 2, desk: 2),
        demo("2ed10c", "Home", .idle, style: 3, desk: 3),
        demo("9b41f2", "Obsidian Vault", .done, style: 4, desk: 5),
        demo("c07a33", "Video Editing", .working, style: 5, desk: 6, subs: [.reading, .working]),
    ]
    let renderer = ImageRenderer(content: LoftStage(agents: agents, services: ["bun dev :3000", "next dev :4000"], frame: 3, mochiAwake: false)
        .background(Color(red: 0.08, green: 0.06, blue: 0.12)))
    renderer.scale = 2
    guard let cg = renderer.cgImage,
          let png = NSBitmapImageRep(cgImage: cg).representation(using: .png, properties: [:]) else { return }
    try? png.write(to: URL(fileURLWithPath: path))
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

                TimelineView(.periodic(from: .now, by: 0.35)) { tl in
                    LoftStage(agents: agents, services: services, frame: Int(tl.date.timeIntervalSince1970 / 0.35),
                              mochiAwake: mochiAwake, selectedId: selectedId, selectedSubId: selectedSubId, mochiSelected: mochiSelected)
                }
                .contentShape(Rectangle())
                .onTapGesture { loc in
                    let px = Int(loc.x / K), py = Int(loc.y / K)
                    // Mochi on the couch
                    if px >= 124 && px <= 164 && py >= 160 && py <= 196 {
                        mochiSelected.toggle(); selectedId = nil; selectedSubId = nil; return
                    }
                    for a in agents where a.deskIdx >= 0 && a.deskIdx < DESK_SLOTS {
                        let (x, y) = stationPos(a.deskIdx)
                        if let sub = a.subagents.first, px >= x + 52 && px <= x + 64 && py >= y - 2 && py <= y + 30 {
                            mochiSelected = false; selectedId = a.id; selectedSubId = selectedSubId == sub.id ? nil : sub.id; return
                        }
                        if px >= x - 2 && px <= x + 50 && py >= y - 22 && py <= y + 32 {
                            mochiSelected = false; selectedSubId = nil; selectedId = selectedId == a.id ? nil : a.id; return
                        }
                    }
                    mochiSelected = false; selectedId = nil; selectedSubId = nil
                }

                if agents.isEmpty && scanCount > 0 {
                    VStack(spacing: 3) {
                        Text("The loft is quiet...")
                        Text("Start Claude Code in a terminal")
                        Text(debugInfo)
                            .font(.system(size: 8, design: .monospaced))
                            .foregroundColor(.yellow.opacity(0.5))
                    }
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.5))
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.black.opacity(0.5)))
                    .position(x: CGFloat(SW)*K/2, y: 110*K)
                }
            }
            .frame(width: CGFloat(SW)*K, height: CGFloat(SH)*K)
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
                                    Circle().fill(STYLES[a.charStyle % STYLES.count].accent).frame(width: 8, height: 8)
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
                                            Circle().fill(STYLES[sub.charStyle % STYLES.count].accent).frame(width: 5, height: 5)
                                            let icon = statusIcon(sub.status)
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
                                    Circle().fill(STYLES[sub.charStyle % STYLES.count].accent).frame(width: 10, height: 10)
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
                                    Circle().fill(STYLES[a.charStyle % STYLES.count].accent).frame(width: 14, height: 14)
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
                                                    Circle().fill(STYLES[sub.charStyle % STYLES.count].accent).frame(width: 8, height: 8)
                                                    let icon = statusIcon(sub.status)
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
        let totalDesks = DESK_SLOTS
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
