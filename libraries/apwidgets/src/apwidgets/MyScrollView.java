package apwidgets;

import processing.core.PApplet;
import android.view.MotionEvent;
import android.widget.ScrollView;

public class MyScrollView extends ScrollView{

	PApplet pApplet;
	public MyScrollView(PApplet pApplet) {
		super(pApplet);
		this.pApplet = pApplet;
		// TODO Auto-generated constructor stub
	}
	//Should only be passed if Android ver 2.2, cause then the calls 
	//are obscured by the overlying ViewGroup and never reach the
	//processing surfaceTouchEvent and the mousePressed etc is
	//never called
	public boolean onTouchEvent(MotionEvent evt){
		pApplet.surfaceTouchEvent(evt);//pass on to processing
		return super.onTouchEvent(evt);//calling super makes the scrolling work
	}
}
