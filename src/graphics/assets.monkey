Strict

Import mojo2

Class Assets
	Global instance:Assets = New Assets()
	
	Const GFX_TRAIN:String = "train.png"
	Const GFX_SURVIVOR:String = "survivor.png"
	
	Field graphics:Map<String, Image> = New StringMap<Image>
	
	Method New()
		graphics.Add(GFX_TRAIN, Image.Load(GFX_TRAIN, 0.0, 1.0))
		graphics.Add(GFX_SURVIVOR, Image.Load(GFX_SURVIVOR, 0.5, 0.0))
	End Method
	
End Class