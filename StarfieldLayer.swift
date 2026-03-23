import QuartzCore

class StarfieldLayer: CALayer {
    private let starWidth: CGFloat = 1.5

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
        ctx.setLineWidth(starWidth)

        // Draw all stars as lines from old position to new position
        for star in view.stars {
            ctx.move(to: CGPoint(x: star.oldScreenX, y: star.oldScreenY))
            ctx.addLine(to: CGPoint(x: star.screenX, y: star.screenY))
        }
        ctx.strokePath()
    }
}
