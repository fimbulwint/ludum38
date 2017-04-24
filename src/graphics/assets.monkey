Strict

Import mojo2

Class Assets
	Global instance:Assets = New Assets()
	
	Const GFX_TITLE:String = "title.png"
	Const GFX_BACKGROUND:String = "background.png"
	Const GFX_TRAIN:String = "train.png"
	Const GFX_BD_MOUNTAINS_0101:String = "bd_mountains_0101.png"
	Const GFX_BD_MOUNTAINS_0102:String = "bd_mountains_0102.png"
	Const GFX_BD_MOUNTAINS_0103:String = "bd_mountains_0103.png"
	Const GFX_BD_MOUNTAINS_0104:String = "bd_mountains_0104.png"
	Const GFX_BD_MOUNTAINS_0105:String = "bd_mountains_0105.png"
	Const GFX_BD_DESERT_0201:String = "bd_desert_0201.png"
	Const GFX_BD_DESERT_0202:String = "bd_desert_0202.png"

	Const ANIMS_FRAMES:Int = 16
	Const GFX_ANIM_SURVIVOR:String = "survivor.png"
	Const GFX_ANIM_MUTANT:String = "mutants.png"

	Const FNT_BOYCOTT:String = "fnt_boycott.png"
	
	Const GFX_GAME_OVER:String = "game_over_screen.png"
	
	Field graphics:Map<String, Image> = New StringMap<Image>
	Field anims:Map<String, Image[]> = New StringMap<Image[]>
	Field fonts:Map<String, Font> = New StringMap<Font>
	
	Method New()
		graphics.Add(GFX_TITLE, Image.Load(GFX_TITLE, 0.0, 0.0))
		graphics.Add(GFX_BACKGROUND, Image.Load(GFX_BACKGROUND, 0.0, 0.0))
		graphics.Add(GFX_TRAIN, Image.Load(GFX_TRAIN, 0.0, 1.0))
		graphics.Add(GFX_BD_MOUNTAINS_0101, Image.Load(GFX_BD_MOUNTAINS_0101, 0.0, 1.0))
		graphics.Add(GFX_BD_MOUNTAINS_0102, Image.Load(GFX_BD_MOUNTAINS_0102, 0.0, 1.0))
		graphics.Add(GFX_BD_MOUNTAINS_0103, Image.Load(GFX_BD_MOUNTAINS_0103, 0.0, 1.0))
		graphics.Add(GFX_BD_MOUNTAINS_0104, Image.Load(GFX_BD_MOUNTAINS_0104, 0.0, 1.0))
		graphics.Add(GFX_BD_MOUNTAINS_0105, Image.Load(GFX_BD_MOUNTAINS_0105, 0.0, 1.0))
		graphics.Add(GFX_BD_DESERT_0201, Image.Load(GFX_BD_DESERT_0201, 0.0, 1.0))
		graphics.Add(GFX_BD_DESERT_0202, Image.Load(GFX_BD_DESERT_0202, 0.0, 1.0))
	
		anims.Add(GFX_ANIM_SURVIVOR, Image.LoadFrames(GFX_ANIM_SURVIVOR, ANIMS_FRAMES, False, .5, 1.0))
		anims.Add(GFX_ANIM_MUTANT, Image.LoadFrames(GFX_ANIM_MUTANT, ANIMS_FRAMES, False, .5, 1.0))
		
		fonts.Add(FNT_BOYCOTT, Font.Load(FNT_BOYCOTT, 48, 10, False))
		
		graphics.Add(GFX_GAME_OVER, Image.Load(GFX_GAME_OVER, 0.0, 0.0))
	End Method
	
End Class