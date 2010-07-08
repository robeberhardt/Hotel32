package com.thelab.hotel32.common
{
	import com.greensock.TweenMax;
	import com.thelab.hotel32.helpers.Logger;
	import com.thelab.hotel32.views.BasicView;
	import com.thelab.hotel32.views.ViewController;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import org.osflash.signals.DeluxeSignal;
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeMappedSignal;
	import org.osflash.signals.natives.NativeRelaySignal;
	import org.osflash.signals.natives.NativeSignal;
	
	// Library Symbols
	import com.thelab.hotel32.assets.TabSingleAsset;
	
	public class Tab extends Sprite
	{
		private var asset 								: MovieClip;
		public var index								: uint;
		private var rolledOver							: NativeSignal;
		private var rolledOut							: NativeSignal;
		private var clicked 							: NativeSignal;
		public var clickedSender						: Signal;
		
		private var label								: MovieClip;
		private var over								: MovieClip;
		private var out									: MovieClip;
		
		private var _selected							: Boolean;
		public var view									: BasicView;
		private var _active								: Boolean;
		
		public function Tab(name:String)
		{
			this.name = name;
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true); }
		}
		
		override public function toString():String
		{
			return "[Tab id: " + name + "]";
		}
		
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			mouseChildren = false;
			
			asset = new TabSingleAsset();
			addChild(asset);
			
			over = asset.label.over;
			out = asset.label.out;
			
			var format:TextFormat = asset.label.out.tf.getTextFormat();
			asset.label.out.tf.text = name;
			asset.label.out.tf.setTextFormat(format);
			
			format = asset.label.over.tf.getTextFormat();
			asset.label.over.tf.text = name;
			asset.label.over.tf.setTextFormat(format);
			
			rolledOver = new NativeSignal(this, MouseEvent.ROLL_OVER, MouseEvent);
			rolledOut = new NativeSignal(this, MouseEvent.ROLL_OUT, MouseEvent);
			clicked = new NativeSignal(this, MouseEvent.CLICK, MouseEvent);
			
			clickedSender = new Signal();
			
			selected = false;
		}
		
		private function doClicked(e:MouseEvent):void
		{
			if (!selected) { clickedSender.dispatch(this); }
		}
		
		private function doRolledOver(e:MouseEvent):void
		{
			if (!selected) { hilite(true); }
		}
		
		private function doRolledOut(e:MouseEvent):void
		{
			if (!selected) { hilite(false); }
		}
		
		private function hilite(val:Boolean):void
		{
			if (val)
			{
				asset.label.out.visible = false;
				asset.label.over.visible = true;
			}
			else
			{
				asset.label.out.visible = true;
				asset.label.over.visible = false;
			}
			TweenMax.to(asset.label, .25, { alpha: (val) ? 1 : 0.7 } );
		}
		
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			_selected = value;
			hilite(_selected);
			if (_selected)
			{
				asset.borderTop.visible = true;
				asset.borderBottom.visible = false;
				asset.borderLeft.visible = true;
				asset.borderRight.visible = true;
				
				rolledOver.remove(doRolledOver);
				rolledOut.remove(doRolledOut);
				clicked.remove(doClicked);
				useHandCursor = false;
				buttonMode = false;
				
				asset.selectedClip.visible = true;
			}
			else
			{
				asset.borderTop.visible = false;
				asset.borderBottom.visible = true;
				asset.borderLeft.visible = false;
				asset.borderRight.visible = false;
				
				rolledOver.add(doRolledOver);
				rolledOut.add(doRolledOut);
				clicked.add(doClicked);
				useHandCursor = true;
				buttonMode = true;
				
				asset.selectedClip.visible = false;
			}
		}
	}
}