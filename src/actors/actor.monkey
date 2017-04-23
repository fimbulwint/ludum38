Strict

Import lifecycleaware
Import mojo2
Import actors.behaviors.behavior
Import actors.gravity
Import world.world
Import graphics.screen

Class Actor Extends LifecycleAware

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
	Field xShift:Float = 0.0
	Field yShift:Float = 0.0
	
	' Movement
	Field movingLeft:Bool
	Field movingRight:Bool
	Field jumping:Bool
	Field speedX:Float
	Field speedY:Float
	Field boxWidth:Float
	Field boxHeight:Float
	
	Method New()
	End Method
	
	Method PostConstruct:Void()
		boxWidth = image.Width()
		boxHeight = image.Height()
		xShift = image.HandleX * boxWidth
		yShift = image.HandleY * boxHeight
	End Method
	
	Method Update:Void(worldState:WorldState)
		behavior.Update()
		TryToMove(worldState)
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
	
	Method TryToMove:Void(worldState:WorldState)
		'if all goes well (no collisions), move
		Move()
		Gravity.applyTo(Self)
	End Method
	
	Method Move:Void()
	End Method

End Class
