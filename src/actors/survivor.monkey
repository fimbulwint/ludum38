Strict

Import mojo2
Import actors.behaviors.controllable
Import actors.actor
Import graphics.assets
Import graphics.screen

Class Survivor Extends Actor

	Method New()
		behavior = New Controllable()
		x = 0.0
		y = Screen.GroundHeight - 1.0
		image = Assets.instance.graphics.Get(Assets.GFX_SURVIVOR)
	End Method

End Class