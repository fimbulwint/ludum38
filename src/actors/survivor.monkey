Strict

Import mojo2
Import actors.behaviors.controllable
Import actors.actor
Import graphics.assets

Class Survivor Extends Actor

	Method New()
		behavior = New Controllable()
		image = Assets.instance.graphics.Get(Assets.GFX_SURVIVOR)
	End Method

End Class