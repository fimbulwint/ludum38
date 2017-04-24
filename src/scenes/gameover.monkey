Strict

Import mojo2
Import scenes.scene
Import graphics.assets
Import graphics.screen

Class GameOver Implements Scene

	Field image:Image = Assets.instance.graphics.Get(Assets.GFX_GAME_OVER)

	Method Update:Void()
	End Method
	
	Method Draw:Void(canvas:Canvas)
		canvas.PushMatrix()
		canvas.SetAlpha(1.0)
		canvas.SetBlendMode(BlendMode.Alpha)
		canvas.SetColor(1.0, 1.0, 1.0)
		canvas.DrawImage(image, 0.0, 0.0)
		canvas.PopMatrix()
	End Method
	
	Method GetSceneResult:String()
		Return Scene.STILL_CURRENT_SCENE
	End Method
	
	Method Finish:Void()
	End Method
	
End Class