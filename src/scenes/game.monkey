Strict

Import mojo2
Import scenes.scene
Import sound.dj
Import world.world

Class Game Implements Scene

	Field world:World = New World()
	Field countDownToGameOver:Int = 100

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
		If (countDownToGameOver = 0)
			Return Scene.RESULT_END
		EndIf
		
		Local survivor:Survivor = Survivor(world.worldState.mainActors.First())
		If (survivor.hp <= 0.0)
			countDownToGameOver -= 1
		EndIf
		
		Return Scene.STILL_CURRENT_SCENE
	End Method
	
	Method Finish:Void()
	End Method
	
End Class