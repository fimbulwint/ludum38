Strict

Import graphics.animator 
Import graphics.screen
Import lifecycleaware
Import mojo2
Import world.world
Import system.time
Import world.gravity

Class Sprite Extends LifecycleAware Abstract

    Const SIDE_CLIPPING_DISTANCE:Float = 100

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

	' Movement	
	Field speedX:Float
	Field speedY:Float
	Field angularSpeed:Float
	
	Method Update:Void(world:World)
		Move(world)
		Gravity.applyTo(Self)
		
		Local deltaInSecs:Float = Time.instance.getDeltaInSecs()
		x += speedX * deltaInSecs
		y += speedY * deltaInSecs
		angle += angularSpeed * deltaInSecs

		CorrectMovement(world)
		If (x + SIDE_CLIPPING_DISTANCE < 0 or x - SIDE_CLIPPING_DISTANCE > Screen.WIDTH)
			world.RemoveLifecycleAware(Self)
		EndIf
	End Method

	Method Move:Void(world:World)
	End Method
	
	Method CorrectMovement:Void(world:World)
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


End Class