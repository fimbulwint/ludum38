Strict

Import mojo2
Import actors.behaviors.behavior

Class Actor

	Field behavior:Behavior
	
	' Drawing parameters
	Field blend:Int = BlendMode.Alpha
	Field alpha:Float = 1.0
	Field x:Float, y:Float, z:Float
	Field r:Float = 1.0
	Field g:Float = 1.0
	Field b:Float = 1.0
	Field x:Float, y:Float, z:Float
	Field angle:Float
	Field sizeX:Float = 1.0
	Field sizeY:Float = 1.0
	Field image:Image = Null
	
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

End Class
