Strict

Import actors.actor
Import graphics.assets
Import graphics.screen

Class Train Extends Actor
	Const TRAIN_SPEED:Float = 1000.0 ' used to determine object speed when touching ground
	
	Method New()
		behavior = New EmptyBehavior()
		x = 0.0
		y = Screen.GroundHeight - 1.0
		z = 100.0
		image = Assets.instance.graphics.Get(Assets.GFX_TRAIN)
	End Method
End Class