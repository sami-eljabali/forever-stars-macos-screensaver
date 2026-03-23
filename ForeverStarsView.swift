import ScreenSaver
import QuartzCore

public let starWidth: CGFloat = 3.2

private let fps: CGFloat = 60
private let starCount = 1200

private let changeColorAndSpeedIntervalSeconds: CGFloat = 10
private let randomizeSpeedEnabled = false
private let randomizeColorEnabled = false

private let starStartSpeed: CGFloat = 3
private let starTopSpeed: CGFloat = 100

private let starStartRedColor: CGFloat = 0.7
private let starStartGreenColor: CGFloat = 0.7
private let starStartBlue: CGFloat = 0.7

private let starEndRedColor: CGFloat = 1.0
private let starEndGreenColor: CGFloat = 1.0
private let starEndBlueColor: CGFloat = 1.0


@objc(ForeverStarsView)
class ForeverStarsView: ScreenSaverView {

    var stars: [Star] = []
    var redColor: CGFloat = starStartRedColor
    var greenColor: CGFloat = starStartGreenColor
    var blueColor: CGFloat = starStartBlue
    private var overallSpeed: CGFloat = starStartSpeed

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
        overallSpeed = starStartSpeed
        redColor = starStartRedColor
        greenColor = starStartGreenColor
        blueColor = starStartBlue

        // Initialize stars
        let width = max(frame.width, 800)
        let height = max(frame.height, 600)
        stars = (0..<starCount).map { _ in
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

        // Timer driving animation's frames per second, added to .common mode so it fires
        // reliably inside the legacyScreenSaver process regardless of run loop mode.
        let anim = Timer(timeInterval: 1.0 / fps, target: self,
                         selector: #selector(animationTick),
                         userInfo: nil, repeats: true)
        RunLoop.current.add(anim, forMode: .common)
        animationTimer = anim

        // Timer to change color and speed
        let timer = Timer(timeInterval: changeColorAndSpeedIntervalSeconds,
                          target: self,
                          selector: #selector(randomizeAppearance),
                          userInfo: nil,
                          repeats: true
        )
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
        if randomizeSpeedEnabled {
            overallSpeed = CGFloat.random(in: starStartSpeed...starTopSpeed)
        }
        if randomizeColorEnabled {
            redColor = CGFloat.random(in: starStartRedColor...starEndRedColor)
            greenColor = CGFloat.random(in: starStartGreenColor...starEndGreenColor)
            blueColor = CGFloat.random(in: starStartBlue...starEndBlueColor)
        }
    }

    // MARK: - Configuration

    override var hasConfigureSheet: Bool { false }
    override var configureSheet: NSWindow? { nil }
}
