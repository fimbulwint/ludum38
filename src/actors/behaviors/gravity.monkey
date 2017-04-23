Strict

Import mojo2
Import actors.actor
Import graphics.screen
Import system.time

Class Gravity

	Const GRAVITY:Float = 300.0

	Function applyTo:Void(actor:Actor)
		If (Not actor.IsOnTrain() And Not actor.IsOnGround())
			actor.speedY -= GRAVITY * Time.instance.getDeltaInSecs()
			
			If (actor.hp > 0.0 And actor.y + actor.boxHeight - actor.yShift > Screen.GroundHeight)
				actor.y = Screen.GroundHeight - actor.boxHeight + actor.yShift
			EndIf
		End If
	End Function

End Class
