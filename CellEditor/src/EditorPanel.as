package 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class EditorPanel extends Sprite
	{
		private var _cells:Vector.<EditorCell> = new Vector.<EditorCell>();
		
		public function EditorPanel()
		{
			super();
			
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			for(var i:int = 0; i < EditorConfig.TW; i++)
			{
				for(var j:int = 0; j < EditorConfig.TH; j++)
				{
					var cell:EditorCell = new EditorCell(i, j);
					cell.draw(EditorConfig.NORMAL_COLOR);
					addChild(cell);
					_cells.push(cell);
				}
			}
		}
		
		private function initEvent():void
		{
			this.addEventListener(MouseEvent.MOUSE_DOWN, __onMouseDown);
			EditorConfig.stage.addEventListener(MouseEvent.MOUSE_UP, __onMouseUp);
		}
		
		private function __onMouseDown(e:MouseEvent):void
		{
			this.addEventListener(MouseEvent.MOUSE_OVER, __onMouseOver);
			
			__onMouseOver(e);
		}
		
		private function __onMouseUp(e:MouseEvent):void
		{
			this.removeEventListener(MouseEvent.MOUSE_OVER, __onMouseOver);
		}
		
		private function __onMouseOver(e:MouseEvent):void
		{
			if(e.target is EditorCell)
			{
				e.stopPropagation();
				e.stopImmediatePropagation();
				
				var cell:EditorCell = e.target as EditorCell;
				cell.selected = !cell.selected;
			}
		}
		
		public function print():void
		{
			var ret:String = "";
			for each( var cell:EditorCell in _cells)
			{
				if(cell.selected)
				{
					ret += cell.tx + "," + cell.ty + "|";
				}
			}
			
			ret = ret.slice(0, ret.length - 1);
			
			trace(ret);
		}
	}
}