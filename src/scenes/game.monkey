Strict

Import mojo2
Import scenes.scene
Import sound.dj
Import world.world

Class Game Implements Scene

	Const PLAYER_X_TO_TRANSIT_TO_GAME_OVER:Float = -200.0 

	Field world:World = New World()

	Method New()
		Dj.instance.PlayMusic(Dj.MUSIC_INGAME)
	End Method
	
	Method Update:Void()
		world.Update()
	End Method
	
	Method Draw:Void(canvas:Canvas)
		world.Draw(canvas)
	End Method
	
	Method GetSceneResult:String()
		Local survivor:Survivor = Survivor(world.worldState.mainActors.First())
		If (survivor.IsDead() And survivor.x < PLAYER_X_TO_TRANSIT_TO_GAME_OVER)
			Return Scene.RESULT_END
		EndIf
		
		Return Scene.STILL_CURRENT_SCENE
	End Method
	
	Method Finish:Void()
		Time.instance.timeDistortion = 1.0
	End Method
	
End Class