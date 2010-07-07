package com.thelab.hotel32.views.video
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class CuePoint extends MovieClip
	{
		private var _data								: XML;
		private var _asset								: MovieClip;
		
		private var dot									: MovieClip;
		private var ring								: MovieClip;
		
		public var id									: String;
		public var index								: int;
		public var time									: Number;
		public var title								: String;
		public var url									: String;
		
		private var _active								: Boolean;
		
		public static const CUE_POINT_CLICKED			: String = "CUE_POINT_CLICKED";
		public static const CUE_POINT_ROLLOVER			: String = "CUE_POINT_ROLLOVER";
		public static const CUE_POINT_ROLLOUT			: String = "CUE_POINT_ROLLOUT";
		
		public function CuePoint(asset:MovieClip, data:XML)
		{
			
			
			_asset = asset;
			_asset.alpha = .6;
			
			dot = _asset.dot;
			dot.visible = false;
			dot.alpha = 0;
			
			ring = _asset.ring;
			ring.alpha = 0;
			ring.scaleX = ring.scaleY = 1.0;
			
			addChild(_asset);
			
			id = data.@id.toString();
			time = Number(data.@time);
			title = data.title.toString();
			url = data.url.toString();			
			
		}

		override public function toString():String
		{
			return "[CuePoint '" + title + "'   time: " + time + "]";
		}
		
		public function activate():void
		{
			_asset.addEventListener(MouseEvent.CLICK, onMouseClick, false, 0, true);
			TweenMax.to(ring, .5, { alpha: 1 });
		}
		
		private function addRollovers():void
		{
			_asset.addEventListener(MouseEvent.ROLL_OVER, onMouseRollOver, false, 0, true);
			_asset.addEventListener(MouseEvent.ROLL_OUT, onMouseRollOut, false, 0, true);
		}
		
		private function removeRollovers():void
		{
			_asset.removeEventListener(MouseEvent.ROLL_OVER, onMouseRollOver);
			_asset.removeEventListener(MouseEvent.ROLL_OUT, onMouseRollOut);
		}
		
		public function reset():void
		{
			dot.visible = false;
			dot.alpha = 0;
			
			ring = _asset.ring;
			ring.alpha = 0;
			ring.scaleX = ring.scaleY = 1.0;
			
			active = false;
		}
		
		public function forceGrow():void
		{
			//removeRollovers();
			TweenMax.to(dot, .5, { autoAlpha: 1 } );
			grow();
		}
		
		public function forceShrink():void
		{
			addRollovers();
			shrink();
		}
		
		public function grow():void
		{
			TweenMax.to(_asset, .25, { alpha: 1 });
			TweenMax.to(_asset.ring, .25, { scaleX: 1.4, scaleY: 1.4, ease:Quad.easeOut });
		}
		
		public function shrink():void
		{
			TweenMax.to(_asset, .25, { alpha: .6 });
			TweenMax.to(_asset.ring, .25, { scaleX: 1, scaleY: 1, ease:Quad.easeIn });
		}
		
		private function onMouseRollOver(e:MouseEvent):void
		{
			grow();
			dispatchEvent(new Event(CUE_POINT_ROLLOVER, true));
		}
		
		private function onMouseRollOut(e:MouseEvent):void
		{
			shrink();
			dispatchEvent(new Event(CUE_POINT_ROLLOUT, true))
		}
		private function onMouseClick(e:MouseEvent):void
		{
			dispatchEvent(new Event(CUE_POINT_CLICKED, true));
		}
		
		public function get active():Boolean
		{
			return _active;
		}

		public function set active(value:Boolean):void
		{
			_active = value;
			if (_active)
			{
				_asset.addEventListener(MouseEvent.CLICK, onMouseClick, false, 0, true);
				TweenMax.to(ring, .5, { alpha: .6, scaleX: 1, scaleY: 1, ease:Quad.easeOut });
				addRollovers();
				useHandCursor = true;
				buttonMode = true;
			}
			else
			{
				removeRollovers();
				useHandCursor = false;
				buttonMode = false;
				_asset.removeEventListener(MouseEvent.CLICK, onMouseClick);
			}
		}

	}
} 