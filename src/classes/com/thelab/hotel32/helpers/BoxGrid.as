package com.thelab.hotel32.helpers
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class BoxGrid extends Sprite
	{
		
//		private var grid									: Sprite;
		private var _rows									: uint;
		private var _cols									: uint;
		private var _rowHeight								: uint;
		private var _colWidth								: uint;
		private var _colSpacing								: uint;
		private var _rowSpacing								: uint;
		
		public var pointsArray								: Array;
		
		public function BoxGrid(cols:uint=4, rows:uint=2, colWidth:uint=100, rowHeight:uint=100, colSpc:uint=10, rowSpc:uint=10 )
		{
			
			_cols = cols;
			_rows = rows;
			
			_colWidth = colWidth;
			_rowHeight = rowHeight;
			
			_colSpacing = colSpc;
			_rowSpacing = rowSpc;
			
			pointsArray = new Array();
			
			for (var i:int = 0; i < (_rows * _cols); i++)
			{
				var pt:Point = new Point;
				var col:uint = Math.floor(i / _rows);
				var row:uint = (i % _rows);
				pt.x = (row * (_colWidth + _colSpacing));
				pt.y = (col * (_rowHeight + _rowSpacing));
				pointsArray.push(pt);
			}
		}
		
		public function addToGrid(theBox:BasicBox):void
		{
			addChild(theBox);
			theBox.x = pointsArray[theBox.index].x;
			theBox.y = pointsArray[theBox.index].y;
		}
		
		public function pointForIndex(ix:uint):Point
		{
			return pointsArray[ix];
		}
		
		public function show():void
		{
			//
		}
		
		public function hide():void
		{
			//
		}
	}
}