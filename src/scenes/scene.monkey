Strict

Interface Scene

	Const STILL_CURRENT_SCENE:String = ""
	Const RESULT_END:String = "RESULT_END"

	Method OnUpdate:Void()
	Method OnRender:Void()
	
	Method GetSceneResult:String()
	
	Method Finish:Void()
End Interface
