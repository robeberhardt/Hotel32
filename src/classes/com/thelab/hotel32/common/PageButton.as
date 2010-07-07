package com.thelab.hotel32.common
{
	import com.greensock.TweenMax;
	import com.thelab.hotel32.helpers.Logger;
	import com.thelab.hotel32.tabbox.PageButtonClip;
	
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
	
	public class PageButton extends Sprite
	{
		private var asset 								: MovieClip;
		private var _index								: uint;
				
		private var rolledOver							: NativeSignal;
		private var rolledOut							: NativeSignal;
		private var clicked 							: NativeSignal;
		public var clickedSender						: Signal;
		
		private var label								: MovieClip;
		private var over								: MovieClip;
		private var out									: MovieClip;
		
		private var _selected							: Boolean;
		
		public function PageButton(name:String)
		{
			this.name = name;
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true); }
		}
		
		override public function toString():String
		{
			return "[ PageButton id: " + name + " index: " + _index + " ]";
		}
		
		public function destroy():void
		{
			asset = null;
			rolledOver = null;
			rolledOut = null;
			clicked = null;
			clickedSender = null;
			label = null;
			over = null;
			out = null;
		}
		
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			mouseChildren = false;
			
			asset = new PageButtonClip();
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
			if (!selected) 
			{ 
				hilite(true);
				TweenMax.to(asset.frame, .25, { alpha: 1 } );
			}
		}
		
		private function doRolledOut(e:MouseEvent):void
		{
			if (!selected) 
			{ 
				hilite(false);
				TweenMax.to(asset.frame, .25, { alpha: .4 } );
			}
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
				
				rolledOver.remove(doRolledOver);
				rolledOut.remove(doRolledOut);
				clicked.remove(doClicked);
				useHandCursor = false;
				buttonMode = false;
				
				asset.selectedClip.visible = true;
				
			}
			else
			{
				rolledOver.add(doRolledOver);
				rolledOut.add(doRolledOut);
				clicked.add(doClicked);
				useHandCursor = true;
				buttonMode = true;
				
				asset.selectedClip.visible = false;
			}
			asset.frame.alpha = .4;
		}
		
		public function get index():uint
		{
			return _index;
		}
		
		public function set index(val:uint):void
		{
			_index = val;
			asset.label.over.tf.text = _index;
			asset.label.out.tf.text = _index;
		}
	}
}