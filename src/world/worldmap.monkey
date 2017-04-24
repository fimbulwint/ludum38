Strict

Import drawable
Import graphics.assets
Import graphics.screen
Import mojo2
Import system.time
Import world.world

Class WorldMap Extends LifecycleAware
	Const ZONE_MOUNTAINS:String = "MOUNTAINS"
	Const ZONE_DESERT:String = "DESERT"
	
	Const yOffset:Float = Ground.GROUND_HEIGHT + 50.0
	Const vx:Float = 600.0
	
	Field zoneTypes:Map<String, ZoneType> = New StringMap<ZoneType> ' for each zonetype, its backdrops definition
	Field map:ZoneDefinition[] ' array of zone definitions with a zonetype and integer list (backdrops)
	Field world:World 
		
	Field level:Int = 0
	Field currentZone:Int
	Field currentBackdrop:Int
	Field prevImage:Image
	Field prevFlipped:Bool
	Field currentImage:Image
	Field currentFlipped:Bool 
	
	Field x:Float = -Screen.WIDTH
	
	Method New(world:World)
		Self.world = world
		InitializeZoneTypes()
		InitMap()
		
		currentZone = map.Length - 1
		currentBackdrop = map[currentZone].content.Length - 1
		currentImage = Null
		z = 1000.0
		AdvanceBackdrop()
	End Method
	
	Method InitializeZoneTypes:Void()
		zoneTypes.Add(ZONE_MOUNTAINS, New ZoneType(ZONE_MOUNTAINS,
			[Assets.instance.graphics.Get(Assets.GFX_BD_MOUNTAINS_0101),
			Assets.instance.graphics.Get(Assets.GFX_BD_MOUNTAINS_0102),
			Assets.instance.graphics.Get(Assets.GFX_BD_MOUNTAINS_0103),
			Assets.instance.graphics.Get(Assets.GFX_BD_MOUNTAINS_0104)]))
		
		zoneTypes.Add(ZONE_DESERT, New ZoneType(ZONE_DESERT,
			[Assets.instance.graphics.Get(Assets.GFX_BD_DESERT_0201),
			Assets.instance.graphics.Get(Assets.GFX_BD_DESERT_0202)]))
	End Method

	Method InitMap:Void()
		map = 	[New ZoneDefinition(zoneTypes.Get(ZONE_MOUNTAINS), 
					[1, 2, 3, 4, 3, 2, -3, -4, -2, 4, 3, -2, -3, 4, 3, -1]),
				New ZoneDefinition(zoneTypes.Get(ZONE_DESERT), 
					[1, 2, 2, 2, 2, 2, 2, -1]),
				New ZoneDefinition(zoneTypes.Get(ZONE_MOUNTAINS),
					[1, 2, 3, -1]),
				New ZoneDefinition(zoneTypes.Get(ZONE_DESERT),
					[1, 2, -1])]
	End Method

	Method Update:Void(worldState:WorldState)
		Local delta:Float = Time.instance.lastFrame
		x-= (delta * vx) / 1000.0
		If (x <= -Screen.WIDTH)
			' the prevImage is no longer seen, advance backdrops
			AdvanceBackdrop()
		End If
	End Method
	
	Method Draw:Void(canvas:Canvas)
		canvas.PushMatrix()
		canvas.SetBlendMode(BlendMode.Alpha)
		canvas.SetAlpha(1.0)
		canvas.SetColor(1.0, 1.0, 1.0)
		If (prevImage <> Null)
			DrawBackdrop(canvas, prevImage, x, prevFlipped)
		End If
		If (currentImage <> Null)
			DrawBackdrop(canvas, currentImage, x + Screen.WIDTH - 1.0, currentFlipped)
		End If
		canvas.PopMatrix()
	End Method
	
	Method GetCurrentZone:ZoneDefinition()
		Return map[currentZone]
	End Method
	
Private
	Method AdvanceBackdrop:Void()
		x += Screen.WIDTH
		prevImage = currentImage
		prevFlipped = currentFlipped
		currentBackdrop += 1
		If (currentBackdrop >= map[currentZone].content.Length)
			currentBackdrop = 0
			currentZone += 1
			If (currentZone >= map.Length)
				currentZone = 0
				level += 1
			End If
		EndIf
		'Print("-> Zone " + currentZone + " - BD " + currentBackdrop)

		Local backdropNumber:Int = map[currentZone].content[currentBackdrop] ' 1-indexed
		If (backdropNumber <> 0)
			Local backdropImages:Map<Int, Image> = map[currentZone].type.backdrops
			currentImage = backdropImages.Get(Abs(backdropNumber))
			currentFlipped = backdropNumber < 0
		EndIf
	End Method

	Method DrawBackdrop:Void(canvas:Canvas, img:Image, x:Float, flipped:Bool)
		If (flipped)
			canvas.DrawImage(img, x + Screen.WIDTH, yOffset, 0.0, -1.0, 1.0)
		Else
			canvas.DrawImage(img, x, yOffset, 0.0, 1.0, 1.0)
		End If
	End Method
End Class


Class ZoneType
	Field id:String
	Field backdrops:Map<Int, Image> = New IntMap<Image>	' 1-based
	
	Method New(id:String, images:Image[]) ' (0 - n-1) will correspond to image for backdrop 1 to image for backdrop n
		Self.id = id
		For Local i:Int = 0 To images.Length - 1
			backdrops.Add(i + 1, images[i]) ' 1-based
		End For
	End Method
End Class

Class ZoneDefinition
	Field type:ZoneType 
	Field content:Int[]
	
	Method New(type:ZoneType, content:Int[])
		Self.type = type
		Self.content = content
	End Method
End Class