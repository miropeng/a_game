package 
{
	import flash.display.Sprite;
	
	public class EditorCell extends Sprite
	{
		private var _tx:int;
		private var _ty:int;
		private var _selected:Boolean;
		
		public function EditorCell(tx:int, ty:int)
		{
			super();
			
			this.tx = tx;
			this.ty = ty;
		}

		public function get tx():int
		{
			return _tx;
		}

		public function set tx(value:int):void
		{
			_tx = value;
			
			this.x = EditorConfig.CELL_SIZE * _tx;
		}

		public function get ty():int
		{
			return _ty;
		}

		public function set ty(value:int):void
		{
			_ty = value;
			
			this.y = EditorConfig.CELL_SIZE * _ty;
		}
		
		
		public function draw(color:uint):void
		{
			this.graphics.clear();
			this.graphics.lineStyle(0.1, 0, 1);
			this.graphics.beginFill(color, 0.5);
			this.graphics.drawRect(0, 0, EditorConfig.CELL_SIZE, EditorConfig.CELL_SIZE);
			this.graphics.endFill();
		}

		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(value:Boolean):void
		{
			if(_selected != value)
			{
				_selected = value;
				if(_selected)
				{
					draw(EditorConfig.SELECT_COLOR);
				}
				else
				{
					draw(EditorConfig.NORMAL_COLOR);
				}
			}
		}

	}
}