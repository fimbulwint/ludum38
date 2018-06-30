Strict

Import mojo2
Import sprites.sprite
Import world.ground
Import world.train

Class FallingDebrisUtils

	Function AssignRandomAngularSpeed:Void(sprite:Sprite)
		sprite.angularSpeed = Rnd(360.0 * 2.0, 360.0 * 5.0)
		If (Rnd(0.0, 100.0) < 50.0) Then sprite.angularSpeed = -sprite.angularSpeed
	End Function
	
	Function BounceFromGround:Void(sprite:Sprite, radius:Float)
		If (sprite.y >= Ground.GROUND_HEIGHT - radius)
			AssignRandomAngularSpeed(sprite)
			sprite.speedX = -Train.TRAIN_SPEED
			sprite.speedY = -sprite.speedY * Rnd(0.5, 0.7)
			sprite.y = Ground.GROUND_HEIGHT - radius
		End If
	End Function

End Class