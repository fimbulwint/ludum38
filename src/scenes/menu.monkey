Strict

Import mojo2
Import scenes.scene
Import sound.dj
Import world.world

Class Menu Implements Scene

	Field img:Image
	
	Method New()
		img = Assets.instance.graphics.Get(Assets.GFX_TITLE)
		Dj.instance.PlayMusic(Dj.SFX_TRAIN)
	End Method
	
	Method Update:Void()
	End Method
	
	Method Draw:Void(canvas:Canvas)
		canvas.PushMatrix()
		canvas.SetBlendMode(BlendMode.Alpha)
		canvas.SetAlpha(1.0)
		canvas.SetColor(1.0, 1.0, 1.0)
		canvas.DrawImage(img, 0.0, 0.0)
		canvas.PopMatrix()
	End Method
	
	Method GetSceneResult:String()
		If (KeyHit(KEY_SPACE)) Then Return Scene.RESULT_END
		Return Scene.STILL_CURRENT_SCENE
	End Method
	
	Method Finish:Void()
	End Method
	
End Class