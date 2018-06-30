Strict

Import mojo2
Import graphics.assets
Import sprites.fallingDebrisUtils

Class Helmet Extends Sprite

	Const RADIUS:Float = 10

	Method New(x:Float, y:Float, vx:Float)
		Self.x = x
		Self.y = y
		z = -10.0
		image = Assets.instance.graphics.Get(Assets.GFX_MISC_HELMET)
		FallingDebrisUtils.AssignRandomAngularSpeed(Self)
		speedY = Rnd(-150.0, -100.0)
		speedX = vx * Rnd(0.8, 1.2) ' slight variation
	End Method

	Method CorrectMovement:Void(world:World)
		FallingDebrisUtils.BounceOffTheGround(Self, RADIUS)
	End Method
	
End Class
