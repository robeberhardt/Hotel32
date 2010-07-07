package nid.utils.dateChooser
{
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
    import flash.display.SimpleButton;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;	
	import caurina.transitions.Tweener;
	import nid.utils.dateChooser.calendarSkin;
	import nid.utils.dateChooser.DateField;
	import nid.utils.dateChooser.iconSprite;
	import nid.events.calendarEvent;
	/**
	 * ...
	 * @author Nidin Vinayak
	 */
	public class DateChooser extends calendarSkin {		
		
		public function get getSelectedDate():String { return selectedDate; }		
		
		public final function DateChooser() {
			dateField 		= new DateField();
			calendarIcon	= new iconSprite();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event):void {
			Construct();
			removeEventListener(Event.ADDED_TO_STAGE, init);			
			//addChild(dateField);	
			//dateField.alpha = 0;
			calendarIcon.addEventListener(calendarEvent.LOADED, update);
			calendarIcon.configIcon(_icon);
			//addChild(calendarIcon);
			addCustomMenuItems();
			addChild(Calendar);
			Calendar.x = 15;
			Calendar.y = 15;
		}
		protected function update(e:calendarEvent):void {
			calendarIcon.x 	= dateField.width + 5;
			isHidden		= true;
			Calendar.x		= calendarIcon.x + calendarIcon.width + 5;
			addCustomMenuItems();
			calendarIcon.addEventListener(MouseEvent.CLICK,showHideCalendar);
			addEventListener(MouseEvent.MOUSE_OVER,MouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,MouseOut);
			addEventListener(MouseEvent.CLICK,MouseClick);
		}
		/*
		 *	CONTEXT MENU 
		 * 
		 */
        private function addCustomMenuItems():void {
			
			myMenu = new ContextMenu();
            myMenu.hideBuiltInItems();
            var menu1:ContextMenuItem;
			var menu2:ContextMenuItem;
            menu1 = null;
			menu1 = new ContextMenuItem("An iGi Lab Production");
            menu2 = new ContextMenuItem("Follow us");			
            menu1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, navigateToSite);
			menu2.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, navigateToSite);
            myMenu.customItems.push(menu1);
			myMenu.customItems.push(menu2);
            this.contextMenu = myMenu;
            return;
        }	
        private function navigateToSite(e:ContextMenuEvent):void
        {
           	navigateToURL(new URLRequest("http://www.infogroupindia.com/blog"), "_blank");
            return;
        }				
//=======================================================================================================
//							MOUSE EVENT LISTENERS
//=======================================================================================================		
		public function showHideCalendar(e:MouseEvent=null):void {
			if (e.currentTarget == stage) {
				trace(e.target.name);
				if(e.target.name == "hit" || e.target.name == "NextButton" || e.target.name == "PrevButton" || e.target == calendarIcon ){					
					trace(e.currentTarget);				
					return;
				}
			}
			if (isHidden) {
				addChild(Calendar);
				Tweener.addTween(Calendar, { alpha:1, time:1, transition:"easeOutExpo" } );
				isHidden	=	false;
				try{
					stage.addEventListener(MouseEvent.MOUSE_UP, showHideCalendar);
				}catch (e:Error) {}
			}else {
				Tweener.addTween(Calendar, { alpha:0, time:0.5, transition:"easeOutExpo",onComplete:function ():void{ removeChild(Calendar); } } );
				isHidden	=	true;
				try{
					stage.removeEventListener(MouseEvent.MOUSE_UP, showHideCalendar);
				}catch (e:Error) {}				
			}
		}
		public function MouseOver(e:MouseEvent):void {
			if(!isHidden){
			if(e.target.name == "hit"){
				if(!e.target.parent.hitted)
				changeColor(e.target.parent,mouseOverCellColor);
			}else{
				return;
			}
			}
		}
		public function MouseOut(e:MouseEvent):void {
			if(!isHidden){
			if(e.target.name == "hit"){
				if(!e.target.parent.hitted)
				changeColor(e.target.parent,e.target.parent.id);
			}else{
				return;
			}
			}
		}
		public function MouseClick(e:MouseEvent):void {
			if(!isHidden){
			if(e.target.name == "hit"){
				e.target.parent.hitted		=	true;
				isHitted.status 			=	true;
				isHitted.num				=	e.target.parent.serial;
				if(oldHit != undefined){
					cellArray[oldHit].hitted 	= 	false;
					changeColor(cellArray[oldHit],cellArray[oldHit].id);
				}
				oldHit			=	e.target.parent.serial;
				selectedDate	=	e.target.parent.date.getDate()+ "/" + (currentmonth + 1) + "/" + currentyear;
				dateField.text	=	selectedDate;
				dispatchEvent(new calendarEvent(calendarEvent.CHANGE, selectedDate));
				showHideCalendar(e);
				if(!e.target.parent.isToday){ changeColor(e.target.parent,mouseOverCellColor); }
			}else{
				return;
			}
			}
		}
	}
}