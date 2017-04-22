Strict

Import mojo2

Class Assets
	Global instance:Assets = New Assets()
	
	Const GFX_TRAIN:String = "train.png"
	
	Field graphics:Map<String, Image> = New StringMap<Image>
	
	
	Method New()
		graphics.Add(GFX_TRAIN, Image.Load(GFX_TRAIN, .0, 1.0))
	End Method
	
End Class