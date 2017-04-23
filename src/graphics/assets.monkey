Strict

Import mojo2

Class Assets
	Global instance:Assets = New Assets()
	
	Const GFX_TRAIN:String = "train.png"
	
	Const GFX_SURVIVOR:String = "survivor.png"
	
	Const GFX_BD_MOUNTAINS_0101:String = "bd_mountains_0101.png"
	Const GFX_BD_MOUNTAINS_0102:String = "bd_mountains_0102.png"
	Const GFX_BD_MOUNTAINS_0103:String = "bd_mountains_0103.png"
	Const GFX_BD_MOUNTAINS_0104:String = "bd_mountains_0104.png"
	Const GFX_BD_MOUNTAINS_0105:String = "bd_mountains_0105.png"
	Const GFX_BD_DESERT_0201:String = "bd_desert_0201.png"
	Const GFX_BD_DESERT_0202:String = "bd_desert_0202.png"
	
	Field graphics:Map<String, Image> = New StringMap<Image>
	
	Method New()
		graphics.Add(GFX_TRAIN, Image.Load(GFX_TRAIN, 0.0, 1.0))
		graphics.Add(GFX_SURVIVOR, Image.Load(GFX_SURVIVOR, 0.0, 0.0))
		
		graphics.Add(GFX_BD_MOUNTAINS_0101, Image.Load(GFX_BD_MOUNTAINS_0101, 0.0, 1.0))
		graphics.Add(GFX_BD_MOUNTAINS_0102, Image.Load(GFX_BD_MOUNTAINS_0102, 0.0, 1.0))
		graphics.Add(GFX_BD_MOUNTAINS_0103, Image.Load(GFX_BD_MOUNTAINS_0103, 0.0, 1.0))
		graphics.Add(GFX_BD_MOUNTAINS_0104, Image.Load(GFX_BD_MOUNTAINS_0104, 0.0, 1.0))
		graphics.Add(GFX_BD_MOUNTAINS_0105, Image.Load(GFX_BD_MOUNTAINS_0105, 0.0, 1.0))
		graphics.Add(GFX_BD_DESERT_0201, Image.Load(GFX_BD_DESERT_0201, 0.0, 1.0))
		graphics.Add(GFX_BD_DESERT_0202, Image.Load(GFX_BD_DESERT_0202, 0.0, 1.0))
		
	End Method
	
End Class