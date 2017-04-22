Strict

Import drawable
Import mojo2
Import actors.behaviors.behavior
Import world.world
Import system.time
Import graphics.screen

Class Actor Extends Drawable

	Const BASE_LATERAL_SPEED:Float = 200.0

	Field behavior:Behavior
	
	' Drawing parameters
	Field blend:Int = BlendMode.Alpha
	Field alpha:Float = 1.0
	Field x:Float, y:Float
	Field r:Float = 1.0
	Field g:Float = 1.0
	Field b:Float = 1.0
	Field angle:Float
	Field sizeX:Float = 1.0
	Field sizeY:Float = 1.0
	Field image:Image = Null
	Field imageHandleXShift:Float = 0.0
	
	' Movement
	Field movingLeft:Bool
	Field movingRight:Bool
	Field jumping:Bool
	Field speedX:Float
	Field boxWidth:Float
	Field boxHeight:Float
	
	Method New()
	End Method
	
	Method PostConstruct:Void()
		boxWidth = image.Width()
		boxHeight = image.Height()
		imageHandleXShift = image.HandleX * boxWidth
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
		Else
			speedX = 0.0
		EndIf
		
		x += speedX * deltaInSecs
		If (OverflowingLeft())
			x = 0
		ElseIf(OverflowingRight())
			x = Screen.Width - 0.5 * boxWidth + imageHandleXShift
		EndIf
	End Method
	
Private
	Method OverflowingLeft:Bool()
		Return x - 0.5 * boxWidth + imageHandleXShift < 0
	End Method
	
	Method OverflowingRight:Bool()
		Return x + 0.5 * boxWidth - imageHandleXShift > Screen.Width
	End Method

End Class
