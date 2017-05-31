Strict

Import mojo2
Import actors.actor
Import graphics.screen
Import system.time

Class Gravity

	Const GRAVITY:Float = 300.0

	Function applyTo:Void(actor:Actor)
		If (actor.gravityBound And Not actor.IsOnTrain() And Not actor.IsOnGround())
			actor.speedY += GRAVITY * Time.instance.getDeltaInSecs()
			
			If (actor.y + actor.boxHeight - actor.yShift > Ground.GROUND_HEIGHT)
                actor.y = actor.GetHeightOnTopOfGround()
				actor.speedY = 0.0
			EndIf
		End If
	End Function

End Class
