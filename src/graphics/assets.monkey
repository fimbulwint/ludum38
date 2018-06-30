Strict

Import mojo2

Class Assets
	Global instance:Assets = New Assets()
	
	Const GFX_TITLE:String = "monkey://data/title.png"
	Const GFX_BACKGROUND:String = "monkey://data/background.png"
	Const GFX_TRAIN:String = "monkey://data/train.png"
	Const GFX_RAILROAD_ROCK:String = "monkey://data/railroad_rock.png"
	Const GFX_RAILROAD_SMALL_ROCK:String = "monkey://data/railroad_small_rock.png"
	Const GFX_BD_MOUNTAINS_0101:String = "monkey://data/bd_mountains_0101.png"
	Const GFX_BD_MOUNTAINS_0102:String = "monkey://data/bd_mountains_0102.png"
	Const GFX_BD_MOUNTAINS_0103:String = "monkey://data/bd_mountains_0103.png"
	Const GFX_BD_MOUNTAINS_0104:String = "monkey://data/bd_mountains_0104.png"
	Const GFX_BD_MOUNTAINS_0105:String = "monkey://data/bd_mountains_0105.png"
	Const GFX_BD_DESERT_0201:String = "monkey://data/bd_desert_0201.png"
	Const GFX_BD_DESERT_0202:String = "monkey://data/bd_desert_0202.png"
	Const GFX_MISC_HELMET:String = "monkey://data/helmet01.png"

	Const ANIMS_FRAMES_SURVIVOR:Int = 32
	Const ANIMS_FRAMES_MUTANT:Int = 16
	Const GFX_ANIM_SURVIVOR:String = "monkey://data/survivor.png"
	Const GFX_ANIM_MUTANT:String = "monkey://data/mutants.png"

	Const IMG_WIDTH_SURVIVOR:Float = 64.0
	Const IMG_HEIGHT_SURVIVOR:Float = 128.0
	Const IMG_MAX_X_SURVIVOR:Float = IMG_WIDTH_SURVIVOR - 1
	Const IMG_MAX_Y_SURVIVOR:Float = IMG_HEIGHT_SURVIVOR - 1
	Const IMG_HANDLE_X_SURVIVOR:Float = 30.0
	Const IMG_HANDLE_Y_SURVIVOR:Float = 38.0
	
	Const IMG_WIDTH_MUTANT:Float = 64.0
	Const IMG_HEIGHT_MUTANT:Float = 64.0
	Const IMG_MAX_X_MUTANT:Float = IMG_WIDTH_MUTANT - 1
	Const IMG_MAX_Y_MUTANT:Float = IMG_HEIGHT_MUTANT - 1
	Const IMG_HANDLE_X_MUTANT:Float = 28.0
	Const IMG_HANDLE_Y_MUTANT:Float = 46.0

		
	Const FNT_BOYCOTT:String = "monkey://data/fnt_boycott.png"
	
	Const GFX_GAME_OVER:String = "monkey://data/game_over_screen.png"
	
	Field graphics:Map<String, Image> = New StringMap<Image>
	Field anims:Map<String, Image[]> = New StringMap<Image[]>
	Field fonts:Map<String, Font> = New StringMap<Font>
	
	Method New()
		graphics.Add(GFX_TITLE, Image.Load(GFX_TITLE, 0.0, 0.0))
		graphics.Add(GFX_BACKGROUND, Image.Load(GFX_BACKGROUND, 0.0, 0.0))
		graphics.Add(GFX_TRAIN, Image.Load(GFX_TRAIN, 0.0, 1.0))
		graphics.Add(GFX_RAILROAD_ROCK, Image.Load(GFX_RAILROAD_ROCK, 0.0, 1.0))
		graphics.Add(GFX_RAILROAD_SMALL_ROCK, Image.Load(GFX_RAILROAD_SMALL_ROCK, 0.5, 0.5))
		graphics.Add(GFX_BD_MOUNTAINS_0101, Image.Load(GFX_BD_MOUNTAINS_0101, 0.0, 1.0))
		graphics.Add(GFX_BD_MOUNTAINS_0102, Image.Load(GFX_BD_MOUNTAINS_0102, 0.0, 1.0))
		graphics.Add(GFX_BD_MOUNTAINS_0103, Image.Load(GFX_BD_MOUNTAINS_0103, 0.0, 1.0))
		graphics.Add(GFX_BD_MOUNTAINS_0104, Image.Load(GFX_BD_MOUNTAINS_0104, 0.0, 1.0))
		graphics.Add(GFX_BD_MOUNTAINS_0105, Image.Load(GFX_BD_MOUNTAINS_0105, 0.0, 1.0))
		graphics.Add(GFX_BD_DESERT_0201, Image.Load(GFX_BD_DESERT_0201, 0.0, 1.0))
		graphics.Add(GFX_BD_DESERT_0202, Image.Load(GFX_BD_DESERT_0202, 0.0, 1.0))
		graphics.Add(GFX_MISC_HELMET, Image.Load(GFX_MISC_HELMET, 0.5, 0.5))
	
		anims.Add(GFX_ANIM_SURVIVOR, Image.LoadFrames(GFX_ANIM_SURVIVOR, ANIMS_FRAMES_SURVIVOR, False, 
			IMG_HANDLE_X_SURVIVOR / IMG_MAX_X_SURVIVOR, IMG_HANDLE_Y_SURVIVOR / IMG_MAX_Y_SURVIVOR))
		anims.Add(GFX_ANIM_MUTANT, Image.LoadFrames(GFX_ANIM_MUTANT, ANIMS_FRAMES_MUTANT, False,
			IMG_HANDLE_X_MUTANT / IMG_MAX_X_MUTANT, IMG_HANDLE_Y_MUTANT / IMG_MAX_Y_MUTANT))
	
		fonts.Add(FNT_BOYCOTT, Font.Load(FNT_BOYCOTT, 48, 10, False))
		
		graphics.Add(GFX_GAME_OVER, Image.Load(GFX_GAME_OVER, 0.0, 0.0))
	End Method
	
End Class