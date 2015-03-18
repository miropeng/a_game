package games.tinywings.box2d
{
	import flash.display.Bitmap;
	
	import citrus.objects.CitrusSprite;

	public class Backgroud 
	{
		[Embed(source="/../embed/b0.png")]
		public static const back0Class:Class;
		private var _backSky0:CitrusSprite;
		private var _backSky1:CitrusSprite;
		
		[Embed(source="/../embed/b1.png")]
		public static const back1Class:Class;
		private var _backGroud0:CitrusSprite;
		private var _backGound1:CitrusSprite;
		
		private var _clipSkyIdx:int;
		private var _clipGroundIdx:int;
		private var _clipWidth:Number;
		
		public function Backgroud()
		{
			var backView1:Bitmap  = new back0Class();
			_clipWidth = backView1.width - 1;
			var clipHeight:Number = backView1.height;
			var backY:Number = state.stage.stageHeight - clipHeight + 10;
			
			_backSky0 = new CitrusSprite("back1", {y:backY,parallaxX:Config.BACK0_MOVE_RATE, parallaxY:0,  width:_clipWidth,view:backView1});
			_backSky1 = new CitrusSprite("back2", {y:backY, parallaxX:Config.BACK0_MOVE_RATE, parallaxY:0, x:_clipWidth, width:_clipWidth, view:backView1});
			state.add(_backSky0);
			state.add(_backSky1);
			
			var backView2:Bitmap  = new back1Class();
			clipHeight = backView2.height;
			backY = state.stage.stageHeight - clipHeight + 20;
			
			_backGroud0 = new CitrusSprite("back3", {y:backY,parallaxX:Config.BACK1_MOVE_RATE, group:10,parallaxY:0,  width:_clipWidth,view:backView2});
			_backGound1 = new CitrusSprite("back4", {y:backY, parallaxX:Config.BACK1_MOVE_RATE, group:10,parallaxY:0, x:_clipWidth, width:_clipWidth, view:backView2});
			state.add(_backGroud0);
			state.add(_backGound1);
		}
		
		private function get state():TinyWingsGameState
		{
			return TinyWingsGameState.instance;
		}
		
		public function update():void 
		{
			var outOfStage:Boolean = false;
			var outOffX:Number = 100;
			
			outOfStage = state.ball.x * Config.BACK0_MOVE_RATE >= (_clipSkyIdx + 1) * _clipWidth + outOffX;
			if(outOfStage)
			{
				if(_clipSkyIdx % 2 == 0)
				{
					_backSky0.x = _backSky1.x + _clipWidth;
				}
				else
				{
					_backSky1.x = _backSky0.x + _clipWidth;
				}
				_clipSkyIdx++;
			}
			
			outOfStage = state.ball.x * Config.BACK1_MOVE_RATE >= (_clipGroundIdx + 1) * _clipWidth + outOffX;
			if(outOfStage)
			{
				if(_clipGroundIdx % 2 == 0)
				{
					_backGroud0.x = _backGound1.x + _clipWidth;
				}
				else
				{
					_backGound1.x = _backGroud0.x + _clipWidth;
				}
				_clipGroundIdx++;
			}
		}
	}
}