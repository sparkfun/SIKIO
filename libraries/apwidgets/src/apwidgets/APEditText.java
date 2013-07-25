/**
 * Copyright 2010 Rikard Lundstedt
 * 
 * This file is part of APWidgets.
 * 
 * APWidgets is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * APWidgets is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License
 * along with APWidgets. If not, see <http://www.gnu.org/licenses/>.
 */

package apwidgets;

import processing.core.PApplet;
import android.content.Context;
import android.text.InputType;
import android.view.KeyEvent;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.TextView.OnEditorActionListener;
/**
 * An editable text field. Add instances to {@link apwidgets.APWidgetContainer}. 
 * 
 * @author Rikard Lundstedt
 *
 */
public class APEditText extends APTextView implements OnEditorActionListener{
	
	private APEditText nextEditText = null;
	private boolean closeImeOnDone = false;
	
	private int editorInfo = EditorInfo.TYPE_NULL;
	private int getEditorInfo(){
		return editorInfo;
	}
	
	private int inputType = InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_FLAG_MULTI_LINE;
	private int getInputType(){
		return inputType;
	}
	
	private boolean horizontallyScrolling = true;
	public boolean getHorizontallyScrolling(){
		return horizontallyScrolling;
	}
	
	/**
	 * If you have called setImeOptions(EditorInfo.IME_ACTION_DONE), 
	 * and you have set closeImeOnDone to true, the IME will close
	 * when you press done.
	 * @param closeImeOnDone
	 */
	public void setCloseImeOnDone(boolean closeImeOnDone){
		this.closeImeOnDone = closeImeOnDone;
	}
	
	/**
	 * If you have called setImeOptions(EditorInfo.IME_ACTION_NEXT), 
	 * you can use this method to specify which EditText will be focused
	 * when you press next.
	 * @param nextEditText
	 */
	public void setNextEditText(APEditText nextEditText){
		if(nextEditText==null){
			throw new NullPointerException("Have you initialized the PEditText used as an argument in calling setNextEditText?");
		}else{
			this.nextEditText = nextEditText;
		}
	}
	
	/**
	 * Creates a new editable text field. 
	 * @param x The text field's x position.
	 * @param y The text field's y position.
	 * @param width The text field's width.
	 * @param height The text field's height.
	 */
	public APEditText(int x, int y, int width, int height) {
		super(x, y, width, height, "");
		this.shouldNotSetOnClickListener = true; //otherwise ime options done, next etc doesn't work
	}
	/**
	 * Initializes the text field. Is called by {@link APWidgetContainer} 
	 * as it is added to it.
	 * 
	 */
	public void init(PApplet pApplet) {
		this.pApplet = pApplet;

		if (view == null) {
			view = new EditText(pApplet);
		}
		((EditText)view).setInputType(inputType);
		((EditText)view).setImeOptions(editorInfo);
		((EditText)view).setHorizontallyScrolling(horizontallyScrolling);
		((EditText)view).setOnEditorActionListener(this);

		super.init(pApplet);
	}
	public boolean onEditorAction(TextView textView, int actionId, KeyEvent keyEvent){
		if(actionId == EditorInfo.IME_ACTION_NEXT){
			if(nextEditText != null){
				((EditText)nextEditText.getView()).requestFocus();
				return true;
			}
		}else if(actionId == EditorInfo.IME_ACTION_DONE){
			onClick(view);
			if(closeImeOnDone){
				InputMethodManager imm = (InputMethodManager)pApplet.getSystemService(Context.INPUT_METHOD_SERVICE);
			    imm.hideSoftInputFromWindow(textView.getWindowToken(), 0);
			}
			return true;
		}
		return false;
	}
	/**
	 * You can set IMEOptions for this EditText using this method. 
	 * See list of IMEOptions here: <a href="http://developer.android.com/reference/android/view/inputmethod/EditorInfo.html">
	 * http://developer.android.com/reference/android/view/inputmethod/EditorInfo.html</a>
	 * @param editorInfo
	 */
	public void setImeOptions(int editorInfo){
		this.editorInfo = editorInfo;
		if (initialized) {
			pApplet.runOnUiThread(new Runnable() {
				public void run() {
					((EditText) view).setImeOptions(getEditorInfo());
				}
			});
		}
	}
	/**
	 * You can set InputType here. See list of different InputTypes here: 
	 * <a href="http://developer.android.com/reference/android/text/InputType.html">
	 * http://developer.android.com/reference/android/text/InputType.html</a>
	 * @param inputType
	 */
	public void setInputType(int inputType){
		this.inputType = inputType;
		if (initialized) {
			pApplet.runOnUiThread(new Runnable() {
				public void run() {
					((EditText) view).setInputType(getInputType());
				}
			});
		}
	}
	public void setHorizontallyScrolling(boolean horizontallyScrolling){
		this.horizontallyScrolling = horizontallyScrolling;
		if (initialized) {
			pApplet.runOnUiThread(new Runnable() {
				public void run() {
					((EditText) view).setHorizontallyScrolling(getHorizontallyScrolling());
				}
			});
		}
	}
	
}