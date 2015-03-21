package com.miro.rt.scene
{
	import com.miro.rt.core.GameManager;
	import com.miro.rt.res.ResAssets;
	
	import citrus.core.starling.StarlingState;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;

	public class WelScene extends StarlingState implements IScene
	{
		private var _back:Image;
		private var _playerBtn:Button;
		
		public function WelScene()
		{
			super();
			
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			initView();
			addEvent();
		}
		
		private function initView():void
		{
			_back = new Image(Texture.fromBitmap(new ResAssets.WelBack()));
			
			_playerBtn = new Button(ResAssets.getAtlas().getTexture("playbtn"));
			_playerBtn.x = (_ce.screenWidth - _playerBtn.width ) / 2;
			_playerBtn.y = _ce.screenHeight - _playerBtn.height - 50;
			
			addChild(_back);
			addChild(_playerBtn);
		}
		
		private function addEvent():void
		{
			_playerBtn.addEventListener(Event.TRIGGERED, onPlayClick);
		}
		
		private function removeEvent():void
		{
			_playerBtn.removeEventListener(Event.TRIGGERED, onPlayClick);
		}
		
		private function onPlayClick(event:Event):void
		{
			GameManager.instance.engine.state = new GameScene();
		}
		
		override public function destroy():void
		{
			removeEvent();
			
			_back.dispose();
			_playerBtn.dispose();
			
			_back = null;
			_playerBtn = null;
			
			super.destroy();
		}
	}
}