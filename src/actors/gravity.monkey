Strict

Import mojo2
Import actors.actor
Import graphics.screen
Import system.time

Class Gravity

	Const GRAVITY:Float = 300.0

	Function applyTo:Void(actor:Actor)
		actor.speedY -= GRAVITY * Time.instance.getDeltaInSecs()
		If (actor.y + actor.boxHeight - actor.yShift > Screen.GroundHeight)
			actor.y = Screen.GroundHeight - actor.boxHeight
		EndIf
	End Function

End Class
