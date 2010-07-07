package com.thelab.hotel32.common
{
	import com.greensock.TweenMax;
	import com.thelab.hotel32.helpers.Logger;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;
	
	public class SimplePaginator extends Sprite
	{
		
		private var pageButtonArray							: Array;
		private var _selectedPage							: PageButton;
		private var _count									: uint;
		
		private var hotspot									: Sprite;
		private var timer									: Timer;
		private var _active									: Boolean;
		private var _auto									: Boolean;
		
		public var timerOffSignal							: NativeSignal;
		public var timerOnSignal							: NativeSignal;
		
		public var hideCompleted							: Signal;
		
		public var selectedSender							: Signal;
	
		public function SimplePaginator(name:String="")
		{
			this.name = name;
			selectedSender = new Signal(PageButton);
			pageButtonArray = new Array();
			visible = false;
			alpha = 0;
			hideCompleted = new Signal();
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true); }
		}
		
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			hotspot = new Sprite();
			timerOffSignal = new NativeSignal(this, MouseEvent.ROLL_OVER, MouseEvent);
			timerOnSignal = new NativeSignal(this, MouseEvent.ROLL_OUT, MouseEvent);
			timer = new Timer(12000);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
		}
		
		public function stopTimer(e:MouseEvent=null):void
		{
			auto = false;
		}
		
		public function startTimer(e:MouseEvent=null):void
		{
			auto = true;
		}
		
		public function get count():uint
		{
			return _count;
		}
		
		public function set count(val:uint):void
		{
			Logger.log(this + "\nsetting count to " + val);
			hideCompleted.addOnce( function() 
			{
				
				_count = val;
				var pb:PageButton;
				
				// erase any existing buttons
				if (pageButtonArray.length > 0)
				{
					for each (pb in pageButtonArray)
					{
						removeChild(pb);
					}
					pageButtonArray = [];
				}
				
				Logger.log("\n\nrebuilding button list\n\n-----------------");
				
				// rebuild the button list
				for (var i:uint=0; i<_count; i++)
				{
					
					pb = new PageButton(name + "-" + i);
					addChild(pb);
					pb.index = i+1;
					pb.x = - ((pb.width * i) + i) ;
					pb.x = -(_count*(pb.width) - ((pb.width)*i));
					pb.clickedSender.add(onPageButtonClicked);
					pageButtonArray.push(pb);
					
					Logger.log("added " + pb, 3);
				}
				
				selectedPage = pageButtonArray[0];
				
				pb = null;
				
				addChildAt(hotspot, 0);
				hotspot.graphics.clear();
				hotspot.graphics.beginFill(0x00FF00, 0);
				hotspot.graphics.drawRect(-(width+14), -14, width+28, height+28);
								
			} );
			
			hide();
		}
		
		private function onPageButtonClicked(which:PageButton):void
		{
			selectedPage = which;
		}
		
		public function get selectedPage():PageButton
		{
			return _selectedPage;
		}
		
		public function set selectedPage(which:PageButton):void
		{
			if (_selectedPage) { _selectedPage.selected = false; }
			_selectedPage = which;
			_selectedPage.selected = true;
			selectedSender.dispatch(which);
			Logger.log("set selected page to " + which);
		}
		
		private function onTimer(e:TimerEvent):void
		{
			var page:uint = _selectedPage.index;
			(page == _count) ? page = 1 : page ++;
			selectedPage = pageButtonArray[page-1];
		}
		
		public function get active():Boolean
		{
			return _active;
		}
		
		public function set active(val:Boolean):void
		{
			_active = val;
			if (_active)
			{
				timerOnSignal.add(startTimer);
				timerOffSignal.add(stopTimer);
			}
			else
			{
				timerOnSignal.removeAll();
				timerOffSignal.removeAll();
			}
			Logger.log(this + ", set active to " + _active);
		}
		
		public function hide():void
		{
			TweenMax.to(this, .15, { autoAlpha: 0, onComplete: function() { hideCompleted.dispatch(); } } );
			active = false;
			auto = false;
		}
		
		public function show():void
		{
			Logger.log("showing paginator - count=" + count);
			if (count > 1)
			{
				TweenMax.to(this, .5, { autoAlpha: 1 } );
				active = true;
				auto = true;
			}
		}
		
		public function get auto():Boolean
		{
			return _auto;
		}
		
		public function set auto(val:Boolean):void
		{
			_auto = val;
			if (_auto)
			{
				timer.start();
			} else
			{
				timer.stop();
			}
		}
		
		override public function toString():String
		{
			return "[SimplePaginator id: " + name + "]";
		}
	}
}