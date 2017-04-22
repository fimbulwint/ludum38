Strict

Import mojo2
Import actors.behaviors.controllable
Import actors.actor
Import graphics.assets
Import graphics.screen

Class Survivor Extends Actor

	Method New()
		behavior = New Controllable(Self)
		x = Screen.Width / 2
		y = Screen.GroundHeight - 60.0
		z = 0.0
		image = Assets.instance.graphics.Get(Assets.GFX_SURVIVOR)
	End Method

End Class