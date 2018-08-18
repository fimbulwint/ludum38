Strict

Import mojo2
Import actors.actor
Import graphics.screen
Import sprites.sprite
Import system.time

Class Gravity

	Const GRAVITY:Float = 300.0

	Function applyTo:Void(actor:Actor)
		If (actor.gravityBound And Not actor.IsOnTrain() And Not actor.IsOnGround())
			actor.speedY += GRAVITY * Time.instance.getDeltaInSecs()
			
			If (actor.y + actor.GetBoxHeight() - actor.boxUp > Ground.GROUND_HEIGHT)
                actor.y = actor.GetHeightOnTopOfGround()
				actor.speedY = 0.0
			EndIf
		End If
	End Function
	
	Function applyTo:Void(sprite:Sprite)
		' sprites handle their collisions
		sprite.speedY += GRAVITY * Time.instance.getDeltaInSecs()
	End Function

End Class
