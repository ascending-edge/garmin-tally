/**
 * @author Greg Rowe <greg.rowe@ascending-edge.com>
 *
 * This application class holds the model for the Tally widget.
 * 
 * Copyright (c) 2017, 2018 Ascending Edge, LLC.
 */
using Toybox.Application as App;


/**
 * This class is the entry point for the widget.  It loads, saves, and
 * stores the counter value.  It also keeps track of the mode (viewing
 * or adjusting).
 */
class TallyApp extends App.AppBase
{
     /// Possible operating modes
	enum 
	{
		MODE_ADJUST,
		MODE_VIEW
	}

     /// Holds the current operating mode
	var m_mode = MODE_VIEW;

     /// Holds the counter value
	var m_count = 0;


     function initialize() 
     {
          AppBase.initialize();
          m_count = 0;
          m_mode = MODE_VIEW;
     }


     function incBy(howMuch)
     {
          m_count += howMuch;
     }

     
     function inc() 
     {
          ++m_count;
     }
     
    
     function dec()
     {
          --m_count;
     }

     
     function getCount()
     {
          return m_count;
     }

     
     function reset()
     {
          m_count = 0;
     }

     
     function setMode(mode)
     {
          m_mode = mode;
     }

     
     function getMode()
     {
          return m_mode;
     }

     
     /** 
      * This loads the "count" property if it is available.
      */
     function onStart(state) 
     {
          var val = self.getProperty("count");
          if(val != null)
          {
               System.println("initial count: " + val);
               m_count = val;
          }
     }

     
     /**
      * This stores the "count" property.
      */
     function onStop(state) 
     {
          System.println("writing count: " + m_count);
          self.setProperty("count", m_count);
     }


     /**
      * This returns the initial view and the input delegate for the
      * widget.  This is called after initialize() and onStart().
      */
     function getInitialView() 
     {
          return [ new TallyView(), new TallyDelegate() ];
     }
}
