package com.thelab.hotel32.views.rooms
{
	import com.greensock.TweenMax;
	import com.thelab.hotel32.helpers.BoxGrid;
	import com.thelab.hotel32.helpers.Logger;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	public class RoomsBoxGrid extends BoxGrid
	{
		public function RoomsBoxGrid(cols:uint=4, rows:uint=2, colWidth:uint=100, rowHeight:uint=100, colSpc:uint=10, rowSpc:uint=10)
		{
			super(cols, rows, colWidth, rowHeight, colSpc, rowSpc);
		}
		
		override public function show():void
		{
			TweenMax.to(this, .5, { autoAlpha: 1 } );
		}
		
		override public function hide():void
		{
			TweenMax.to(this, .5, { autoAlpha: 0 } );
		}
	}
}