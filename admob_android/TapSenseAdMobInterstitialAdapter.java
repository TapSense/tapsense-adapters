package com.tapsense.adapters;

import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;

import com.google.ads.mediation.MediationAdRequest;
import com.google.ads.mediation.customevent.CustomEventInterstitial;
import com.google.ads.mediation.customevent.CustomEventInterstitialListener;
import com.tapsense.android.publisher.TSErrorCode;
import com.tapsense.android.publisher.TSKeywordMap;
import com.tapsense.android.publisher.TapSenseAds;
import com.tapsense.android.publisher.TapSenseInterstitial;
import com.tapsense.android.publisher.TapSenseInterstitialListener;

public class TapSenseAdMobInterstitialAdapter implements
    CustomEventInterstitial, TapSenseInterstitialListener {

  private CustomEventInterstitialListener mInterstitialListener;
  private TapSenseInterstitial mInterstitial;

  @Override
  public void requestInterstitialAd(
      final CustomEventInterstitialListener listener, final Activity activity,
      String label, String serverParameter,
      MediationAdRequest mediationAdRequest, Object extra) {
    try {
      // Remove test mode before going live and submitting to Play Store
      TapSenseAds.setTestMode();

      mInterstitialListener = listener;

      JSONObject serverParameterJson = new JSONObject(serverParameter);

      mInterstitial = new TapSenseInterstitial(activity,
          serverParameterJson.getString("adUnitId"), false,
          TSKeywordMap.EMPTY_TS_KEYWORD_MAP);
      mInterstitial.setListener(this);
      mInterstitial.requestAd();
    } catch (JSONException e) {
      listener.onFailedToReceiveAd();
    }
  }

  @Override
  public void showInterstitial() {
    if (mInterstitial != null && mInterstitial.isReady()) {
      mInterstitial.showAd();
    }
  }

  @Override
  public void destroy() {
    if (mInterstitial != null) {
      mInterstitial.destroy();
    }
  }

  @Override
  public void onInterstitialLoaded(TapSenseInterstitial interstitial) {
    if (mInterstitialListener != null) {
      mInterstitialListener.onReceivedAd();
    }

  }

  @Override
  public void onInterstitialFailedToLoad(TapSenseInterstitial interstitial,
      TSErrorCode errorCode) {
    if (mInterstitialListener != null) {
      mInterstitialListener.onFailedToReceiveAd();
    }
  }

  @Override
  public void onInterstitialShown(TapSenseInterstitial interstitial) {
    if (mInterstitialListener != null) {
      mInterstitialListener.onPresentScreen();
    }
  }

  @Override
  public void onInterstitialDismissed(TapSenseInterstitial interstitial) {
    if (mInterstitialListener != null) {
      mInterstitialListener.onDismissScreen();
    }
  }

}
