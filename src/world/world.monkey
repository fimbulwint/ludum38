Strict

Import graphics.screen
Import mojo2 
Import world.train

Class World
	Field train:Train

	Method New()
		train = New Train()
	End Method
	
	Method Update:Void()
		train.Update()
	End Method
	
	Method Draw:Void(canvas:Canvas)
		canvas.PushMatrix()
		canvas.SetAlpha(1.0)
		canvas.SetBlendMode(BlendMode.Alpha)
		canvas.SetColor(0.0, 0.6, 0.0)
		canvas.DrawRect(0.0, Screen.GroundHeight, Screen.Width, Screen.Height - Screen.GroundHeight)
		train.Draw(canvas)
		canvas.PopMatrix()
	End Method
	
End Class