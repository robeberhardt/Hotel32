package com.thelab.hotel32.views.lounge
{
	import com.greensock.TweenMax;
	import com.thelab.hotel32.assets.ToolTipAsset;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class WedgeTag extends Sprite
	{
		private var leftFoot				: Segment;
		private var leftLeg					: Segment;
		private var leftSide				: Segment;
		
		private var rightFoot				: Segment;
		private var rightLeg				: Segment;
		private var rightSide				: Segment;
		
		private var top						: Segment;
		
		private var _width					: Number;
		private var _height					: Number;
		private var strokeWeight			: Number;
		private var strokeColor				: Number;
		private var wedgeOffset				: Number;
		
		private var distanceBetweenFeet		: Number;
		
		public var asset					: MovieClip;
		private var theMask					: Sprite;
		
		public function WedgeTag(w:Number=150, h:Number=30, sw:Number=1, sc:Number=0xFF0000, wf:Number=0)
		{
			_width = w;
			_height = h;
			strokeWeight = sw;
			strokeColor = sc;
			wedgeOffset = wf;
			
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init); }
		}
		
		private function init(e:Event=null)
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			alpha = 0;
			visible = false;

			asset = new ToolTipAsset();
			addChild(asset);
			
			theMask = new Sprite();
			theMask.graphics.beginFill(0x0000FF, 1);
			theMask.graphics.drawRect(0, 0, _width + 8, _height + 8);
			theMask.x = -(_width * .5) - 4;
			theMask.y = -(_height) - 4;
			theMask.scaleX = 0;
			addChild(theMask);
			asset.mask = theMask;
			
			leftFoot = new Segment(10, strokeWeight, strokeColor);
			addChild(leftFoot);
			rightFoot = new Segment(10, strokeWeight, strokeColor);
			addChild(rightFoot);
			leftFoot.rotation = -130;
			rightFoot.rotation = -50;
			
			distanceBetweenFeet = distanceBetweenPoints(leftFoot.getPin(), rightFoot.getPin());

			leftLeg = new Segment((_width * .5) - (distanceBetweenFeet * .5), strokeWeight, strokeColor);
			leftLeg.x = leftFoot.getPin().x;
			leftLeg.y = leftFoot.getPin().y;
			leftLeg.rotation = -180;
			addChild(leftLeg);
			
			rightLeg = new Segment((_width * .5) - (distanceBetweenFeet * .5), strokeWeight, strokeColor);
			rightLeg.x = rightFoot.getPin().x;
			rightLeg.y = rightFoot.getPin().y;
			addChild(rightLeg);
						
			leftSide = new Segment(_height + leftFoot.getPin().y, strokeWeight, strokeColor);
			leftSide.x = leftLeg.getPin().x;
			leftSide.y = leftLeg.getPin().y;
			leftSide.rotation = -90;
			addChild(leftSide);
			
			rightSide = new Segment(_height + leftFoot.getPin().y, strokeWeight, strokeColor);
			rightSide.x = rightLeg.getPin().x;
			rightSide.y = rightLeg.getPin().y;
			rightSide.rotation = -90;
			addChild(rightSide);
			
			top = new Segment(_width, strokeWeight, strokeColor);
			top.x = leftSide.getPin().x;
			top.y = leftSide.getPin().y;
			addChild(top);

		}
		
		public function set progress(val:Number):void
		{
			theMask.scaleX = val;
		}
		

		private function distanceBetweenPoints(p1:Point, p2:Point):Number
		{
			var a:Number = p1.x - p2.x;
			var b:Number = p1.y - p2.y;
			return Math.sqrt((a*a) + (b*b));
		}
		
		private function angleBetweenPoints(p1:Point, p2:Point):Number
		{
			var dx:Number = p1.x - p2.x;
			var dy:Number = p1.y - p2.y;
			return Math.atan2(dy, dx);
		}
		
		private function deg2rad(d:Number):Number
		{
			return d * Math.PI / 180;
		}
		
		private function rad2deg(r:Number):Number
		{
			return r * 180 / Math.PI;
		}
		
		public function show(d:Number=0):void
		{
			TweenMax.to(this, .25, { delay: d, autoAlpha: 1 });
		}
		
		public function hide(d:Number=0):void
		{
			TweenMax.to(this, .25, { delay: d, autoAlpha: 0 });
		}
	}
}