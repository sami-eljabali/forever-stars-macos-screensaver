import ScreenSaver
import QuartzCore

// MARK: - Star Model

private struct Star {
    var x: CGFloat
    var y: CGFloat
    var z: CGFloat
    var speed: CGFloat
    var oldScreenX: CGFloat = 0
    var oldScreenY: CGFloat = 0
    var screenX: CGFloat = 0
    var screenY: CGFloat = 0
}

// MARK: - Starfield Layer

private class StarfieldLayer: CALayer {

    weak var starfieldView: ForeverStarsView?

    override func action(forKey event: String) -> (any CAAction)? {
        // Disable all implicit animations
        return NSNull()
    }

    override func draw(in ctx: CGContext) {
        guard let view = starfieldView else { return }

        let bounds = self.bounds

        // Paint the background black
        ctx.setFillColor(CGColor.black)
        ctx.fill(bounds)

        // Set the star color
        ctx.setStrokeColor(CGColor(
            red: view.redColor,
            green: view.greenColor,
            blue: view.blueColor,
            alpha: 1.0
        ))
        ctx.setLineWidth(1.5)

        // Draw all stars as lines from old position to new position
        for star in view.stars {
            ctx.move(to: CGPoint(x: star.oldScreenX, y: star.oldScreenY))
            ctx.addLine(to: CGPoint(x: star.screenX, y: star.screenY))
        }
        ctx.strokePath()
    }
}

// MARK: - Forever Stars View

@objc(ForeverStarsView)
class ForeverStarsView: ScreenSaverView {

    private static let starCount = 500
    private static let starTopSpeed: CGFloat = 200

    fileprivate var stars: [Star] = []
    fileprivate var redColor: CGFloat = 1.0
    fileprivate var greenColor: CGFloat = 1.0
    fileprivate var blueColor: CGFloat = 1.0
    private var overallSpeed: CGFloat = 50

    private var animationTimer: Timer?
    private var colorTimer: Timer?

    // MARK: - Initialization

    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        wantsLayer = true
        animationTimeInterval = 1.0 / 60.0

        // Randomize initial color and speed
        overallSpeed = CGFloat.random(in: 20...Self.starTopSpeed)
        redColor = CGFloat.random(in: 0.1...1.0)
        greenColor = CGFloat.random(in: 0.1...1.0)
        blueColor = CGFloat.random(in: 0.1...1.0)

        // Initialize stars
        let width = max(frame.width, 800)
        let height = max(frame.height, 600)
        stars = (0..<Self.starCount).map { _ in
            Star(
                x: CGFloat.random(in: -(width * 2)...(width * 2)),
                y: CGFloat.random(in: -(height * 2)...(height * 2)),
                z: CGFloat.random(in: 100...500),
                speed: CGFloat.random(in: 1...10)
            )
        }
    }

    // MARK: - Layer Setup

    override func makeBackingLayer() -> CALayer {
        let starfield = StarfieldLayer()
        starfield.starfieldView = self
        starfield.isOpaque = true
        starfield.backgroundColor = CGColor.black
        starfield.contentsScale = window?.backingScaleFactor ?? 2.0
        return starfield
    }

    override var wantsUpdateLayer: Bool { true }

    // MARK: - Animation Lifecycle

    override func startAnimation() {
        super.startAnimation()

        // Update layer scale for current screen
        if let scale = window?.backingScaleFactor {
            layer?.contentsScale = scale
        }

        // Timer drives animation at ~60fps, added to .common mode so it fires
        // reliably inside the legacyScreenSaver process regardless of run loop mode.
        let anim = Timer(timeInterval: 1.0 / 60.0, target: self,
                         selector: #selector(animationTick),
                         userInfo: nil, repeats: true)
        RunLoop.current.add(anim, forMode: .common)
        animationTimer = anim

        // Timer to change color and speed every 10 seconds
        let timer = Timer(timeInterval: 10.0, target: self,
                         selector: #selector(randomizeAppearance),
                         userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .common)
        colorTimer = timer
    }

    override func stopAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
        colorTimer?.invalidate()
        colorTimer = nil
        super.stopAnimation()
    }

    // MARK: - Animation

    @objc private func animationTick() {
        updateStars()
        layer?.setNeedsDisplay()
    }

    override func animateOneFrame() {
        // Fallback if the framework calls this directly
        updateStars()
        layer?.setNeedsDisplay()
    }

    private func updateStars() {
        let width = bounds.width
        let height = bounds.height
        let halfWidth = width / 2
        let halfHeight = height / 2

        for i in stars.indices {
            // Save old screen position
            stars[i].oldScreenX = (stars[i].x / stars[i].z) * 500 + halfWidth
            stars[i].oldScreenY = (stars[i].y / stars[i].z) * 500 + halfHeight

            // Move star closer (decrease z)
            stars[i].z -= (stars[i].speed + overallSpeed)

            // Compute new screen position
            stars[i].screenX = (stars[i].x / stars[i].z) * 500 + halfWidth
            stars[i].screenY = (stars[i].y / stars[i].z) * 500 + halfHeight

            // Reset star if off-screen or past camera
            if stars[i].screenX > width || stars[i].screenX < 0 ||
               stars[i].screenY > height || stars[i].screenY < 0 ||
               stars[i].z <= 0 {
                stars[i].speed = CGFloat.random(in: 1...10)
                stars[i].x = CGFloat.random(in: -(width * 2)...(width * 2))
                stars[i].y = CGFloat.random(in: -(height * 2)...(height * 2))
                stars[i].z = CGFloat.random(in: 100...10000)
                stars[i].oldScreenX = stars[i].screenX
                stars[i].oldScreenY = stars[i].screenY
            }
        }
    }

    @objc private func randomizeAppearance() {
        overallSpeed = CGFloat.random(in: 20...Self.starTopSpeed)
        redColor = CGFloat.random(in: 0.1...1.0)
        greenColor = CGFloat.random(in: 0.1...1.0)
        blueColor = CGFloat.random(in: 0.1...1.0)
    }

    // MARK: - Configuration

    override var hasConfigureSheet: Bool { false }
    override var configureSheet: NSWindow? { nil }
}
