Strict

Import mojo2
Import actors.behaviors.controllable
Import actors.actor
Import graphics.assets
Import graphics.screen
Import system.time

Class Survivor Extends Actor

	Const BASE_LATERAL_SPEED:Float = 300.0
	Const JUMP_SPEED:Float = 250.0

	Method New()
		behavior = New Controllable(Self)
		x = Screen.Width / 2
		y = Screen.GroundHeight - boxHeight
		z = 0.0
		image = Assets.instance.graphics.Get(Assets.GFX_SURVIVOR)
		
		Super.PostConstruct()
	End Method
	
	Method TryToMove:Void(worldState:WorldState)
		Local deltaInSecs:Float = Time.instance.getDeltaInSecs()
	
		'if all goes well (no collisions and stuff), move
		
		If (movingLeft)
			speedX = -BASE_LATERAL_SPEED
		ElseIf(movingRight)
			speedX = BASE_LATERAL_SPEED
		Else
			speedX = 0.0
		EndIf
		
		x += speedX * deltaInSecs
		If (OverflowingLeft())
			x = -xShift
		ElseIf(OverflowingRight())
			x = Screen.Width - boxWidth + xShift
		EndIf

		If (jumping And y = Screen.GroundHeight - boxHeight)
			speedY = JUMP_SPEED
		EndIf

		y -= speedY * deltaInSecs
		
	End Method
	
Private
	Method OverflowingLeft:Bool()
		Return x - xShift < 0
	End Method
	
	Method OverflowingRight:Bool()
		Return x + boxWidth - xShift > Screen.Width
	End Method

End Class