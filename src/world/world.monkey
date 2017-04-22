Strict

Import graphics.screen
Import mojo2 
Import world.ground
Import world.train


Class World
	Field ground:Ground
	Field train:Train

	Method New()
		ground = New Ground()
		train = New Train()
	End Method
	
	Method Update:Void()
		ground.Update()
		train.Update()
	End Method
	
	Method Draw:Void(canvas:Canvas)
		ground.Draw(canvas)
		train.Draw(canvas)
	End Method
	
End Class