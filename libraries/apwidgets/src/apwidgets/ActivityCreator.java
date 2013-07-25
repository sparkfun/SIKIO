package apwidgets;

import android.app.Activity;
import android.content.Intent;

public class ActivityCreator {
	public static void startActivity(Activity activity, String name){
		Intent i = new Intent(activity, APActivity.class);
	    i.putExtra("fakePApplet", name);
	    activity.startActivity(i);   
	}
}
