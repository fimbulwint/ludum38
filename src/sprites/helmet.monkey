Strict

Import mojo2
Import actors.actor
Import graphics.assets
Import graphics.screen
Import system.time
Import world.ground

Class Helmet Extends Sprite

	Const RADIUS:Float = 10

	Method New(x:Float, y:Float, vx:Float)
		Self.x = x
		Self.y = y
		z = -10.0
		image = Assets.instance.graphics.Get(Assets.GFX_MISC_HELMET)
		AssignRandomAngularSpeed()
		speedY = Rnd(-150.0, -100.0)
		speedX = vx * Rnd(0.8, 1.2) ' slight variation
	End Method

	Method CorrectMovement:Void(world:World)
		If (y >= Ground.GROUND_HEIGHT - RADIUS)
			AssignRandomAngularSpeed()
			speedX = -Train.TRAIN_SPEED
			speedY = -speedY * Rnd(0.5, 0.7)
			y = Ground.GROUND_HEIGHT - RADIUS
		End If
	End Method
	
	Method AssignRandomAngularSpeed:Void()
		angularSpeed = Rnd(360.0 * 2.0, 360.0 * 5.0)
		If (Rnd(0.0, 100.0) < 50.0) Then angularSpeed = -angularSpeed
	End Method
	
End Class
