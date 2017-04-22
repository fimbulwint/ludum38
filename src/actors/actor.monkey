Strict

Import mojo2
Import actors.behaviors.behavior
Import world.world
Import system.time

Class Actor

	Const BASE_LATERAL_SPEED:Float = 200.0

	Field behavior:Behavior
	
	' Drawing parameters
	Field blend:Int = BlendMode.Alpha
	Field alpha:Float = 1.0
	Field x:Float, y:Float, z:Float
	Field r:Float = 1.0
	Field g:Float = 1.0
	Field b:Float = 1.0
	Field angle:Float
	Field sizeX:Float = 1.0
	Field sizeY:Float = 1.0
	Field image:Image = Null
	
	Field movingLeft:Bool
	Field movingRight:Bool
	Field jumping:Bool
	
	Field speedX:Float
	
	Method New()
	End Method
	
	Method Update:Void()
		behavior.Update()
	End Method
	
	Method Draw:Void(canvas:Canvas)
		If (image <> Null)
			canvas.PushMatrix()
			canvas.SetBlendMode(blend)
			canvas.SetAlpha(alpha)
			canvas.SetColor(r, g, b)
			canvas.DrawImage(image, x, y, angle, sizeX, sizeY)
			canvas.PopMatrix()
		End If
	End Method
	
	Method CompleteMovement:Void(worldState:WorldState)
		'if no collissions, move
		Local deltaInSecs:Float = Time.instance.realLastFrame / 1000
	
		If (movingLeft)
			speedX = -BASE_LATERAL_SPEED
		ElseIf(movingRight)
			speedX = BASE_LATERAL_SPEED
		EndIf
		
		x += deltaInSecs + speedX
	End Method

End Class
