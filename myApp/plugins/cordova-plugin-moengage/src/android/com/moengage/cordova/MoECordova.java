package com.moengage.cordova;


import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import android.content.Context;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import com.moe.pushlibrary.MoEHelper;
import android.util.Log;
import android.os.Bundle;
import com.moengage.push.PushManager;
import java.util.Iterator;
import android.text.TextUtils;
import com.moe.pushlibrary.models.GeoLocation;

/**
 * This class echoes a string called from JavaScript.
 */
public class MoECordova extends CordovaPlugin {

  private static final String ACTION_PASS_TOKEN = "pass_token";
  private static final String ACTION_PASS_PAYLOAD = "pass_payload";
  private static final String ACTION_SET_EXISTING_USER = "existing_user";
  private static final String ACITON_SET_USER_ATTRIBUTE = "set_user_attribute";
  private static final String ACTION_TRACK_EVENT = "track_event";
  private static final String ACTION_SET_UNIQUE_ID = "unique_id";
  private static final String ACTION_USER_LOGOUT = "logout";
  private static final String ACTION_USER_LOCATION = "set_user_attribute_location";
  private static final String ACTION_SET_LOG_LEVEL = "setLogLevel";
  private static final String ACTION_ENABLE_DATA_REDIRECTION = "enableDataRedirection";
  private static final String ACITON_SET_USER_ATTRIBUTE_TIMESTAMP = "set_user_attribute_timestamp";

  @Override public boolean execute(String action, JSONArray args, CallbackContext callbackContext)
      throws JSONException {
    Log.d("MoECordova", "inside native code : " + action);
    Context context = getApplicationContext();
    MoEHelper moeHelper = MoEHelper.getInstance(context);
    JSONObject jsonObject= args.getJSONObject(0);
    Log.d("MoECordova", "payload : " + jsonObject.toString());
    boolean isFailed = false;
    switch(action){
      case ACTION_PASS_TOKEN :
        String token = jsonObject.getString("gcm_token");
        PushManager.getInstance().refreshToken(context, token);
        break;
      case ACTION_PASS_PAYLOAD :
        JSONObject payload = jsonObject.getJSONObject("gcm_payload");
        Bundle data = jsonToBundle(payload);
        PushManager.getInstance().getPushHandler().handlePushPayload(context, data);
        break;
      case ACTION_SET_EXISTING_USER :
        boolean isExisting = jsonObject.getBoolean("existing_user");
        moeHelper.setExistingUser(isExisting);
        break;
      case ACITON_SET_USER_ATTRIBUTE :
        String dataType = jsonObject.getString("attribute_type");
        String attributeName = jsonObject.getString("attribute_name");
        switch(dataType){
          case "boolean":
            moeHelper.setUserAttribute(attributeName, jsonObject.getBoolean("attribute_value"));
            break;
          case "String":
            moeHelper.setUserAttribute(attributeName, jsonObject.getString("attribute_value"));
            break;
          case "integer":
            moeHelper.setUserAttribute(attributeName, jsonObject.getInt("attribute_value"));
            break;
          case "double":
            moeHelper.setUserAttribute(attributeName, jsonObject.getDouble("attribute_value"));
            break;
        }
        break;
      case ACTION_TRACK_EVENT :
        String eventName = jsonObject.getString("event_name");
        JSONObject eventAttributes = jsonObject.getJSONObject("event_attributes");
        moeHelper.trackEvent(eventName, eventAttributes);
        break;
      case ACTION_USER_LOGOUT:
        moeHelper.logoutUser();
        break;
      case ACTION_USER_LOCATION:
        String locationAttributeName = jsonObject.getString("attribute_name");
        double latitude = jsonObject.getDouble("attribute_lat_value");
        double longitude = jsonObject.getDouble("attribute_lon_value");
        GeoLocation geoLocation = new GeoLocation(latitude, longitude);
        if (!TextUtils.isEmpty(locationAttributeName)) {
          moeHelper.setUserAttribute(locationAttributeName, geoLocation);
        }else{
          moeHelper.setUserLocation(latitude, longitude);
        }
        break;
      case ACTION_SET_LOG_LEVEL:
        int loglevel = jsonObject.getInt("log_level");
        moeHelper.setLogLevel(loglevel);
        break;
      case ACTION_ENABLE_DATA_REDIRECTION:
      boolean shouldRedirectData = jsonObject.getBoolean("set_redirect");
      moeHelper.setDataRedirection(shouldRedirectData);
      break;
      case ACITON_SET_USER_ATTRIBUTE_TIMESTAMP:
      String attrName = jsonObject.getString("attribute_name");
      moeHelper.setUserAttributeEpochTime(attrName, jsonObject.getLong("attribute_value"));
      break;
      default:
      callbackContext.error("fail");
      isFailed = true;
    }
    if (!isFailed) {
     callbackContext.success("success");
    }
    return true;
  }


    private Context getApplicationContext() {
        return this.cordova.getActivity().getApplicationContext();
    }

    private Bundle jsonToBundle(JSONObject json){
    try {
        Bundle bundle = new Bundle();
        Iterator iter = json.keys();
        while(iter.hasNext()){
          String key = (String)iter.next();
          String value = json.getString(key);
        bundle.putString(key,value);
    }
    return bundle;
    } catch (JSONException e) {

    }
    return null;
}

}
