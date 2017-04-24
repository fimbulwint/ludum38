Strict

Import mojo2
Import scenes.scene
Import sound.dj
Import world.world

Class Menu Implements Scene
	Const SHINE_SPEED:Float = 0.15

	Field img:Image
	Field shine:Float = -0.5
	
	Method New()
		img = Assets.instance.graphics.Get(Assets.GFX_TITLE)
		Dj.instance.PlayMusic(Dj.SFX_TRAIN)
	End Method
	
	Method Update:Void()
		Local delta:Float = Time.instance.getDeltaInSecs()
		shine += delta * SHINE_SPEED
		If (shine > 0.5) Then shine = -0.5
	End Method
	
	Method Draw:Void(canvas:Canvas)
		canvas.PushMatrix()
		canvas.SetBlendMode(BlendMode.Alpha)
		canvas.SetAlpha(1.0)
		canvas.SetColor(1.0, 1.0, 1.0)
		canvas.DrawImage(img, 0.0, 0.0)
		canvas.SetBlendMode(BlendMode.Additive)
		canvas.SetAlpha(Abs(shine))
		canvas.SetColor(1.0, 1.0, 1.0)
		canvas.DrawImage(img, 0.0, 0.0)
		canvas.PopMatrix()
	End Method
	
	Method GetSceneResult:String()
		If (KeyHit(KEY_SPACE)) Then Return Scene.RESULT_END
		Return Scene.STILL_CURRENT_SCENE
	End Method
	
	Method Finish:Void()
		Dj.instance.StopMusic()
	End Method
	
End Class