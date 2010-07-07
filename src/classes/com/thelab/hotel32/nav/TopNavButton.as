package com.thelab.hotel32.nav
{
	import com.greensock.TweenMax;
	import com.thelab.hotel32.views.BasicView;
	import com.thelab.hotel32.views.ViewController;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.osflash.signals.DeluxeSignal;
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeMappedSignal;
	import org.osflash.signals.natives.NativeRelaySignal;
	import org.osflash.signals.natives.NativeSignal;
	
	public class TopNavButton extends Sprite
	{
		private var _asset 								: MovieClip;
		
		private var rolledOver							: NativeSignal;
		private var rolledOut							: NativeSignal;
		private var clicked 							: NativeSignal;
		public var dispatchClicked						: Signal;
		
		private var _selected							: Boolean;
		public var view									: BasicView;
		private var _active								: Boolean;
		
		public function TopNavButton(asset:MovieClip)
		{
			x = asset.x;
			y = asset.y;
			name = asset.name.slice(asset.name.lastIndexOf("_")+1);
			_asset = asset;
			_asset.x = 0;
			_asset.y = 0;
			_asset.alpha = 1.0;
			alpha = 0.7;
			_active = true;
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true); }
		}
		
		override public function toString():String
		{
			return "[TopNavButton id: " + name + " x:" + x + " y:" + y + "]";
		}
		
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addChild(_asset);
			
			rolledOver = new NativeSignal(this, MouseEvent.ROLL_OVER, MouseEvent);
			rolledOut = new NativeSignal(this, MouseEvent.ROLL_OUT, MouseEvent);
			clicked = new NativeSignal(this, MouseEvent.CLICK, MouseEvent);
			
			// hotspot
			var h:Sprite = new Sprite();
			addChild(h);
			h.graphics.beginFill(0x00FF00, 0);
			h.graphics.drawRect(-5, -2, this.width + 15, -18);
			
			dispatchClicked = new Signal();
			
			selected = false;
		}
		
		private function doClicked(e:MouseEvent):void
		{
			if (_active) 
			{
				selected = true;
				active = false;
				dispatchClicked.dispatch(this);
			}
		}
		
		private function doRolledOver(e:MouseEvent):void
		{
			if (_active) { hilite(true); }
		}
		
		private function doRolledOut(e:MouseEvent):void
		{
			if (_active) { hilite(false); }
		}
		
		private function hilite(val:Boolean):void
		{
			if (val)
			{
				_asset.out.visible = false;
				_asset.over.visible = true;
			}
			else
			{
				_asset.out.visible = true;
				_asset.over.visible = false;
			}
			TweenMax.to(this, .25, { alpha: (val) ? 1 : 0.7 } );
		}


		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(value:Boolean):void
		{
			_selected = value;
			hilite(_selected);
			if (selected)
			{
				rolledOver.remove(doRolledOver);
				rolledOut.remove(doRolledOut);
				clicked.remove(doClicked);
				useHandCursor = false;
				buttonMode = false;
			}
			else
			{
				rolledOver.add(doRolledOver);
				rolledOut.add(doRolledOut);
				clicked.add(doClicked);
				useHandCursor = true;
				buttonMode = true;
			}
		}

		public function get active():Boolean
		{
			return _active;
		}

		public function set active(value:Boolean):void
		{
			_active = value;
			useHandCursor = _active;
			buttonMode = _active;
			if (!_active && !_selected)
			{
				hilite(false);
			}
		}
	}
}