Strict

Import actors.actor
Import graphics.assets
Import graphics.screen

Class Train Extends Actor
	Method New()
		behavior = New EmptyBehavior()
		x = 0.0
		y = Screen.GroundHeight - 1.0
		z = 100.0
		image = Assets.instance.graphics.Get(Assets.GFX_TRAIN)
	End Method
End Class