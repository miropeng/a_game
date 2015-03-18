package
{
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	
	import citrus.core.starling.StarlingCitrusEngine;
	import citrus.utils.Mobile;
	import com.miro.rt.core.GameManager;
	
	
	public class RainbowTotoro extends StarlingCitrusEngine
	{
		public var compileForMobile:Boolean;
		
		public function RainbowTotoro()
		{
			super();
			
			// 支持 autoOrient
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 60;
			
			compileForMobile = Mobile.isAndroid()? true : false;
		}
		
		override public function initialize():void
		{
			if (compileForMobile) 
			{
				
				setUpStarling(true, 1, new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight));
			} 
			else 
			{
				setUpStarling(true);
			}
		}
		
		override public function setUpStarling(debugMode:Boolean=false, antiAliasing:uint=1, viewPort:Rectangle=null, stage3D:Stage3D=null):void
		{
			super.setUpStarling(debugMode, antiAliasing, viewPort, stage3D);
			
			if (compileForMobile) {
				//				// set iPhone & iPad size, used for Starling contentScaleFactor
				//				// landscape mode!
				_starling.stage.stageWidth = 800;
				_starling.stage.stageHeight = 480;
			}
		}
		
		override public function handleStarlingReady():void
		{
			state = new GameManager();
		}
	}
}