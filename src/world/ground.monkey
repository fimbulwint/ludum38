Strict

Import actors.actor
Import graphics.screen
Import mojo2

Class Ground Extends Actor
	Method New()
		behavior = New EmptyBehavior()
	End Method

	Method Draw:Void(canvas:Canvas)
		canvas.PushMatrix()
		canvas.SetAlpha(1.0)
		canvas.SetBlendMode(BlendMode.Alpha)
		canvas.SetColor(0.0, 0.6, 0.0)
		canvas.DrawRect(0.0, Screen.GroundHeight, Screen.Width, Screen.Height - Screen.GroundHeight)
		canvas.PopMatrix()
	End Method	
End Class
