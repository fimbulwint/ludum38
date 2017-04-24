Strict

Import mojo2
Import scenes.scene
Import sound.dj
Import world.world

Class Game Implements Scene

	Field world:World = New World()

	Method New()
		Dj.instance.PlayInGameMusic()
	End Method
	
	Method Update:Void()
		world.Update()
	End Method
	
	Method Draw:Void(canvas:Canvas)
		world.Draw(canvas)
	End Method
	
	Method GetSceneResult:String()
		Return Scene.STILL_CURRENT_SCENE
	End Method
	
	Method Finish:Void()
	End Method
	
End Class